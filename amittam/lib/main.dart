import 'dart:async';

import 'package:Amittam/src/libs/animationlib.dart';
import 'package:Amittam/src/libs/firebaselib.dart';
import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/displayable_password.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:Amittam/src/objects/password.dart';
import 'package:Amittam/src/objects/search_delegates.dart';
import 'package:Amittam/src/screens/add_password.dart';
import 'package:Amittam/src/screens/display_password.dart';
import 'package:Amittam/src/screens/first_login.dart';
import 'package:Amittam/src/screens/generate_password.dart';
import 'package:Amittam/src/screens/login.dart';
import 'package:Amittam/src/screens/settings.dart';
import 'package:Amittam/src/values.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() => runApp(SplashScreen());

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreenPage(),
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}

class SplashScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    updateBrightness();
    SchedulerBinding.instance.window.onPlatformBrightnessChanged =
        updateBrightness;
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () async {
      await Prefs.initialize();
      await FirebaseService.initialize();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => (Prefs.firstLogin ||
                  Prefs.preferences.getString('encrypted_master_password') ==
                      null)
              ? FirstLoginPage()
              : LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: CustomColors.colorBackground,
          height: double.infinity,
          width: double.infinity,
          child: FlareActor(
            'assets/anims/intro.flr',
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation:
                CustomColors.isDarkMode ? 'introDarkMode' : 'introBrightMode',
          ),
        ),
      ),
      bottomSheet: LinearProgressIndicator(
        backgroundColor: Colors.grey,
        valueColor: AlwaysStoppedAnimation<Color>(CustomColors.colorForeground),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
            behavior: MainScrollBehavior(), child: child);
      },
      theme: ThemeData(
        canvasColor: CustomColors.isDarkMode
            ? CustomMaterialColor(0xFF000000)
            : CustomMaterialColor(0xFFFFFFFF),
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isSelecting = false;
  var _scrollController = ScrollController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _verticalPageController = PageController();
  var _horizontalPageController = PageController();

  Widget _secondPage;
  Widget _topSecondPage;

  void rebuild() => setState(() {});

  void fullyRebuild() {
    Values.passwords = Prefs.passwords;
    Values.passwords.sort(
        (a, b) => a.platform.toLowerCase().compareTo(b.platform.toLowerCase()));
    Values.displayablePasswords = passwordsToDisplayable(Values.passwords);
    rebuild();
  }

  @override
  void initState() {
    _secondPage = DisplayPasswordPage(
      Password(
        'Dummy',
        passwordType: PasswordType.emailAccount,
        platform: 'DummyPlatform',
        username: 'DummyUsername',
      ),
      onPop: () {},
    );
    _topSecondPage = SettingsPage(rebuild);
    Values.passwords.sort(
        (a, b) => a.platform.toLowerCase().compareTo(b.platform.toLowerCase()));
    Values.displayablePasswords = passwordsToDisplayable(Values.passwords);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Building Main Page...');
    Values.afterBrightnessUpdate = fullyRebuild;
    Values.passwords.sort(
        (a, b) => a.platform.toLowerCase().compareTo(b.platform.toLowerCase()));
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _verticalPageController,
      scrollDirection: Axis.vertical,
      children: [
        PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _horizontalPageController,
          children: [
            Scaffold(
              key: _scaffoldKey,
              backgroundColor: CustomColors.colorBackground,
              appBar: StandardAppBar(
                leading: isSelecting
                    ? IconButton(
                        onPressed: () {
                          for (var pw in Values.displayablePasswords)
                            pw.isSelected = false;
                          isSelecting = false;
                          rebuild();
                        },
                        icon: Icon(Icons.arrow_back,
                            color: CustomColors.colorForeground))
                    : null,
                title: Strings.appTitle,
                actions: isSelecting
                    ? <Widget>[
                        IconButton(
                          icon: Icon(MdiIcons.delete, color: Colors.green),
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            int amountSelected = 0;
                            for (var pw in Values.displayablePasswords)
                              if (pw.isSelected) amountSelected++;
                            showStandardDialog(
                              context: context,
                              title: 'Deletion',
                              content: StandardText(
                                  'Do you really want to delete the selected password' +
                                      (amountSelected > 1 ? 's' : '') +
                                      '?'),
                              onConfirm: () {
                                for (var pw in Values.displayablePasswords)
                                  if (pw.isSelected)
                                    Values.passwords.remove(pw.password);
                                Prefs.passwords = Values.passwords;
                                isSelecting = false;
                                fullyRebuild();
                              },
                            );
                          },
                        ),
                      ]
                    : <Widget>[
                        IconButton(
                          icon: Icon(Icons.search),
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () => Values.displayablePasswords.isEmpty
                              ? _scaffoldKey.currentState?.showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        CustomColors.colorBackground,
                                    content: StandardText('Error!',
                                        textAlign: TextAlign.center),
                                  ),
                                )
                              : showSearch(
                                  context: context,
                                  delegate: PasswordSearchDelegate(
                                    Values.displayablePasswords,
                                    fullyRebuild,
                                    initialScrollOffset:
                                        _scrollController.offset,
                                  ),
                                ),
                        ),
                      ],
              ),
              body: InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  if (!isSelecting) return;
                  for (var pw in Values.displayablePasswords)
                    pw.isSelected = false;
                  isSelecting = false;
                  rebuild();
                },
                child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.all(16),
                  child: Values.displayablePasswords.isEmpty
                      ? Center(
                          child: StandardText(currentLang.noPasswordsRegistered,
                              fontSize: 20))
                      : ListView.separated(
                          controller: _scrollController,
                          cacheExtent: 5,
                          itemBuilder: (context, index) {
                            DisplayablePassword displayablePassword =
                                Values.displayablePasswords[index];
                            Password password = displayablePassword.password;
                            displayablePassword.onTap = () async {
                              if (isSelecting) {
                                setState(() => displayablePassword.isSelected =
                                    !displayablePassword.isSelected);
                                bool atLeastOneSelected = false;
                                for (var pw in Values.displayablePasswords)
                                  if (!atLeastOneSelected && pw.isSelected) {
                                    atLeastOneSelected = true;
                                    break;
                                  }
                                setState(
                                    () => isSelecting = atLeastOneSelected);
                                return;
                              }
                              setState(() => _secondPage = DisplayPasswordPage(
                                    password,
                                    onPop: () {
                                      fullyRebuild();
                                      animateToPage(0, _verticalPageController);
                                    },
                                  ));
                              animateToPage(1, _verticalPageController);
                            };
                            displayablePassword.onLongPress = () {
                              setState(() => displayablePassword.isSelected =
                                  !displayablePassword.isSelected);
                              bool atLeastOneSelected = false;
                              for (var pw in Values.displayablePasswords)
                                if (!atLeastOneSelected && pw.isSelected) {
                                  atLeastOneSelected = true;
                                  break;
                                }
                              setState(() => isSelecting = atLeastOneSelected);
                            };
                            return displayablePassword.asWidget;
                          },
                          separatorBuilder: (context, index) =>
                              StandardDivider(),
                          itemCount: Values.displayablePasswords.length,
                        ),
                ),
              ),
              drawer: Drawer(
                child: Container(
                  height: double.infinity,
                  color: CustomColors.colorBackground,
                  child: ListView(
                    children: [
                      Container(
                        child: ListTile(
                            title: StandardText(currentLang.appTitle,
                                fontSize: 26)),
                      ),
                      ListTile(
                        leading: StandardIcon(Icons.add),
                        title: StandardText(currentLang.addPassword),
                        onTap: () {
                          Navigator.pop(context);
                          _topSecondPage = AddPasswordPage(() {
                            fullyRebuild();
                            animateToPage(0, _horizontalPageController);
                          });
                          rebuild();
                          animateToPage(1, _horizontalPageController);
                        },
                      ),
                      ListTile(
                        leading: StandardIcon(MdiIcons.lockQuestion),
                        title: StandardText(currentLang.generatePassword),
                        onTap: () {
                          Navigator.pop(context);
                          _topSecondPage = GeneratePasswordPage(() {
                            rebuild();
                            animateToPage(0, _horizontalPageController);
                          });
                          rebuild();
                          animateToPage(1, _horizontalPageController);
                        },
                      ),
                      ListTile(
                        leading: StandardIcon(Icons.settings),
                        title: StandardText(currentLang.settings),
                        onTap: () {
                          Navigator.pop(context);
                          _topSecondPage = SettingsPage(() {
                            fullyRebuild();
                            animateToPage(0, _horizontalPageController);
                          });
                          rebuild();
                          animateToPage(1, _horizontalPageController);
                        },
                      ),
                      ListTile(
                        leading: StandardIcon(MdiIcons.logout),
                        title: StandardText(currentLang.logOut),
                        onTap: () {
                          Values.passwords = [];
                          Password.key = null;
                          Animations.pushReplacement(context, LoginPage());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _topSecondPage
          ],
        ),
        _secondPage,
      ],
    );
  }
}
