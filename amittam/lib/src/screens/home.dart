import 'package:Amittam/src/libs/animationlib.dart';
import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/displayable_password.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:Amittam/src/objects/password.dart';
import 'package:Amittam/src/screens/password/add_password.dart';
import 'package:Amittam/src/screens/password/display_password.dart';
import 'package:Amittam/src/screens/password/generate_password.dart';
import 'package:Amittam/src/screens/settings/settings.dart';
import 'package:Amittam/src/values.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'login/login.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSelecting = false;
  bool isSearching = false;
  var _scrollController = ScrollController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _verticalPageController = PageController();
  var _horizontalPageController = PageController();

  Widget _secondPage, _topSecondPage;

  void rebuild() => setState(() {});

  void fullyRebuild() {
    Values.passwords = Prefs.passwords;
    Values.passwords.sort(
        (a, b) => a.platform.toLowerCase().compareTo(b.platform.toLowerCase()));
    rebuild();
  }

  void stopSearching() {
    FocusScope.of(context).unfocus();
    isSearching = false;
    fullyRebuild();
  }

  @override
  void initState() {
    _secondPage = DisplayPasswordPage(
      Password(
        'Dummy',
        passwordType: PasswordType.emailAccount,
        platform: 'DummyPlatform',
        username: 'DummyUsername',
      ),
      onPop: () {},
    );
    _topSecondPage = SettingsPage(rebuild);
    Values.passwords.sort(
        (a, b) => a.platform.toLowerCase().compareTo(b.platform.toLowerCase()));
    Values.displayablePasswords = passwordsToDisplayable(Values.passwords);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Building Main Page...');
    Values.passwords.sort(
        (a, b) => a.platform.toLowerCase().compareTo(b.platform.toLowerCase()));
    Values.displayablePasswords = passwordsToDisplayable(Values.passwords);
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _verticalPageController,
      scrollDirection: Axis.vertical,
      children: [
        PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _horizontalPageController,
          children: [
            Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                leading: isSelecting
                    ? IconButton(
                        onPressed: () {
                          for (var pw in Values.displayablePasswords)
                            pw.isSelected = false;
                          isSelecting = false;
                          rebuild();
                        },
                        icon: Icon(Icons.arrow_back),
                      )
                    : isSearching
                        ? IconButton(
                            onPressed: stopSearching,
                            icon: Icon(Icons.arrow_back))
                        : null,
                title: isSearching
                    ? TextFormField(
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: currentLang.searchDot,
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          disabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          print(value);
                          List<Password> tempPasswords = [];
                          for (var pw in Prefs.passwords)
                            if (pw.platform
                                    .trim()
                                    .toLowerCase()
                                    .contains(value.trim().toLowerCase()) ||
                                pw.username
                                    .trim()
                                    .toLowerCase()
                                    .contains(value.trim().toLowerCase()) ||
                                pw.notes
                                    .trim()
                                    .toLowerCase()
                                    .contains(value.trim().toLowerCase()))
                              tempPasswords.add(pw);
                          print(tempPasswords);
                          setState(() => Values.passwords = tempPasswords);
                        },
                      )
                    : StandardText(Strings.appTitle, fontSize: 25),
                actions: <Widget>[
                  IconButton(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(isSelecting
                        ? MdiIcons.delete
                        : isSearching ? Icons.close : Icons.search),
                    onPressed: isSelecting
                        ? () {
                            int amountSelected = 0;
                            for (var pw in Values.displayablePasswords)
                              if (pw.isSelected) amountSelected++;
                            showStandardDialog(
                              context: context,
                              title: currentLang.deletion,
                              content: StandardText(
                                  currentLang.deleteSelectedPasswordsWarning(
                                      amountSelected > 1)),
                              onConfirm: () {
                                for (var pw in Values.displayablePasswords)
                                  if (pw.isSelected)
                                    Values.passwords.remove(pw.password);
                                Prefs.passwords = Values.passwords;
                                isSelecting = false;
                                fullyRebuild();
                              },
                            );
                          }
                        : () => isSearching
                            ? stopSearching()
                            : Values.displayablePasswords.isEmpty
                                ? _scaffoldKey.currentState?.showSnackBar(
                                    SnackBar(
                                      content: StandardText('Error!',
                                          textAlign: TextAlign.center),
                                    ),
                                  )
                                : setState(() => isSearching = true),
                  ),
                ],
              ),
              body: InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  if (isSearching) setState(() => isSearching = false);
                  if (!isSelecting) return;
                  for (var pw in Values.displayablePasswords)
                    pw.isSelected = false;
                  isSelecting = false;
                  rebuild();
                },
                child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.all(16),
                  child: Values.displayablePasswords.isEmpty
                      ? isSearching
                          ? ListTile(
                              title: StandardText(currentLang.noResults,
                                  textAlign: TextAlign.center))
                          : Center(
                              child: StandardText(
                                  currentLang.noPasswordsRegistered,
                                  fontSize: 20))
                      : ListView.separated(
                          physics: BouncingScrollPhysics(),
                          controller: _scrollController,
                          cacheExtent: 20,
                          itemBuilder: (context, index) {
                            DisplayablePassword displayablePassword =
                                Values.displayablePasswords[index];
                            Password password = displayablePassword.password;
                            displayablePassword.onTap = () async {
                              if (isSelecting) {
                                setState(() => displayablePassword.isSelected =
                                    !displayablePassword.isSelected);
                                bool atLeastOneSelected = false;
                                for (var pw in Values.displayablePasswords)
                                  if (!atLeastOneSelected && pw.isSelected) {
                                    atLeastOneSelected = true;
                                    break;
                                  }
                                setState(
                                    () => isSelecting = atLeastOneSelected);
                                return;
                              }
                              FocusScope.of(context).unfocus();
                              setState(
                                () => _secondPage = DisplayPasswordPage(
                                  password,
                                  onPop: () {
                                    fullyRebuild();
                                    animateToPage(0, _verticalPageController);
                                  },
                                ),
                              );
                              await animateToPage(1, _verticalPageController);
                              if (isSearching) stopSearching();
                            };
                            displayablePassword.onLongPress = () {
                              if (isSearching) return;
                              setState(() => displayablePassword.isSelected =
                                  !displayablePassword.isSelected);
                              bool atLeastOneSelected = false;
                              for (var pw in Values.displayablePasswords)
                                if (!atLeastOneSelected && pw.isSelected) {
                                  atLeastOneSelected = true;
                                  break;
                                }
                              setState(() => isSelecting = atLeastOneSelected);
                            };
                            return displayablePassword.asWidget;
                          },
                          separatorBuilder: (context, index) =>
                              StandardDivider(),
                          itemCount: Values.displayablePasswords.length,
                        ),
                ),
              ),
              drawer: Drawer(
                child: Container(
                  height: double.infinity,
                  child: ListView(
                    children: [
                      Container(
                        child: ListTile(
                            title: StandardText(currentLang.appTitle,
                                fontSize: 26)),
                      ),
                      ListTile(
                        leading: Icon(Icons.add),
                        title: Text(currentLang.addPassword),
                        onTap: () {
                          Navigator.pop(context);
                          _topSecondPage = AddPasswordPage(() {
                            fullyRebuild();
                            animateToPage(0, _horizontalPageController);
                          });
                          rebuild();
                          animateToPage(1, _horizontalPageController);
                        },
                      ),
                      ListTile(
                        leading: Icon(MdiIcons.lockQuestion),
                        title: Text(currentLang.generatePassword),
                        onTap: () {
                          Navigator.pop(context);
                          _topSecondPage = GeneratePasswordPage(() {
                            rebuild();
                            animateToPage(0, _horizontalPageController);
                          });
                          rebuild();
                          animateToPage(1, _horizontalPageController);
                        },
                      ),
                      ListTile(
                        leading: Icon(MdiIcons.cogOutline),
                        title: Text(currentLang.settings),
                        onTap: () {
                          Navigator.pop(context);
                          _topSecondPage = SettingsPage(() {
                            fullyRebuild();
                            animateToPage(0, _horizontalPageController);
                          });
                          rebuild();
                          animateToPage(1, _horizontalPageController);
                        },
                      ),
                      ListTile(
                        leading: Icon(MdiIcons.logout),
                        title: Text(currentLang.logOut),
                        onTap: () {
                          Values.passwords = [];
                          Password.key = null;
                          Animations.pushReplacement(context, LoginPage());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _topSecondPage
          ],
        ),
        _secondPage,
      ],
    );
  }
}
