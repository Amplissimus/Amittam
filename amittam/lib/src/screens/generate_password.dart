import 'dart:math';

import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:Amittam/src/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GeneratePasswordPage extends StatefulWidget {
  GeneratePasswordPage(this.onPop);

  final void Function() onPop;

  @override
  _GeneratePasswordPageState createState() => _GeneratePasswordPageState();
}

class _GeneratePasswordPageState extends State<GeneratePasswordPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  double currentSliderValue = 16;
  String currentGenPassword = '0';
  double pwTextSize = 23;

  bool usingSpecialCharacters = false;
  bool usingNumbers = false;

  void updatePwTextSize() {
    if (currentSliderValue < 9)
      pwTextSize = 30;
    else if (currentSliderValue < 13)
      pwTextSize = 28;
    else if (currentSliderValue < 17)
      pwTextSize = 26;
    else if (currentSliderValue < 20)
      pwTextSize = 24;
    else if (currentSliderValue < 23)
      pwTextSize = 23;
    else if (currentSliderValue < 27)
      pwTextSize = 22;
    else
      pwTextSize = 18;
  }

  void regenPassword() {
    String tempString = '';
    for (var i = 0; i < currentSliderValue; i++) {
      int randomNumber = new Random().nextInt(100);
      if (randomNumber < 34) {
        int _randomNumber = new Random().nextInt(25);
        String s = standardLetters[_randomNumber];
        int __randomNumber = new Random().nextInt(2);
        if (__randomNumber == 1) s = s.toUpperCase();
        tempString = '$tempString$s';
      } else if (randomNumber < 67) {
        if (usingNumbers) {
          int _randomNumber = new Random().nextInt(9);
          int s = standardNumbers[_randomNumber];
          tempString = '$tempString$s';
        } else {
          int _randomNumber = new Random().nextInt(25);
          String s = standardLetters[_randomNumber];
          int __randomNumber = new Random().nextInt(2);
          if (__randomNumber == 1) s = s.toUpperCase();
          tempString = '$tempString$s';
        }
      } else {
        if (usingSpecialCharacters) {
          int _randomNumber = new Random().nextInt(21);
          String s = specialCharacters[_randomNumber];
          tempString = '$tempString$s';
        } else {
          int _randomNumber = new Random().nextInt(25);
          String s = standardLetters[_randomNumber];
          int __randomNumber = new Random().nextInt(2);
          if (__randomNumber == 1) s = s.toUpperCase();
          tempString = '$tempString$s';
        }
      }
    }
    currentGenPassword = tempString;
  }

  final List<String> specialCharacters = [
    '!',
    '"',
    '§',
    '%',
    '&',
    '\$',
    '/',
    '(',
    ')',
    '=',
    '?',
    '{',
    '[',
    ']',
    '}',
    '\\',
    '#',
    '+',
    '-',
    '~',
    '*',
    '°',
  ];
  final List<String> standardLetters = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
  ];
  final List<int> standardNumbers = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    0,
  ];

  @override
  Widget build(BuildContext context) {
    if (currentGenPassword == '0') regenPassword();
    Values.afterBrightnessUpdate = () => setState(() {});
    return WillPopScope(
      onWillPop: widget.onPop,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: CustomColors.colorBackground,
        appBar: StandardAppBar(
          title: currentLang.generatePassword,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: CustomColors.colorForeground,
            ),
            onPressed: widget.onPop,
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              StandardDivider(height: null),
              Container(
                height: 40,
                child: Center(
                  child: Text(
                    currentGenPassword,
                    style: TextStyle(
                      color: CustomColors.colorForeground,
                      fontSize: pwTextSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              StandardDivider(height: null),
              Slider(
                min: 1,
                max: 32,
                value: currentSliderValue,
                onChanged: (value) => setState(() {
                  currentSliderValue = value;
                  regenPassword();
                  updatePwTextSize();
                }),
                divisions: 31,
                label: '${currentSliderValue.toInt()}',
              ),
              Divider(color: CustomColors.colorForeground),
              SwitchWithText(
                text: currentLang.useNumbers,
                value: usingNumbers,
                onChanged: (value) {
                  setState(() {
                    usingNumbers = value;
                    regenPassword();
                  });
                },
              ),
              SwitchWithText(
                text: currentLang.useSpecialChars,
                value: usingSpecialCharacters,
                onChanged: (value) {
                  setState(() {
                    usingSpecialCharacters = value;
                    regenPassword();
                  });
                },
              ),
              StandardDivider(height: null),
              Card(
                color: CustomColors.lightBackground,
                child: ListTile(
                  leading: Icon(MdiIcons.contentCopy, color: Colors.green),
                  title: StandardText(currentLang.copyPWToClipboard),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: currentGenPassword));
                    scaffoldKey.currentState?.showSnackBar(
                      SnackBar(
                        backgroundColor: CustomColors.colorBackground,
                        content: StandardText(
                          currentLang.copiedPWToClipboard,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
