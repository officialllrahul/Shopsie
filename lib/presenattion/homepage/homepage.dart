import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopsie/presenattion/login_page/login_page.dart';
import 'package:shopsie/presenattion/order_details_page/order_details_page.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    // Navigator.pushReplacementNamed(context, 'LoginPage');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const loginPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text('Dashboard',style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout,color: Colors.white,),
              onPressed: signOut,
            ),
          ],
        ),
      body:StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('/product').snapshots(),
                builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic>? data =
                      document.data() as Map<String, dynamic>?;
                      if (data == null ||
                          data['p_image'] == null ||
                          data['p_name'] == null ||
                          data['seller_id'] == null ||
                          data['category'] == null||
                          data['p_description'] == null ||
                          data['p_price'] == null) {
                        return SizedBox(); // Skip rendering if any required field is null
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailsPage(data: data),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Image.network(
                              data['p_image']!,
                              width: 100,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            title: Text(data['p_name']!),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Seller ID: ${data['seller_id']}'),
                                Text('Description: ${data['p_description']}'),
                                Text('Price: ${data['p_price']}'),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            );
  }
}
