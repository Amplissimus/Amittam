import 'dart:convert';

import 'package:Amittam/values.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as crypt;

class Password {
  Password(
    String password, {
    @required String username,
    @required String platform,
    String notes = '',
  }) {
    if (key == null)
      throw 'Masterpassword not defined! Password could not be initialized!';
    this.password = password;
    this.platform = platform;
    this.notes = notes;
    this.username = username;
  }

  static var key;

  static set masterPassword(String s) =>
      key = crypt.Key.fromUtf8(expandStringTo32Characters(s));

  String encryptedPlatform = '';
  String encryptedUsername = '';
  String encryptedNotes = '';
  String encryptedPassword = '';

  set platform(String s) => encryptedPlatform = encryptWithMasterPWToBase64(s);
  String get platform => decryptWithMasterPWFromBase64(encryptedPlatform);

  set username(String s) => encryptedPlatform = encryptWithMasterPWToBase64(s);
  String get username => decryptWithMasterPWFromBase64(encryptedUsername);

  set notes(String s) => encryptedPlatform = encryptWithMasterPWToBase64(s);
  String get notes => decryptWithMasterPWFromBase64(encryptedNotes);

  set password(String s) => encryptedPassword = encryptWithMasterPWToBase64(s);
  String get password => decryptWithMasterPWFromBase64(encryptedPassword);

  String encryptWithMasterPWToBase64(Object obj) {
    try {
      return crypt.Encrypter(crypt.AES(key))
          .encrypt(obj.toString(), iv: crypt.IV.fromLength(16))
          .base64;
    } catch (e) {
      throw 'Incorrect data decryption behavior!';
    }
  }

  String decryptWithMasterPWFromBase64(String encrypted) {
    try {
      return crypt.Encrypter(crypt.AES(key)).decrypt(
          crypt.Encrypted.fromBase64(encrypted),
          iv: crypt.IV.fromLength(16));
    } catch (e) {
      throw 'Incorrect Masterpassword or incorrect data decryption behavior!';
    }
  }

  @override
  String toString() {
    return 'encryptedPlatform: $encryptedPlatform, '
        'encryptedUsername: $encryptedUsername, '
        'encryptedPassword: $encryptedPassword, '
        'encryptedNotes: $encryptedNotes';
  }

  Password.fromMap(Map<String, dynamic> json)
      : encryptedPlatform = json['encryptedPlatform'],
        encryptedUsername = json['encryptedUsername'],
        encryptedNotes = json['encryptedNotes'],
        encryptedPassword = json['encryptedPassword'];

  factory Password.fromJson(String jsonString) {
    return Password.fromMap(json.decode(jsonString));
  }

  Map toMap() {
    return {
      'encryptedPlatform': this.encryptedPlatform,
      'encryptedUsername': this.encryptedUsername,
      'encryptedNotes': this.encryptedNotes,
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
