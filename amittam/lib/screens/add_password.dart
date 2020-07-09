import 'package:Amittam/libs/lib.dart';
import 'package:Amittam/libs/prefslib.dart';
import 'package:Amittam/libs/uilib.dart';
import 'package:Amittam/main.dart';
import 'package:Amittam/objects/password.dart';
import 'package:Amittam/values.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:password_strength/password_strength.dart';

class AddPassword extends StatelessWidget {
  final GlobalKey<FormFieldState> platformTextFieldKey = GlobalKey();
  final TextEditingController platformTextFieldController =
      TextEditingController();
  final GlobalKey<FormFieldState> usernameTextFieldKey = GlobalKey();
  final TextEditingController usernameTextFieldController =
      TextEditingController();
  final GlobalKey<FormFieldState> passwordTextFieldKey = GlobalKey();
  final TextEditingController passwordTextFieldController =
      TextEditingController();
  final GlobalKey<FormFieldState> notesTextFieldKey = GlobalKey();
  final TextEditingController notesTextFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    AddPasswordValues.platformTextFieldErrorString = null;
    AddPasswordValues.usernameTextFieldErrorString = null;
    AddPasswordValues.passwordTextFieldErrorString = null;
    AddPasswordValues.notesTextFieldErrorString = null;
    AddPasswordValues.passwordStrengthColor = Colors.grey;
    AddPasswordValues.passwordTextFieldInputHidden = true;
    AddPasswordValues.currentPWType = AddPasswordValues.passwordTypes[0];
    AddPasswordValues.updateUsernameText();
    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          backgroundColor: CustomColors.colorBackground,
          appBar: customAppBar(
            title: Strings.appTitle,
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
                    DropdownButton(
                      value: AddPasswordValues.currentPWType,
                      items: AddPasswordValues.passwordTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style:
                                TextStyle(color: CustomColors.colorForeground),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => AddPasswordValues.currentPWType = value);
                        AddPasswordValues.updateUsernameText(
                          functionAfterFinish: () => setState(
                            () {
                              AddPasswordValues.platformTextFieldErrorString =
                                  null;
                            },
                          ),
                        );
                      },
                      underline: Container(
                        height: 2,
                        color: CustomColors.colorForeground,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(4)),
                    (AddPasswordValues.pwTypeIndex == 0)
                        ? Column(
                            children: [
                              customTextFormField(
                                hint: 'Platform',
                                key: platformTextFieldKey,
                                controller: platformTextFieldController,
                                errorText: AddPasswordValues
                                    .platformTextFieldErrorString,
                                onChanged: (value) {
                                  setState(() => AddPasswordValues
                                      .platformTextFieldErrorString = null);
                                },
                              ),
                              Padding(padding: EdgeInsets.all(8)),
                            ],
                          )
                        : Container(),
                    customTextFormField(
                      textinputType: TextInputType.emailAddress,
                      hint: AddPasswordValues.usernameText,
                      key: usernameTextFieldKey,
                      controller: usernameTextFieldController,
                      errorText: AddPasswordValues.usernameTextFieldErrorString,
                      onChanged: (value) {
                        setState(() => AddPasswordValues
                            .usernameTextFieldErrorString = null);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8)),
                    customTextFormField(
                      suffixIcon: IconButton(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: AddPasswordValues.passwordTextFieldInputHidden
                            ? Icon(Icons.visibility,
                                color: CustomColors.colorForeground)
                            : Icon(Icons.visibility_off,
                                color: CustomColors.colorForeground),
                        onPressed: () => setState(() => AddPasswordValues
                                .passwordTextFieldInputHidden =
                            !AddPasswordValues.passwordTextFieldInputHidden),
                      ),
                      obscureText:
                          AddPasswordValues.passwordTextFieldInputHidden,
                      textinputType: TextInputType.visiblePassword,
                      errorText: AddPasswordValues.passwordTextFieldErrorString,
                      controller: passwordTextFieldController,
                      key: passwordTextFieldKey,
                      hint: 'Password',
                      onChanged: (text) {
                        setState(() => AddPasswordValues
                            .passwordTextFieldErrorString = null);
                        String value = passwordTextFieldController.text.trim();
                        double strength = estimatePasswordStrength(value);

                        if (strength < 0.3)
                          setState(() => AddPasswordValues
                              .passwordStrengthColor = Colors.grey);
                        else if (strength < 0.7)
                          setState(() => AddPasswordValues
                              .passwordStrengthColor = Colors.orange);
                        else
                          setState(() => AddPasswordValues
                              .passwordStrengthColor = Colors.green);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8)),
                    AnimatedContainer(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AddPasswordValues.passwordStrengthColor,
                        border: Border(),
                      ),
                      height: 10,
                      duration: Duration(milliseconds: 250),
                    ),
                    Padding(padding: EdgeInsets.all(8)),
                    customTextFormField(
                      hint: 'Notes (optional)',
                      key: notesTextFieldKey,
                      controller: notesTextFieldController,
                      errorText: AddPasswordValues.notesTextFieldErrorString,
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
          floatingActionButton: extendedFab(
            onPressed: () {
              bool processWillCancel = false;
              if (passwordTextFieldController.text.trim().isEmpty) {
                setState(() => AddPasswordValues.passwordTextFieldErrorString =
                    'Field cannot be empty!');
                processWillCancel = true;
              }
              if (usernameTextFieldController.text.trim().isEmpty) {
                setState(() => AddPasswordValues.usernameTextFieldErrorString =
                    'Field cannot be empty!');
                processWillCancel = true;
              }
              if (platformTextFieldController.text.trim().isEmpty) {
                setState(() => AddPasswordValues.platformTextFieldErrorString =
                    'Field cannot be empty!');
                processWillCancel = true;
              }
              if (processWillCancel) return;
              Password password = Password(
                passwordTextFieldController.text,
                usernameParam: usernameTextFieldController.text,
                notesParam: notesTextFieldController.text,
                platformParam: platformTextFieldController.text,
              );
              Values.passwords.add(password);
              Prefs.savePasswords(Values.passwords);
              Navigator.pop(context);
            },
            label: Text('Save'),
            icon: Icon(Icons.save),
          ),
        );
      },
    );
  }
}

class AddPasswordValues {
  static String platformTextFieldErrorString;
  static String usernameTextFieldErrorString;
  static String passwordTextFieldErrorString;
  static String notesTextFieldErrorString;

  static Color passwordStrengthColor = Colors.grey;
  static bool passwordTextFieldInputHidden = true;

  static String usernameText;
  static String currentPWType;
  static final List<String> passwordTypes = [
    'Online Account',
    'E-Mail Account',
    'WLAN Password',
  ];
  static int get pwTypeIndex {
    if (!passwordTypes.contains(currentPWType)) return -1;
    return passwordTypes.indexOf(currentPWType);
  }

  static void updateUsernameText({void Function() functionAfterFinish}) {
    if (functionAfterFinish == null) functionAfterFinish = () {};
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
      default:
        usernameText = 'Username';
    }
    functionAfterFinish();
  }
}
