import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopsie/presenattion/dashboard/dashboard.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const OrderDetailsPage({Key? key, this.data}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  int quantity = 1;
  double initialPrice = 0.0;
  @override
  void initState() {
    super.initState();
    // Set the initial price when the widget is created
    initialPrice = double.parse(widget.data?['p_price'] ?? '0.0');
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the total price based on the current quantity
    double totalPrice = quantity * initialPrice;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Order Details',style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show the image here
                  Image.network(
                    widget.data?['p_image'] ?? '', // Provide the image URL here
                    width: 300, // Set the width as per your requirement
                    height: 400, // Set the height as per your requirement
                    fit: BoxFit.cover, // Adjust the fit as needed
                  ),
                  const SizedBox(height: 16),
                  // Add spacing between the image and other details
                  Text('Product Title: ${widget.data?['p_name']}',style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                  Text('Seller ID: ${widget.data?['seller_id']}'),
                  Text('Description: ${widget.data?['p_description']}'),
                  Text('Price:₹ ${widget.data?['p_price']}',style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity--;
                            }
                          });
                        },
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Add spacing between the quantity and "Buy Now" button
                  // Display the total price dynamically
                  Text('Total Price: ₹${totalPrice.toStringAsFixed(2)}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                  ElevatedButton(
                    onPressed: () async{
                      User? user = FirebaseAuth.instance.currentUser;
                      // Implement "Buy Now" functionality here
                      // This can include navigation, adding to cart, or making a purchase

                      // Store details in a new collection in Firestore
                      if (user != null){
                        await FirebaseFirestore.instance
                            .collection('purchased_items')
                            .add({
                          'userId': user.uid,
                          'p_name': widget.data?['p_name'],
                          'seller_id': widget.data?['seller_id'],
                          'p_description': widget.data?['p_description'],
                          'p_price': widget.data?['p_price'],
                          'quantity': quantity,
                          'total_price': totalPrice, // Store the total price
                          'p_image': widget.data?['p_image'],
                          'timestamp': FieldValue.serverTimestamp(),
                          // Add other necessary details
                        }).then((value) {
                          // Show a success message or navigate to a success page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Item purchased successfully!')),
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const dashBoard()));

                        }).catchError((error) {
                          // Handle errors if any
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to purchase item: $error')),
                          );
                        });
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('user is not logged in'))
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent, // Set the background color to green
                      onPrimary: Colors.white, // Set the text color to white
                    ),
                    child: const Text('Buy Now'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}