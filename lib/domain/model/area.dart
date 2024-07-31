// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';

class Area {
  final int id;
  final String name;
  final String number;
  final int unitId;
  final int? machinesQuantity;
  Area({
    required this.id,
    required this.name,
    required this.number,
    required this.unitId,
    this.machinesQuantity
  });

  static final empty = Area(id: 0, name: '', number: '', unitId: 0);

  factory Area.fromDTO(AreaDTO dto) {
    return Area(id: dto.id, name: dto.name, number: dto.number, unitId: dto.unitId);
  }
}
