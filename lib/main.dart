import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'home.dart';
import 'login_view.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }

        // After initialization, app is shown
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Library Locator',
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.pink,
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    primary: Colors.white)
              )
            ),
            home: HomePage(),
          );
        }

        // While app is initializing
        return LoadingScreen();
      }
    );
  }

}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Text('Loading...')
    );
  }
}
