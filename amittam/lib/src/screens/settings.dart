import 'package:Amittam/src/libs/auth.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Settings extends StatefulWidget {
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  GlobalKey<FormFieldState> confirmTextFieldKey = GlobalKey();
  TextEditingController confirmTextFieldController = TextEditingController();
  GlobalKey<FormFieldState> passwordTextFieldKey = GlobalKey();
  TextEditingController passwordTextFieldController = TextEditingController();

  String confirmTextFieldErrorText;
  String passwordTextFieldErrorText;

  @override
  Widget build(BuildContext context) {
    Values.afterBrightnessUpdate = () => setState(() {});
    return Scaffold(
      backgroundColor: CustomColors.colorBackground,
      appBar: StandardAppBar(
        title: 'Amittam',
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomColors.colorForeground,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView(
          children: [
            SwitchWithText(
              text: 'Fast Login',
              value: Prefs.fastLogin,
              onChanged: (value) => setState(() => Prefs.fastLogin = value),
            ),
            AuthService.isSignedIn
                ? StandardButton(
                    iconData: MdiIcons.google,
                    text: 'Sign out',
                    onTap: () =>
                        AuthService.signOut().then((value) => setState(() {})),
                  )
                : StandardButton(
                    iconData: MdiIcons.google,
                    text: 'Sign in with google',
                    onTap: () =>
                        AuthService.signIn().then((value) => setState(() {})),
                  ),
            StandardButton(
              iconData: Icons.info_outline,
              text: 'Show App information',
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'Amittam',
                applicationVersion: '1.0.1',
                applicationIcon: CustomColors.isDarkMode
                    ? ColorFiltered(
                        colorFilter: ColorFilter.srgbToLinearGamma(),
                        child:
                            Image.asset('assets/images/logo.png', height: 40),
                      )
                    : Image.asset('assets/images/logo.png', height: 40),
                children: [
                  Text('Amittam is an open source password '
                      'manager which stores all data locally, which is '
                      'encrypted by using a master password which means '
                      'that it should only be possible to decrypt the '
                      'data by knowing the master password.'),
                ],
              ),
            ),
            StandardButton(
              iconData: Icons.delete,
              text: 'Delete App data',
              onTap: () {
                confirmTextFieldController.text = '';
                passwordTextFieldController.text = '';
                confirmTextFieldErrorText = null;
                passwordTextFieldErrorText = null;
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => StatefulBuilder(
                    builder: (context, setAlState) {
                      return AlertDialog(
                        backgroundColor: CustomColors.colorBackground,
                        title: StandardText('Delete App-Data'),
                        actions: [
                          FlatButton(
                            splashColor: CustomColors.colorForeground,
                            onPressed: () => Navigator.pop(context),
                            child: StandardText('CANCEL'),
                          ),
                          FlatButton(
                            splashColor: CustomColors.colorForeground,
                            onPressed: () {
                              if (confirmTextFieldController.text ==
                                      'CONFIRM' &&
                                  Prefs.masterPasswordIsValid(
                                      passwordTextFieldController.text)) {
                                Prefs.preferences.clear();
                                SystemNavigator.pop();
                              }
                            },
                            child: StandardText('CONFIRM'),
                          ),
                        ],
                        content: InkWell(
                          onTap: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus)
                              currentFocus.unfocus();
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                StandardText(
                                  'Please type "CONFIRM" in the Textbox below and '
                                  'then confirm deleting the App-Data '
                                  'using your master password.',
                                  fontSize: 16,
                                ),
                                Padding(padding: EdgeInsets.all(8)),
                                StandardTextFormField(
                                  hint: 'Requested text',
                                  controller: confirmTextFieldController,
                                  key: confirmTextFieldKey,
                                  errorText: confirmTextFieldErrorText,
                                  onChanged: (value) {
                                    setAlState(
                                        () => confirmTextFieldErrorText = null);
                                    if (value.trim().isEmpty)
                                      setAlState(() =>
                                          confirmTextFieldErrorText =
                                              'Field cannot be empty!');
                                  },
                                ),
                                Padding(padding: EdgeInsets.all(8)),
                                StandardTextFormField(
                                  hint: 'Enter Masterpassword',
                                  controller: passwordTextFieldController,
                                  key: passwordTextFieldKey,
                                  errorText: passwordTextFieldErrorText,
                                  onChanged: (value) {
                                    setAlState(() =>
                                        passwordTextFieldErrorText = null);
                                    if (value.trim().isEmpty)
                                      setAlState(() =>
                                          passwordTextFieldErrorText =
                                              'Field cannot be empty!');
                                  },
                                ),
                              ],
                            ),
                          ),
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
