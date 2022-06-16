import 'package:dashboard/login.dart';
import 'package:dashboard/register.dart';
import 'package:flutter/material.dart';

class LoginCateory extends StatefulWidget {
  const LoginCateory({Key? key}) : super(key: key);

  @override
  State<LoginCateory> createState() => _LoginCateoryState();
}

class _LoginCateoryState extends State<LoginCateory> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see theEvi
        // application has a blue toolbar. Then, without quitting the app, try

      ),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(17, 18, 41, 255),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
              ),
              Container(
                child: Column(
                  children: [
                    const Text('Login or Register',
                        style: TextStyle(fontSize: 12, color: Colors.white)),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                          onPressed: (() => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            )
                          }),
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15.0),
                              minimumSize: const Size.fromHeight(40),
                              primary: const Color.fromARGB(186, 25, 250, 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(color: Colors.white)),
                              textStyle: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          child: const Text('Login')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                          onPressed: (() => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const Registraion()),
                            )
                          }),
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15.0),
                              minimumSize: const Size.fromHeight(40),
                              primary: const Color.fromARGB(186, 34, 250, 97),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(color: Colors.white)),
                              textStyle: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          child: const Text('Registration')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
