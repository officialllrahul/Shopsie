import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class cartPage extends StatefulWidget {
  const cartPage({super.key});

  @override
  State<cartPage> createState() => _cartPageState();
}

class _cartPageState extends State<cartPage> {
  final CollectionReference _items = FirebaseFirestore.instance.collection('purchased_items');
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> deleteCartItem(String documentId) async {
    try {
      await _items.doc(documentId).delete();
      print('Item deleted successfully');
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order List"),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: _items
            .where('userId', isEqualTo: _user?.uid)
            .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()); // Show a loading indicator
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No items in the cart'));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                final Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;

                return ListTile(
                  leading: Image.network(
                    data?['p_image'] ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error); // You can replace this with a custom error widget
                    },
                  ),

                  title: Text(data?['p_name'] ?? ''),
                  subtitle: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text('Quantity: ${data?['quantity'] ?? ''}'),
                          Text('Seller ID: ${data?['seller_id'] ?? ''}'),
                        ],
                      ),
                      IconButton(onPressed: (){
                        // Call the delete function when the IconButton is pressed
                        deleteCartItem(documentSnapshot.id);
                        Fluttertoast.showToast(
                          msg: "Item deleted successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      },
                          icon: const Icon(Icons.delete,color: Colors.red,)),

                    ],
                  ),
                  // Add other necessary details
                );
              },
            );
          },
        ),
      ),
    );
  }
}
