import 'package:Amittam/libs/lib.dart';
import 'package:Amittam/libs/prefslib.dart';
import 'package:Amittam/libs/uilib.dart';
import 'package:Amittam/main.dart';
import 'package:Amittam/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Settings extends StatelessWidget {
  final GlobalKey<FormFieldState> confirmTextFieldKey = GlobalKey();
  final TextEditingController confirmTextFieldController =
      TextEditingController();
  final GlobalKey<FormFieldState> passwordTextFieldKey = GlobalKey();
  final TextEditingController passwordTextFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    updateBrightness();
    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          backgroundColor: CustomColors.colorBackground,
          appBar: customAppBar(
            title: 'Amittam',
          ),
          body: Container(
            margin: EdgeInsets.all(16),
            child: ListView(
              children: [
                switchWithText(
                  text: 'Fast Login',
                  value: Prefs.fastLogin,
                  onChanged: (value) => setState(() => Prefs.fastLogin = value),
                ),
                RaisedButton.icon(
                  color: Colors.green,
                  onPressed: () {
                    confirmTextFieldController.text = '';
                    passwordTextFieldController.text = '';
                    SettingsValues.confirmTextFieldErrorText = null;
                    SettingsValues.passwordTextFieldErrorText = null;
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) => StatefulBuilder(
                        builder: (context, setAlState) {
                          return standardDialog(
                            title: 'Delete App-Data',
                            actions: [
                              FlatButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'CANCEL',
                                  style: TextStyle(
                                    color: CustomColors.colorForeground,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  if (confirmTextFieldController.text ==
                                          'CONFIRM' &&
                                      Prefs.masterPasswordIsValid(
                                          passwordTextFieldController.text)) {
                                    Prefs.preferences.clear();
                                    SystemNavigator.pop();
                                  }
                                },
                                child: Text(
                                  'CONFIRM',
                                  style: TextStyle(
                                    color: CustomColors.colorForeground,
                                    fontSize: 18,
                                  ),
                                ),
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
                                    Text(
                                      'Please type "CONFIRM" in the Textbox below and '
                                      'then confirm deleting the App-Data '
                                      'using your master password.',
                                      style: TextStyle(
                                        color: CustomColors.colorForeground,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(8)),
                                    customTextFormField(
                                      hint: 'Requested text',
                                      controller: confirmTextFieldController,
                                      key: confirmTextFieldKey,
                                      errorText: SettingsValues
                                          .confirmTextFieldErrorText,
                                      onChanged: (value) {
                                        setAlState(() => SettingsValues
                                            .confirmTextFieldErrorText = null);
                                        if (value.trim().isEmpty)
                                          setAlState(() => SettingsValues
                                                  .confirmTextFieldErrorText =
                                              'Field cannot be empty!');
                                      },
                                    ),
                                    Padding(padding: EdgeInsets.all(8)),
                                    customTextFormField(
                                      hint: 'Enter Masterpassword',
                                      controller: passwordTextFieldController,
                                      key: passwordTextFieldKey,
                                      errorText: SettingsValues
                                          .passwordTextFieldErrorText,
                                      onChanged: (value) {
                                        setAlState(() => SettingsValues
                                            .passwordTextFieldErrorText = null);
                                        if (value.trim().isEmpty)
                                          setAlState(() => SettingsValues
                                                  .passwordTextFieldErrorText =
                                              'Field cannot be empty!');
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  icon: Icon(MdiIcons.delete, color: Colors.white),
                  label: Text(
                    'Delete App-Data',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class SettingsValues {
  static String confirmTextFieldErrorText;
  static String passwordTextFieldErrorText;
}
