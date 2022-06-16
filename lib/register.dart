import 'package:dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Registraion extends StatefulWidget {
  const Registraion({Key? key}) : super(key: key);

  @override
  State<Registraion> createState() => _RegistraionState();
}

class _RegistraionState extends State<Registraion> {
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  var _emailController = TextEditingController(),
      _passwordController = TextEditingController(),
      _confirmPasswordController = TextEditingController(),
      _nameController = TextEditingController(),
      _phoneController = TextEditingController();

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate();
      await Firebase.initializeApp();

    if (!isValid!) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      isLoading = true;
    });
    try {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text)
          .then((value) => {
        if (value.user != null)
          {
            FirebaseDatabase.instance
                .ref()
                .child('users')
                .child(value.user!.uid)
                .set({
              'name': _nameController.text,
              'phone': _phoneController.text,
            })
                .then((value) => {
              setState(() {
                isLoading = false;
              }),
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const Dashboard()),
                  ((route) => false))
            })
                .catchError((error) => {
              setState(() {
                isLoading = false;
              })
            })
          }
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {
        showError('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        showError('The email address is invalid.');
      } else {
        showError('Error: ${e.code}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError(e);
    }
  }

  void showError(var text) {
    final snackBar = SnackBar(
      content: const Text('Yes!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 25, bottom: 55),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: const Color.fromARGB(84, 0, 0, 0),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 40, bottom: 20),
                        child: Text(
                          'Register',
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
                    controller: _nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Name',
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
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return 'Enter a valid email!';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value!.isEmpty || value.length < 10) {
                        return 'Phone Number must be at least 10 characters';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
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
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return 'Password must be at least 6 characters';
                      } else if (value != _passwordController.text) {
                        return 'Password does not match';
                      }
                      return null;
                    },
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 55, right: 55),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                      onPressed: (() => {
                        _submit(),
                      }),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15.0),
                          minimumSize: const Size.fromHeight(30),
                          primary: const Color.fromARGB(184, 150, 192, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                      child: const Text(
                        'Sign Up',
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
                        setState(() => {
                          isLoading = false,
                        })
                      }),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15.0),
                          minimumSize: const Size.fromHeight(30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(
                                color: Color.fromARGB(186, 110, 233, 255)),
                          )),
                      child: const Text(
                        'Cancel',
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
