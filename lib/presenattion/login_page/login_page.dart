import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopsie/presenattion/dashboard/dashboard.dart';
import 'package:shopsie/presenattion/phone_auth/phone_auth.dart';
import 'package:shopsie/presenattion/reset_password/reset_password.dart';
import 'package:shopsie/presenattion/signup_page/signup_page.dart';
import 'package:shopsie/widgets/custom_button.dart';
import 'package:sign_in_button/sign_in_button.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Google SignIn
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(googleCredential);
      SharedPreferences prefs =
      await SharedPreferences.getInstance();
      prefs.setBool('isPhone', false);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(googleCredential);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const dashBoard()),
      );
      Fluttertoast.showToast(
          msg: "Google SignIn successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0);
      return userCredential;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: [
              Container(
                  height: 100,
                  width: 100,
                  child: Image.asset("assets/images/logo.png")),
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
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
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
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  cursorColor: Colors.blueAccent,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'Email',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
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
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
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
                      hintText: 'Password',
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
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
                    } else if (!RegExp(r'^.{8}$').hasMatch(value)) {
                      return 'password must contain 8 digits!';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(1, 10, 1, 5),
                        child: CustomButton(
                          onPressed: () {
                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text)
                                .then((value) async {

                              // Store the user document ID in shared preferences
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString('userDocId', value.user?.uid ?? '');
                              prefs.setBool('isPhone', false);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const dashBoard()));
                              Fluttertoast.showToast(
                                  msg: "Sign in successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.blueGrey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }).onError((error, stackTrace) {
                              Fluttertoast.showToast(msg:  "${error.toString()}");
                              print("Error: ${error.toString()}");
                            });
                          },
                          text: "Log in",
                        )),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: Row(
                    children: [
                      Container(
                        color: Colors.grey,
                        height: 2,
                        width: MediaQuery.of(context).size.width * 0.36,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.black87, fontSize: 15),
                        ),
                      ),
                      Container(
                        color: Colors.grey,
                        height: 2,
                        width: MediaQuery.of(context).size.width * 0.36,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: SignInButton(
                  Buttons.google,
                  text: "Login with Google",
                  onPressed: () {
                    signInWithGoogle();
                    print("Google sign in successfully");
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PhoneAuth()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust the radius as needed
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(5,5,10,5),
                            child: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                          ),
                          Text("Login with phone number",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15))
                        ],
                      )),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()));
                      },
                      child: const Text(
                        'Forget Password ?',
                        style:
                            TextStyle(fontSize: 14, color: Colors.blueAccent),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account ?"),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EmailSignUp()));
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(color: Colors.blueAccent),
                            ))
                      ],
                    )
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
