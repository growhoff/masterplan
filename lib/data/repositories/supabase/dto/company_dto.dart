// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CompanyDTO {
  final String shortName;
  final String fullName;

  CompanyDTO({
    required this.shortName,
    required this.fullName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'short_name': shortName,
      'full_name': fullName,
    };
  }

  factory CompanyDTO.fromMap(Map<String, dynamic> map) {
    return CompanyDTO(
      shortName: map['short_name'] as String,
      fullName: map['full_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CompanyDTO.fromJson(String source) => CompanyDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
