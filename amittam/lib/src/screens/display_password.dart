import 'package:Amittam/src/libs/animationlib.dart';
import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:Amittam/src/objects/password.dart';
import 'package:Amittam/src/screens/display_qr.dart';
import 'package:Amittam/src/values.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:password_strength/password_strength.dart';

class DisplayPassword extends StatefulWidget {
  DisplayPassword(this.password, {this.onPop});

  final void Function() onPop;
  final Password password;

  @override
  _DisplayPasswordState createState() => _DisplayPasswordState(password);
}

class _DisplayPasswordState extends State<DisplayPassword> {
  _DisplayPasswordState(this.password) {
    passwordTextFieldController =
        TextEditingController(text: password.password);
    platformTextFieldController =
        TextEditingController(text: password.platform);
    usernameTextFieldController =
        TextEditingController(text: password.username);
    notesTextFieldController = TextEditingController(text: password.notes);
    isEditingPlatform = false;
    isEditingUsername = false;
    isEditingPassword = false;
    isEditingNotes = false;
  }

  Password password;

  String platformTextFieldErrorString;
  String usernameTextFieldErrorString;
  String passwordTextFieldErrorString;
  String notesTextFieldErrorString;

  bool isEditingPlatform = false;
  bool isEditingUsername = false;
  bool isEditingPassword = false;
  bool isEditingNotes = false;

  bool passwordTextFieldInputHidden = false;
  Color passwordStrengthColor = Colors.grey;

  GlobalKey<FormFieldState> platformTextFieldKey = GlobalKey();
  TextEditingController platformTextFieldController;
  GlobalKey<FormFieldState> usernameTextFieldKey = GlobalKey();
  TextEditingController usernameTextFieldController;
  GlobalKey<FormFieldState> passwordTextFieldKey = GlobalKey();
  TextEditingController passwordTextFieldController;
  GlobalKey<FormFieldState> notesTextFieldKey = GlobalKey();
  TextEditingController notesTextFieldController;

  FocusNode platformTextFieldFocusNode = FocusNode();
  FocusNode usernameTextFieldFocusNode = FocusNode();
  FocusNode passwordTextFieldFocusNode = FocusNode();
  FocusNode notesTextFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Values.afterBrightnessUpdate = () => setState(() {});
    String value = passwordTextFieldController.text.trim();
    double strength = estimatePasswordStrength(value);
    if (strength < 0.3)
      setState(() => passwordStrengthColor = Colors.grey);
    else if (strength < 0.7)
      setState(() => passwordStrengthColor = Colors.orange);
    else
      setState(() => passwordStrengthColor = Colors.green);
    return WillPopScope(
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
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            margin: EdgeInsets.all(16),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(padding: EdgeInsets.all(2)),
                password.passwordType == PasswordType.onlineAccount
                    ? Container(
                        child: isEditingPlatform
                            ? StandardTextFormField(
                                hint: 'Platform',
                                key: platformTextFieldKey,
                                controller: platformTextFieldController,
                                errorText: platformTextFieldErrorString,
                                focusNode: platformTextFieldFocusNode,
                                onChanged: (text) {
                                  setState(() =>
                                      platformTextFieldErrorString = null);
                                  if (platformTextFieldController.text
                                      .trim()
                                      .isEmpty)
                                    setState(() =>
                                        platformTextFieldErrorString =
                                            'Field cannot be empty!');
                                },
                              )
                            : DisplayValueWidget(
                                value: password.platform,
                                valueType: 'Platform',
                                onTap: () {
                                  setState(() => isEditingPlatform = true);
                                  platformTextFieldFocusNode.requestFocus();
                                },
                              ),
                      )
                    : Container(),
                Padding(padding: EdgeInsets.all(8)),
                isEditingUsername
                    ? StandardTextFormField(
                        hint: 'Username',
                        textinputType: TextInputType.emailAddress,
                        key: usernameTextFieldKey,
                        controller: usernameTextFieldController,
                        errorText: usernameTextFieldErrorString,
                        focusNode: usernameTextFieldFocusNode,
                        onChanged: (text) {
                          setState(() => usernameTextFieldErrorString = null);
                          if (usernameTextFieldController.text.isEmpty)
                            setState(() => usernameTextFieldErrorString =
                                'Field cannot be empty!');
                        },
                      )
                    : DisplayValueWidget(
                        value: password.username,
                        valueType: 'Username',
                        onTap: () {
                          setState(() => isEditingUsername = true);
                          usernameTextFieldFocusNode.requestFocus();
                        },
                      ),
                Padding(padding: EdgeInsets.all(8)),
                isEditingPassword
                    ? StandardTextFormField(
                        hint: 'Password',
                        key: passwordTextFieldKey,
                        controller: passwordTextFieldController,
                        errorText: passwordTextFieldErrorString,
                        obscureText: passwordTextFieldInputHidden,
                        focusNode: passwordTextFieldFocusNode,
                        onChanged: (text) {
                          setState(() => passwordTextFieldErrorString = null);
                          if (passwordTextFieldController.text.isEmpty)
                            setState(() => passwordTextFieldErrorString =
                                'Field cannot be empty!');
                          String value =
                              passwordTextFieldController.text.trim();
                          double strength = estimatePasswordStrength(value);

                          if (strength < 0.3)
                            setState(() => passwordStrengthColor = Colors.grey);
                          else if (strength < 0.7)
                            setState(
                                () => passwordStrengthColor = Colors.orange);
                          else
                            setState(
                                () => passwordStrengthColor = Colors.green);
                        },
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
                      )
                    : DisplayValueWidget(
                        value: password.password,
                        valueType: 'Password',
                        onTap: () {
                          setState(() => isEditingPassword = true);
                          passwordTextFieldFocusNode.requestFocus();
                        },
                      ),
                isEditingPassword
                    ? Column(
                        children: <Widget>[
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
                        ],
                      )
                    : Container(height: 0, width: 0),
                Padding(padding: EdgeInsets.all(8)),
                isEditingNotes
                    ? StandardTextFormField(
                        hint: 'Notes (optional)',
                        key: notesTextFieldKey,
                        controller: notesTextFieldController,
                        errorText: notesTextFieldErrorString,
                        focusNode: notesTextFieldFocusNode,
                      )
                    : DisplayValueWidget(
                        value: password.notes,
                        valueType: 'Notes',
                        onTap: () {
                          setState(() => isEditingNotes = true);
                          notesTextFieldFocusNode.requestFocus();
                        },
                      ),
                password.passwordType == PasswordType.wlanPassword
                    ? Column(
                        children: [
                          Padding(padding: EdgeInsets.all(8)),
                          StandardButton(
                            iconData: MdiIcons.qrcode,
                            text: 'Show QR',
                            onTap: () => Animations.push(
                              context,
                              DisplayQr(
                                'WIFI:T:WPA;S:'
                                '${password.username}'
                                ';P:'
                                '${password.password}'
                                ';;',
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.all(
                      password.passwordType == PasswordType.wlanPassword
                          ? 2
                          : 4),
                ),
                StandardButton(
                  iconData: MdiIcons.delete,
                  text: 'Delete password',
                  onTap: () => showStandardDialog(
                    context: context,
                    content: StandardText(
                        'Do you really want to delete this password?'),
                    title: 'Deletion',
                    onConfirm: () {
                      if (isEditingNotes ||
                          isEditingPassword ||
                          isEditingPlatform ||
                          isEditingUsername)
                        Values.passwords.removeAt(
                            Values.passwords.indexOf(widget.password));
                      else
                        Values.passwords
                            .removeAt(Values.passwords.indexOf(password));
                      Prefs.passwords = Values.passwords;
                      if (widget.onPop != null) widget.onPop();
                    },
                  ),
                ),
              ],
            ),
          ),
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        floatingActionButton: (isEditingNotes ||
                isEditingPassword ||
                isEditingPlatform ||
                isEditingUsername)
            ? ExtendedFab(
                onPressed: () {
                  if ((platformTextFieldController.text
                              .trimRight()
                              .trimLeft()
                              .isEmpty &&
                          password.passwordType ==
                              PasswordType.onlineAccount) ||
                      usernameTextFieldController.text
                          .trimRight()
                          .trimLeft()
                          .isEmpty ||
                      passwordTextFieldController.text.isEmpty) return;
                  setState(() {
                    password.password = passwordTextFieldController.text;
                    password.platform =
                        platformTextFieldController.text.trimRight().trimLeft();
                    password.notes =
                        notesTextFieldController.text.trimRight().trimLeft();
                    password.username =
                        usernameTextFieldController.text.trimRight().trimLeft();
                    Values.passwords[
                        Values.passwords.indexOf(widget.password)] = password;
                    Prefs.passwords = Values.passwords;
                    if (widget.onPop != null) widget.onPop();
                    isEditingNotes = false;
                    isEditingPassword = false;
                    isEditingPlatform = false;
                    isEditingUsername = false;
                  });
                  FocusScope.of(context).unfocus();
                },
                label: Text('Save'),
                icon: Icon(Icons.save),
              )
            : null,
      ),
      onWillPop: () {
        widget.onPop();
        FocusScope.of(context).unfocus();
        return Future(() => false);
      },
    );
  }
}
