import 'package:dashboard/dashboard.dart';
import 'package:dashboard/login.dart';
import 'package:dashboard/loginOptions.dart';
import 'package:dashboard/register.dart';
import 'package:dashboard/notificationservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  Firebase.initializeApp();
  runApp(Home() );
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Vitals',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0XFF010411),
        scaffoldBackgroundColor: Color(0XFF010411),
      ),
      home: LoginCateory() ,
      debugShowCheckedModeBanner: false,
    );
  }
}

