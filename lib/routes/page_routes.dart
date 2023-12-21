import 'package:flutter/cupertino.dart';
import 'package:shopsie/presenattion/dashboard/dashboard.dart';
import 'package:shopsie/presenattion/login_page/login_page.dart';
import 'package:shopsie/presenattion/splash_screen/splash_screen.dart';

class AppRoutes{
  static const String splashScreen ='/';
  static const String loginScreen ='/login';
  static const String dashboard= '/dashboard';

  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.splashScreen: (context) => SplashScreen(),
      AppRoutes.loginScreen: (context) => loginPage(),
      AppRoutes.dashboard: (context) => dashBoard(),

    };
  }

}