import 'dart:async';

import 'package:Amittam/src/libs/animationlib.dart';
import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/displayable_password.dart';
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
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() {
  runApp(SplashScreen());
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreenPage());
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => (Prefs.firstLogin ||
                  Prefs.preferences.getString('encrypted_master_password') ==
                      null)
              ? FirstLogin()
              : Login(),
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
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  bool isSelecting = false;
  var _scrollController = ScrollController();

  void rebuild() {
    setState(() {});
  }

  void fullyRebuild() {
    Values.passwords = Prefs.passwords;
    Values.passwords.sort(
        (a, b) => a.platform.toLowerCase().compareTo(b.platform.toLowerCase()));
    Values.displayablePasswords = passwordsToDisplayable(Values.passwords);
    rebuild();
  }

  @override
  void initState() {
    Values.passwords.sort(
        (a, b) => a.platform.toLowerCase().compareTo(b.platform.toLowerCase()));
    Values.displayablePasswords = passwordsToDisplayable(Values.passwords);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Values.afterBrightnessUpdate = fullyRebuild;
    Values.passwords.sort(
        (a, b) => a.platform.toLowerCase().compareTo(b.platform.toLowerCase()));
    return Scaffold(
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
                icon:
                    Icon(Icons.arrow_back, color: CustomColors.colorForeground))
            : null,
        title: Strings.appTitle,
        actions: isSelecting
            ? [
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
                      actions: <Widget>[
                        FlatButton(
                          splashColor: CustomColors.colorForeground,
                          child: StandardText('CANCEL'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        FlatButton(
                          splashColor: CustomColors.colorForeground,
                          child: StandardText('CONFIRM'),
                          onPressed: () {
                            for (var pw in Values.displayablePasswords)
                              if (pw.isSelected)
                                Values.passwords.remove(pw.password);
                            Prefs.passwords = Values.passwords;
                            isSelecting = false;
                            fullyRebuild();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ]
            : [
                IconButton(
                  icon: Icon(Icons.search, color: CustomColors.colorForeground),
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: PasswordSearchDelegate(
                        Values.displayablePasswords,
                        fullyRebuild,
                        initialScrollOffset: _scrollController.offset,
                      ),
                    );
                  },
                ),
              ],
      ),
      body: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: () {
          if (isSelecting) {
            for (var pw in Values.displayablePasswords) pw.isSelected = false;
            isSelecting = false;
            rebuild();
          }
        },
        child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.all(16),
          child: Values.displayablePasswords.isEmpty
              ? Center(
                  child: StandardText('No passwords registered!', fontSize: 20))
              : ListView.separated(
                  controller: _scrollController,
                  cacheExtent: 5,
                  itemBuilder: (context, index) {
                    DisplayablePassword displayablePassword =
                        Values.displayablePasswords[index];
                    Password password = displayablePassword.password;
                    displayablePassword.onTap = () {
                      if (isSelecting) {
                        setState(() => displayablePassword.isSelected =
                            !displayablePassword.isSelected);
                        bool atLeastOneSelected = false;
                        for (var pw in Values.displayablePasswords) {
                          if (!atLeastOneSelected && pw.isSelected) {
                            atLeastOneSelected = true;
                            break;
                          }
                        }
                        setState(() => isSelecting = atLeastOneSelected);
                        return;
                      }
                      Values.afterBrightnessUpdate = null;
                      Animations.push(
                          context,
                          DisplayPassword(password,
                              functionOnPop: fullyRebuild));
                    };
                    displayablePassword.onLongPress = () {
                      setState(() => displayablePassword.isSelected =
                          !displayablePassword.isSelected);
                      bool atLeastOneSelected = false;
                      for (var pw in Values.displayablePasswords) {
                        if (!atLeastOneSelected && pw.isSelected) {
                          atLeastOneSelected = true;
                          break;
                        }
                      }
                      setState(() => isSelecting = atLeastOneSelected);
                    };
                    return displayablePassword.asWidget;
                  },
                  separatorBuilder: (context, index) => Divider(
                    color: CustomColors.colorForeground,
                    thickness: 2,
                    height: 0,
                  ),
                  itemCount: Values.displayablePasswords.length,
                ),
        ),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.green,
        overlayOpacity: 0,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.green,
            label: 'Generate password',
            child: Icon(MdiIcons.lockQuestion),
            onTap: () {
              Values.afterBrightnessUpdate = null;
              Animations.push(context, GeneratePassword());
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.green,
            label: 'Add password',
            child: Icon(Icons.add),
            onTap: () {
              Values.afterBrightnessUpdate = null;
              Animations.push(
                  context, AddPassword(functionAfterSave: fullyRebuild));
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.green,
            label: 'Settings',
            child: Icon(Icons.settings),
            onTap: () {
              Values.afterBrightnessUpdate = null;
              Animations.push(context, Settings());
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.green,
            label: 'Log out',
            child: Icon(MdiIcons.logout),
            onTap: () {
              Values.passwords = [];
              Password.key = null;
              Animations.pushReplacement(context, LoginPage());
            },
          ),
        ],
      ),
    );
  }
}
