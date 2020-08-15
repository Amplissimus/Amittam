import 'package:Amittam/src/libs/animationlib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/objects/displayable_password.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:Amittam/src/objects/password.dart';
import 'package:Amittam/src/screens/display_password.dart';
import 'package:Amittam/src/values.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PasswordSearchDelegate extends SearchDelegate<DisplayablePassword> {
  PasswordSearchDelegate(this.passwords, this.onPop,
      {this.initialScrollOffset = 0.0});

  final List<DisplayablePassword> passwords;
  final void Function() onPop;
  final double initialScrollOffset;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(MdiIcons.magnifyClose, color: Colors.white),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () => close(context, null),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var _controller =
        ScrollController(initialScrollOffset: initialScrollOffset);
    List<DisplayablePassword> tempPasswords = [];
    if (query.isEmpty) {
      tempPasswords = Values.displayablePasswords;
    } else {
      Values.passwords = Prefs.passwords;
      String stringToCheck = query.trim().toLowerCase();
      for (Password pw in Values.passwords) {
        if (pw.username.toLowerCase().contains(stringToCheck) ||
            pw.platform.toLowerCase().contains(stringToCheck) ||
            pw.notes.toLowerCase().contains(stringToCheck)) {
          tempPasswords.add(DisplayablePassword(pw));
        }
      }
      tempPasswords.sort((a, b) => a.password.platform
          .toLowerCase()
          .compareTo(b.password.platform.toLowerCase()));
    }
    return Container(
      color: CustomColors.colorBackground,
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.all(16),
          child: tempPasswords.isEmpty
              ? ListTile(
                  title:
                      StandardText('No results!', textAlign: TextAlign.center))
              : ListView.separated(
                  controller: _controller,
                  cacheExtent: 5,
                  itemBuilder: (context, index) {
                    DisplayablePassword displayablePassword =
                        tempPasswords[index];
                    Password password = displayablePassword.password;
                    displayablePassword.onTap = () {
                      Navigator.pop(context);
                      Animations.push(context,
                          DisplayPasswordPage(password, onPop: onPop));
                    };
                    displayablePassword.onLongPress = () {};
                    return displayablePassword.asWidget;
                  },
                  separatorBuilder: (context, index) => StandardDivider(),
                  itemCount: tempPasswords.length,
                ),
        ),
      ),
    );
  }

  @override
  String get searchFieldLabel => currentLang.searchDot;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      textTheme: TextTheme(),
      primaryColor: Colors.green,
    );
  }
}
