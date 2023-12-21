import 'package:flutter/material.dart';

class productPage extends StatefulWidget {
  const productPage({super.key});

  @override
  State<productPage> createState() => _productPageState();
}

class _productPageState extends State<productPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Product"),
      ),
    );
  }
}
