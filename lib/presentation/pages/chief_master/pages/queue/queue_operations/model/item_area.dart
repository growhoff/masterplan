// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
// import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/domain/model/area.dart';
import 'package:master_plan/domain/model/item_machine.dart';

class ItemArea {
  final List<ItemMachine> list;
  final Area area;
  ItemArea({
    required this.list,
    required this.area,
  });
}
