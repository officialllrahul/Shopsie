import 'package:flutter/material.dart';

class offerPage extends StatefulWidget {
  const offerPage({super.key});

  @override
  State<offerPage> createState() => _offerPageState();
}

class _offerPageState extends State<offerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Offers"),
      ),
    );
  }
}
