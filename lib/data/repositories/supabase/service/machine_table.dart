import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MachineTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_machine');

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<int> insert(Dto dto) async {
    if (dto is MachineDTO) {
      var data = await table.insert({
        'name': dto.name,
        'inventory_number': dto.inventoryNumber,
        'area_id': dto.areaId
      }).select('id');
      return data[0]['id'];
    }
    return 0;
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select();
  }

  Future<List<Map<String, dynamic>>> selectId(int id) {
    return table.select().eq('id', id);
  }

  Future<List<Map<String, dynamic>>> selectMachineToArea(int areaId) {
    return table.select().eq('area_id', areaId);
  }

  Future<List<Map<String, dynamic>>> selectMachineToAreaList(
      List<int> listAreaId) {
    return table.select().inFilter('area_id', listAreaId);
  }

  Future<List<Map<String, dynamic>>> selectByUnitIdList(List<int> unitIdList) async{
    return await table
        .select('*, z_area!inner(*)')
        .inFilter('z_area.unit_id', unitIdList);
  }

  Future<List<Map<String, dynamic>>> selectListId(List<int> listId) {
    String filters = '';
    for (var i = 0; i < listId.length; i++) {
      if (i == (listId.length - 1)) {
        filters += 'id.eq.${listId[i]}';
      } else {
        filters += 'id.eq.${listId[i]},';
      }
    }
    return table.select().or(filters);
  }

  @override
  Future update(int id, Dto dto) async {
    if (dto is MachineDTO) {
      await table.update({
        'name': dto.name,
        'inventory_number': dto.inventoryNumber,
        'area_id': dto.areaId
      }).eq('id', id);
    }
  }

  stream() {
    return table.stream(primaryKey: ['id']);
  }

  Future<int> fetchMachinesQuantityOnArea({required int areaId}) async {
    var res =
        await table.select('id').eq('area_id', areaId).count(CountOption.exact);
    return res.count;
  }
}
