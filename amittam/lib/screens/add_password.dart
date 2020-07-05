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
        home: AddPasswordPage(),
      ),
    );
  }
}

class AddPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddPasswordPageState();
}

class AddPasswordPageState extends State<AddPasswordPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.colorBackground,
      appBar: customAppBar(
        title: Strings.appTitle,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
          ),
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
      ),
      body: InkWell(
        focusColor: Colors.transparent,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.transparent,
          margin: EdgeInsets.all(16),
          child: Center(
            child: ListView(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(8)),
                customTextFormField(
                  hint: 'Platform',
                  key: platformTextFieldKey,
                  controller: platformTextFieldController,
                  errorText: platformTextFieldErrorString,
                ),
                Padding(padding: EdgeInsets.all(8)),
                customTextFormField(
                  textinputType: TextInputType.emailAddress,
                  hint: 'Username',
                  key: usernameTextFieldKey,
                  controller: usernameTextFieldController,
                  errorText: usernameTextFieldErrorString,
                ),
                Padding(padding: EdgeInsets.all(8)),
                customTextFormField(
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
                customTextFormField(
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
      floatingActionButton: extendedFab(
        onPressed: () {
          if (passwordTextFieldController.text.trim().isEmpty) {
            setState(
                () => passwordTextFieldErrorString = 'Field cannot be empty!');
          }
          Password password = Password(
            passwordTextFieldController.text,
            username: usernameTextFieldController.text,
            notes: notesTextFieldController.text,
            platform: platformTextFieldController.text,
          );
          Values.passwords.add(password);
          Prefs.savePasswords(Values.passwords);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => new MainApp(),
            ),
          );
        },
        label: Text('Save'),
        icon: Icon(Icons.save),
      ),
    );
  }
}
