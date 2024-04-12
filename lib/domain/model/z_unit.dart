// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/z_area.dart';

class ZUnit {
  final int id;
  final String name;
  final List<ZArea> areaList;
  final List<int> areaListId;
  ZUnit({
    required this.id,
    required this.name,
    required this.areaList,
    required this.areaListId,
  });
}
