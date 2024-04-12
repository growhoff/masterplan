// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/unit.dart';

class Company {
  final int id;
  final String name;
  final String code;
  final List<Unit> unitList;
  Company({
    required this.id,
    required this.name,
    required this.code,
    required this.unitList,
  });
}
