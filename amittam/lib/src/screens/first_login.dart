import 'package:Amittam/src/libs/animationlib.dart';
import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/main.dart';
import 'package:Amittam/src/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:password_strength/password_strength.dart';

class FirstLogin extends StatefulWidget {
  @override
  _FirstLoginState createState() => _FirstLoginState();
}

class _FirstLoginState extends State<FirstLogin> {
  Color passwordStrengthColor = Colors.grey;
  GlobalKey<FormFieldState> masterPWTextFieldKey = GlobalKey();
  TextEditingController masterPWTextFieldController = TextEditingController();
  String masterPWTextFieldErrorString;
  bool masterPWTextFieldInputHidden = false;

  @override
  void initState() {
    Values.afterBrightnessUpdate = () => setState(() {});
    super.initState();
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
                StandardTextFormField(
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
                  hint: 'Set Masterpassword',
                  onChanged: (textFieldText) {
                    setState(() => masterPWTextFieldErrorString = null);
                    String value = textFieldText.trim();
                    double strength = estimatePasswordStrength(value);
                    if (strength < 0.3)
                      setState(() => passwordStrengthColor = Colors.grey);
                    else if (strength < 0.7)
                      setState(() => passwordStrengthColor = Colors.orange);
                    else
                      setState(() => passwordStrengthColor = Colors.green);
                  },
                ),
                Padding(padding: EdgeInsets.all(8)),
                AnimatedContainer(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: passwordStrengthColor,
                    border: Border(),
                  ),
                  height: 10,
                  duration: Duration(milliseconds: 250),
                ),
                Padding(padding: EdgeInsets.all(48)),
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
        label: StandardText('Set Password'),
        onPressed: () {
          double strength =
              estimatePasswordStrength(masterPWTextFieldController.text.trim());
          if (strength < 0.3) {
            setState(() =>
                masterPWTextFieldErrorString = 'Password not strong enough!');
            return;
          }
          showStandardDialog(
            context: context,
            title: 'Confirm Master Password',
            content: StandardText(
              'Please confirm that '
              '"${masterPWTextFieldController.text.trim()}"'
              ' is your correct password!',
            ),
            onConfirm: () {
              try {
                Prefs.setMasterPassword(
                    masterPWTextFieldController.text.trim());
              } catch (e) {
                print(errorString(e));
                masterPWTextFieldErrorString = 'Error!';
                return;
              }
              Prefs.firstLogin = false;
              Animations.pushReplacement(context, MainApp());
            },
          );
          return;
        },
        icon: Icon(MdiIcons.formTextboxPassword),
      ),
    );
  }
}
