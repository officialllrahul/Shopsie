import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopsie/presenattion/dashboard/dashboard.dart';
import 'package:shopsie/presenattion/phone_signup/phone_signup.dart';
import 'package:shopsie/widgets/custom_button.dart';

class VerifyCode extends StatefulWidget {
  final String verificationId;
  final String phone;
  const VerifyCode({required this.verificationId, Key? key, required this.phone}) : super(key: key);

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool loading = false;
  final phonenumberController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final usersRef = FirebaseFirestore.instance.collection('UsersData');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 50,),
            TextField(
              controller: phonenumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Enter OTP",
              ),
            ),
            const SizedBox(height: 70,),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () async {
                  final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: phonenumberController.text.toString(),
                  );
                  try {
                    await auth.signInWithCredential(credential);
                    // Check if the phone number matches the one in UserProfileData
                    final currentUser = auth.currentUser;
                    if (currentUser != null) {
                      final mobile = currentUser.phoneNumber;
                      final userSnapshot = await usersRef
                          .where('phone', isEqualTo: mobile)
                          .limit(1)
                          .get();

                      if (userSnapshot.docs.isNotEmpty) {
                        // Phone number matches, navigate to Dashboard
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => dashBoard()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PhoneSignup()),
                        );
                      }
                    }
                  } catch (e) {
                    toastMessage(e.toString());
                  }
                },
                text: 'Verify OTP',
              ),
            )
          ],
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
