import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as crypt;

class Password {
  Password(String password) {
    key = crypt.Key.fromUtf8(password);
    crypt.Encrypter crypter = crypt.Encrypter(crypt.AES(key));
    this.encryptedPassword =
        crypter.encrypt(password, iv: crypt.IV.fromLength(16)).base64;
  }

  String encryptedPassword = '';

  static var key;

  String get password => crypt.Encrypter(crypt.AES(key)).decrypt(
      crypt.Encrypted.fromBase64(encryptedPassword),
      iv: crypt.IV.fromLength(16));

  @override
  String toString() {
    return 'encryptedPassword: $encryptedPassword';
  }

  Password.fromMap(Map<String, dynamic> json)
      : encryptedPassword = json['encryptedPassword'];

  factory Password.fromJson(String jsonString) {
    return Password.fromMap(json.decode(jsonString));
  }

  Map toMap() {
    return {
      'encryptedPassword': this.encryptedPassword,
    };
  }

  String toJson() {
    return json.encode(toMap());
  }
}

String expandStringTo32Characters(String string) {
  String tempString = string;
  int i = 0;
  while (tempString.length < 32) {
    i++;
    tempString = '$tempString${string.substring(i)}';
    if (i >= string.length - 1) i = 0;
  }
  print(tempString.replaceRange(31, tempString.length - 1, ''));
  return tempString.replaceRange(31, tempString.length - 1, '');
}
