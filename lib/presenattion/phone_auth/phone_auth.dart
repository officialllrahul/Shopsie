import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shopsie/presenattion/dashboard/dashboard.dart';
import 'package:shopsie/presenattion/phone_signup/phone_signup.dart';
import 'package:shopsie/widgets/custom_button.dart';

import 'Verify_code.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  bool loading = false;
  final phonenumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 100, 0, 10),
                child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset("assets/images/logo.png")),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                      child: Text("Welcome to Shopsie",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 25,
                              fontWeight: FontWeight.bold))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 100),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                      child: Text("Sign in to continue",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold))),
                ),
              ),
              TextField(
                controller: phonenumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                ),
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                onPressed: () {
                  String phoneNumber = phonenumberController.text.trim();
                  // Ensure that the phone number starts with a plus sign
                  if (!phoneNumber.startsWith("+")) {
                    phoneNumber = "+$phoneNumber";
                  }
                  auth.verifyPhoneNumber(
                    phoneNumber: phoneNumber,
                    verificationCompleted: (_) {},
                    verificationFailed: (e) {
                      toastMessage(e.toString());
                    },
                    codeSent: (String verificationId, int? token) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyCode(verificationId: verificationId, phone: phoneNumber),
                        ),
                      );
                    },
                    codeAutoRetrievalTimeout: (e) {
                      toastMessage(e.toString());
                    },
                  );
                },
                // onPressed: _verifyPhoneNumber,
                text: "SEND OTP",
              ),
            ],
          ),
        ),
      ),
    );
  }
  void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

