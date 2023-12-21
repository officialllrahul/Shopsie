import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'navigate.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen=SplashServices();
  @override
  void initState() {
    super.initState();
    splashScreen.isLogin(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: double.infinity,
          width: double.infinity,
          color:Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height:100,
                width: 100,
                child: Image.asset("assets/images/logo.png"),
              ),
               const SizedBox(
                height: 50,
                width: double.infinity,
                child: Center(child: Text("Shopsie",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 35),)),
              ),
            ],
          )
        ),
      ),
    );
  }
}