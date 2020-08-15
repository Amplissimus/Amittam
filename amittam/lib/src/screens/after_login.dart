import 'package:Amittam/src/libs/animationlib.dart';
import 'package:Amittam/src/libs/firebaselib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:Amittam/src/objects/password.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../values.dart';
import 'login.dart';

class AfterLoginPage extends StatefulWidget {
  AfterLoginPage(this.onPop);

  final void Function() onPop;

  @override
  _AfterLoginPageState createState() => _AfterLoginPageState();
}

class _AfterLoginPageState extends State<AfterLoginPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: CustomColors.colorBackground,
        appBar: StandardAppBar(title: currentLang.finishLogin),
        body: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              StandardButton(
                iconData: MdiIcons.cloudUpload,
                text: currentLang.useLocalStoredData,
                onTap: () => showStandardDialog(
                  context: context,
                  title: currentLang.proceedByUsingLocalData,
                  content: StandardText(currentLang.proceedByUsingOnlineDataDesc),
                  onConfirm: () async {
                    await FirebaseService.saveSettings();
                    await FirebaseService.savePasswords(Prefs.passwords);
                    Prefs.allowRetrievingCloudData = true;
                    if (widget.onPop != null) widget.onPop();
                  },
                ),
              ),
              Padding(padding: EdgeInsets.all(4)),
              StandardButton(
                iconData: MdiIcons.cloudDownload,
                text: currentLang.useOnlineStoredData,
                onTap: () => showStandardDialog(
                  context: context,
                  title: currentLang.proceedByUsingOnlineData,
                  content: StandardText(
                      currentLang.proceedByUsingOnlineDataDesc),
                  onConfirm: () async {
                    final String previousMasterPassword = Prefs.preferences
                        .getString('encrypted_master_password')
                        .trim();
                    Prefs.allowRetrievingCloudData = true;
                    await FirebaseService.loadSettings();
                    await FirebaseService.retrievePasswords();
                    if (previousMasterPassword ==
                            Prefs.preferences
                                .getString('encrypted_master_password')
                                .trim() &&
                        widget.onPop != null)
                      widget.onPop();
                    else {
                      Values.passwords = [];
                      Password.key = null;
                      Animations.pushReplacement(context, LoginPage());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: null,
    );
  }
}
