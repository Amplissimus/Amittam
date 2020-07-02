import 'package:Amittam/libs/lib.dart';
import 'package:Amittam/libs/uilib.dart';
import 'package:Amittam/values.dart';
import 'package:flutter/material.dart';

class FirstLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    updateBrightness();
    return MaterialApp(home: FirstLoginScreenPage());
  }
}

class FirstLoginScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FirstLoginScreenPageState();
}

class FirstLoginScreenPageState extends State<FirstLoginScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.colorBackground,
      appBar: customAppBar(title: Strings.appTitle),
    );
  }
}
