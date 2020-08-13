import 'package:Amittam/src/libs/animationlib.dart';
import 'package:Amittam/src/libs/firebaselib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:Amittam/src/objects/password.dart';
import 'package:Amittam/src/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'login.dart';

class PhoneLogin extends StatefulWidget {
  PhoneLogin(this.onPop);

  final void Function() onPop;

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  var _pnTextFieldController = TextEditingController();
  String _pnErrorText;
  var _codeTextFieldController = TextEditingController();
  String _codeErrorText;
  var _pageController = PageController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var verificationId;
  bool isLoading = false;

  final List<Password> finalTempPasswords = Prefs.passwords;
  final String finalTempMasterPW =
      Prefs.preferences.getString('encrypted_master_password');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.colorBackground,
      appBar: StandardAppBar(
        title: currentLang.phoneLogin,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomColors.colorForeground,
          ),
          onPressed: () => {widget.onPop(), FocusScope.of(context).unfocus()},
        ),
      ),
      body: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              height: double.infinity,
              margin: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    StandardTextFormField(
                      autofocus: true,
                      controller: _pnTextFieldController,
                      errorText: _pnErrorText,
                      hint: currentLang.phoneNumber,
                      textInputType: TextInputType.phone,
                      onChanged: (value) {
                        if (value.isEmpty)
                          setState(
                              () => _pnErrorText = currentLang.fieldIsEmpty);
                        else
                          setState(() => _pnErrorText = null);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(2)),
                    StandardButton(
                      iconData: MdiIcons.phoneLock,
                      text: currentLang.verifyPhoneNumber,
                      onTap: () async {
                        if (_pnTextFieldController.text.trim().isEmpty) {
                          setState(
                              () => _pnErrorText = currentLang.fieldIsEmpty);
                          return;
                        }
                        setState(() => isLoading = true);
                        try {
                          await FirebaseService.signIn(
                              _pnTextFieldController.text.trim(),
                              (verificationId, [forceResendingToken]) {
                            setState(() => isLoading = false);
                            _pageController.animateToPage(1,
                                duration: Duration(milliseconds: 600),
                                curve: Curves.easeOutCirc);
                            this.verificationId = verificationId;
                          });
                          FocusScope.of(context).unfocus();
                        } catch (e) {
                          _scaffoldKey.currentState?.showSnackBar(
                            SnackBar(
                              backgroundColor: CustomColors.colorBackground,
                              content: StandardText(
                                currentLang.enteredPhoneNumberInvalid,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        setState(() => isLoading = false);
                      },
                    ),
                    StandardText(
                      currentLang.phoneLoginWarning,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: double.infinity,
              margin: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    StandardText(
                        'Please enter the received verification code below.'),
                    Padding(padding: EdgeInsets.all(4)),
                    StandardTextFormField(
                      autofocus: true,
                      controller: _codeTextFieldController,
                      errorText: _codeErrorText,
                      hint: currentLang.verificationCode,
                      onChanged: (value) {
                        if (value.isEmpty)
                          setState(
                              () => _codeErrorText = currentLang.fieldIsEmpty);
                        else
                          setState(() => _codeErrorText = null);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(2)),
                    StandardButton(
                      text: currentLang.verifyCode,
                      iconData: MdiIcons.check,
                      onTap: () async {
                        try {
                          setState(() => isLoading = true);
                          await FirebaseService.firebaseAuth
                              .signInWithCredential(
                                  PhoneAuthProvider.getCredential(
                                      verificationId: verificationId,
                                      smsCode:
                                          _codeTextFieldController.text.trim()))
                              .then((AuthResult result) =>
                                  FirebaseService.firebaseUser = result.user);
                          await FirebaseService.initialize();
                          setState(() => isLoading = false);
                          FocusScope.of(context).unfocus();
                          Values.passwords = [];
                          Password.key = null;
                          Animations.pushReplacement(context, Login());
                        } catch (e) {
                          setState(() => isLoading = false);
                          _scaffoldKey.currentState?.showSnackBar(
                            SnackBar(
                              backgroundColor: CustomColors.colorBackground,
                              content: StandardText(
                                currentLang.enteredVerificationCodeWrong,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap: () => FocusScope.of(context).unfocus(),
      ),
      bottomSheet: isLoading
          ? LinearProgressIndicator(
              backgroundColor: Colors.grey,
              valueColor:
                  AlwaysStoppedAnimation<Color>(CustomColors.colorForeground),
            )
          : null,
    );
  }
}
