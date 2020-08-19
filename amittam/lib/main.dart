import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/screens/splash_screen.dart';
import 'package:Amittam/src/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      builder: (_) => ThemeChanger(ThemeData.dark()),
      child: MaterialAppWithTheme(homePage: SplashScreenPage()),
    );
  }
}
