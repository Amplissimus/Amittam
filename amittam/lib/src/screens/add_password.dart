import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:Amittam/src/objects/password.dart';
import 'package:Amittam/src/values.dart';
import 'package:flutter/material.dart';
import 'package:password_strength/password_strength.dart';

class AddPasswordPage extends StatefulWidget {
  AddPasswordPage(this.onPop);

  final void Function() onPop;

  @override
  _AddPasswordPageState createState() => _AddPasswordPageState();
}

class _AddPasswordPageState extends State<AddPasswordPage> {
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
  PasswordType currentPWType = PasswordType.onlineAccount;

  void rebuild() => setState(() {});

  void updateUsernameText() {
    switch (currentPWType) {
      case PasswordType.onlineAccount:
        usernameText = currentLang.username;
        break;
      case PasswordType.emailAccount:
        usernameText = currentLang.mailAddress;
        break;
      case PasswordType.wifiPassword:
        usernameText = 'SSID';
        break;
      case PasswordType.other:
        usernameText = currentLang.context;
        break;
      default:
        usernameText = currentLang.username;
    }
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
    currentPWType = PasswordType.onlineAccount;
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
          title: currentLang.addPassword,
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
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(8)),
                  StandardDropdownButton(
                    value: currentPWType,
                    items: PasswordType.values
                        .map<DropdownMenuItem<PasswordType>>((PasswordType value) => DropdownMenuItem<PasswordType>(
                        value: value,
                        child: StandardText(
                          currentLang.pwTypeToString(value),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ).toList(),
                    onChanged: (value) {
                      currentPWType = value;
                      updateUsernameText();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  (currentPWType == PasswordType.onlineAccount)
                      ? Column(
                          children: [
                            StandardTextFormField(
                              hint: currentLang.platform,
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
                    textInputType: TextInputType.emailAddress,
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
                    textInputType: TextInputType.visiblePassword,
                    errorText: passwordTextFieldErrorString,
                    controller: passwordTextFieldController,
                    key: passwordTextFieldKey,
                    hint: currentLang.password,
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
                    hint: currentLang.notesOptional,
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
                currentPWType == PasswordType.onlineAccount) {
              setState(() =>
                  platformTextFieldErrorString = 'Field cannot be empty!');
              processWillCancel = true;
            }
            if (currentPWType != PasswordType.onlineAccount)
              platformTextFieldController.text =
                  usernameTextFieldController.text;
            if (processWillCancel) return;
            FocusScope.of(context).unfocus();
            Password password = Password(
              passwordTextFieldController.text,
              username: usernameTextFieldController.text,
              notes: notesTextFieldController.text,
              platform: platformTextFieldController.text,
              passwordType: currentPWType,
            );
            Values.passwords.add(password);
            Prefs.passwords = Values.passwords;
            if (widget.onPop != null) widget.onPop();
          },
          label: Text(currentLang.save),
          icon: Icon(Icons.save),
        ),
      ),
    );
  }
}
