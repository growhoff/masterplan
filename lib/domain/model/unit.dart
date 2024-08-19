// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/domain/model/staff.dart';

class Unit {
  final int id;
  final String? name;
  final String? number;
  final int companyId;
  final int? staffId;
  final Staff? chief;
  final int? areasQuantity;
  final int? machinesQuantity;
  final int? operatorsQuantity;
  final int? supportStaffQuantity;

  Unit({
    required this.id,
    this.name,
    this.number,
    required this.companyId,
    this.staffId,
    this.chief,
    this.areasQuantity,
    this.machinesQuantity,
    this.operatorsQuantity,
    this.supportStaffQuantity,
  });

  static final empty = Unit(
      id: 0,
      companyId: 0,
      areasQuantity: 0,
      machinesQuantity: 0,
      operatorsQuantity: 0,
      supportStaffQuantity: 0);

  factory Unit.fromDTO(UnitDTO dto) {
    return Unit(
      id: dto.id,
      name: dto.name,
      number: dto.number,
      companyId: dto.companyId,
    );
  }
}
