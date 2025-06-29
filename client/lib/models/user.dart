// lib/models/user.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:client/models/ukm.dart'; 
part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final int id;
  final String name;
  final String? nim;
  final String? email;
  final String? role;

  @JsonKey(name: 'foto_profil_url')
  final String? fotoProfilUrl;

  @JsonKey(name: 'ukm_admin') 
  final Ukm? ukmAdmin;

  User({
    required this.id,
    required this.name,
    this.nim,
    this.email,
    this.role,
    this.fotoProfilUrl,
    this.ukmAdmin, 
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}