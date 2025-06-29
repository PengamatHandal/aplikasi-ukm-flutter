// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  nim: json['nim'] as String?,
  email: json['email'] as String?,
  role: json['role'] as String?,
  fotoProfilUrl: json['foto_profil_url'] as String?,
  ukmAdmin:
      json['ukm_admin'] == null
          ? null
          : Ukm.fromJson(json['ukm_admin'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'nim': instance.nim,
  'email': instance.email,
  'role': instance.role,
  'foto_profil_url': instance.fotoProfilUrl,
  'ukm_admin': instance.ukmAdmin?.toJson(),
};
