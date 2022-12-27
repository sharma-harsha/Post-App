import 'package:flutter/material.dart';
import 'package:signup_page/firebase_services/splash_services.dart';
// import 'dart:js';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServices splashScreen = SplashServices();

  @override
  void initState() {
    super.initState();
    splashScreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('firebase Tutorial' , style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),),
    );
  }
}