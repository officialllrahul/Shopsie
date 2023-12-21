import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopsie/presenattion/dashboard/dashboard.dart';

import '../../widgets/custom_button.dart';

class PhoneSignup extends StatefulWidget {
  const PhoneSignup({super.key});

  @override
  State<PhoneSignup> createState() => _PhoneSignupState();
}

class _PhoneSignupState extends State<PhoneSignup> {
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance.currentUser;
  final CollectionReference _items =
      FirebaseFirestore.instance.collection('UsersData');
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    phoneController.text = auth!.phoneNumber!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: [
              SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset("assets/images/logo.png")),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                      child: Text("Let's get started",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 25,
                              fontWeight: FontWeight.bold))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                      child: Text("Please enter all fields",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold))),
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autofocus: false,
                    decoration: const InputDecoration(
                        hintText: "Full Name",
                        prefixIcon: Icon(Icons.person_outline),
                        labelStyle: TextStyle(fontSize: 20),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15)),
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter name";
                      } else if (!RegExp(r'^(?=.*?[A-Z])').hasMatch(value)) {
                        return "name must contain at least one capital letter";
                      } else if (!RegExp(r'^(?=.*?[a-z])').hasMatch(value)) {
                        return "name must contain at least one small letter";
                      } else if (RegExp(r'^(?=.*?[0-9])').hasMatch(value)) {
                        return "name does not contain number";
                      } else if (RegExp(r'^(?=.*?[!@#$%^&*(),.?":{}|<>])')
                          .hasMatch(value)) {
                        return "name does not contain any special character";
                      }
                      return null;
                    },
                  )),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autofocus: false,
                    decoration: const InputDecoration(
                        hintText: "Your Email",
                        prefixIcon: Icon(Icons.email_outlined),
                        labelStyle: TextStyle(fontSize: 20),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15)),
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter email";
                      } else if (!value.contains("@")) {
                        return "Please enter valid email";
                      } else if (!value.contains(".com")) {
                        return "Please enter valid email";
                      }
                      return null;
                    },
                  )),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autofocus: false,
                    decoration: const InputDecoration(
                        hintText: "Phone Number",
                        prefixIcon: Icon(Icons.phone_outlined),
                        labelStyle: TextStyle(fontSize: 20),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15)),
                    controller: phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter phone number";
                      } else if (value.length != 10) {
                        return "Please enter valid number";
                      }
                      return null;
                    },
                  )),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autofocus: false,
                    decoration: const InputDecoration(
                        hintText: "Address",
                        prefixIcon: Icon(Icons.location_on_outlined),
                        labelStyle: TextStyle(fontSize: 20),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15)),
                    controller: addressController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your address";
                      }
                      return null;
                    },
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        onPressed: () async {
                          try {
                            await Firebase
                                .initializeApp(); // Initialize Firebase

                            User? user = FirebaseAuth.instance.currentUser;

                            if (user == null) {
                              // User is not signed in
                              print('User is not signed in.');
                              return;
                            }

                            String userId =
                                user.uid; // Get the current user UID

                            // Registration successful
                            final String phoneName = nameController.text;
                            final String phoneEmail = emailController.text;
                            final String phoneMobile = phoneController.text;
                            final String phoneAddress = addressController.text;

                            // Add user details to Firestore
                            await _items.doc(userId).set({
                              "name": phoneName,
                              "email": phoneEmail,
                              "phone": phoneMobile,
                              "address": phoneAddress,
                              "userId": userId
                            });

                            // Store the UID in shared preferences
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('userDocId', userId);

                            // Clear text fields after successful registration
                            nameController.text = '';
                            phoneController.text = '';
                            addressController.text = '';
                            emailController.text='';

                            // Print success message to the console
                            print("User created: $userId");
                            print("Registration successful!");

                            // Show a toast message
                            Fluttertoast.showToast(
                              msg: "Registration successful",
                              backgroundColor: Colors.blueGrey,
                              timeInSecForIosWeb: 5,
                            );
                            prefs.setBool('isPhone', true);

                            // Navigate to the dashboard
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => dashBoard()),
                            ); // Replace with your Dashboard class
                          } catch (e) {
                            print("Error during sign up: $e");

                            // Handle specific error cases
                            if (e is FirebaseAuthException) {
                              if (e.code == 'email-already-in-use') {
                                // The email address is already in use by another account.
                                print("Email is already in use.");
                                // Show a toast message or handle the case as needed
                                Fluttertoast.showToast(
                                  msg:
                                      "Email is already in use. Please use a different email.",
                                  backgroundColor: Colors.red,
                                  timeInSecForIosWeb: 5,
                                );
                              } else {
                                // Handle other FirebaseAuthException cases as needed
                                print("FirebaseAuthException: ${e.code}");
                              }
                            } else {
                              // Handle other exceptions
                              print("Unexpected error during sign up: $e");
                            }
                          }
                        },
                        text: "Sign up")
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
