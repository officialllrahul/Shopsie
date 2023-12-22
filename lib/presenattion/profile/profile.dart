import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopsie/presenattion/edit_profile/edit_profile.dart';
import 'package:shopsie/widgets/custom_button.dart';

import '../login_page/login_page.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    // Navigator.pushReplacementNamed(context, 'LoginPage');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const loginPage()),
    );
  }
  final CollectionReference _items = FirebaseFirestore.instance.collection('UsersData');
  User ? _user;
  String ? _name;
  String ? _email;
  String ? _address;
  String ? _phone;
  String? _docId;
  final auth = FirebaseAuth.instance;
  // Method to fetch user data
  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? storedUid = prefs.getString('userDocId');
    bool? status = prefs.getBool('isPhone');
    final currentUser = auth.currentUser;
    String? phoneNumber = currentUser?.phoneNumber;
    String? email = currentUser?.email;

    if (currentUser != null) {
      try {
        DocumentSnapshot<Object?> snapshot;
        if (status ==null || status == false) {
          snapshot = await _items.where('email', isEqualTo: email).limit(1).get().then((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              return querySnapshot.docs.first;
            } else {
              throw Exception("User data not found for phone number: $phoneNumber");
            }
          });

        } else {
          // If no stored document ID, try fetching based on phone number
          snapshot = await _items.where('phone', isEqualTo: phoneNumber).limit(1).get().then((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              return querySnapshot.docs.first;
            } else {
              throw Exception("User data not found for phone number: $phoneNumber");
            }
          });
        }

        if (snapshot.exists) {
          Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            setState(() {
              _name = userData['name'];
              _email = userData['email'];
              _phone = userData['phone'];
              _address = userData['address'];
              _docId = userData["userId"];
            });
          }
        } else {
          print("User data does not exist in Firestore");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }


  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
      if (_user != null) {
        // Fetch user profile data from FireStore
        _fetchUserData();
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _user != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            if (_name != null) Text(_name!),
            const SizedBox(height: 10),
            if (_email != null) Text(_email!),
            const SizedBox(height: 20),
            if (_phone != null) Text(_phone!),
            const SizedBox(height: 20),
            if (_address != null) Text(_address!),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const editProfile()),
                );
              },
              text: 'Edit Profile',
            ),
            CustomButton(onPressed: (){
              signOut();
            }, text:"Logout")
          ],
        )
            : const CircularProgressIndicator(), // Show loading indicator
      ),
    );
  }
}
