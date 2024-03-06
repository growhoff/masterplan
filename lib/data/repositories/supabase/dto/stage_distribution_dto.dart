import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class StageDistributionDTO {
  final int id;
  final int stageId;
  final bool isDistributed;
  StageDistributionDTO({
    required this.id,
    required this.stageId,
    required this.isDistributed,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'stage_id': stageId,
      'is_distributed': isDistributed,
    };
  }

  factory StageDistributionDTO.fromMap(Map<String, dynamic> map) {
    return StageDistributionDTO(
      id: map['id'] as int,
      stageId: map['stage_id'] as int,
      isDistributed: map['is_distributed'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory StageDistributionDTO.fromJson(String source) => StageDistributionDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
