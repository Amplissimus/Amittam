import 'package:Amittam/src/libs/animationlib.dart';
import 'package:Amittam/src/libs/firebaselib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:Amittam/src/objects/password.dart';
import 'package:Amittam/src/screens/login/first_login.dart';
import 'package:Amittam/src/screens/settings/delete_app_data.dart';
import 'package:Amittam/src/values.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:Amittam/src/screens/settings/after_login.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage(this.onPop);

  final void Function() onPop;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Lang selectedLang;

  var _pageController = PageController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _secondPage;

  @override
  void initState() {
    _secondPage = AfterLoginPage(() {
      setState(() {});
      animateToPage(0, _pageController);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_pageController.offset == 0.0)
          widget.onPop();
        else
          animateToPage(0, _pageController);
        if (FirebaseService.isSignedIn && !Prefs.allowRetrievingCloudData)
          FirebaseService.signOut().then((value) => setState(() {}));
        return Future(() => false);
      },
      child: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          Scaffold(
            key: _scaffoldKey,
            appBar: StandardAppBar(
              title: currentLang.settings,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back), onPressed: widget.onPop),
            ),
            body: Container(
              margin: EdgeInsets.all(16),
              child: ListView(
                children: [
                  SwitchWithText(
                    context: context,
                    text: currentLang.fastLogin,
                    value: Prefs.fastLogin,
                    onChanged: (value) =>
                        setState(() => Prefs.fastLogin = value),
                  ),
                  SwitchWithText(
                      context: context,
                      text: currentLang.useSystemTheme,
                      value: Prefs.useSystemTheme,
                      onChanged: (value) {
                        setState(() => Prefs.useSystemTheme = value);
                        Provider.of<ThemeChanger>(context)
                            .setDarkMode(Prefs.useDarkTheme);
                      }),
                  SwitchWithText(
                      context: context,
                      text: currentLang.useDarkTheme,
                      value: Prefs.useDarkTheme,
                      onChanged: Prefs.useSystemTheme
                          ? null
                          : (value) {
                              setState(() => Prefs.useDarkTheme = value);
                              Provider.of<ThemeChanger>(context)
                                  .setDarkMode(Prefs.useDarkTheme);
                            }),
                  FirebaseService.isSignedIn
                      ? StandardButton(
                          iconData: MdiIcons.google,
                          text: currentLang.logOut,
                          onTap: () => showStandardDialog(
                            context: context,
                            title: currentLang.confirmGoogleLogout,
                            content: StandardText(
                                currentLang.confirmGoogleLogoutDesc),
                            onConfirm: () => FirebaseService.signOut()
                                .then((value) => setState(() {})),
                          ),
                        )
                      : StandardButton(
                          iconData: MdiIcons.google,
                          text: currentLang.signInWithGoogle,
                          onTap: () async {
                            bool hasConfirmed = false;
                            await FirebaseService.signInWithGoogle();
                            if (await FirebaseService.hasExistingData()) {
                              setState(() => _secondPage = AfterLoginPage(() {
                                    setState(() {});
                                    animateToPage(0, _pageController);
                                  }));
                              animateToPage(1, _pageController);
                            } else {
                              await showStandardDialog(
                                context: context,
                                title: currentLang.confirmFirstGoogleLogin,
                                content: StandardText(
                                    currentLang.confirmFirstGoogleLoginDesc),
                                onConfirm: () => hasConfirmed = true,
                              );
                              if (!hasConfirmed)
                                await FirebaseService.signOut();
                              else
                                await FirebaseService.saveData();
                              setState(() {});
                            }
                          },
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
                          data: Themes.darkTheme,
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
                        },
                      );
                    },
                  ),
                  StandardButton(
                    iconData: MdiIcons.lockReset,
                    text: currentLang.editMasterPassword,
                    onTap: () {
                      for (Password pw in Prefs.passwords)
                        Values.decryptedPasswords.add(pw.asDecryptedPassword);
                      setState(() => _secondPage = FirstLoginPage(onPop: () {
                            FocusScope.of(context).unfocus();
                            setState(() {});
                            animateToPage(0, _pageController);
                          }));
                      animateToPage(1, _pageController);
                    },
                  ),
                  StandardButton(
                    iconData: MdiIcons.folderInformation,
                    text: currentLang.howWeUseYourData,
                    onTap: () => showStandardDialog(
                      context: context,
                      title: currentLang.howWeUseYourData,
                      content: SingleChildScrollView(
                        child: StandardText(currentLang.howWeUseYourDataDesc),
                      ),
                    ),
                  ),
                  StandardButton(
                    iconData: Icons.info_outline,
                    text: currentLang.showAppInfo,
                    onTap: () => showAboutDialog(
                      context: context,
                      applicationName: currentLang.appTitle,
                      applicationVersion: currentLang.versionString,
                      applicationIcon:
                          Image.asset('assets/images/logo.png', height: 40),
                      children: [Text(currentLang.appInfo)],
                    ),
                  ),
                  StandardButton(
                    iconData: Icons.delete,
                    text: currentLang.deleteAppData,
                    onTap: () {
                      setState(() => _secondPage = DeleteAppDataPage(() {
                            setState(() {});
                            animateToPage(0, _pageController);
                          }));
                      animateToPage(1, _pageController);
                    },
                  ),
                ],
              ),
            ),
          ),
          _secondPage
        ],
      ),
    );
  }
}
