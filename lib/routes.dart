import 'package:flutter/material.dart';
import 'package:tpworld_admin/view/admin/admin_home.dart';
import 'package:tpworld_admin/view/splash_view.dart';

import 'view/admin/admin_login.dart';

class Routes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String verifyCode = '/verifyCode';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashView());
      case login:
        return MaterialPageRoute(builder: (_) => AdminLoginView());
      case home:
        return MaterialPageRoute(builder: (_) => AdminHomePageView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
