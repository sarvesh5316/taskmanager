// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/screens/home_screen.dart';

import '../auth/signin_screen.dart';
import '../components/consts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      Timer(Duration(seconds: 3), () {
        Get.offAll(() => HomeScreen());
        logger.i(auth.currentUser!.email);
      });
    } else {
      Timer(Duration(seconds: 3), () {
        Get.offAll(() => SignInScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/logo.png",
              ),
              fit: BoxFit.contain,
            ),
            color: Colors.red,
            borderRadius: BorderRadius.circular(200),
          ),
        ),
      ),
    );
  }
}
