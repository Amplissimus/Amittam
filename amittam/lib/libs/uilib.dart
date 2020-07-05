import 'package:Amittam/values.dart';
import 'package:flutter/material.dart';

Widget customAppBar({
  @required String title,
  bool centerTitle = true,
  List<Widget> actions,
  double fontSize = 25,
  Widget leading,
}) {
  return AppBar(
    leading: leading,
    actions: actions,
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
  bool enableInteractiveSelection = true,
  Widget suffixIcon,
  bool obscureText = false,
  bool autofocus = false,
  FocusNode focusNode,
}) {
  return TextFormField(
    autofocus: autofocus,
    focusNode: focusNode,
    obscureText: obscureText,
    enableInteractiveSelection: enableInteractiveSelection,
    onChanged: onChanged,
    cursorColor: CustomColors.colorForeground,
    controller: controller,
    key: key,
    keyboardType: textinputType,
    style: TextStyle(color: CustomColors.colorForeground),
    decoration: InputDecoration(
      suffixIcon: suffixIcon,
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

Widget switchWithText({
  @required String text,
  @required bool value,
  void Function(bool) onChanged,
}) {
  return ListTile(
    title: Text(text, style: TextStyle(color: CustomColors.colorForeground)),
    trailing: Switch(
      inactiveTrackColor: Colors.grey,
      inactiveThumbColor: CustomColors.colorForeground,
      value: value,
      onChanged: onChanged,
      activeColor: Colors.green,
    ),
  );
}

Widget displayValueWidget({
  Object value = '',
  String valueType = '',
  bool editable = true,
  void Function() onTap,
}) {
  TextStyle style =
      TextStyle(color: CustomColors.colorForeground, fontSize: 18);
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: CustomColors.colorForeground),
      borderRadius: BorderRadius.circular(5),
    ),
    child: InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(18),
        child: Text(
          value.toString().isEmpty ? '$valueType' : '$value ($valueType)',
          style: style,
        ),
      ),
    ),
  );
}

class MainBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
          BuildContext context, Widget child, AxisDirection axisDirection) =>
      child;
}

MaterialColor materialColor(int code) {
  Color c = Color(code);
  return MaterialColor(code, {
    50: c,
    100: c,
    200: c,
    300: c,
    400: c,
    500: c,
    600: c,
    700: c,
    800: c,
    900: c
  });
}

Widget standardDialog({
  String title = '',
  List<Widget> actions,
  Widget content,
}) {
  return AlertDialog(
    title: Text(title, style: TextStyle(color: CustomColors.colorForeground)),
    content: content,
    actions: actions,
    backgroundColor: CustomColors.colorBackground,
    elevation: 0,
  );
}
