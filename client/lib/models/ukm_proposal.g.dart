// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ukm_proposal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UkmProposal _$UkmProposalFromJson(Map<String, dynamic> json) => UkmProposal(
  id: (json['id'] as num).toInt(),
  namaUkm: json['nama_ukm'] as String,
  deskripsi: json['deskripsi'] as String,
  kategori: json['kategori'] as String,
  logoPath: json['logo_path'] as String,
  status: json['status'] as String,
  proposer: User.fromJson(json['proposer'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UkmProposalToJson(UkmProposal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nama_ukm': instance.namaUkm,
      'deskripsi': instance.deskripsi,
      'kategori': instance.kategori,
      'logo_path': instance.logoPath,
      'status': instance.status,
      'proposer': instance.proposer.toJson(),
    };
