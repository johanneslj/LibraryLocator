import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'main.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final RegExp usernameRegex = new RegExp(r"^[A-Za-z\d]{4,20}$");
  final RegExp passwordRegex = new RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@#$!%*?&_]{8,}$");

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
          child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField( // Username text field
                        controller: usernameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Username...'
                        ),
                        validator: (String? value) {
                          return (!usernameRegex.hasMatch(value!)
                              ? "Username can only contain alphanumeric characters, and must be 4-20 characters."
                              : null);
                        }
                    ),
                    TextFormField( // Password text field
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Password...',
                      ), obscureText: true,
                      validator: (String? value) {
                        return (!passwordRegex.hasMatch(value!)
                            ? "Password must be 8 characters or longer, \nand contain at least one upper case letter, \none lower case letter,\nand one digit."
                            : null);
                      },
                    ),
                    TextFormField( // Password confirm text field
                      controller: passwordConfirmController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Confirm Password...',
                      ), obscureText: true,
                      validator: (String? value) {
                        return (value != passwordController.text) ? "Passwords must match." : null;
                      },
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage()
                                  ),
                                );
                              }
                            },
                            child: const Text('Login')
                        )
                    )
                  ]
              )
          ),

        )
    );
  }
}