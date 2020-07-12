import 'package:Amittam/libs/uilib.dart';
import 'package:Amittam/values.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DisplayQr extends StatelessWidget {
  DisplayQr(this.data);
  final String data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context)),
        elevation: 0,
        title: Text(
          'Display QR',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(30),
          child: QrImage(
            data: data,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
