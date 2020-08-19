import 'package:Amittam/src/objects/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class StandardAppBar extends AppBar {
  StandardAppBar({
    @required String title,
    Color fontColor,
    bool centerTitle = true,
    List<Widget> actions,
    double fontSize = 25,
    Widget leading,
    Color backgroundColor,
  }) : super(
          leading: leading,
          actions: actions,
          elevation: 0,
          backgroundColor: backgroundColor,
          centerTitle: centerTitle,
          title: StandardText(title, fontSize: fontSize, fontColor: fontColor),
        );
}

class StandardTextFormField extends TextFormField {
  StandardTextFormField({
    String hint,
    TextInputType textInputType,
    GlobalKey<FormFieldState> key,
    TextEditingController controller,
    String errorText,
    void Function(String) onChanged,
    void Function(String) onSaved,
    bool enableInteractiveSelection = true,
    Widget suffixIcon,
    bool obscureText = false,
    bool autofocus = false,
    FocusNode focusNode,
    List<TextInputFormatter> formatters,
  }) : super(
          onSaved: onSaved,
          autofocus: autofocus,
          focusNode: focusNode,
          obscureText: obscureText,
          enableInteractiveSelection: enableInteractiveSelection,
          onChanged: onChanged,
          controller: controller,
          inputFormatters: formatters,
          key: key,
          keyboardType: textInputType,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            errorText: errorText,
            labelText: hint,
          ),
        );
}

class SwitchWithText extends ListTile {
  SwitchWithText({
    @required BuildContext context,
    @required String text,
    @required bool value,
    @required void Function(bool) onChanged,
    Color fontColor,
  }) : super(
          title: StandardText(text, fontColor: fontColor),
          trailing: Switch(
            inactiveTrackColor:
                Provider.of<ThemeChanger>(context).usesDarkTheme()
                    ? Colors.white30
                    : Colors.black26,
            inactiveThumbColor: Colors.grey,
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
            border: Border.all(color: Colors.grey),
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

Future<void> showStandardDialog({
  @required BuildContext context,
  String title = '',
  Widget content,
  void Function() onConfirm,
}) async =>
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: StandardText(title),
        content: content,
        elevation: 0,
        actions: <Widget>[
          FlatButton(
            child: Text(currentLang.cancel.toUpperCase()),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child: Text(currentLang.confirm.toUpperCase()),
            onPressed: () => {Navigator.pop(context), onConfirm()},
          ),
        ],
      ),
    );

class StandardText extends Text {
  StandardText(String text,
      {double fontSize, TextAlign textAlign, Color fontColor})
      : super(text,
            textAlign: textAlign,
            style: TextStyle(color: fontColor, fontSize: fontSize));
}

class StandardDivider extends Divider {
  StandardDivider({double height = 0}) : super(thickness: 2, height: height);
}

class StandardSpeedDialChild extends SpeedDialChild {
  StandardSpeedDialChild({
    String label,
    @required Icon icon,
    void Function() onTap,
  }) : super(label: label, child: icon, onTap: onTap);
}

class StandardButton extends Card {
  StandardButton(
      {@required IconData iconData,
      void Function() onTap,
      @required String text})
      : super(
          child: ListTile(
            leading: Icon(iconData, color: Colors.green),
            title: StandardText(text),
            onTap: onTap,
          ),
        );
}

class StandardDropdownButton extends DropdownButton {
  StandardDropdownButton(
      {@required List<DropdownMenuItem<dynamic>> items,
      @required dynamic value,
      @required void Function(dynamic value) onChanged})
      : super(
          items: items,
          onChanged: onChanged,
          value: value,
          underline: Container(height: 2, color: Colors.green),
        );
}

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;

  ThemeChanger(this._themeData);

  ThemeData getTheme() => _themeData;

  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }

  void setDarkMode(bool b) =>
      setTheme(b ? Themes.darkTheme : Themes.brightTheme);

  bool usesDarkTheme() => getTheme() == Themes.darkTheme;
}

class MaterialAppWithTheme extends StatelessWidget {
  MaterialAppWithTheme({@required this.homePage});

  final Object homePage;

  @override
  Widget build(BuildContext context) => MaterialApp(
        builder: (context, child) =>
            ScrollConfiguration(behavior: MainScrollBehavior(), child: child),
        home: homePage,
        theme: Provider.of<ThemeChanger>(context).getTheme(),
      );
}

class Themes {
  var f = ThemeData(primarySwatch: Colors.green);
  static final ThemeData brightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.green,
    cursorColor: Colors.black,
    accentColor: Colors.green,
    cardColor: Color.fromRGBO(220, 220, 220, 1),
    colorScheme: ColorScheme(
      primary: Colors.green,
      primaryVariant: Colors.green,
      secondary: Colors.black,
      secondaryVariant: Colors.black,
      surface: Colors.white10,
      background: Colors.white10,
      error: Colors.red,
      onPrimary: Colors.green,
      onSecondary: Colors.black,
      onSurface: Colors.white10,
      onBackground: Colors.white10,
      onError: Colors.red,
      brightness: Brightness.light,
    ),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle:
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      elevation: 0,
      backgroundColor: Colors.black12,
    ),
    cardTheme: CardTheme(elevation: 0),
    textTheme: TextTheme(
      headline1: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      headline2: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      headline3: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      headline4: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      headline5: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      headline6: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      subtitle1: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      subtitle2: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      bodyText2: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      caption: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      button: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      overline: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.deepPurple, //  <-- dark color
      textTheme:
          ButtonTextTheme.primary, //  <-- this auto selects the right color
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Colors.green,
      inactiveTrackColor: Colors.white12,
      thumbColor: Colors.black,
      inactiveTickMarkColor: Colors.green,
      valueIndicatorColor: Colors.green,
      overlayColor: Colors.black12,
    ),
    iconTheme: IconThemeData(color: Colors.black),
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        headline6: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      iconTheme: IconThemeData(color: Colors.black),
      actionsIconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
      shadowColor: Colors.transparent,
      centerTitle: true,
      color: Colors.black12,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
    ),
  );
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.green,
    cursorColor: Colors.white,
    accentColor: Colors.green,
    cardColor: Color.fromRGBO(70, 70, 70, 1),
    cardTheme: CardTheme(elevation: 0),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      elevation: 0,
      backgroundColor: Colors.black12,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Colors.green,
      inactiveTrackColor: Colors.white12,
      thumbColor: Colors.white,
      inactiveTickMarkColor: Colors.green,
      valueIndicatorColor: Colors.green,
      overlayColor: Colors.white10,
    ),
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      headline1: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      headline2: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      headline3: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      headline4: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      headline5: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      headline6: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      subtitle1: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      subtitle2: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      bodyText2: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      caption: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      button: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      overline: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.black26,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.white, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.0),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
    ),
  );
}
