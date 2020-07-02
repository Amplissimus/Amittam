import 'package:amittam/values.dart';
import 'package:flutter/material.dart';

Widget customAppBar({
  @required String title,
  bool centerTitle = true,
  double fontSize = 25,
}) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    centerTitle: centerTitle,
    title: Text(
      title,
      style: TextStyle(fontSize: fontSize, color: CustomColors.colorForeground),
    ),
  );
}
