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
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 24,
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("if user is logged in use biometrics"),
                        ],
                      ),
                      SizedBox(height: 35),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              "Email",
                              style: TextStyle(
                                color: Colors.pinkAccent
                              )
                          ),
                          TextFormField(
                            // Username text field
                            controller: emailController,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color:Colors.pinkAccent
                                  ),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                hintText: 'Email'
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              "Password",
                              style: TextStyle(
                                  color: Colors.pinkAccent
                              )
                          ),
                          TextFormField( // Password text field
                            controller: passwordController,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color:Colors.pinkAccent
                                ),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Password...',
                            ), obscureText: true,
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Container(
                            child: Column(
                                children: <Widget>[
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.pinkAccent,
                                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              fixedSize: const Size(330,20),
                                            ),
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
                                            child: const Text('Sign In')
                                        ),
                                      ]
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) => (RegisterPage())),
                                              );
                                            },
                                            child: const Text('Forgotten Password')
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) => (RegisterPage())),
                                              );
                                            },
                                            child: const Text('Register')
                                        ),
                                      ]
                                  ),
                                ]
                            ),
                          )
                      )
                    ]
                )
            ),
          ),
        )
    );
  }
}