import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_locator/services/database_service.dart';
import 'package:library_locator/user/profile_view.dart';
import 'package:library_locator/providers/bottom_navigation_provider.dart';
import 'package:library_locator/views/search_view.dart';

import 'views/bottom_navigation_bar_widget.dart';
import 'views/home.dart';
import 'views/loadingScreenView.dart';
import 'user/login_view.dart';

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
  List<Widget>? cache;

  Widget _getViewContainer(int index) {

    final _currentUser = FirebaseAuth.instance.currentUser;

    List<Widget> notLoggedIn = [HomePage(updateCache: updateCache, cache: this.cache), SearchView(cache: this.cache), LoginPage()];
    List<Widget> userWidgetsList = [HomePage(updateCache: updateCache, cache: this.cache), SearchView(cache: this.cache), ProfilePage()];


    if (_currentUser != null) {
        return userWidgetsList[index];
    } else {
      return notLoggedIn[index];
    }
  }

  void updateCache() {
    DatabaseService().getBooks().then((value) => this.cache = value);
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
                brightness: Brightness.dark,
                primarySwatch: Colors.amber,
                primaryTextTheme: Typography.whiteCupertino,
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
          return LoadingScreen(fontSize: 30);
        });
  }
}


