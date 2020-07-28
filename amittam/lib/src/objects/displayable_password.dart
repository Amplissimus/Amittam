import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/objects/password.dart';
import 'package:Amittam/src/values.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DisplayablePassword {
  DisplayablePassword(this.password) {
    titleText = password.platform;
  }

  final Password password;

  bool isSelected = false;
  String titleText;
  TextStyle textStyle = TextStyle(color: CustomColors.colorForeground);
  void Function() onTap = () {};
  void Function() onLongPress = () {};

  Widget get asWidget {
    return Container(
      color: isSelected ? Values.green15 : Colors.transparent,
      child: ListTile(
        leading: suitableLeadingIcon,
        title: Text(titleText, style: textStyle),
        subtitle: Text(password.username, style: textStyle),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }

  Icon get suitableLeadingIcon {
    switch (password.passwordType) {
      case PasswordType.onlineAccount:
        titleText = password.platform;
        String checkText = password.platform.trim().toLowerCase();
        if (checkText.contains('google') || checkText.contains('gmail')) {
          return Icon(
            MdiIcons.google,
            color: isSelected ? CustomColors.colorForeground : Colors.green,
            size: 40,
          );
        } else if (checkText.contains('microsoft')) {
          return Icon(
            MdiIcons.microsoft,
            color: isSelected ? CustomColors.colorForeground : Colors.green,
            size: 40,
          );
        } else if (checkText.contains('windows')) {
          return Icon(
            MdiIcons.microsoftWindows,
            color: isSelected ? CustomColors.colorForeground : Colors.green,
            size: 40,
          );
        } else if (checkText.contains('minecraft') ||
            checkText.contains('mojang')) {
          return Icon(
            MdiIcons.minecraft,
            color: isSelected ? CustomColors.colorForeground : Colors.green,
            size: 40,
          );
        } else if (checkText.contains('playstation') ||
            checkText.contains('ps3') ||
            checkText.contains('ps4') ||
            checkText.contains('ps5')) {
          return Icon(
            MdiIcons.sonyPlaystation,
            color: isSelected ? CustomColors.colorForeground : Colors.green,
            size: 40,
          );
        } else {
          return Icon(
            MdiIcons.accountCircle,
            color: isSelected ? CustomColors.colorForeground : Colors.green,
            size: 40,
          );
        }
        break;
      case PasswordType.emailAccount:
        titleText = 'Mail Address';
        return Icon(
          MdiIcons.email,
          color: isSelected ? CustomColors.colorForeground : Colors.green,
          size: 40,
        );
        break;
      case PasswordType.wlanPassword:
        titleText = 'WiFi';
        return Icon(
          MdiIcons.wifiStrength3Lock,
          color: isSelected ? CustomColors.colorForeground : Colors.green,
          size: 40,
        );
        break;
      default:
        return Icon(
          MdiIcons.accountCircle,
          color: isSelected ? CustomColors.colorForeground : Colors.green,
          size: 40,
        );
    }
  }
}

List<DisplayablePassword> passwordsToDisplayable(List<Password> pws) {
  if (pws == null) return [];
  List<DisplayablePassword> dpws = [];
  for (Password password in pws) {
    dpws.add(DisplayablePassword(password));
  }
  return dpws;
}
