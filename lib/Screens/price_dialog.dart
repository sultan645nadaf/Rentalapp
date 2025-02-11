import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PriceDialog extends StatefulWidget {
  static const String id = 'price-dialog-screen';
  @override
  _PriceDialogState createState() => _PriceDialogState();
}

class _PriceDialogState extends State<PriceDialog>
    with SingleTickerProviderStateMixin {
  int selectedTabIndex = 0;
  final List<String> tabs = ['1-10 days', '11-20 days', '21-30 days'];
  late TabController _tabController;

  // Data maps for different tabs
  List<Map<String, dynamic>> prices1To10 = [];
  List<Map<String, dynamic>> prices11To20 = [];
  List<Map<String, dynamic>> prices21To30 = [];

  DateTime? selectedDate;
  int selectedNumberOfDays = 1; // Default to 1 day
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    fetchPrices();
  }

  Future<void> fetchPrices() async {
    try {
      // Fetch data for 1-10 days
      QuerySnapshot snapshot1To10 = await FirebaseFirestore.instance
          .collection('prices')
          .where('tab', isEqualTo: '1-10 days')
          .get();

      // Fetch data for 11-20 days
      QuerySnapshot snapshot11To20 = await FirebaseFirestore.instance
          .collection('prices')
          .where('tab', isEqualTo: '11-20 days')
          .get();

      // Fetch data for 21-30 days
      QuerySnapshot snapshot21To30 = await FirebaseFirestore.instance
          .collection('prices')
          .where('tab', isEqualTo: '21-30 days')
          .get();

      setState(() {
        prices1To10 = snapshot1To10.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        prices11To20 = snapshot11To20.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        prices21To30 = snapshot21To30.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching prices: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // Calculate number of days between selected date and today
        final today = DateTime.now();
        selectedNumberOfDays = picked.difference(today).inDays + 1;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildTable(List<Map<String, dynamic>> prices) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      children: [
        TableRow(
          children: [
            TableCell(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Duration', style: TextStyle(fontWeight: FontWeight.bold)),
            )),
            TableCell(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Per Day Rent', style: TextStyle(fontWeight: FontWeight.bold)),
            )),
            TableCell(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Total Price', style: TextStyle(fontWeight: FontWeight.bold)),
            )),
          ],
        ),
        for (var price in prices)
          TableRow(
            children: [
              TableCell(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(price['duration']),
              )),
              TableCell(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("₹ ${price['perDayRent']} / day"),
              )),
              TableCell(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("₹ ${price['totalPrice']}"),
              )),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prices'),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.blue,
          onTap: (index) {
            setState(() {
              selectedTabIndex = index;
            });
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: buildTable(selectedTabIndex == 0
                          ? prices1To10
                          : selectedTabIndex == 1
                              ? prices11To20
                              : prices21To30),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.date_range),
                    label: Text("Select your date"),
                  ),
                  if (selectedDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}",
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
