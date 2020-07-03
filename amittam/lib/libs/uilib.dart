import 'package:Amittam/values.dart';
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

Widget customTextFormField({
  String hint,
  TextInputType textinputType,
  GlobalKey<FormFieldState> key,
  TextEditingController controller,
  String errorText,
  void Function(String) onChanged,
}) {
  return TextFormField(
    onChanged: onChanged,
    cursorColor: CustomColors.colorForeground,
    controller: controller,
    key: key,
    keyboardType: textinputType,
    style: TextStyle(color: CustomColors.colorForeground),
    decoration: InputDecoration(
      errorText: errorText,
      labelText: hint,
      fillColor: CustomColors.colorForeground,
      labelStyle: TextStyle(color: CustomColors.colorForeground),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: CustomColors.colorForeground),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: CustomColors.colorForeground, width: 1.0),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: CustomColors.colorForeground, width: 2.0),
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}

Widget extendedFab({
  @required void Function() onPressed,
  @required Widget label,
  Widget icon,
}) {
  return FloatingActionButton.extended(
    onPressed: onPressed,
    label: label,
    icon: icon,
    backgroundColor: CustomColors.colorBackground,
    foregroundColor: CustomColors.colorForeground,
    elevation: 0,
    focusElevation: 0,
    splashColor: CustomColors.colorForeground,
    focusColor: Colors.transparent,
  );
}
