import 'dart:convert';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class EquipmentDistributionDTO {
  final int id;
  final int equipmentId;
  final int userId;
  EquipmentDistributionDTO({
    required this.id,
    required this.equipmentId,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'equipment_id': equipmentId,
      'user_id': userId,
    };
  }

  factory EquipmentDistributionDTO.fromMap(Map<String, dynamic> map) {
    return EquipmentDistributionDTO(
      id: map['id'] as int,
      equipmentId: map['equipment_id'] as int,
      userId: map['user_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory EquipmentDistributionDTO.fromJson(String source) => EquipmentDistributionDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
