import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopsie/presenattion/login_page/login_page.dart';
import 'package:shopsie/widgets/custom_button.dart';

class EmailSignUp extends StatefulWidget {
  const EmailSignUp({super.key});

  @override
  State<EmailSignUp> createState() => EmailSignUpState();
}

class EmailSignUpState extends State<EmailSignUp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _obscureText = true;
  bool _obscureTexts = true;
  final CollectionReference _items =
      FirebaseFirestore.instance.collection('UsersData');
  String? _userDocId;

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
                      child: Text("Create an new account",
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
                        prefixText: '+91',
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
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        hintText: "Password",
                        labelStyle: const TextStyle(fontSize: 20),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        errorStyle: const TextStyle(
                            color: Colors.redAccent, fontSize: 15)),
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      } else if (!RegExp(r'^(?=.*?[a-z])').hasMatch(value)) {
                        return 'Text must contain at least one lowercase letter !';
                      } else if (!RegExp(r'^(?=.*?[A-Z])').hasMatch(value)) {
                        return 'Text must contain at least one capital letter !';
                      } else if (!RegExp(r'^(?=.*?[0-9])').hasMatch(value)) {
                        return 'Text must contain at least one number!';
                      } else if (!RegExp(r'^(?=.*?[!@#$%^&*(),.?":{}|<>])')
                          .hasMatch(value)) {
                        return 'Text must contain at least one special character!';
                      } else if (value.length != 8) {
                        return 'password must contain 8 digits!';
                      }
                      return null;
                    },
                  )),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: _obscureTexts,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTexts
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureTexts = !_obscureTexts;
                            });
                          },
                        ),
                        hintText: "Confirm Password",
                        labelStyle: const TextStyle(fontSize: 20),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        errorStyle: const TextStyle(
                            color: Colors.redAccent, fontSize: 15)),
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      } else if (value != passwordController.text) {
                        return 'Passwords do not match';
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
                          if (_formKey.currentState!.validate()) {
                            await Firebase.initializeApp();
                            // try {
                            //   // Check if the email already exists
                            //   QuerySnapshot emailQuery = await _items
                            //       .where("email", isEqualTo: emailController.text)
                            //       .get();
                            //
                            //   if (emailQuery.docs.isNotEmpty) {
                            //     // Email already exists, show a toast message
                            //     Fluttertoast.showToast(
                            //       msg: "Email already exists. Please use a different email address.",
                            //       toastLength: Toast.LENGTH_SHORT,
                            //       gravity: ToastGravity.CENTER,
                            //       timeInSecForIosWeb: 2,
                            //       backgroundColor: Colors.blueGrey,
                            //       textColor: Colors.white,
                            //       fontSize: 16.0,
                            //     );
                            //     return;
                            //   }
                            //   // Check if the phone number already exists
                            //   QuerySnapshot phoneQuery = await _items
                            //       .where("phone", isEqualTo: phoneController.text)
                            //       .get();
                            //   if (phoneQuery.docs.isNotEmpty) {
                            //     // Phone number already exists, show a toast message
                            //     Fluttertoast.showToast(
                            //       msg: "Phone number already exists. Please use a different number.",
                            //       toastLength: Toast.LENGTH_SHORT,
                            //       gravity: ToastGravity.CENTER,
                            //       timeInSecForIosWeb: 2,
                            //       backgroundColor: Colors.blueGrey,
                            //       textColor: Colors.white,
                            //       fontSize: 16.0,
                            //     );
                            //     return;
                            //   }
                            //   UserCredential userCredential =
                            //       await auth.createUserWithEmailAndPassword(
                            //     email: emailController.text.toString(),
                            //     password: passwordController.text.toString(),
                            //   );
                            //   final String name = nameController.text;
                            //   final String email = emailController.text;
                            //   final String phone = phoneController.text;
                            //   final String address = addressController.text;
                            //   final String password = passwordController.text;
                            //   String userId = userCredential.user?.uid ?? "";
                            //
                            //   await _items.doc(userId).set({
                            //     "name": name,
                            //     "email": email,
                            //     "phone": "+91"+phone,
                            //     "address": address,
                            //     "password": password
                            //   });
                            //
                            //   //clear text fields after successful registration
                            //   nameController.text = '';
                            //   emailController.text = '';
                            //   phoneController.text = '';
                            //   addressController.text = '';
                            //   passwordController.text = '';
                            //
                            //   // print("Sign up successfully");
                            //   Navigator.pushReplacement(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => const dashBoard(),
                            //       ));
                            //   Fluttertoast.showToast(
                            //       msg: "Register Successful");
                            // }
                          try{
                            UserCredential userCredential = await auth.createUserWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passwordController.text.toString(),
                            ).whenComplete(() async {
                              // Check if the email is already in use
                              QuerySnapshot emailQuery = await _items.where("email", isEqualTo: emailController.text).get();
                              // Check if the mobile number is already in use
                              QuerySnapshot mobileQuery = await _items.where("phone", isEqualTo: phoneController.text).get();
                              if (emailQuery.docs.isNotEmpty && mobileQuery.docs.isNotEmpty) {
                              // Both email and mobile number are already in use
                              Fluttertoast.showToast(
                              msg: "Both email and mobile number are already in use.",
                              backgroundColor: Colors.blueGrey,
                              timeInSecForIosWeb: 5,
                              );
                              return; // Stop execution if both email and mobile are already in use
                              }
                              if (emailQuery.docs.isNotEmpty) {
                                // Email is already in use
                                Fluttertoast.showToast(
                                  msg: "Email is already in use",
                                  backgroundColor: Colors.blueGrey,
                                  timeInSecForIosWeb: 5,
                                );
                                return; // Stop execution if email is already in use
                              }
                              if (mobileQuery.docs.isNotEmpty) {
                                // Mobile number is already in use
                                Fluttertoast.showToast(
                                  msg: "Phone number is already in use",
                                  backgroundColor: Colors.blueGrey,
                                  timeInSecForIosWeb: 5,
                                );
                                Fluttertoast.showToast(
                                  msg: "Please use a different mobile number.",
                                  backgroundColor: Colors.blueGrey,
                                  timeInSecForIosWeb: 5,
                                );
                                // Stop execution if mobile number is already in use
                              }
                              else{
                                // Registration successful
                                final String name = nameController.text;
                                final String email = emailController.text;
                                final String phone = phoneController.text;
                                final String address = addressController.text;
                                final String password = passwordController.text;
                                // Get the user ID
                                String userId = auth.currentUser?.uid ?? "";
                                // Add user details to Firestore or any other database
                                await _items.doc(userId).set({
                                  "name": name,
                                  "email": email,
                                  "phone": "+91$phone",
                                  "address": address,
                                  "password": password,
                                  "userId": userId,
                                });
                                // Store the document ID in shared preferences
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('userDocId', userId);
                                // Store the document ID in _userDocId
                                _userDocId = userId;
                              }
                            });


                            // Clear text fields after successful registration
                            nameController.text = '';
                            emailController.text = '';
                            addressController.text = '';
                            phoneController.text = '';
                            passwordController.text = '';

                            // Print success message to the console
                            print("User created: ${userCredential.user?.uid}");
                            print("Registration successful!");

                            // Show a toast message
                            Fluttertoast.showToast(
                              msg: "Registration successful",
                              backgroundColor: Colors.blueGrey,
                              timeInSecForIosWeb: 5,
                            );
                            //Navigate to the dashboard
                            Navigator.push(context, MaterialPageRoute(builder: (context) => loginPage()));
                          }catch (e) {
                              Fluttertoast.showToast(
                                  msg: "$e",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.blueGrey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          }
                        },
                        text: "Sign up")
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const loginPage()));
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.blueAccent),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
