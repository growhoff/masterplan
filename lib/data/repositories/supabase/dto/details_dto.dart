import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class DetailsDTO extends Dto{
  final int id;
  final String planNumber;
  final String planName;
  DetailsDTO({
    required this.id,
    required this.planNumber,
    required this.planName,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'plan_number': planNumber,
      'plan_name': planName,
    };
  }

  factory DetailsDTO.fromMap(Map<String, dynamic> map) {
    return DetailsDTO(
      id: map['id'] as int,
      planNumber: map['plan_number'] as String,
      planName: map['plan_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DetailsDTO.fromJson(String source) => DetailsDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
