import 'package:amittam/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void updateBrightness() {
  var brightness = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
      .platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;
  CustomColors.setMode(darkMode: isDarkMode);
}
