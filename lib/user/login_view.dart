import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_locator/user/forgot_password.dart';
import 'package:library_locator/user/register_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../views/home.dart';
import '../main.dart';

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
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign In"),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Email", style: TextStyle(color: Colors.amber)),
                          TextFormField(
                            validator: (val) => val!.isEmpty || !val.contains("@")
                                ? "Enter a valid email"
                                : null,
                            // Username text field
                            controller: emailController,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                hintText: 'Email'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Password", style: TextStyle(color: Colors.amber)),
                          TextFormField(
                            // Password text field
                            controller: passwordController,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Password...',
                            ),
                            obscureText: true,
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Container(
                            child: Column(children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            try {
                                              UserCredential userCredential =
                                              await FirebaseAuth.instance
                                                  .signInWithEmailAndPassword(
                                                  email: emailController
                                                      .text,
                                                  password:
                                                  passwordController
                                                      .text);

                                              print(userCredential.toString());
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          App()));
                                            } on FirebaseAuthException catch (e) {
                                              print(e.toString());
                                              String msg = "";
                                              if (e.code == 'user-not-found') {
                                                msg = "User not found";
                                              } else if (e.code ==
                                                  'wrong-password') {
                                                msg = 'Wrong password';
                                              }
                                              Fluttertoast.showToast(
                                                  msg: msg,
                                                  toastLength: Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.BOTTOM,
                                                  fontSize: 16.0);
                                            }
                                          }
                                        },
                                        child: const Text('Sign In')))
                                    ,
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    (ForgotPasswordPage())),
                                          );
                                        },
                                        child:
                                            const Text('Forgot Password?', style: TextStyle(color: Colors.amberAccent))),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    (RegisterPage())),
                                          );
                                        },
                                        child: const Text('Sign up', style: TextStyle(color: Colors.amberAccent))),
                                  ]),
                            ]),
                          ))
                    ])),
          ),
        ));
  }
}
