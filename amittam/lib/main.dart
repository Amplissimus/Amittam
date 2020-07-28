import 'dart:async';

import 'package:Amittam/src/libs/animationlib.dart';
import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/displayable_password.dart';
import 'package:Amittam/src/objects/password.dart';
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
        return ScrollConfiguration(behavior: MainBehavior(), child: child);
      },
      theme: ThemeData(
        canvasColor: CustomColors.isDarkMode
            ? materialColor(0xFF000000)
            : materialColor(0xFFFFFFFF),
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  bool isSearching = false;
  bool isSelecting = false;
  FocusNode searchFieldFocusNode = FocusNode();

  void rebuild() {
    setState(() {});
  }

  void fullyRebuild() {
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
    Values.afterBrightnessUpdate = rebuild;
    Values.passwords.sort(
        (a, b) => a.platform.toLowerCase().compareTo(b.platform.toLowerCase()));
    if (isSearching)
      Values.displayablePasswords = passwordsToDisplayable(Values.passwords);
    return Scaffold(
      backgroundColor: CustomColors.colorBackground,
      appBar: AppBar(
        leading: isSelecting
            ? IconButton(
                onPressed: () {
                  for (var pw in Values.displayablePasswords) {
                    pw.isSelected = false;
                  }
                  isSelecting = false;
                  rebuild();
                },
                icon:
                    Icon(Icons.arrow_back, color: CustomColors.colorForeground))
            : null,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: isSearching
            ? AnimatedContainer(
                duration: Duration(milliseconds: 150),
                height: 50,
                child: TextField(
                  style: TextStyle(color: CustomColors.colorForeground),
                  focusNode: searchFieldFocusNode,
                  cursorColor: CustomColors.colorForeground,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: CustomColors.colorForeground),
                    filled: true,
                    fillColor: CustomColors.lightBackground,
                  ),
                  onChanged: (value) {
                    Values.passwords = Prefs.getPasswords();
                    String stringToCheck = value.trim().toLowerCase();
                    List<Password> tempPasswords = [];
                    for (Password pw in Values.passwords) {
                      if (pw.username.toLowerCase().contains(stringToCheck) ||
                          pw.platform.toLowerCase().contains(stringToCheck) ||
                          pw.notes.toLowerCase().contains(stringToCheck)) {
                        tempPasswords.add(pw);
                      }
                    }
                    tempPasswords.sort((a, b) => a.platform
                        .toLowerCase()
                        .compareTo(b.platform.toLowerCase()));
                    Values.passwords = tempPasswords;
                    rebuild();
                  },
                ),
              )
            : isSelecting
                ? Container()
                : Text(Strings.appTitle,
                    style: TextStyle(
                        fontSize: 25, color: CustomColors.colorForeground)),
        actions: isSelecting
            ? [
                IconButton(
                  icon: Icon(MdiIcons.delete, color: Colors.green),
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    setState(() => isSearching = !isSearching);
                    if (isSearching) searchFieldFocusNode.requestFocus();
                  },
                ),
              ]
            : [
                IconButton(
                  icon: Icon(isSearching ? MdiIcons.magnifyClose : Icons.search,
                      color: CustomColors.colorForeground),
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    setState(() => isSearching = !isSearching);
                    if (isSearching) searchFieldFocusNode.requestFocus();
                  },
                ),
              ],
      ),
      body: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() => Values.passwords = Prefs.getPasswords());
          if (isSearching) {
            setState(() => isSearching = false);
          }
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
        child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.all(16),
          child: ListView.separated(
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
                Animations.push(context,
                    DisplayPassword(password, functionOnPop: fullyRebuild));
              };
              displayablePassword.onLongPress = () {
                if (isSearching) return;
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
