import 'package:Amittam/libs/lib.dart';
import 'package:Amittam/libs/prefslib.dart';
import 'package:Amittam/libs/uilib.dart';
import 'package:Amittam/objects/password.dart';
import 'package:Amittam/values.dart';
import 'package:flutter/material.dart';
import 'package:Amittam/main.dart';
import 'package:password_strength/password_strength.dart';

class DisplayPassword extends StatelessWidget {
  DisplayPassword(Password password) {
    DisplayPasswordValues.password = password;
  }
  @override
  Widget build(BuildContext context) {
    updateBrightness();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainApp(),
          ),
        );
        return false;
      },
      child: MaterialApp(
        builder: (context, child) {
          return ScrollConfiguration(behavior: MainBehavior(), child: child);
        },
        home: DisplayPasswordPage(),
      ),
    );
  }
}

class DisplayPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DisplayPasswordPageState();
}

class DisplayPasswordPageState extends State<DisplayPasswordPage> {
  GlobalKey<FormFieldState> platformTextFieldKey = GlobalKey();
  TextEditingController platformTextFieldController =
      TextEditingController(text: DisplayPasswordValues.password.platform);
  GlobalKey<FormFieldState> usernameTextFieldKey = GlobalKey();
  TextEditingController usernameTextFieldController =
      TextEditingController(text: DisplayPasswordValues.password.username);
  GlobalKey<FormFieldState> passwordTextFieldKey = GlobalKey();
  TextEditingController passwordTextFieldController =
      TextEditingController(text: DisplayPasswordValues.password.password);
  GlobalKey<FormFieldState> notesTextFieldKey = GlobalKey();
  TextEditingController notesTextFieldController =
      TextEditingController(text: DisplayPasswordValues.password.notes);

  FocusNode platformTextFieldFocusNode = FocusNode();
  FocusNode usernameTextFieldFocusNode = FocusNode();
  FocusNode passwordTextFieldFocusNode = FocusNode();
  FocusNode notesTextFieldFocusNode = FocusNode();

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

  @override
  void initState() {
    String value = passwordTextFieldController.text.trim();
    double strength = estimatePasswordStrength(value);
    if (strength < 0.3)
      setState(() => passwordStrengthColor = Colors.grey);
    else if (strength < 0.7)
      setState(() => passwordStrengthColor = Colors.orange);
    else
      setState(() => passwordStrengthColor = Colors.green);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.colorBackground,
      appBar: customAppBar(title: 'Amittam'),
      body: InkWell(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
        child: Container(
          margin: EdgeInsets.all(16),
          child: ListView(
            children: [
              Padding(padding: EdgeInsets.all(8)),
              isEditingPlatform
                  ? customTextFormField(
                      hint: 'Platform',
                      key: platformTextFieldKey,
                      controller: platformTextFieldController,
                      errorText: platformTextFieldErrorString,
                      focusNode: platformTextFieldFocusNode,
                      onChanged: (text) {
                        setState(() => platformTextFieldErrorString = null);
                        if (platformTextFieldController.text.trim().isEmpty)
                          setState(() => platformTextFieldErrorString =
                              'Field cannot be empty!');
                      },
                    )
                  : displayValueWidget(
                      value: DisplayPasswordValues.password.platform,
                      valueType: 'Platform',
                      onTap: () {
                        setState(() => isEditingPlatform = true);
                        platformTextFieldFocusNode.requestFocus();
                      },
                    ),
              Padding(padding: EdgeInsets.all(8)),
              isEditingUsername
                  ? customTextFormField(
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
                  : displayValueWidget(
                      value: DisplayPasswordValues.password.username,
                      valueType: 'Username',
                      onTap: () {
                        setState(() => isEditingUsername = true);
                        usernameTextFieldFocusNode.requestFocus();
                      },
                    ),
              Padding(padding: EdgeInsets.all(8)),
              isEditingPassword
                  ? customTextFormField(
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
                        String value = passwordTextFieldController.text.trim();
                        double strength = estimatePasswordStrength(value);

                        if (strength < 0.3)
                          setState(() => passwordStrengthColor = Colors.grey);
                        else if (strength < 0.7)
                          setState(() => passwordStrengthColor = Colors.orange);
                        else
                          setState(() => passwordStrengthColor = Colors.green);
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
                  : displayValueWidget(
                      value: DisplayPasswordValues.password.password,
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
                  ? customTextFormField(
                      hint: 'Notes (optional)',
                      key: notesTextFieldKey,
                      controller: notesTextFieldController,
                      errorText: notesTextFieldErrorString,
                      focusNode: notesTextFieldFocusNode,
                    )
                  : displayValueWidget(
                      value: DisplayPasswordValues.password.notes,
                      valueType: 'Notes',
                      onTap: () {
                        setState(() => isEditingNotes = true);
                        notesTextFieldFocusNode.requestFocus();
                      },
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
          ? extendedFab(
              onPressed: () {
                if (platformTextFieldController.text.trimRight().trimLeft().isEmpty ||
                    usernameTextFieldController.text
                        .trimRight()
                        .trimLeft()
                        .isEmpty ||
                    passwordTextFieldController.text.isEmpty) return;
                setState(() {
                  DisplayPasswordValues.password.password =
                      passwordTextFieldController.text;
                  DisplayPasswordValues.password.platform =
                      platformTextFieldController.text.trimRight().trimLeft();
                  DisplayPasswordValues.password.notes =
                      notesTextFieldController.text.trimRight().trimLeft();
                  DisplayPasswordValues.password.username =
                      usernameTextFieldController.text.trimRight().trimLeft();
                  Prefs.savePasswords(Values.passwords);
                  isEditingNotes = false;
                  isEditingPassword = false;
                  isEditingPlatform = false;
                  isEditingUsername = false;
                });
              },
              label: Text('Save'),
              icon: Icon(Icons.save),
            )
          : Container(height: 0, width: 0),
    );
  }
}

class DisplayPasswordValues {
  static Password password;
}
