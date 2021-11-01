import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_locator/register_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) =>
          HomePage()));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Log In"),
        ),
        body: Center(
          child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField( // Username text field
                      controller: emailController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email'
                      ),
                    ),
                    TextFormField( // Password text field
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Password...',
                      ), obscureText: true,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                            children: <Widget>[
                              ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      try {
                                        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                            email: emailController.text, password: passwordController.text);

                                        print(userCredential.toString());

                                        Navigator.push(context, MaterialPageRoute(
                                              builder: (context) => HomePage()));

                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'user-not-found') {
                                          Fluttertoast.showToast(msg: 'User not found.');

                                        } else if (e.code == 'wrong-password') {
                                          Fluttertoast.showToast(msg: 'Wrong password.');
                                        }
                                      }

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomePage()),
                                      );
                                    }
                                  },
                                  child: const Text('Login')
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => (RegisterPage())),
                                    );
                                  },
                                  child: const Text('Register')
                              ),
                            ]
                        )
                    )
                  ]
              )
          ),
        )
    );
  }
}