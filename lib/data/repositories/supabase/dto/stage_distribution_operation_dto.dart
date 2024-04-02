// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class StStageDistributionDTO extends Dto {
  final int id;
  final String operationName;
  final List<int> operationsIdList;
  final int quantity;
  StStageDistributionDTO({
    required this.id,
    required this.operationName,
    required this.operationsIdList,
    required this.quantity,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'operation_name': operationName,
      'operations_id_list': operationsIdList,
      'quantity': quantity,
    };
  }

  factory StStageDistributionDTO.fromMap(Map<String, dynamic> map) {
    return StStageDistributionDTO(
      id: map['id'] as int,
      operationName: map['operation_name'] as String,
      operationsIdList: (map['operations_id_list'] as List<dynamic>).map((e) => e as int).toList(),
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory StStageDistributionDTO.fromJson(String source) => StStageDistributionDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
