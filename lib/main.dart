import 'package:flutter/material.dart';
import 'package:umacalendar_v2/base/base.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CALUMa v2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(title: 'CALUMa'),
    );
  }
}


