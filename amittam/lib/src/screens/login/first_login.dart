import 'package:Amittam/src/libs/animationlib.dart';
import 'package:Amittam/src/libs/encryption_library.dart';
import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/main.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:Amittam/src/objects/password.dart';
import 'package:Amittam/src/screens/home.dart';
import 'package:Amittam/src/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:password_strength/password_strength.dart';

class FirstLoginPage extends StatefulWidget {
  FirstLoginPage({this.onPop});

  final void Function() onPop;

  @override
  _FirstLoginPageState createState() => _FirstLoginPageState();
}

class _FirstLoginPageState extends State<FirstLoginPage> {
  Color passwordStrengthColor = Colors.grey;
  GlobalKey<FormFieldState> masterPWTextFieldKey = GlobalKey();
  TextEditingController masterPWTextFieldController = TextEditingController();
  TextEditingController currentMasterPWTextFieldController =
      TextEditingController();
  String masterPWTextFieldErrorString;
  bool masterPWTextFieldInputHidden = false;

  @override
  void initState() {
    currentMasterPWTextFieldController.text = '';
    masterPWTextFieldController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        title: widget.onPop != null
            ? currentLang.editMasterPassword
            : currentLang.appTitle,
        leading: widget.onPop != null
            ? IconButton(icon: Icon(Icons.arrow_back), onPressed: widget.onPop)
            : null,
      ),
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
                  hint: widget.onPop != null
                      ? currentLang.enterNewMasterPassword
                      : currentLang.enterMasterPW,
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
      floatingActionButton: FloatingActionButton.extended(
        label: Text(currentLang.setMasterPW),
        onPressed: () {
          double strength =
              estimatePasswordStrength(masterPWTextFieldController.text.trim());
          if (strength < 0.3) {
            setState(() =>
                masterPWTextFieldErrorString = currentLang.pwNotStrongEnough);
            return;
          }
          showStandardDialog(
            context: context,
            title: currentLang.confirmMasterPW,
            content: StandardText(currentLang
                .firstLoginConfirmPW(masterPWTextFieldController.text.trim())),
            onConfirm: () {
              print('setting mpw');
              try {
                EncryptionService.setMasterPassword(
                    masterPWTextFieldController.text.trim());
              } catch (e) {
                print('failed!');
                print(errorString(e));
                setState(() => masterPWTextFieldErrorString = 'Error!');
                return;
              }
              if (Values.decryptedPasswords.isEmpty)
                Prefs.firstLogin = false;
              else {
                List<Password> tempPasswordList = [];
                for (DecryptedPassword pw in Values.decryptedPasswords)
                  tempPasswordList.add(pw.asPassword);
                Prefs.passwords = tempPasswordList;
                Values.decryptedPasswords = [];
                if (widget.onPop != null) widget.onPop();
                return;
              }
              Animations.pushReplacement(context, HomePage());
            },
          );
          return;
        },
        icon: Icon(MdiIcons.formTextboxPassword),
      ),
    );
  }
}
