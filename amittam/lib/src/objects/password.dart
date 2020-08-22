import 'dart:convert';

import 'package:Amittam/src/libs/encryption_library.dart';
import 'package:Amittam/src/libs/lib.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:encrypt/encrypt.dart' as crypt;

class Password {
  Password(
    String password, {
    String username = '',
    String platform = '',
    String notes = '',
    this.passwordType,
  }) {
    if (EncryptionService.keys.isEmpty)
      throw 'Masterpassword not defined! Password could not be initialized!';
    this.password = password;
    this.platform = platform;
    this.notes = notes == null ? '' : notes;
    this.username = username;
  }

  PasswordType passwordType;

  String encryptedPlatform = '';
  String encryptedUsername = '';
  String encryptedNotes = '';
  String encryptedPassword = '';

  set platform(String s) =>
      encryptedPlatform = EncryptionService.encryptToBase64(
          s, EncryptionService.getEncrypterFromKeys());

  String get platform => EncryptionService.decryptFromBase64(
      encryptedPlatform, EncryptionService.getEncrypterFromKeys());

  set username(String s) =>
      encryptedUsername = EncryptionService.encryptToBase64(
          s, EncryptionService.getEncrypterFromKeys());

  String get username => EncryptionService.decryptFromBase64(
      encryptedUsername, EncryptionService.getEncrypterFromKeys());

  set notes(String s) => encryptedNotes = EncryptionService.encryptToBase64(
      s, EncryptionService.getEncrypterFromKeys());

  String get notes => EncryptionService.decryptFromBase64(
      encryptedNotes, EncryptionService.getEncrypterFromKeys());

  set password(String s) =>
      encryptedPassword = EncryptionService.encryptToBase64(
          s, EncryptionService.getEncrypterFromKeys());

  String get password => EncryptionService.decryptFromBase64(
      encryptedPassword, EncryptionService.getEncrypterFromKeys());

  Map<String, dynamic> toMap() => {
        'encryptedPlatform': this.encryptedPlatform,
        'encryptedUsername': this.encryptedUsername,
        'encryptedNotes': this.encryptedNotes,
        'encryptedPassword': this.encryptedPassword,
        'passwordType': EnumToString.parse(this.passwordType),
      };

  Map<String, dynamic> toDecryptedMap() => {
        'platform': this.platform,
        'username': this.username,
        'password': this.password,
        'notes': this.notes,
        'passwordType': EnumToString.parse(this.passwordType),
      };

  String toJson() => json.encode(toMap());

  String toEncryptedJson() => EncryptionService.encryptToBase64(
      toJson(), EncryptionService.getEncrypterFromKeys());

  String toDecryptedJson() => json.encode(toDecryptedMap());

  Password.fromMap(Map<String, dynamic> json)
      : encryptedPlatform = json['encryptedPlatform'],
        encryptedUsername = json['encryptedUsername'],
        encryptedNotes = json['encryptedNotes'],
        encryptedPassword = json['encryptedPassword'],
        passwordType =
            EnumToString.fromString(PasswordType.values, json['passwordType']);

  factory Password.fromDecryptedMap(Map<String, dynamic> json) => Password(
        json['password'],
        platform: json['platform'],
        username: json['username'],
        notes: json['notes'],
        passwordType:
            EnumToString.fromString(PasswordType.values, json['passwordType']),
      );

  DecryptedPassword get asDecryptedPassword => DecryptedPassword(
        platform: this.platform,
        username: this.username,
        password: this.password,
        notes: this.notes,
        passwordType: this.passwordType,
      );

  Password.fromSnapshot(DataSnapshot snapshot)
      : encryptedPlatform = snapshot.value['encryptedPlatform'],
        encryptedUsername = snapshot.value['encryptedUsername'],
        encryptedNotes = snapshot.value['encryptedNotes'],
        encryptedPassword = snapshot.value['encryptedPassword'],
        passwordType = EnumToString.fromString(
            PasswordType.values, snapshot.value['encryptedPlatform']);

  factory Password.fromJson(String jsonString) =>
      Password.fromMap(json.decode(jsonString));

  factory Password.fromEncryptedJson(String s) =>
      Password.fromMap(json.decode(EncryptionService.decryptFromBase64(
          s, EncryptionService.getEncrypterFromKeys())));

  factory Password.fromDecryptedJson(String jsonString) =>
      Password.fromDecryptedMap(json.decode(jsonString));

  @override
  String toString() =>
      'Password{passwordType: $passwordType, encryptedPlatform: $encryptedPlatform, encryptedUsername: $encryptedUsername, encryptedNotes: $encryptedNotes, encryptedPassword: $encryptedPassword}';
}

class DecryptedPassword {
  DecryptedPassword({
    this.platform = '',
    this.username = '',
    this.password = '',
    this.notes = '',
    this.passwordType = PasswordType.onlineAccount,
  });

  String platform;
  String username;
  String password;
  String notes;
  PasswordType passwordType;

  Password get asPassword => Password(
        this.password,
        platform: this.platform,
        username: this.username,
        notes: this.notes,
        passwordType: this.passwordType,
      );

  Map<String, dynamic> toMap() => {
        'platform': this.platform,
        'username': this.username,
        'password': this.password,
        'notes': this.notes,
        'passwordType': EnumToString.parse(this.passwordType),
      };

  String get asAutofillPassword => '${this.platform}~${this.username}~${this.password}';

  DecryptedPassword.fromMap(Map<String, dynamic> json)
      : platform = json['platform'],
        username = json['username'],
        notes = json['notes'],
        password = json['password'],
        passwordType =
            EnumToString.fromString(PasswordType.values, json['passwordType']);

  factory DecryptedPassword.fromJson(String jsonString) =>
      DecryptedPassword.fromMap(json.decode(jsonString));

  @override
  String toString() =>
      'DecryptedPassword{platform: $platform, username: $username, password: $password, notes: $notes, passwordType: $passwordType}';
}
