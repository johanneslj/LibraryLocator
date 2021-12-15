import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_locator/providers/bottom_navigation_provider.dart';

class BottomNavigationBarWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _currentUser = FirebaseAuth.instance.currentUser;
    final _indexState = watch(bottomNavigationBarIndexProvider);
    final _indexNotifier = watch(bottomNavigationBarIndexProvider.notifier);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    List<BottomNavigationBarItem> getNavigationBarItem() {
      List<BottomNavigationBarItem> barItemsList = [];
      print(_currentUser);
      barItemsList.add(BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)));
      barItemsList.add(BottomNavigationBarItem(label: "Search", icon: Icon(Icons.search)));
      if (_currentUser != null) {
        barItemsList.add(BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.person)));
        return barItemsList;
      } else {
        barItemsList.add(BottomNavigationBarItem(label: "Login", icon: Icon(Icons.person)));
        return barItemsList;
      }
    }

    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _indexState,
        backgroundColor: colorScheme.surface,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
        selectedLabelStyle: textTheme.caption,
        unselectedLabelStyle: textTheme.caption,
        onTap: (value) => {_indexNotifier.updateIndex(value)},
        items: getNavigationBarItem());
  }
}
