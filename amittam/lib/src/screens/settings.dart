import 'package:Amittam/src/libs/animationlib.dart';
import 'package:Amittam/src/libs/firebaselib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:Amittam/src/screens/phone_login.dart';
import 'package:Amittam/src/values.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Settings extends StatefulWidget {
  Settings(this.onPop);

  final void Function() onPop;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  GlobalKey<FormFieldState> confirmTextFieldKey = GlobalKey();
  TextEditingController confirmTextFieldController = TextEditingController();
  GlobalKey<FormFieldState> passwordTextFieldKey = GlobalKey();
  TextEditingController passwordTextFieldController = TextEditingController();

  String confirmTextFieldErrorText;
  String passwordTextFieldErrorText;

  Lang selectedLang;

  var _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Values.afterBrightnessUpdate = () => setState(() {});
    return WillPopScope(
      onWillPop: () {
        if (_pageController.offset == 0.0)
          widget.onPop();
        else
          animateToPage(0, _pageController);
        return Future(() => false);
      },
      child: PageView(
        controller: _pageController,
        children: [
          Scaffold(
            backgroundColor: CustomColors.colorBackground,
            appBar: StandardAppBar(
              title: currentLang.appTitle,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: CustomColors.colorForeground,
                ),
                onPressed: widget.onPop,
              ),
            ),
            body: Container(
              margin: EdgeInsets.all(16),
              child: ListView(
                children: [
                  SwitchWithText(
                    text: currentLang.fastLogin,
                    value: Prefs.fastLogin,
                    onChanged: (value) =>
                        setState(() => Prefs.fastLogin = value),
                  ),
                  FirebaseService.isSignedIn
                      ? StandardButton(
                          iconData: MdiIcons.phoneLock,
                          text: currentLang.logOut,
                          onTap: () => FirebaseService.signOut()
                              .then((value) => setState(() {})),
                        )
                      : StandardButton(
                          iconData: MdiIcons.phoneLock,
                          text: currentLang.signInWithPhoneNumber,
                          onTap: () => animateToPage(1, _pageController),
                        ),
                  StandardButton(
                    text: currentLang.chooseLang,
                    iconData: MdiIcons.translate,
                    onTap: () {
                      selectedLang = languageToLang(currentLang);
                      showStandardDialog(
                        context: context,
                        title: currentLang.chooseLang,
                        content: Theme(
                          data: ThemeData(
                              canvasColor: CustomColors.isDarkMode
                                  ? CustomMaterialColor(0xFF000000)
                                  : CustomMaterialColor(0xFFFFFFFF)),
                          child: StatefulBuilder(
                            builder: (context, setAlState) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                StandardDropdownButton(
                                  value: selectedLang,
                                  items: Lang.values
                                      .map<DropdownMenuItem<Lang>>(
                                        (Lang lang) => DropdownMenuItem<Lang>(
                                          value: lang,
                                          child: StandardText(
                                              langToLanguage(lang).englishName),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (lang) =>
                                      setAlState(() => selectedLang = lang),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onConfirm: () {
                          currentLang = langToLanguage(selectedLang);
                          setState(() {});
                          if (widget.onPop != null) widget.onPop();
                        },
                      );
                    },
                  ),
                  StandardButton(
                    iconData: Icons.info_outline,
                    text: currentLang.showAppInfo,
                    onTap: () => showAboutDialog(
                      context: context,
                      applicationName: currentLang.appTitle,
                      applicationVersion: currentLang.versionString,
                      applicationIcon: CustomColors.isDarkMode
                          ? ColorFiltered(
                              colorFilter: ColorFilter.srgbToLinearGamma(),
                              child: Image.asset('assets/images/logo.png',
                                  height: 40),
                            )
                          : Image.asset('assets/images/logo.png', height: 40),
                      children: [Text(currentLang.appInfo)],
                    ),
                  ),
                  StandardButton(
                    iconData: Icons.delete,
                    text: currentLang.deleteAppData,
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
                              title: StandardText(currentLang.deleteAppData),
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
                                          setAlState(() =>
                                              confirmTextFieldErrorText = null);
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
                                              passwordTextFieldErrorText =
                                                  null);
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
          ),
          PhoneLogin(() {
            setState(() {});
            animateToPage(0, _pageController);
          }),
        ],
      ),
    );
  }
}
