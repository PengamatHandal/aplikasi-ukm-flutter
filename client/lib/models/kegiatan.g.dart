// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kegiatan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kegiatan _$KegiatanFromJson(Map<String, dynamic> json) => Kegiatan(
  id: (json['id'] as num).toInt(),
  judul: json['judul'] as String,
  deskripsi: json['deskripsi'] as String,
  gambarUrl: json['gambar_url'] as String?,
  tanggalAcara: DateTime.parse(json['tanggal_acara'] as String),
  lokasi: json['lokasi'] as String,
  ukm:
      json['ukm'] == null
          ? null
          : Ukm.fromJson(json['ukm'] as Map<String, dynamic>),
);

Map<String, dynamic> _$KegiatanToJson(Kegiatan instance) => <String, dynamic>{
  'id': instance.id,
  'judul': instance.judul,
  'deskripsi': instance.deskripsi,
  'gambar_url': instance.gambarUrl,
  'tanggal_acara': instance.tanggalAcara.toIso8601String(),
  'lokasi': instance.lokasi,
  'ukm': instance.ukm?.toJson(),
};
