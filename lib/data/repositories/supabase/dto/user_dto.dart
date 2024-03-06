import 'dart:convert';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserDTO {
  final int id;
  final String fio;
  final int positionId;
  final int regionId;
  final int companyId;
  UserDTO({
    required this.id,
    required this.fio,
    required this.positionId,
    required this.regionId,
    required this.companyId,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fio': fio,
      'position_id': positionId,
      'region_id': regionId,
      'company_id': companyId,
    };
  }

  factory UserDTO.fromMap(Map<String, dynamic> map) {
    return UserDTO(
      id: map['id'] as int,
      fio: map['fio'] as String,
      positionId: map['position_id'] as int,
      regionId: map['region_id'] as int,
      companyId: map['company_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDTO.fromJson(String source) => UserDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
