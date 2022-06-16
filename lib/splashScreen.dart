import 'dart:async';

import 'package:dashboard/Dashboard.dart';
import 'package:dashboard/loginOptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (FirebaseAuth.instance.currentUser != null) {
        timer.cancel();
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) => Dashboard(),
          ),
        );
      } else {
        timer.cancel();
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) => const LoginCateory(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(17, 18, 41, 255),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  <Widget>[
              Image.asset(
                'assets/images/logo.png',
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              SizedBox(height: 20),
              const Text(
                'WELCOME',
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
