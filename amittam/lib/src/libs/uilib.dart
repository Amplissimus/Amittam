import 'package:Amittam/src/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StandardAppBar extends AppBar {
  StandardAppBar({
    @required String title,
    bool centerTitle = true,
    List<Widget> actions,
    double fontSize = 25,
    Widget leading,
    Color backgroundColor = Colors.transparent,
  }) : super(
          leading: leading,
          actions: actions,
          elevation: 0,
          backgroundColor: backgroundColor,
          centerTitle: centerTitle,
          title: StandardText(title, fontSize: fontSize),
        );
}

class StandardTextFormField extends TextFormField {
  StandardTextFormField({
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
    List<TextInputFormatter> formatters,
  }) : super(
          autofocus: autofocus,
          focusNode: focusNode,
          obscureText: obscureText,
          enableInteractiveSelection: enableInteractiveSelection,
          onChanged: onChanged,
          cursorColor: CustomColors.colorForeground,
          controller: controller,
          inputFormatters: formatters,
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
              borderSide:
                  BorderSide(color: CustomColors.colorForeground, width: 1.0),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: CustomColors.colorForeground, width: 2.0),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
}

class ExtendedFab extends StatelessWidget {
  ExtendedFab({@required this.onPressed, @required this.label, this.icon});

  final void Function() onPressed;
  final Widget label;
  final Widget icon;

  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
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

class SwitchWithText extends ListTile {
  SwitchWithText({
    @required String text,
    @required bool value,
    @required void Function(bool) onChanged,
  }) : super(
          title: StandardText(text),
          trailing: Switch(
            inactiveTrackColor: Colors.grey,
            inactiveThumbColor: CustomColors.colorForeground,
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
        );
}

class DisplayValueWidget extends Container {
  DisplayValueWidget(
      {Object value = '', String valueType = '', void Function() onTap})
      : super(
          decoration: BoxDecoration(
            border: Border.all(color: CustomColors.colorForeground),
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.all(18),
              child: StandardText(
                value.toString().isEmpty ? '$valueType' : '$value',
                fontSize: 18,
              ),
            ),
          ),
        );
}

class MainScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
          BuildContext context, Widget child, AxisDirection axisDirection) =>
      child;
}

class CustomMaterialColor extends MaterialColor {
  CustomMaterialColor(int code)
      : super(code, {
          50: Color(code),
          100: Color(code),
          200: Color(code),
          300: Color(code),
          400: Color(code),
          500: Color(code),
          600: Color(code),
          700: Color(code),
          800: Color(code),
          900: Color(code),
        });
}

void showStandardDialog({
  @required BuildContext context,
  String title = '',
  Widget content,
  void Function() onConfirm,
}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: StandardText(title),
        content: content,
        backgroundColor: CustomColors.colorBackground,
        elevation: 0,
        actions: <Widget>[
          FlatButton(
            splashColor: CustomColors.colorForeground,
            child: StandardText('CANCEL'),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            splashColor: CustomColors.colorForeground,
            child: StandardText('CONFIRM'),
            onPressed: onConfirm,
          ),
        ],
      ),
    );

class StandardText extends Text {
  StandardText(String text, {double fontSize})
      : super(text,
            style: TextStyle(
                color: CustomColors.colorForeground, fontSize: fontSize));
}
