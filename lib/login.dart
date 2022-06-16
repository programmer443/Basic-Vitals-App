// ignore_for_file: invalid_return_type_for_catch_error

import 'package:dashboard/dashboard.dart';
import 'package:dashboard/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;

  var _emailController = TextEditingController(),
      _passwordController = TextEditingController();
      
  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
     await Firebase.initializeApp();
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      isLoading = true;
    });
    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text)
          .then((user) => {
        FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(user.user!.uid)
            .once()
            .then((snapshot) {
          if (snapshot.snapshot.exists) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
                ((route) => false));
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Error"),
                    content: const Text("User not found"),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text("Ok"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
          }
        })
      })
          .catchError((e) => {
        _passwordController.clear(),
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(e.message),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Ok'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            )),
        setState(() {
          isLoading = false;
        }),
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: const Color.fromARGB(84, 0, 0, 0),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 40, bottom: 20),
                        child: Text(
                          'Log In',
                          style: TextStyle(
                              fontSize: 35,
                              color: Color.fromARGB(255, 24, 161, 88),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) =>
                    value!.isEmpty ? 'Email is required' : null,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) =>
                    value!.isEmpty ? 'Password is required' : null,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 55, right: 55),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                      onPressed: (() => {_submit()}),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15.0),
                          minimumSize: const Size.fromHeight(30),
                          primary: const Color.fromARGB(184, 150, 192, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 55, right: 55),
                  child: ElevatedButton(
                      onPressed: (() => {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Registraion(),
                          ),
                        )
                      }),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15.0),
                          minimumSize: const Size.fromHeight(30),
                          primary: const Color.fromARGB(0, 2, 2, 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(
                                color: Color.fromARGB(184, 150, 192, 0)),
                          )),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ]),
            ),
          ),
        ));
  }
}
