import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class StaffDTO {
  final String number;
  final String password;
  final String fio;
  final int region;
  final String position;
  final String company;
  StaffDTO({
    required this.number,
    required this.password,
    required this.fio,
    required this.region,
    required this.position,
    required this.company,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'number': number,
      'password': password,
      'FIO': fio,
      'region': region,
      'position': position,
      'company': company,
    };
  }

  factory StaffDTO.fromMap(Map<String, dynamic> map) {
    return StaffDTO(
      number: map['number'] as String,
      password: map['password'] as String,
      fio: map['FIO'] as String,
      region: map['region'] as int,
      position: map['position'] as String,
      company: map['company'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StaffDTO.fromJson(String source) => StaffDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
