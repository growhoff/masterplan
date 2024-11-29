// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class StageDTO extends Dto {
  final int id;
  final String number;
  final String name;
  final int? areaId;
  final AreaDTO? area;
  final int? batchId;
  final BatchDTO? batch;
  final int? batchArchiveId;

  StageDTO({
    required this.id,
    required this.number,
    required this.name,
    this.batchArchiveId,
     this.areaId,
    this.batchId,
    this.area,
    this.batch,

  });
  
  static final empty = StageDTO(
    id: 0, 
    number: '',
    name: '', 
    areaId: 0,
    batchId: 0,
  );


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'name': name,
      'area_id': areaId,

      'batch_id': batchId,
    };
  }

  factory StageDTO.fromMap(Map<String, dynamic> map) {
    return StageDTO(
      id: map['id'] as int,
      number: map['number'] as String,
      name: map['name'] as String,
      areaId: map['area_id'] != null ? map['area_id'] : null ,
batchArchiveId: map['batch_archive_id'],
      batchId: map['batch_id'] ,
      area: map['z_area'] != null ? AreaDTO.fromMap(map['z_area']) : null,
      batch: map['z_batch'] != null ? BatchDTO.fromMap(map['z_batch']) : null,

    );
  }

  String toJson() => json.encode(toMap());

  factory StageDTO.fromJson(String source) => StageDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
