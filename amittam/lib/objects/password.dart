import 'package:flutter/material.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:json_serializable/builder.dart';
import 'package:json_serializable/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'password.g.dart';

@JsonSerializable()
class Password {
  Password({
    @required this.encryptionKey,
    @required this.encryptedPassword,
  });
  String encryptionKey = '';
  String encryptedPassword = '';

  @override
  String toString() {
    return 'encryptionKey: $encryptionKey, encryptedPassword: $encryptedPassword';
  }

  Map<String, dynamic> toJson() => _$PasswordToJson(this);
  factory Password.fromJson(Map<String, dynamic> json) =>
      _$PasswordFromJson(json);
}

Future<Password> getPassword(String password) async {
  final cryptor = new PlatformStringCryptor();
  String encryptionKey = await cryptor.generateRandomKey();
  String encryptedPassword = await cryptor.encrypt(password, encryptionKey);
  return Password(
      encryptionKey: encryptionKey, encryptedPassword: encryptedPassword);
}
