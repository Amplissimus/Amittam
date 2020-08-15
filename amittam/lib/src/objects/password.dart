import 'dart:convert';

import 'package:Amittam/src/libs/firebaselib.dart';
import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/libs/prefslib.dart';
import 'package:Amittam/src/objects/displayable_password.dart';
import 'package:Amittam/src/values.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as crypt;

class Password {
  Password(
    String password, {
    String username = '',
    String platform = '',
    String notes = '',
    this.passwordType,
  }) {
    if (key == null)
      throw 'Masterpassword not defined! Password could not be initialized!';
    this.password = password;
    this.platform = platform;
    this.notes = notes;
    this.username = username;
  }

  static var key;

  static void updateKey(String s) =>
      key = crypt.Key.fromUtf8(expandStringTo32Characters(s));

  static set masterPassword(String s) =>
      Password.key = crypt.Key.fromUtf8(expandStringTo32Characters(s));

  PasswordType passwordType;

  String encryptedPlatform = '';
  String encryptedUsername = '';
  String encryptedNotes = '';
  String encryptedPassword = '';

  set platform(String s) => encryptedPlatform = encryptWithMasterPWToBase64(s);

  String get platform => decryptWithMasterPWFromBase64(encryptedPlatform);

  set username(String s) => encryptedUsername = encryptWithMasterPWToBase64(s);

  String get username => decryptWithMasterPWFromBase64(encryptedUsername);

  set notes(String s) => encryptedNotes = encryptWithMasterPWToBase64(s);

  String get notes => decryptWithMasterPWFromBase64(encryptedNotes);

  set password(String s) => encryptedPassword = encryptWithMasterPWToBase64(s);

  String get password => decryptWithMasterPWFromBase64(encryptedPassword);

  String encryptWithMasterPWToBase64(String decrypted) {
    if (decrypted.isEmpty) return '';
    try {
      return crypt.Encrypter(crypt.AES(key))
          .encrypt(decrypted, iv: crypt.IV.fromLength(16))
          .base64;
    } catch (e) {
      throw 'Incorrect data encryption behavior!';
    }
  }

  String decryptWithMasterPWFromBase64(String encrypted) {
    if (encrypted.isEmpty) return '';
    try {
      return crypt.Encrypter(crypt.AES(key)).decrypt(
          crypt.Encrypted.fromBase64(encrypted),
          iv: crypt.IV.fromLength(16));
    } catch (e) {
      throw 'Incorrect Masterpassword or incorrect data decryption behavior!';
    }
  }

  Password.fromMap(Map<String, dynamic> json)
      : encryptedPlatform = json['encryptedPlatform'],
        encryptedUsername = json['encryptedUsername'],
        encryptedNotes = json['encryptedNotes'],
        encryptedPassword = json['encryptedPassword'],
        passwordType =
            EnumToString.fromString(PasswordType.values, json['passwordType']);

  factory Password.fromJson(String jsonString) =>
      Password.fromMap(json.decode(jsonString));

  Password.fromSnapshot(DataSnapshot snapshot)
      : encryptedPlatform = snapshot.value['encryptedPlatform'],
        encryptedUsername = snapshot.value['encryptedUsername'],
        encryptedNotes = snapshot.value['encryptedNotes'],
        encryptedPassword = snapshot.value['encryptedPassword'],
        passwordType = EnumToString.fromString(
            PasswordType.values, snapshot.value['encryptedPlatform']);

  Map<String, dynamic> toMap() => {
        'encryptedPlatform': this.encryptedPlatform,
        'encryptedUsername': this.encryptedUsername,
        'encryptedNotes': this.encryptedNotes,
        'encryptedPassword': this.encryptedPassword,
        'passwordType': EnumToString.parse(this.passwordType),
      };

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toDecryptedMap() => {
        'platform': this.platform,
        'username': this.username,
        'password': this.password,
        'notes': this.notes,
        'passwordType': EnumToString.parse(this.passwordType),
      };

  factory Password.fromDecryptedMap(Map<String, dynamic> json) => Password(
        json['password'],
        platform: json['platform'],
        username: json['username'],
        notes: json['notes'],
        passwordType:
            EnumToString.fromString(PasswordType.values, json['passwordType']),
      );

  factory Password.fromDecryptedJson(String jsonString) =>
      Password.fromDecryptedMap(json.decode(jsonString));

  String toDecryptedJson() => json.encode(toDecryptedMap());

  static String exportPasswordsToEncryptedString(List<Password> passwords) {
    List<String> tempStringList = [];
    for (Password password in passwords) tempStringList.add(password.toJson());
    String jsonDecrypted = jsonEncode(tempStringList);
    return crypt.Encrypter(crypt.AES(Password.key))
        .encrypt(jsonDecrypted, iv: crypt.IV.fromLength(16))
        .base64;
  }

  DecryptedPassword get asDecryptedPassword => DecryptedPassword(
        platform: this.platform,
        username: this.username,
        password: this.password,
        notes: this.notes,
        passwordType: this.passwordType,
      );

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

Future<void> getPasswordsFromFirebaseEventSnapshot(
    DataSnapshot dataSnapshot) async {
  if (!Prefs.allowRetrievingCloudData) return;
  int i = 0;
  bool b = true;
  List<String> tempStringList = [];
  List<Password> tempPasswordList = [];
  while (b)
    try {
      tempStringList.add(dataSnapshot.value[i]);
      tempPasswordList.add(Password.fromJson(dataSnapshot.value[i]));
      i++;
    } catch (e) {
      b = false;
    }
  Prefs.preferences.setStringList('passwords', tempStringList);
  Values.passwords = tempPasswordList;
  await FirebaseService.masterPasswordRef.once().then((snapshot) =>
      Prefs.preferences.setString(
          'encrypted_master_password', snapshot.value.toString().trim()));
  if (Values.afterBrightnessUpdate != null) Values.afterBrightnessUpdate();
}
