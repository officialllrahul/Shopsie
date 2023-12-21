import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopsie/presenattion/edit_profile/edit_profile.dart';
import 'package:shopsie/widgets/custom_button.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final CollectionReference _items = FirebaseFirestore.instance.collection('UsersData');
  User ? _user;
  String ? _name;
  String ? _email;
  String ? _address;
  String ? _phone;

  // Method to fetch user data
  Future<void> _fetchUserData() async {
    if (_user != null) {
      try {
        DocumentSnapshot<Object?> snapshot = await _items.doc(_user!.uid).get();

        if (snapshot.exists) {
          Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            setState(() {
              _name = userData['name'];
              _email = userData['email'];
              _address = userData['address'];
              _phone = userData['phone'];
            });
          }
        } else {
          // Handle the case where the user data doesn't exist
          print("User data does not exist in Firestore for user: ${_user!.uid}");
        }

      } catch (e) {
        // Handle errors during data fetching
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
          ],
        )
            : const CircularProgressIndicator(), // Show loading indicator
      ),
    );
  }
}