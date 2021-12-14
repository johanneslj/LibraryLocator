import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../main.dart';
import '../views/home.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = "";

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Forgot Password"),
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
                          Text("Please enter your email",
                              style: TextStyle(
                                fontSize: 24,
                              )),
                        ],
                      ),
                      SizedBox(height: 35),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Email"),
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
                                          if (_formKey.currentState!.validate()) {
                                              FirebaseAuth.instance.sendPasswordResetEmail(
                                                  email: emailController.text);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => App()
                                                  )
                                              );
                                              Fluttertoast.showToast(
                                                msg: "If this accout exists, an email with password reset instructions has been sent.",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.amber,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                              );
                                          }
                                        },
                                        child: const Text('Reset Password')))
                                    ,
                                  ]),
                            ]),
                          ))
                    ])),
          ),
        ));
  }
}
