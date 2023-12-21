import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopsie/presenattion/splash_screen/splash_screen.dart';
import 'package:shopsie/routes/page_routes.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: AppRoutes.routes,
    )
  );
}
