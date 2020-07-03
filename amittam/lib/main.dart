import 'package:Amittam/libs/lib.dart';
import 'package:Amittam/libs/prefslib.dart';
import 'package:Amittam/libs/uilib.dart';
import 'package:Amittam/objects/password.dart';
import 'package:Amittam/screens/add_password.dart';
import 'package:Amittam/screens/first_login.dart';
import 'package:Amittam/screens/login.dart';
import 'package:Amittam/values.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

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
      Values.passwords = Prefs.getPasswords();
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
        primarySwatch: Colors.blue,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.colorBackground,
      appBar: customAppBar(title: Strings.appTitle),
      body: Center(
        child: ListView.separated(
          itemBuilder: (context, index) {
            Password password = Values.passwords[index];
            return ListTile(
              title: Text(password.platform),
              subtitle: Text(password.username),
            );
          },
          separatorBuilder: (context, index) =>
              Divider(color: CustomColors.colorForeground),
          itemCount: Values.passwords.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AddPassword(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
