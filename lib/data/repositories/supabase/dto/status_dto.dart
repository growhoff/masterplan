import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class StatusDTO {
  final int id;
  final String name;
  StatusDTO({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory StatusDTO.fromMap(Map<String, dynamic> map) {
    return StatusDTO(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StatusDTO.fromJson(String source) => StatusDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
