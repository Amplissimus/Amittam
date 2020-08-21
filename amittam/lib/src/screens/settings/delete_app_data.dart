import 'package:Amittam/src/libs/encryption_library.dart';
import 'package:Amittam/src/libs/firebaselib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeleteAppDataPage extends StatefulWidget {
  DeleteAppDataPage(this.onPop);

  final void Function() onPop;

  @override
  _DeleteAppDataPageState createState() => _DeleteAppDataPageState();
}

class _DeleteAppDataPageState extends State<DeleteAppDataPage> {
  TextEditingController confirmTextFieldController = TextEditingController();
  TextEditingController passwordTextFieldController = TextEditingController();

  String confirmTextFieldErrorText;
  String passwordTextFieldErrorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
          title: currentLang.deleteAppData,
          leading: IconButton(
              icon: Icon(Icons.arrow_back), onPressed: widget.onPop)),
      body: InkWell(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          margin: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StandardText(
                  currentLang.resetActionRequest,
                  fontSize: 16,
                ),
                Padding(padding: EdgeInsets.all(8)),
                StandardTextFormField(
                  hint: currentLang.requestedText,
                  controller: confirmTextFieldController,
                  errorText: confirmTextFieldErrorText,
                  onChanged: (value) {
                    setState(() => confirmTextFieldErrorText = null);
                    if (value.trim().isEmpty)
                      setState(() =>
                          confirmTextFieldErrorText = currentLang.fieldIsEmpty);
                  },
                ),
                Padding(padding: EdgeInsets.all(8)),
                StandardTextFormField(
                  textInputType: TextInputType.visiblePassword,
                  hint: currentLang.enterMasterPW,
                  controller: passwordTextFieldController,
                  errorText: passwordTextFieldErrorText,
                  onChanged: (value) {
                    setState(() => passwordTextFieldErrorText = null);
                    if (value.trim().isEmpty)
                      setState(() => passwordTextFieldErrorText =
                          currentLang.fieldIsEmpty);
                  },
                ),
                Padding(padding: EdgeInsets.all(4)),
                StandardButton(
                  iconData: Icons.delete,
                  text: currentLang.deleteAppData,
                  onTap: () async {
                    bool willCancel = false;
                    if (confirmTextFieldController.text !=
                        currentLang.confirm.toUpperCase()) {
                      willCancel = true;
                      confirmTextFieldErrorText = currentLang.invalidInput;
                    }
                    if (!EncryptionService.masterPasswordIsValid(
                        passwordTextFieldController.text)) {
                      willCancel = true;
                      passwordTextFieldErrorText = currentLang.invalidInput;
                    }
                    setState(() {});
                    if (!willCancel) {
                      showStandardDialog(
                          context: context,
                          title: currentLang.deleteAppData,
                          content: Text(currentLang.reallyDeleteAppData),
                          onConfirm: () async {
                            if (FirebaseService.isSignedIn)
                              FirebaseService.deleteOnlineData();
                            await Prefs.preferences.clear();
                            SystemNavigator.pop();
                          });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.arrow_back),
        onPressed: () => {widget.onPop(), FocusScope.of(context).unfocus()},
        label: Text(currentLang.cancel),
      ),
    );
  }
}
