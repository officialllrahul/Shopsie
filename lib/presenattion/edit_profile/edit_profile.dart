import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopsie/presenattion/dashboard/dashboard.dart';

class editProfile extends StatefulWidget {
  const editProfile({super.key});

  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Enter your name",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  hintText: "Enter your mobile number",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: "Enter your address",
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  await _updateUserProfile();
                },
                child: Text("Save Changes"),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> _updateUserProfile() async {

    User? user = FirebaseAuth.instance.currentUser;

    // Get the values from the controllers
    String newName = _nameController.text;
    String newMobile = _phoneController.text;
    String newAddress = _addressController.text;

    // Replace "userId" with the actual user ID or identifier
    String? userId = user?.uid;

    // Update the data in Firestore using the values newName, newMobile, and newPassword
    await FirebaseFirestore.instance.collection("UsersData").doc(userId).update({
      "name": newName,
      "phone": newMobile,
      "address": newAddress,
      "userId":userId
    });

    Navigator.push(context,MaterialPageRoute(builder: (context)=> dashBoard()));
  }
}