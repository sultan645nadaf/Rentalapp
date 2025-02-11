import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electronicsrent/Screens/firebase_services.dart';
import 'package:flutter/material.dart';

class SellerCategoryScreen extends StatelessWidget {
  static const String id = 'seller-category-list-screen';
  const SellerCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseServices _service = FirebaseServices();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          shape: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
          backgroundColor: Colors.white,
          title: Text('Categories'),
        ),
        body: Container(
          child: FutureBuilder<QuerySnapshot>(
            future: _service.categories.get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Container(
                  height: 200,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Error loading categories'),
                          Text('See all')
                        ],
                      ),
                    ],
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Container(
                // Adjusted height
                child: Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          var doc = snapshot.data?.docs[index];
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                onTap: () {
                                  //sub categories
                                },
                                leading: Image.network(
                                  doc?['image'],
                                  width: 40,
                                ),
                                title: Text(
                                  doc?['catName'],
                                  style: TextStyle(fontSize: 15),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                ),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
