import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class StageDTO {
  final int id;
  final String number;
  final int operationsQuentity;
  final int detailsQuentity;
  final int companyId;
  final int detailsId;
  StageDTO({
    required this.id,
    required this.number,
    required this.operationsQuentity,
    required this.detailsQuentity,
    required this.companyId,
    required this.detailsId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'operations_quentity': operationsQuentity,
      'details_quentity': detailsQuentity,
      'company_id': companyId,
      'details_id': detailsId,
    };
  }

  factory StageDTO.fromMap(Map<String, dynamic> map) {
    return StageDTO(
      id: map['id'] as int,
      number: map['number'] as String,
      operationsQuentity: map['operations_quentity'] as int,
      detailsQuentity: map['details_quentity'] as int,
      companyId: map['company_id'] as int,
      detailsId: map['details_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory StageDTO.fromJson(String source) => StageDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
