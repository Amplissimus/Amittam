import 'package:flutter/material.dart';
import 'package:json_serializable/builder.dart';
import 'package:json_serializable/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:encrypt/encrypt.dart' as crypt;

part 'password.g.dart';

@JsonSerializable()
class Password {
  Password({
    @required this.encryptionKey,
    @required this.encryptedPassword,
  });
  String encryptionKey = '';
  String encryptedPassword = '';

  String get password =>
      crypt.Encrypter(crypt.AES(crypt.Key.fromBase64(encryptionKey)))
          .decrypt(crypt.Encrypted.fromBase64(encryptedPassword));

  @override
  String toString() {
    return 'encryptionKey: $encryptionKey, encryptedPassword: $encryptedPassword';
  }

  Map<String, dynamic> toJson() => _$PasswordToJson(this);
  factory Password.fromJson(Map<String, dynamic> json) =>
      _$PasswordFromJson(json);
}

Password getPassword(String password) {
  var key = crypt.Key.fromSecureRandom(32);
  String encryptionKey = key.base64;
  String encryptedPassword =
      crypt.Encrypter(crypt.AES(key)).encrypt(password).base64;
  return Password(
      encryptionKey: encryptionKey, encryptedPassword: encryptedPassword);
}
