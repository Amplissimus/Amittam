import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:Amittam/src/objects/password.dart';
import 'package:Amittam/src/values.dart';
import 'package:flutter/material.dart';
import 'package:password_strength/password_strength.dart';

class AddPassword extends StatefulWidget {
  AddPassword(this.onPop);

  final void Function() onPop;

  @override
  _AddPasswordState createState() => _AddPasswordState();
}

class _AddPasswordState extends State<AddPassword> {
  GlobalKey<FormFieldState> platformTextFieldKey = GlobalKey();
  TextEditingController platformTextFieldController = TextEditingController();
  GlobalKey<FormFieldState> usernameTextFieldKey = GlobalKey();
  TextEditingController usernameTextFieldController = TextEditingController();
  GlobalKey<FormFieldState> passwordTextFieldKey = GlobalKey();
  TextEditingController passwordTextFieldController = TextEditingController();
  GlobalKey<FormFieldState> notesTextFieldKey = GlobalKey();
  TextEditingController notesTextFieldController = TextEditingController();

  String platformTextFieldErrorString;
  String usernameTextFieldErrorString;
  String passwordTextFieldErrorString;
  String notesTextFieldErrorString;

  Color passwordStrengthColor = Colors.grey;
  bool passwordTextFieldInputHidden = true;

  String usernameText;
  String currentPWType;
  PasswordType passwordType = PasswordType.onlineAccount;
  final List<String> passwordTypes = [
    'Online Account',
    'E-Mail Account',
    'WiFi Password',
    'Other',
  ];

  void rebuild() => setState(() {});

  int get pwTypeIndex {
    if (!passwordTypes.contains(currentPWType)) return -1;
    return passwordTypes.indexOf(currentPWType);
  }

  void updateUsernameText() {
    switch (pwTypeIndex) {
      case 0:
        usernameText = 'Username';
        break;
      case 1:
        usernameText = 'Mail Address';
        break;
      case 2:
        usernameText = 'SSID';
        break;
      case 3:
        usernameText = 'Context';
        break;
      default:
        usernameText = 'Username';
    }
    passwordType = PasswordType.values[pwTypeIndex];
    platformTextFieldErrorString = null;
    rebuild();
  }

  @override
  void initState() {
    platformTextFieldErrorString = null;
    usernameTextFieldErrorString = null;
    passwordTextFieldErrorString = null;
    notesTextFieldErrorString = null;
    passwordStrengthColor = Colors.grey;
    passwordTextFieldInputHidden = true;
    currentPWType = passwordTypes[0];
    passwordType = PasswordType.onlineAccount;
    Values.afterBrightnessUpdate = rebuild;
    updateUsernameText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        widget.onPop();
        FocusScope.of(context).unfocus();
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: CustomColors.colorBackground,
        appBar: StandardAppBar(
          title: currentLang.appTitle,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: CustomColors.colorForeground,
            ),
            onPressed: () => {widget.onPop(), FocusScope.of(context).unfocus()},
          ),
        ),
        body: InkWell(
          focusColor: Colors.transparent,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.transparent,
            margin: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(8)),
                  StandardDropdownButton(
                    value: currentPWType,
                    items: passwordTypes
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: StandardText(
                          value,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      currentPWType = value;
                      updateUsernameText();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  (pwTypeIndex == 0)
                      ? Column(
                          children: [
                            StandardTextFormField(
                              hint: 'Platform',
                              key: platformTextFieldKey,
                              controller: platformTextFieldController,
                              errorText: platformTextFieldErrorString,
                              onChanged: (value) {
                                setState(
                                    () => platformTextFieldErrorString = null);
                              },
                            ),
                            Padding(padding: EdgeInsets.all(8)),
                          ],
                        )
                      : Container(),
                  StandardTextFormField(
                    textinputType: TextInputType.emailAddress,
                    hint: usernameText,
                    key: usernameTextFieldKey,
                    controller: usernameTextFieldController,
                    errorText: usernameTextFieldErrorString,
                    onChanged: (value) {
                      setState(() => usernameTextFieldErrorString = null);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8)),
                  StandardTextFormField(
                    suffixIcon: IconButton(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: passwordTextFieldInputHidden
                          ? Icon(Icons.visibility,
                              color: CustomColors.colorForeground)
                          : Icon(Icons.visibility_off,
                              color: CustomColors.colorForeground),
                      onPressed: () => setState(() =>
                          passwordTextFieldInputHidden =
                              !passwordTextFieldInputHidden),
                    ),
                    obscureText: passwordTextFieldInputHidden,
                    textinputType: TextInputType.visiblePassword,
                    errorText: passwordTextFieldErrorString,
                    controller: passwordTextFieldController,
                    key: passwordTextFieldKey,
                    hint: 'Password',
                    onChanged: (text) {
                      setState(() => passwordTextFieldErrorString = null);
                      String value = passwordTextFieldController.text.trim();
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
                  Padding(padding: EdgeInsets.all(8)),
                  StandardTextFormField(
                    hint: 'Notes (optional)',
                    key: notesTextFieldKey,
                    controller: notesTextFieldController,
                    errorText: notesTextFieldErrorString,
                  ),
                  Padding(padding: EdgeInsets.all(48)),
                ],
              ),
            ),
          ),
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
          },
        ),
        floatingActionButton: ExtendedFab(
          onPressed: () {
            bool processWillCancel = false;
            if (passwordTextFieldController.text.trim().isEmpty) {
              setState(() =>
                  passwordTextFieldErrorString = 'Field cannot be empty!');
              processWillCancel = true;
            }
            if (usernameTextFieldController.text.trim().isEmpty) {
              setState(() =>
                  usernameTextFieldErrorString = 'Field cannot be empty!');
              processWillCancel = true;
            }
            if (platformTextFieldController.text.trim().isEmpty &&
                passwordType == PasswordType.onlineAccount) {
              setState(() =>
                  platformTextFieldErrorString = 'Field cannot be empty!');
              processWillCancel = true;
            }
            if (passwordType != PasswordType.onlineAccount)
              platformTextFieldController.text =
                  usernameTextFieldController.text;
            if (processWillCancel) return;
            FocusScope.of(context).unfocus();
            Password password = Password(
              passwordTextFieldController.text,
              username: usernameTextFieldController.text,
              notes: notesTextFieldController.text,
              platform: platformTextFieldController.text,
              passwordType: passwordType,
            );
            Values.passwords.add(password);
            Prefs.passwords = Values.passwords;
            if (widget.onPop != null) widget.onPop();
          },
          label: Text('Save'),
          icon: Icon(Icons.save),
        ),
      ),
    );
  }
}
