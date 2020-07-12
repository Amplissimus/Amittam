import 'package:Amittam/libs/animationlib.dart';
import 'package:Amittam/libs/lib.dart';
import 'package:Amittam/libs/prefslib.dart';
import 'package:Amittam/libs/uilib.dart';
import 'package:Amittam/objects/password.dart';
import 'package:Amittam/screens/add_password.dart';
import 'package:Amittam/screens/display_password.dart';
import 'package:Amittam/screens/first_login.dart';
import 'package:Amittam/screens/generate_password.dart';
import 'package:Amittam/screens/login.dart';
import 'package:Amittam/screens/settings.dart';
import 'package:Amittam/values.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() {
  runApp(SplashScreen());
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    updateBrightness();
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
    updateBrightness();
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
    updateBrightness();
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
  FocusNode searchFieldFocusNode = FocusNode();

  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Values.passwords.sort(
        (a, b) => a.platform.toLowerCase().compareTo(b.platform.toLowerCase()));
    return Scaffold(
      backgroundColor: CustomColors.colorBackground,
      appBar: AppBar(
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
            : Text(Strings.appTitle,
                style: TextStyle(
                    fontSize: 25, color: CustomColors.colorForeground)),
        actions: [
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
              Password password = Values.passwords[index];
              String titleText;
              int pwTypeIndex =
                  PasswordType.values.indexOf(password.passwordType);
              Icon leadingIcon;
              switch (pwTypeIndex) {
                case 0:
                  titleText = password.platform;
                  String checkText = password.platform.trim().toLowerCase();
                  if (checkText.contains('google')) {
                    leadingIcon = Icon(
                      MdiIcons.google,
                      color: Colors.green,
                      size: 40,
                    );
                  } else if (checkText.contains('microsoft')) {
                    leadingIcon = Icon(
                      MdiIcons.microsoft,
                      color: Colors.green,
                      size: 40,
                    );
                  } else if (checkText.contains('minecraft')) {
                    leadingIcon = Icon(
                      MdiIcons.minecraft,
                      color: Colors.green,
                      size: 40,
                    );
                  } else if (checkText.contains('playstation')) {
                    leadingIcon = Icon(
                      MdiIcons.sonyPlaystation,
                      color: Colors.green,
                      size: 40,
                    );
                  } else {
                    leadingIcon = Icon(
                      MdiIcons.accountCircle,
                      color: Colors.green,
                      size: 40,
                    );
                  }
                  break;
                case 1:
                  titleText = 'Mail Address';
                  leadingIcon = Icon(
                    MdiIcons.email,
                    color: Colors.green,
                    size: 40,
                  );
                  break;
                case 2:
                  titleText = 'WLAN';
                  leadingIcon = Icon(
                    MdiIcons.wifi,
                    color: Colors.green,
                    size: 40,
                  );
                  break;
                default:
                  titleText = 'Error';
                  leadingIcon = Icon(
                    MdiIcons.accountCircle,
                    color: Colors.green,
                    size: 40,
                  );
              }
              return Container(
                color: Colors.transparent,
                child: ListTile(
                  leading: leadingIcon,
                  title: Text(
                    titleText,
                    style: TextStyle(color: CustomColors.colorForeground),
                  ),
                  subtitle: Text(
                    password.username,
                    style: TextStyle(
                      color: CustomColors.colorForeground,
                    ),
                  ),
                  onTap: () {
                    Animations.push(context,
                        DisplayPassword(password, functionOnPop: rebuild));
                  },
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
              color: CustomColors.colorForeground,
              thickness: 2,
            ),
            itemCount: Values.passwords.length,
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        overlayOpacity: 0,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            label: 'Generate password',
            child: Icon(MdiIcons.lockQuestion),
            onTap: () => Animations.push(context, GeneratePassword()),
          ),
          SpeedDialChild(
            label: 'Add password',
            child: Icon(Icons.add),
            onTap: () => Animations.push(
                context, AddPassword(functionAfterSave: rebuild)),
          ),
          SpeedDialChild(
            label: 'Settings',
            child: Icon(Icons.settings),
            onTap: () => Animations.push(context, Settings()),
          ),
        ],
      ),
    );
  }
}
