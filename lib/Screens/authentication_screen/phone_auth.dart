import 'package:electronicsrent/Screens/services/phoneauth_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhoneAuth extends StatefulWidget {
  static const String id = 'phone-auth-screen';

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  bool validate = false;
  var countryCodeController = TextEditingController(text: '+91');
  var phoneNumberController = TextEditingController();

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
          SizedBox(
            width: 8,
          ),
          Text('please wait')
        ],
      ),
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  PhoneAuthServices _service = PhoneAuthServices();

  @override
  void dispose() {
    showAlertDialog(context);
    super.dispose();
  }

  String CounterText = '0';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'login',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.red.shade200,
                child: Icon(
                  Icons.person_rounded,
                  size: 60,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Enter your phone number',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'we will send confirmation code to your phone',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: countryCodeController,
                    enabled: false,
                    decoration: InputDecoration(
                        counterText: '00',
                        counterStyle: TextStyle(color: Colors.white38),
                        labelText: 'Country'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.length == 10) {
                        setState(() {
                          validate = true;
                        });
                      }
                      if (value.length < 10) {
                        setState(() {
                          validate = false;
                        });
                      }
                    },
                    autofocus: true,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    controller: phoneNumberController,
                    // onChanged: (value) {
                    //   setState(() {
                    //     CounterText = value.length.toString();
                    //   });
                    // },
                    decoration: InputDecoration(
                      helperMaxLines: 10,
                      // counterText: '$CounterText/10',
                      // counterStyle: TextStyle(fontSize: 8, color: Colors.grey),
                      labelText: 'Number',
                      hintText: 'Enter your phone number',
                      hintStyle: TextStyle(
                        fontSize: 8,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100, left: 30, right: 30),
          child: AbsorbPointer(
            absorbing: validate ? false : true,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: validate
                    ? WidgetStateProperty.all(Theme.of(context).primaryColor)
                    : WidgetStateProperty.all(Colors.black),
              ),
              onPressed: () {
                String number =
                    '${countryCodeController.text}${phoneNumberController.text}';
                showAlertDialog(context);

                _service.verifyPhoneNumber(context, number);
              },
              child: Text(
                'next',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
