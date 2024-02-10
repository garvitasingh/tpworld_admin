import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tpworld_admin/view/admin/admin_login.dart';
import 'package:tpworld_admin/view/admin/dashboard.dart';

import '../routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      checkUserAuthentication();
    });
    super.initState();
  }

  Future<void> checkUserAuthentication() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      // User is already authenticated, navigate to home screen
      // Navigator.pushReplacementNamed(context, '/dashboard');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DashBoardView(
              index: 0,
            ),
          ),
          (route) => false);
    } else {
      // User is not authenticated, navigate to login screen
      //   Navigator.pushReplacementNamed(context, '/login');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => AdminLoginView(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        color: Colors.white,
        padding: EdgeInsets.all(120),
        child: Image.asset("assets/images/LOGO.png"),
      ),
    );
  }
}
