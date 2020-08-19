import 'package:Amittam/main.dart';
import 'package:Amittam/src/libs/animationlib.dart';
import 'package:Amittam/src/libs/firebaselib.dart';
import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/screens/login/first_login.dart';
import 'package:Amittam/src/screens/login/login.dart';
import 'package:Amittam/src/values.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool isDarkMode = false;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    Prefs.initialize().then((value) {
      setState(() => isDarkMode = Prefs.useDarkTheme);
      Future.delayed(Duration(milliseconds: 1500), () async {
        Provider.of<ThemeChanger>(context)
            .setTheme(Prefs.useDarkTheme ? Themes.darkTheme : Themes.brightTheme);
        await FirebaseService.initialize();
        Animations.pushReplacement(
          context,
          (Prefs.firstLogin ||
              Prefs.preferences.getString('encrypted_master_password') ==
                  null)
              ? FirstLoginPage()
              : LoginPage(),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.white12 : Colors.white,
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: FlareActor(
            'assets/anims/intro.flr',
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: isDarkMode ? 'introDarkMode' : 'introBrightMode',
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
