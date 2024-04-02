// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class PackageDTO2 extends Dto {
  final int id;
  final int number;
  final List<int> batchId;
  PackageDTO2({
    required this.id,
    required this.number,
    required this.batchId,
  });
//  areaId: (map['area_id'] as List<dynamic>).map((e) => e as int).toList(),

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'batch_id': batchId,
    };
  }

  factory PackageDTO2.fromMap(Map<String, dynamic> map) {
    return PackageDTO2(
      id: map['id'] as int,
      number: map['number'] as int,
      batchId: (map['batch_id'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PackageDTO2.fromJson(String source) => PackageDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
}
