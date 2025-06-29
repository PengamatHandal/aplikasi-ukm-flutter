import 'package:json_annotation/json_annotation.dart';
import 'package:client/models/ukm.dart';

part 'kegiatan.g.dart';

@JsonSerializable(explicitToJson: true)
class Kegiatan {
  final int id;
  final String judul;
  final String deskripsi;

  @JsonKey(name: 'gambar_url')
  final String? gambarUrl;
  
  @JsonKey(name: 'tanggal_acara')
  final DateTime tanggalAcara;

  final String lokasi;
  
  final Ukm? ukm;

  Kegiatan({
    required this.id,
    required this.judul,
    required this.deskripsi,
    this.gambarUrl,
    required this.tanggalAcara,
    required this.lokasi,
    this.ukm,
  });

  factory Kegiatan.fromJson(Map<String, dynamic> json) => _$KegiatanFromJson(json);

  Map<String, dynamic> toJson() => _$KegiatanToJson(this);
}