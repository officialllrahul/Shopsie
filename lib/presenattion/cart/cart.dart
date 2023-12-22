import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopsie/presenattion/product_ordered_page/product_ordered_page.dart';

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
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: streamSnapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                  final Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
                  return Card(
                    shadowColor: Colors.black,
                    elevation: 5,
                      child: GestureDetector(
                      onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ProductOrderedPage(data: data)),
                    );
                  },
                    child: ListTile(
                      leading: Image.network(
                        data?['p_image'] ?? '',
                        width: 100,
                        height: 100,
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
                              Text('Total amount: \₹${data?['total_price'] ?? ''}'),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
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
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                      // Add other necessary details
                    ),
                      )
                  );
                },
              );
            }
            // You might want to handle the case where there's no data
            return const CircularProgressIndicator(); // Replace this with a loading indicator or an empty state widget
          },
        )
      )
    );
  }
}
