import 'dart:convert';

import 'package:Amittam/values.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as crypt;

class Password {
  Password(String password, {this.username, this.platform, this.notes}) {
    if (Values.masterPassword == null || Values.masterPassword.isEmpty)
      throw 'Masterpassword not defined! Password could not be initialized!';
    key = crypt.Key.fromUtf8(expandStringTo32Characters(Values.masterPassword));
    crypt.Encrypter crypter = crypt.Encrypter(crypt.AES(key));
    this.encryptedPassword =
        crypter.encrypt(password, iv: crypt.IV.fromLength(16)).base64;
  }

  String platform;
  String username;
  String notes;
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
      : platform = json['platform'],
        username = json['username'],
        notes = json['notes'],
        encryptedPassword = json['encryptedPassword'];

  factory Password.fromJson(String jsonString) {
    return Password.fromMap(json.decode(jsonString));
  }

  Map toMap() {
    return {
      'platform': this.platform,
      'username': this.username,
      'notes': this.notes,
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
  return tempString.replaceRange(31, tempString.length - 1, '');
}
