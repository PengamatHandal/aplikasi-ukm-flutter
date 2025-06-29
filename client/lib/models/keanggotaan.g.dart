// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keanggotaan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Keanggotaan _$KeanggotaanFromJson(Map<String, dynamic> json) => Keanggotaan(
  id: (json['id'] as num).toInt(),
  status: json['status'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$KeanggotaanToJson(Keanggotaan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'user': instance.user.toJson(),
    };
