import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:Amittam/src/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DisplayQrPage extends StatefulWidget {
  DisplayQrPage(this.data, {this.onPop});

  final String data;
  final void Function() onPop;

  @override
  _DisplayQrPageState createState() => _DisplayQrPageState();
}

class _DisplayQrPageState extends State<DisplayQrPage> {
  bool useNativeTheme = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ThemeChanger>(context).setDarkMode(Prefs.useDarkTheme);
        if(widget.onPop != null) widget.onPop();
        return false;
      },
      child: Scaffold(
        appBar: StandardAppBar(
          title: currentLang.appTitle,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Provider.of<ThemeChanger>(context)
                  .setDarkMode(Prefs.useDarkTheme);
              if(widget.onPop != null) widget.onPop();
            },
          ),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImage(
                  data: widget.data,
                  foregroundColor:
                      Provider.of<ThemeChanger>(context).getTheme().cursorColor,
                ),
                Padding(padding: EdgeInsets.all(4)),
                Prefs.useDarkTheme
                    ? SwitchWithText(
                        context: context,
                        text: currentLang.scanOptimized,
                        value: !useNativeTheme,
                        onChanged: Prefs.useDarkTheme
                            ? (value) {
                                setState(() => useNativeTheme = !value);
                                if (!useNativeTheme)
                                  Provider.of<ThemeChanger>(context)
                                      .setDarkMode(!Prefs.useDarkTheme);
                                else
                                  Provider.of<ThemeChanger>(context)
                                      .setDarkMode(Prefs.useDarkTheme);
                              }
                            : null,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
