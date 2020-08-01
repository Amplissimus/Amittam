import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/values.dart';
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
    return StatefulBuilder(
      builder: (context, setState) {
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
                Card(
                  color: CustomColors.lightBackground,
                  child: ListTile(
                    leading: Icon(Icons.info_outline, color: Colors.green),
                    title: Text('Show App information',
                        style: TextStyle(color: CustomColors.colorForeground)),
                    onTap: () => showAboutDialog(
                      context: context,
                      applicationName: 'Amittam',
                      applicationVersion: '1.0.1',
                      applicationIcon: CustomColors.isDarkMode
                          ? ColorFiltered(
                              colorFilter: ColorFilter.srgbToLinearGamma(),
                              child: Image.asset('assets/images/logo.png',
                                  height: 40),
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
                ),
                Card(
                  color: CustomColors.lightBackground,
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.green),
                    title: StandardText('Delete app data'),
                    onTap: () {
                      confirmTextFieldController.text = '';
                      passwordTextFieldController.text = '';
                      SettingsValues.confirmTextFieldErrorText = null;
                      SettingsValues.passwordTextFieldErrorText = null;
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
                                        errorText: SettingsValues
                                            .confirmTextFieldErrorText,
                                        onChanged: (value) {
                                          setAlState(() => SettingsValues
                                                  .confirmTextFieldErrorText =
                                              null);
                                          if (value.trim().isEmpty)
                                            setAlState(() => SettingsValues
                                                    .confirmTextFieldErrorText =
                                                'Field cannot be empty!');
                                        },
                                      ),
                                      Padding(padding: EdgeInsets.all(8)),
                                      StandardTextFormField(
                                        hint: 'Enter Masterpassword',
                                        controller: passwordTextFieldController,
                                        key: passwordTextFieldKey,
                                        errorText: SettingsValues
                                            .passwordTextFieldErrorText,
                                        onChanged: (value) {
                                          setAlState(() => SettingsValues
                                                  .passwordTextFieldErrorText =
                                              null);
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
                                focusColor: Colors.transparent,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
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
