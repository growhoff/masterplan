// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class UnitDTO extends Dto {
  final int id;
  final String? name;
  final String? number;
  final int companyId;
  final int? staffId;
  final StaffDTO? staff;
  final int? areasQuantity;
  final int? machinesQuantity;
  final int? operatorsQuantity;
  final int? supportStaffQuantity;

  UnitDTO(
      {required this.id,
      this.name,
      this.number,
      required this.companyId,
      this.staffId,
      this.staff,
      this.areasQuantity,
       this.machinesQuantity,
       this.operatorsQuantity,
       this.supportStaffQuantity});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'company_id': companyId,
    };
  }

  factory UnitDTO.fromMap(Map<String, dynamic> map) {
    return UnitDTO(
        id: map['id'] as int,
        name: map['name'] ?? '',
        companyId: map['company_id'] as int,
        number: map['number'] ?? '',
        staffId: map['staff_id'],
        staff: map['z_staff'] != null ? StaffDTO.fromMap(map['z_staff']) : null,
        areasQuantity: map['areas_quantity'],
        machinesQuantity: map['machines_quantity'],
        operatorsQuantity: map['operators_quantity'],
        supportStaffQuantity: map['support_staff_quantity']);
  }

  String toJson() => json.encode(toMap());

  factory UnitDTO.fromJson(String source) =>
      UnitDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
