import 'package:Amittam/libs/animationlib.dart';
import 'package:Amittam/libs/lib.dart';
import 'package:Amittam/libs/prefslib.dart';
import 'package:Amittam/libs/uilib.dart';
import 'package:Amittam/objects/password.dart';
import 'package:Amittam/screens/display_qr.dart';
import 'package:Amittam/values.dart';
import 'package:flutter/material.dart';
import 'package:Amittam/main.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:password_strength/password_strength.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DisplayPassword extends StatelessWidget {
  DisplayPassword(Password password, {this.functionOnPop}) {
    DisplayPasswordValues.password = password;
    DisplayPasswordValues.passwordTextFieldController =
        TextEditingController(text: password.password);
    DisplayPasswordValues.platformTextFieldController =
        TextEditingController(text: password.platform);
    DisplayPasswordValues.usernameTextFieldController =
        TextEditingController(text: password.username);
    DisplayPasswordValues.notesTextFieldController =
        TextEditingController(text: password.notes);
    DisplayPasswordValues.isEditingPlatform = false;
    DisplayPasswordValues.isEditingUsername = false;
    DisplayPasswordValues.isEditingPassword = false;
    DisplayPasswordValues.isEditingNotes = false;
  }
  void Function() functionOnPop;

  final FocusNode platformTextFieldFocusNode = FocusNode();
  final FocusNode usernameTextFieldFocusNode = FocusNode();
  final FocusNode passwordTextFieldFocusNode = FocusNode();
  final FocusNode notesTextFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        Values.afterBrightnessUpdate = () => setState(() {});
        String value =
            DisplayPasswordValues.passwordTextFieldController.text.trim();
        double strength = estimatePasswordStrength(value);
        if (strength < 0.3)
          setState(
              () => DisplayPasswordValues.passwordStrengthColor = Colors.grey);
        else if (strength < 0.7)
          setState(() =>
              DisplayPasswordValues.passwordStrengthColor = Colors.orange);
        else
          setState(
              () => DisplayPasswordValues.passwordStrengthColor = Colors.green);
        return Scaffold(
          backgroundColor: CustomColors.colorBackground,
          appBar: customAppBar(
            title: 'Amittam',
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: CustomColors.colorForeground,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: InkWell(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
            },
            child: Container(
              margin: EdgeInsets.all(16),
              child: ListView(
                children: [
                  Padding(padding: EdgeInsets.all(2)),
                  DisplayPasswordValues.password.passwordType ==
                          PasswordType.onlineAccount
                      ? Container(
                          child: DisplayPasswordValues.isEditingPlatform
                              ? customTextFormField(
                                  hint: 'Platform',
                                  key: DisplayPasswordValues
                                      .platformTextFieldKey,
                                  controller: DisplayPasswordValues
                                      .platformTextFieldController,
                                  errorText: DisplayPasswordValues
                                      .platformTextFieldErrorString,
                                  focusNode: platformTextFieldFocusNode,
                                  onChanged: (text) {
                                    setState(() => DisplayPasswordValues
                                        .platformTextFieldErrorString = null);
                                    if (DisplayPasswordValues
                                        .platformTextFieldController.text
                                        .trim()
                                        .isEmpty)
                                      setState(() => DisplayPasswordValues
                                              .platformTextFieldErrorString =
                                          'Field cannot be empty!');
                                  },
                                )
                              : displayValueWidget(
                                  value:
                                      DisplayPasswordValues.password.platform,
                                  valueType: 'Platform',
                                  onTap: () {
                                    setState(() => DisplayPasswordValues
                                        .isEditingPlatform = true);
                                    platformTextFieldFocusNode.requestFocus();
                                  },
                                ),
                        )
                      : Container(),
                  Padding(padding: EdgeInsets.all(8)),
                  DisplayPasswordValues.isEditingUsername
                      ? customTextFormField(
                          hint: 'Username',
                          textinputType: TextInputType.emailAddress,
                          key: DisplayPasswordValues.usernameTextFieldKey,
                          controller:
                              DisplayPasswordValues.usernameTextFieldController,
                          errorText: DisplayPasswordValues
                              .usernameTextFieldErrorString,
                          focusNode: usernameTextFieldFocusNode,
                          onChanged: (text) {
                            setState(() => DisplayPasswordValues
                                .usernameTextFieldErrorString = null);
                            if (DisplayPasswordValues
                                .usernameTextFieldController.text.isEmpty)
                              setState(() => DisplayPasswordValues
                                      .usernameTextFieldErrorString =
                                  'Field cannot be empty!');
                          },
                        )
                      : displayValueWidget(
                          value: DisplayPasswordValues.password.username,
                          valueType: 'Username',
                          onTap: () {
                            setState(() =>
                                DisplayPasswordValues.isEditingUsername = true);
                            usernameTextFieldFocusNode.requestFocus();
                          },
                        ),
                  Padding(padding: EdgeInsets.all(8)),
                  DisplayPasswordValues.isEditingPassword
                      ? customTextFormField(
                          hint: 'Password',
                          key: DisplayPasswordValues.passwordTextFieldKey,
                          controller:
                              DisplayPasswordValues.passwordTextFieldController,
                          errorText: DisplayPasswordValues
                              .passwordTextFieldErrorString,
                          obscureText: DisplayPasswordValues
                              .passwordTextFieldInputHidden,
                          focusNode: passwordTextFieldFocusNode,
                          onChanged: (text) {
                            setState(() => DisplayPasswordValues
                                .passwordTextFieldErrorString = null);
                            if (DisplayPasswordValues
                                .passwordTextFieldController.text.isEmpty)
                              setState(() => DisplayPasswordValues
                                      .passwordTextFieldErrorString =
                                  'Field cannot be empty!');
                            String value = DisplayPasswordValues
                                .passwordTextFieldController.text
                                .trim();
                            double strength = estimatePasswordStrength(value);

                            if (strength < 0.3)
                              setState(() => DisplayPasswordValues
                                  .passwordStrengthColor = Colors.grey);
                            else if (strength < 0.7)
                              setState(() => DisplayPasswordValues
                                  .passwordStrengthColor = Colors.orange);
                            else
                              setState(() => DisplayPasswordValues
                                  .passwordStrengthColor = Colors.green);
                          },
                          suffixIcon: IconButton(
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: DisplayPasswordValues
                                    .passwordTextFieldInputHidden
                                ? Icon(Icons.visibility,
                                    color: CustomColors.colorForeground)
                                : Icon(Icons.visibility_off,
                                    color: CustomColors.colorForeground),
                            onPressed: () => setState(() =>
                                DisplayPasswordValues
                                        .passwordTextFieldInputHidden =
                                    !DisplayPasswordValues
                                        .passwordTextFieldInputHidden),
                          ),
                        )
                      : displayValueWidget(
                          value: DisplayPasswordValues.password.password,
                          valueType: 'Password',
                          onTap: () {
                            setState(() =>
                                DisplayPasswordValues.isEditingPassword = true);
                            passwordTextFieldFocusNode.requestFocus();
                          },
                        ),
                  DisplayPasswordValues.isEditingPassword
                      ? Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.all(8)),
                            AnimatedContainer(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color:
                                    DisplayPasswordValues.passwordStrengthColor,
                                border: Border(),
                              ),
                              height: 10,
                              duration: Duration(milliseconds: 250),
                            ),
                          ],
                        )
                      : Container(height: 0, width: 0),
                  Padding(padding: EdgeInsets.all(8)),
                  DisplayPasswordValues.isEditingNotes
                      ? customTextFormField(
                          hint: 'Notes (optional)',
                          key: DisplayPasswordValues.notesTextFieldKey,
                          controller:
                              DisplayPasswordValues.notesTextFieldController,
                          errorText:
                              DisplayPasswordValues.notesTextFieldErrorString,
                          focusNode: notesTextFieldFocusNode,
                        )
                      : displayValueWidget(
                          value: DisplayPasswordValues.password.notes,
                          valueType: 'Notes',
                          onTap: () {
                            setState(() =>
                                DisplayPasswordValues.isEditingNotes = true);
                            notesTextFieldFocusNode.requestFocus();
                          },
                        ),
                  DisplayPasswordValues.password.passwordType ==
                          PasswordType.wlanPassword
                      ? Column(
                          children: [
                            Padding(padding: EdgeInsets.all(8)),
                            RaisedButton.icon(
                              color: Colors.green,
                              onPressed: () {
                                Animations.push(
                                    context,
                                    DisplayQr(
                                        'WIFI:T:WPA;S:${DisplayPasswordValues.password.username};P:${DisplayPasswordValues.password.password};;'));
                              },
                              icon: Icon(MdiIcons.qrcode, color: Colors.white),
                              label: Text('Show QR',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        )
                      : Container(),
                  Padding(padding: EdgeInsets.all(2)),
                  RaisedButton.icon(
                    color: Colors.green,
                    onPressed: () {
                      Values.passwords.removeAt(Values.passwords
                          .indexOf(DisplayPasswordValues.password));
                      Prefs.savePasswords(Values.passwords);
                      if (functionOnPop != null) functionOnPop();
                      Navigator.pop(context);
                    },
                    icon: Icon(MdiIcons.delete, color: Colors.white),
                    label: Text('Delete password',
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          floatingActionButton: (DisplayPasswordValues.isEditingNotes ||
                  DisplayPasswordValues.isEditingPassword ||
                  DisplayPasswordValues.isEditingPlatform ||
                  DisplayPasswordValues.isEditingUsername)
              ? extendedFab(
                  onPressed: () {
                    if ((DisplayPasswordValues.platformTextFieldController.text
                                .trimRight()
                                .trimLeft()
                                .isEmpty &&
                            DisplayPasswordValues.password.passwordType ==
                                PasswordType.onlineAccount) ||
                        DisplayPasswordValues.usernameTextFieldController.text
                            .trimRight()
                            .trimLeft()
                            .isEmpty ||
                        DisplayPasswordValues
                            .passwordTextFieldController.text.isEmpty) return;
                    setState(() {
                      DisplayPasswordValues.password.password =
                          DisplayPasswordValues
                              .passwordTextFieldController.text;
                      DisplayPasswordValues.password.platform =
                          DisplayPasswordValues.platformTextFieldController.text
                              .trimRight()
                              .trimLeft();
                      DisplayPasswordValues.password.notes =
                          DisplayPasswordValues.notesTextFieldController.text
                              .trimRight()
                              .trimLeft();
                      DisplayPasswordValues.password.username =
                          DisplayPasswordValues.usernameTextFieldController.text
                              .trimRight()
                              .trimLeft();
                      Prefs.savePasswords(Values.passwords);
                      if (functionOnPop != null) functionOnPop();
                      DisplayPasswordValues.isEditingNotes = false;
                      DisplayPasswordValues.isEditingPassword = false;
                      DisplayPasswordValues.isEditingPlatform = false;
                      DisplayPasswordValues.isEditingUsername = false;
                    });
                  },
                  label: Text('Save'),
                  icon: Icon(Icons.save),
                )
              : Container(height: 0, width: 0),
        );
      },
    );
  }
}

class DisplayPasswordValues {
  static Password password;

  static String platformTextFieldErrorString;
  static String usernameTextFieldErrorString;
  static String passwordTextFieldErrorString;
  static String notesTextFieldErrorString;

  static bool isEditingPlatform = false;
  static bool isEditingUsername = false;
  static bool isEditingPassword = false;
  static bool isEditingNotes = false;

  static bool passwordTextFieldInputHidden = false;
  static Color passwordStrengthColor = Colors.grey;

  static GlobalKey<FormFieldState> platformTextFieldKey = GlobalKey();
  static TextEditingController platformTextFieldController;
  static GlobalKey<FormFieldState> usernameTextFieldKey = GlobalKey();
  static TextEditingController usernameTextFieldController;
  static GlobalKey<FormFieldState> passwordTextFieldKey = GlobalKey();
  static TextEditingController passwordTextFieldController;
  static GlobalKey<FormFieldState> notesTextFieldKey = GlobalKey();
  static TextEditingController notesTextFieldController;
}
