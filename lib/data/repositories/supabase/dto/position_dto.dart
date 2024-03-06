import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PositionDTO {
  final int id;
  final String name;
  PositionDTO({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory PositionDTO.fromMap(Map<String, dynamic> map) {
    return PositionDTO(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PositionDTO.fromJson(String source) => PositionDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
