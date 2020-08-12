import 'package:Amittam/src/libs/auth.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: CustomColors.colorBackground,
        appBar: StandardAppBar(title: 'Phone Registration'),
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
                        controller: _pnTextFieldController,
                        errorText: _pnErrorText,
                        hint: 'Phone Number',
                        textinputType: TextInputType.phone,
                      ),
                      Padding(padding: EdgeInsets.all(2)),
                      StandardButton(
                        iconData: MdiIcons.phoneLock,
                        text: 'Verify phone number',
                        onTap: () async {
                          setState(() => isLoading = true);
                          try {
                            await AuthService.signIn(_pnTextFieldController.text.trim(),
                                    (verificationId, [forceResendingToken]) {
                                  setState(() => isLoading = false);
                                  _pageController.animateToPage(1,
                                      duration: Duration(milliseconds: 600),
                                      curve: Curves.easeOutCirc);
                                  this.verificationId = verificationId;
                                });
                          } catch(e) {
                            _scaffoldKey.currentState?.showSnackBar(
                              SnackBar(
                                backgroundColor: CustomColors.colorBackground,
                                content: StandardText(
                                  'The entered phone number does not exist!',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          setState(() => isLoading = false);
                        },
                      ),
                      StandardText(
                        'By pressing on the button above, an SMS may be sent. Message & Data rates may apply.',
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
                        controller: _codeTextFieldController,
                        errorText: _codeErrorText,
                        hint: 'Verfifcation Code',
                      ),
                      Padding(padding: EdgeInsets.all(2)),
                      StandardButton(
                        text: 'Verify code',
                        iconData: MdiIcons.check,
                        onTap: () async {
                          try {
                            setState(() => isLoading = true);
                            await AuthService.firebaseAuth
                                .signInWithCredential(
                                    PhoneAuthProvider.getCredential(
                                        verificationId: verificationId,
                                        smsCode: _codeTextFieldController.text
                                            .trim()))
                                .then((AuthResult result) =>
                                    AuthService.firebaseUser = result.user);
                            AuthService.isSignedIn = true;
                            setState(() => isLoading = false);
                          } catch (e) {
                            setState(() => isLoading = false);
                            _scaffoldKey.currentState?.showSnackBar(
                              SnackBar(
                                backgroundColor: CustomColors.colorBackground,
                                content: StandardText(
                                  'The entered verfication code was wrong!',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                            AuthService.isSignedIn = false;
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
