import 'package:Amittam/libs/lib.dart';
import 'package:Amittam/libs/uilib.dart';
import 'package:Amittam/values.dart';
import 'package:flutter/material.dart';

class DisplayPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    updateBrightness();
    return MaterialApp(home: DisplayPasswordPage());
  }
}

class DisplayPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DisplayPasswordPageState();
}

class DisplayPasswordPageState extends State<DisplayPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.colorBackground,
      appBar: customAppBar(title: 'Amittam'),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView(
          children: [
            displayValueWidget(value: 'Google', valueType: 'Platform'),
          ],
        ),
      ),
    );
  }
}
