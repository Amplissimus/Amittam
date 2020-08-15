import 'package:Amittam/src/libs/uilib.dart';
import 'package:Amittam/src/objects/language.dart';
import 'package:Amittam/src/values.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DisplayQrPage extends StatefulWidget {
  DisplayQrPage(this.data);

  final String data;

  @override
  _DisplayQrPageState createState() => _DisplayQrPageState();
}

class _DisplayQrPageState extends State<DisplayQrPage> {
  bool useNativeTheme = true;

  @override
  void initState() {
    Values.afterBrightnessUpdate = () => setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        fontColor: useNativeTheme ? CustomColors.colorForeground : Colors.black,
        title: currentLang.appTitle,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color:
                  useNativeTheme ? CustomColors.colorForeground : Colors.black,
            ),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [QrImage(
                  data: widget.data,
                  backgroundColor: useNativeTheme
                      ? CustomColors.colorBackground
                      : Colors.white,
                  foregroundColor: useNativeTheme
                      ? CustomColors.colorForeground
                      : Colors.black,
                ),
              Padding(padding: EdgeInsets.all(4)),
              CustomColors.isDarkMode
                  ? SwitchWithText(
                      fontColor: useNativeTheme
                          ? CustomColors.colorForeground
                          : Colors.black,
                      text: currentLang.scanOptimized,
                      value: !useNativeTheme,
                      onChanged: (value) =>
                          setState(() => useNativeTheme = !value))
                  : null,
            ],
          ),
        ),
      ),
      backgroundColor:
          useNativeTheme ? CustomColors.colorBackground : Colors.white,
    );
  }
}
