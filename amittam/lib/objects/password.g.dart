// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Password _$PasswordFromJson(Map<String, dynamic> json) {
  return Password(
    encryptionKey: json['encryptionKey'] as String,
    encryptedPassword: json['encryptedPassword'] as String,
  );
}

Map<String, dynamic> _$PasswordToJson(Password instance) => <String, dynamic>{
      'encryptionKey': instance.encryptionKey,
      'encryptedPassword': instance.encryptedPassword,
    };
