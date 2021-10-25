import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'login_view.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final RegExp usernameRegex = new RegExp(r"^[A-Za-z\d]{4,20}$");
  final RegExp passwordRegex =
      new RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@#$!%*?&_]{8,}$");

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 35),
                      Text("Sign Up",
                          style: TextStyle(
                            fontSize: 24,
                          )),
                      SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Email",
                              style: TextStyle(color: Colors.pinkAccent)),
                          TextFormField(
                              // Username text field
                              controller: usernameController,
                              decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.pinkAccent),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  hintText: 'Username...'),
                              validator: (String? value) {
                                return (!usernameRegex.hasMatch(value!)
                                    ? "Username can only contain alphanumeric characters, and must be 4-20 characters."
                                    : null);
                              }),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Password",
                              style: TextStyle(color: Colors.pinkAccent)),
                          TextFormField(
                            // Password text field
                            controller: passwordController,
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.pinkAccent),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Password...',
                            ),
                            obscureText: true,
                            validator: (String? value) {
                              return (!passwordRegex.hasMatch(value!)
                                  ? "Password must be 8 characters or longer, \nand contain at least one upper case letter, \none lower case letter,\nand one digit."
                                  : null);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Confirm Password",
                              style: TextStyle(color: Colors.pinkAccent)),
                          TextFormField(
                            // Password confirm text field
                            controller: passwordConfirmController,
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.pinkAccent),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Confirm Password...',
                            ),
                            obscureText: true,
                            validator: (String? value) {
                              return (value != passwordController.text)
                                  ? "Passwords must match."
                                  : null;
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(children: <Widget>[
                          Row(children: <Widget>[
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.pinkAccent,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  fixedSize: const Size(330, 20),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                    );
                                  }
                                },
                                child: const Text('Continue'))
                          ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Have an account?"),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                (LoginPage())),
                                      );
                                    },
                                    child: const Text('Sign In')),
                              ]),
                        ]),
                      )
                    ])),
          ),
        ));
  }
}
