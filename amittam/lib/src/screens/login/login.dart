import 'package:Amittam/src/libs/animationlib.dart';
import 'package:Amittam/src/libs/encryption_library.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:Amittam/src/screens/home.dart';
import 'package:Amittam/src/values.dart';
import 'package:Amittam/main.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:password_strength/password_strength.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color passwordStrengthColor = Colors.grey;
  GlobalKey<FormFieldState> masterPWTextFieldKey = GlobalKey();
  TextEditingController masterPWTextFieldController = TextEditingController();
  FocusNode masterPwTextFieldFocusNode = FocusNode();
  String masterPWTextFieldErrorString;
  bool masterPWTextFieldInputHidden = true;

  @override
  void initState() {
    masterPWTextFieldController.text = '';
    super.initState();
    masterPwTextFieldFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(title: Strings.appTitle),
      body: InkWell(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          margin: EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                StandardTextFormField(
                  focusNode: masterPwTextFieldFocusNode,
                  suffixIcon: IconButton(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: masterPWTextFieldInputHidden
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: () => setState(() =>
                        masterPWTextFieldInputHidden =
                            !masterPWTextFieldInputHidden),
                  ),
                  obscureText: masterPWTextFieldInputHidden,
                  enableInteractiveSelection: false,
                  textInputType: TextInputType.visiblePassword,
                  errorText: masterPWTextFieldErrorString,
                  controller: masterPWTextFieldController,
                  key: masterPWTextFieldKey,
                  hint: currentLang.enterMasterPW,
                  onChanged: (value) async {
                    if (value.trim().isEmpty)
                      setState(() => masterPWTextFieldErrorString =
                          currentLang.fieldIsEmpty);
                    else
                      setState(() => masterPWTextFieldErrorString = null);
                    if (!Prefs.fastLogin) return;
                    String text = masterPWTextFieldController.text.trim();
                    if (estimatePasswordStrength(text) < 0.3) {
                      return;
                    } else if (EncryptionService.masterPasswordIsValid(text)) {
                      Values.passwords = Prefs.passwords;
                      Animations.pushReplacement(context, HomePage());
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
        onTap: () => FocusScope.of(context).unfocus(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String text = masterPWTextFieldController.text.trim();
          if (!EncryptionService.masterPasswordIsValid(text))
            setState(() =>
                masterPWTextFieldErrorString = currentLang.enteredPWIsWrong);
          else {
            Values.passwords = Prefs.passwords;
            Animations.pushReplacement(context, HomePage());
          }
        },
        icon: Icon(MdiIcons.login),
        label: Text(currentLang.logIn),
      ),
    );
  }
}
