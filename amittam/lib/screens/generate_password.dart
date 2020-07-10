import 'dart:math';

import 'package:Amittam/libs/uilib.dart';
import 'package:Amittam/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GeneratePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (GeneratePasswordValues.currentGenPassword == '0')
      GeneratePasswordValues.regenPassword();
    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          key: GeneratePasswordValues.scaffoldKey,
          backgroundColor: CustomColors.colorBackground,
          appBar: customAppBar(title: Strings.appTitle),
          body: Container(
            child: Column(
              children: <Widget>[
                Divider(color: CustomColors.colorForeground, thickness: 2),
                Text(
                  GeneratePasswordValues.currentGenPassword,
                  style: TextStyle(
                    color: CustomColors.colorForeground,
                    fontSize: GeneratePasswordValues.pwTextSize,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(color: CustomColors.colorForeground, thickness: 2),
                Slider(
                  min: 1,
                  max: 32,
                  value: GeneratePasswordValues.currentSliderValue,
                  onChanged: (value) => setState(() {
                    GeneratePasswordValues.currentSliderValue = value;
                    GeneratePasswordValues.regenPassword();
                    GeneratePasswordValues.updatePwTextSize();
                  }),
                  divisions: 31,
                  label: '${GeneratePasswordValues.currentSliderValue.toInt()}',
                ),
                Divider(color: CustomColors.colorForeground),
                switchWithText(
                  text: 'Use numbers',
                  value: GeneratePasswordValues.usingNumbers,
                  onChanged: (value) {
                    setState(() {
                      GeneratePasswordValues.usingNumbers = value;
                      GeneratePasswordValues.regenPassword();
                    });
                  },
                ),
                switchWithText(
                  text: 'Use special characters',
                  value: GeneratePasswordValues.usingSpecialCharacters,
                  onChanged: (value) {
                    GeneratePasswordValues.regenPassword();
                    setState(() {
                      GeneratePasswordValues.usingSpecialCharacters = value;
                      GeneratePasswordValues.regenPassword();
                    });
                  },
                ),
                Divider(color: CustomColors.colorForeground, thickness: 2),
                RaisedButton.icon(
                  color: Colors.green,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                        text: GeneratePasswordValues.currentGenPassword));
                    GeneratePasswordValues.scaffoldKey.currentState
                        ?.showSnackBar(
                      SnackBar(
                        backgroundColor: CustomColors.colorBackground,
                        content: Text(
                          'Copied password to clipboard!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: CustomColors.colorForeground),
                        ),
                      ),
                    );
                  },
                  icon: Icon(MdiIcons.contentCopy, color: Colors.white),
                  label: Text(
                    'Copy password to clipboard',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class GeneratePasswordValues {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  static double currentSliderValue = 1;
  static String currentGenPassword = '0';
  static double pwTextSize = 23;

  static bool usingSpecialCharacters = false;
  static bool usingNumbers = false;

  static void updatePwTextSize() {
    if (currentSliderValue < 11)
      pwTextSize = 30;
    else if (currentSliderValue < 21)
      pwTextSize = 25;
    else if (currentSliderValue < 27)
      pwTextSize = 23;
    else
      pwTextSize = 18;
  }

  static void regenPassword() {
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

  static final List<String> specialCharacters = [
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
  static final List<String> standardLetters = [
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
  static final List<int> standardNumbers = [
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
}