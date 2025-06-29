import 'package:json_annotation/json_annotation.dart';
import 'package:client/models/kegiatan.dart';
import 'package:client/models/user.dart';

part 'ukm.g.dart';

@JsonSerializable(explicitToJson: true)
class Ukm {
  final int id;
  @JsonKey(name: 'nama_ukm')
  final String namaUkm;
  final String? deskripsi;
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  final String? kategori;
  @JsonKey(name: 'is_pendaftaran_buka', defaultValue: false)
  final bool isPendaftaranBuka;
  final User? admin;
  @JsonKey(defaultValue: [])
  final List<Kegiatan>? kegiatans;
  @JsonKey(defaultValue: [])
  final List<User>? anggota;

  Ukm({
    required this.id,
    required this.namaUkm,
    this.deskripsi,
    this.logoUrl,
    this.kategori,
    required this.isPendaftaranBuka,
    this.admin,
    this.kegiatans,
    this.anggota,
  });

  Ukm copyWith({
    int? id,
    String? namaUkm,
    String? deskripsi,
    String? logoUrl,
    String? kategori,
    bool? isPendaftaranBuka,
    User? admin,
    List<Kegiatan>? kegiatans,
    List<User>? anggota,
  }) {
    return Ukm(
      id: id ?? this.id,
      namaUkm: namaUkm ?? this.namaUkm,
      deskripsi: deskripsi ?? this.deskripsi,
      logoUrl: logoUrl ?? this.logoUrl,
      kategori: kategori ?? this.kategori,
      isPendaftaranBuka: isPendaftaranBuka ?? this.isPendaftaranBuka,
      admin: admin ?? this.admin,
      kegiatans: kegiatans ?? this.kegiatans,
      anggota: anggota ?? this.anggota,
    );
  }

  factory Ukm.fromJson(Map<String, dynamic> json) => _$UkmFromJson(json);
  Map<String, dynamic> toJson() => _$UkmToJson(this);
}