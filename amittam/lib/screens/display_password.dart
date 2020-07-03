import 'package:Amittam/libs/lib.dart';
import 'package:Amittam/libs/uilib.dart';
import 'package:Amittam/values.dart';
import 'package:flutter/material.dart';

class DiaplayPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    updateBrightness();
    return MaterialApp(home: DiaplayPasswordPage());
  }
}

class DiaplayPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DiaplayPasswordPageState();
}

class DiaplayPasswordPageState extends State<DiaplayPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Amittam'),
      body: Center(),
    );
  }
}
