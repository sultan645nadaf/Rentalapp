import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:electronicsrent/Screens/services/phoneauth_services.dart';

class OtpScreen extends StatefulWidget {
  final String number, verId;
  OtpScreen({required this.number, required this.verId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool _loading = false;
  String error = '';

  PhoneAuthServices _services = PhoneAuthServices();

  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Future<void> phoneCredential(BuildContext context, String otp) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verId,
        smsCode: otp,
      );

      final User? user = (await _auth.signInWithCredential(credential)).user;

      if (user != null) {
        _services.addUser(context, user.uid);
        //Navigator.pushReplacementNamed(context, LocationScreen.id);
      } else {
        print('Login failed');
        setState(() {
          error = 'Login failed';
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        error = 'Invalid OTP';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false, // to remove back screen
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.red.shade700,
                      child: Icon(
                        CupertinoIcons.person_alt_circle,
                        size: 60,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Welcome back',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'We sent a 6-digit code to ',
                            style: TextStyle(fontSize: 20, color: Colors.amber),
                            children: [
                              TextSpan(
                                text: widget.number,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.edit),
                      ),
                    ],
                  ),
                  SizedBox(height: 80),
                  Row(
                    children: List.generate(6, (index) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: TextFormField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textInputAction: TextInputAction.next,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                if (index < 5) {
                                  FocusScope.of(context)
                                      .requestFocus(_focusNodes[index + 1]);
                                } else {
                                  FocusScope.of(context).unfocus();
                                  String otp = _controllers
                                      .map((controller) => controller.text)
                                      .join();
                                  if (otp.length == 6) {
                                    setState(() {
                                      _loading = true;
                                    });
                                    phoneCredential(context, otp);
                                  }
                                }
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(context)
                                    .requestFocus(_focusNodes[index - 1]);
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 50),
                  if (_loading)
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 50,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  SizedBox(height: 18),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
