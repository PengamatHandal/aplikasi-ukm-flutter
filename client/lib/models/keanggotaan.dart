import 'package:json_annotation/json_annotation.dart';
import 'package:client/models/user.dart';

part 'keanggotaan.g.dart';

@JsonSerializable(explicitToJson: true)
class Keanggotaan {
  final int id; 
  
  final String status;

  final User user;

  Keanggotaan({
    required this.id,
    required this.status,
    required this.user,
  });

  factory Keanggotaan.fromJson(Map<String, dynamic> json) => _$KeanggotaanFromJson(json);
  Map<String, dynamic> toJson() => _$KeanggotaanToJson(this);
}