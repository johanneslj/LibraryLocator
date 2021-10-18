import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G'];
    final List<int> colorCodes = <int>[600, 500, 100];
    return Scaffold(
        appBar: AppBar(
          title: Text('First Route'),
        ),
        body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              while(colorCodes.length < entries.length){
                colorCodes.add(colorCodes[0]);
              }
              return Container(
                height: 50,
                color: Colors.amber[colorCodes[index]],
                child: ElevatedButton(
                  child: Text(entries[index]),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(title: 'cool')),
                    );
// Navigate to second route when tapped.
                  },
                ),
              );
            }));
  }
}
