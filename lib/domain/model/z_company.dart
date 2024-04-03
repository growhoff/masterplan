// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/z_unit.dart';

class ZCompany {
  final int id;
  final String name;
  final String code;
  final List<ZUnit> unitList;
  ZCompany({
    required this.id,
    required this.name,
    required this.code,
    required this.unitList,
  });
}
