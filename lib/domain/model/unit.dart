// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/area.dart';

class Unit {
  final int id;
  final String name;
  final List<Area> areaList;
  final List<int> areaListId;
  Unit({
    required this.id,
    required this.name,
    required this.areaList,
    required this.areaListId,
  });
}
