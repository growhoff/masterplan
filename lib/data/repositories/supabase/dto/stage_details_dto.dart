import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class StageDetailsDTO {
  final int id;
  final int stageId;
  final int detailNumber;
  final int companyId;
  StageDetailsDTO({
    required this.id,
    required this.stageId,
    required this.detailNumber,
    required this.companyId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'stage_id': stageId,
      'detail_number': detailNumber,
      'company_id': companyId,
    };
  }

  factory StageDetailsDTO.fromMap(Map<String, dynamic> map) {
    return StageDetailsDTO(
      id: map['id'] as int,
      stageId: map['stage_id'] as int,
      detailNumber: map['detail_number'] as int,
      companyId: map['company_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory StageDetailsDTO.fromJson(String source) => StageDetailsDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
