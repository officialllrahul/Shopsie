import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopsie/presenattion/dashboard/dashboard.dart';
import 'package:shopsie/presenattion/login_page/login_page.dart';

class SplashServices{
  void isLogin(BuildContext context)
  {
    final auth=FirebaseAuth.instance;
    final user=auth.currentUser;
    if(user!=null){
      Timer(const Duration(seconds: 3),(){
        Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (context) => const dashBoard()
        )
        );
      }
      );
    }

    else{
      Timer(const Duration(seconds: 3),(){
        Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (context) => const loginPage()
        )
        );
      }
      );
    }
  }
}