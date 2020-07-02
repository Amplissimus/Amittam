import 'package:amittam/libs/lib.dart';
import 'package:amittam/libs/uilib.dart';
import 'package:amittam/values.dart';
import 'package:flutter/material.dart';

import 'objects/password.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.colorBackground,
      appBar: customAppBar(title: 'Amittam'),
      body: Container(
        color: Colors.transparent,
      ),
    );
  }
}
