import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as crypt;

part 'password.g.dart';

class Password {
  Password({
    @required this.encryptionKey,
    @required this.encryptedPassword,
  });
  String encryptionKey = '';
  String encryptedPassword = '';

  String get password =>
      crypt.Encrypter(crypt.AES(crypt.Key.fromBase64(encryptionKey))).decrypt(
          crypt.Encrypted.fromBase64(encryptedPassword),
          iv: crypt.IV.fromLength(16));

  @override
  String toString() {
    return 'encryptionKey: $encryptionKey, encryptedPassword: $encryptedPassword';
  }

  Password.fromMap(Map<String, dynamic> json)
      : encryptionKey = json['encryptionKey'],
        encryptedPassword = json['encryptedPassword'];

  factory Password.fromJson(String jsonString) {
    return Password.fromMap(json.decode(jsonString));
  }

  Map toMap() {
    return {
      'encryptionKey': this.encryptionKey,
      'encryptedPassword': this.encryptedPassword,
    };
  }

  String toJson() {
    return json.encode(toMap());
  }
}

Password getPassword(String password) {
  var key = crypt.Key.fromSecureRandom(32);
  var iv = crypt.IV.fromLength(16);
  crypt.Encrypter crypter = crypt.Encrypter(crypt.AES(key));
  String encryptionKey = key.base64;
  String encryptedPassword = crypter.encrypt(password, iv: iv).base64;
  return Password(
      encryptionKey: encryptionKey, encryptedPassword: encryptedPassword);
}
