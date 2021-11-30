import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_locator/profile_view.dart';
import 'package:library_locator/providers/bottom_navigation_provider.dart';

import 'book_details_view.dart';
import 'bottom_navigation_bar_widget.dart';
import 'home.dart';
import 'login_view.dart';

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase provider, Object? newValue) {
    print('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}

void main() {
  runApp(ProviderScope(observers: [
    Logger(),
  ], overrides: [], child: App()));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Widget _getViewContainer(int index) {

    final _currentUser = FirebaseAuth.instance.currentUser;

    List<Widget> notLoggedIn = [HomePage(), BookDetailsView(isbn: "12345"), LoginPage()];
    List<Widget> userWidgetsList = [HomePage(), BookDetailsView(isbn: "12345"), ProfilePage()];


    if (_currentUser != null) {
        return userWidgetsList[index];
    } else {
      return notLoggedIn[index];
    }
  }

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
              home: Scaffold(
                body: Consumer(builder: (context, watch, child) {
                  final _indexState = watch(bottomNavigationBarIndexProvider);
                  return SafeArea(
                    child: _getViewContainer(_indexState),
                  );
                },),
                bottomNavigationBar: BottomNavigationBarWidget(),
              ),
            );
          }

          // While app is initializing
          return LoadingScreen();
        });
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Text('Loading...'));
  }
}
