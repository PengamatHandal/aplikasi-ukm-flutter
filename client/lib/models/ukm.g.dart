// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ukm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ukm _$UkmFromJson(Map<String, dynamic> json) => Ukm(
  id: (json['id'] as num).toInt(),
  namaUkm: json['nama_ukm'] as String,
  deskripsi: json['deskripsi'] as String?,
  logoUrl: json['logo_url'] as String?,
  kategori: json['kategori'] as String?,
  isPendaftaranBuka: json['is_pendaftaran_buka'] as bool? ?? false,
  admin:
      json['admin'] == null
          ? null
          : User.fromJson(json['admin'] as Map<String, dynamic>),
  kegiatans:
      (json['kegiatans'] as List<dynamic>?)
          ?.map((e) => Kegiatan.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  anggota:
      (json['anggota'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$UkmToJson(Ukm instance) => <String, dynamic>{
  'id': instance.id,
  'nama_ukm': instance.namaUkm,
  'deskripsi': instance.deskripsi,
  'logo_url': instance.logoUrl,
  'kategori': instance.kategori,
  'is_pendaftaran_buka': instance.isPendaftaranBuka,
  'admin': instance.admin?.toJson(),
  'kegiatans': instance.kegiatans?.map((e) => e.toJson()).toList(),
  'anggota': instance.anggota?.map((e) => e.toJson()).toList(),
};
