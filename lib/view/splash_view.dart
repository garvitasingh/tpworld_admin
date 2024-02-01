import 'dart:async';

import 'package:flutter/material.dart';

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
      Navigator.pushReplacementNamed(context, Routes.login);
     
    });
    super.initState();
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
