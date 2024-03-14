import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/dto/change_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/company_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/equipment_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/region_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ShiftsDistributionDTO extends Dto{
  final int id;
  final ChangeDTO change;
  final DateTime date;
  final EquipmentDTO equipment;
  final UserDTO user;
  final RegionDTO region;
  final CompanyDTO company;
  ShiftsDistributionDTO({
    required this.id,
    required this.change,
    required this.date,
    required this.equipment,
    required this.user,
    required this.region,
    required this.company,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'change_id': change.id,
      'date': date.millisecondsSinceEpoch,
      'equipment_id': equipment.id,
      'user_id': user.id,
      'region_id': region.id,
      'company_id': company.id,
    };
  }

  factory ShiftsDistributionDTO.fromMap(Map<String, dynamic> map) {
    final listDate = (map['date'] as String).split('-');
    final y = int.parse(listDate[0]);
    final m = int.parse(listDate[1]);
    final d = int.parse(listDate[2]);
    return ShiftsDistributionDTO(
      id: map['id'] as int,
      change: ChangeDTO.fromMap(map['f_change'] as Map<String,dynamic>),
      date: DateTime.utc(y,m,d),
      equipment: EquipmentDTO.fromMap(map['f_equipment'] as Map<String,dynamic>),
      user: UserDTO.fromMap(map['f_user'] as Map<String,dynamic>),
      region: RegionDTO.fromMap(map['f_region'] as Map<String,dynamic>),
      company: CompanyDTO.fromMap(map['f_company'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShiftsDistributionDTO.fromJson(String source) => ShiftsDistributionDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
