import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/values.dart';
import 'package:Amittam/main.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:password_strength/password_strength.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  Color passwordStrengthColor = Colors.grey;
  GlobalKey<FormFieldState> masterPWTextFieldKey = new GlobalKey();
  TextEditingController masterPWTextFieldController =
      new TextEditingController();
  FocusNode masterPwTextFieldFocusNode = FocusNode();
  String masterPWTextFieldErrorString;
  bool masterPWTextFieldInputHidden = true;

  @override
  void initState() {
    masterPWTextFieldController.text = '';
    Values.afterBrightnessUpdate = () => setState(() {});
    super.initState();
    masterPwTextFieldFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.colorBackground,
      appBar: StandardAppBar(title: Strings.appTitle),
      body: InkWell(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.transparent,
          margin: EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                customTextFormField(
                  focusNode: masterPwTextFieldFocusNode,
                  suffixIcon: IconButton(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: masterPWTextFieldInputHidden
                        ? Icon(Icons.visibility,
                            color: CustomColors.colorForeground)
                        : Icon(Icons.visibility_off,
                            color: CustomColors.colorForeground),
                    onPressed: () => setState(() =>
                        masterPWTextFieldInputHidden =
                            !masterPWTextFieldInputHidden),
                  ),
                  obscureText: masterPWTextFieldInputHidden,
                  enableInteractiveSelection: false,
                  textinputType: TextInputType.visiblePassword,
                  errorText: masterPWTextFieldErrorString,
                  controller: masterPWTextFieldController,
                  key: masterPWTextFieldKey,
                  hint: 'Enter Masterpassword',
                  onChanged: (value) {
                    setState(() => masterPWTextFieldErrorString = null);
                    if (!Prefs.fastLogin) return;
                    String text = masterPWTextFieldController.text.trim();
                    if (estimatePasswordStrength(text) < 0.3) {
                      return;
                    } else if (Prefs.masterPasswordIsValid(text)) {
                      Values.passwords = Prefs.passwords;
                      Values.afterBrightnessUpdate = null;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainApp(),
                        ),
                      );
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(64)),
              ],
            ),
          ),
        ),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
      ),
      floatingActionButton: ExtendedFab(
        onPressed: () {
          String text = masterPWTextFieldController.text.trim();
          if (estimatePasswordStrength(text) < 0.3)
            setState(() => masterPWTextFieldErrorString = 'Impossible input!');
          else if (!Prefs.masterPasswordIsValid(text))
            setState(() => masterPWTextFieldErrorString = 'Invalid input!');
          else {
            Values.passwords = Prefs.passwords;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainApp(),
              ),
            );
          }
        },
        icon: Icon(MdiIcons.login),
        label: Text('Log in'),
      ),
    );
  }
}
