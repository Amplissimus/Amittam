import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/language.dart';
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
  void Function() onTap = () {};
  void Function() onLongPress = () {};

  Widget get asWidget {
    return Container(
      color: isSelected ? Values.green15 : Colors.transparent,
      child: ListTile(
        leading: suitableLeadingIcon,
        title: StandardText(titleText),
        subtitle: StandardText(password.username),
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
        if (checkText.contains('google') || checkText.contains('gmail'))
          return getLeadingIcon(MdiIcons.google);
        else if (checkText.contains('microsoft'))
          return getLeadingIcon(MdiIcons.microsoft);
        else if (checkText.contains('windows'))
          return getLeadingIcon(MdiIcons.microsoftWindows);
        else if (checkText.contains('minecraft') ||
            checkText.contains('mojang'))
          return getLeadingIcon(MdiIcons.minecraft);
        else if (checkText.contains('playstation') ||
            checkText.contains('ps3') ||
            checkText.contains('ps4') ||
            checkText.contains('ps5'))
          return getLeadingIcon(MdiIcons.sonyPlaystation);
        else if (checkText.contains('facebook'))
          return getLeadingIcon(MdiIcons.facebook);
        else if (checkText.contains('discord'))
          return getLeadingIcon(MdiIcons.discord);
        else
          return getLeadingIcon(MdiIcons.accountCircle);
        break;
      case PasswordType.emailAccount:
        titleText = currentLang.mailAddress;
        return getLeadingIcon(MdiIcons.email);
        break;
      case PasswordType.wifiPassword:
        titleText = currentLang.wifi;
        return getLeadingIcon(MdiIcons.wifiStrength3Lock);
        break;
      default:
        return getLeadingIcon(MdiIcons.accountCircle);
    }
  }

  Icon getLeadingIcon(IconData data) => Icon(
        data,
        color: isSelected ? null : Colors.green,
        size: 40,
      );
}

List<DisplayablePassword> passwordsToDisplayable(List<Password> pws) {
  if (pws == null) return [];
  List<DisplayablePassword> dpws = [];
  for (Password password in pws) dpws.add(DisplayablePassword(password));
  return dpws;
}
