// lib/models/ukm_proposal.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:client/models/user.dart';

part 'ukm_proposal.g.dart';

@JsonSerializable(explicitToJson: true)
class UkmProposal {
  final int id;

  @JsonKey(name: 'nama_ukm')
  final String namaUkm;

  final String deskripsi;
  final String kategori;
  
  @JsonKey(name: 'logo_path')
  final String logoPath;
  
  final String status;

  // Data user yang mengajukan proposal
  final User proposer;

  UkmProposal({
    required this.id,
    required this.namaUkm,
    required this.deskripsi,
    required this.kategori,
    required this.logoPath,
    required this.status,
    required this.proposer,
  });

  factory UkmProposal.fromJson(Map<String, dynamic> json) => _$UkmProposalFromJson(json);
  Map<String, dynamic> toJson() => _$UkmProposalToJson(this);
}