import 'package:flutter/material.dart';
import 'package:umacalendar_v2/base/home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  static const String _TITLE = "CALUMa";
  static const int _COLOR_HEX = 0xff004edc;
  static const Color _COLOR = Color(_COLOR_HEX);
  static const MaterialColor _COLOR_MATERIAL = MaterialColor(_COLOR_HEX, {
    50: _COLOR,
    100: _COLOR,
    200: _COLOR,
    300: _COLOR,
    400: _COLOR,
    500: _COLOR,
    600: _COLOR,
    700: _COLOR,
    800: _COLOR,
    900: _COLOR
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _TITLE,
      theme: ThemeData(primarySwatch: _COLOR_MATERIAL),
      home: Home(title: _TITLE),
    );
  }
}
