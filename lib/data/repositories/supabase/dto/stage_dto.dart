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
  final bool isdistributed;
  final int? batchId;
  final BatchDTO? batch;
  final int? batchArchiveId;
  StageDTO({
    required this.id,
    required this.number,
    required this.name,
     this.areaId,
    required this.isdistributed,
    this.batchId,
    this.area,
    this.batch,
    this.batchArchiveId
  });
  
  static final empty = StageDTO(
    id: 0, 
    number: '',
    name: '', 
    areaId: 0, 
    isdistributed: false, 
    batchId: 0,
  );


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'name': name,
      'area_id': areaId,
      'is_distributed': isdistributed,
      'batch_id': batchId,
    };
  }

  factory StageDTO.fromMap(Map<String, dynamic> map) {
    return StageDTO(
      id: map['id'] as int,
      number: map['number'] as String,
      name: map['name'] as String,
      areaId: map['area_id'] != null ? map['area_id'] : null ,
      isdistributed: map['is_distributed'] as bool,
      batchId: map['batch_id'] ,
      area: map['z_area'] != null ? AreaDTO.fromMap(map['z_area']) : null,
      batch: map['z_batch'] != null ? BatchDTO.fromMap(map['z_batch']) : null,
      batchArchiveId: map['batch_archive_id']
    );
  }

  String toJson() => json.encode(toMap());

  factory StageDTO.fromJson(String source) => StageDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
