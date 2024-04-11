import 'package:master_plan/data/repositories/supabase/dto2/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AreaTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_area');

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<void> insert(Dto dto) async {
    if (dto is AreaDTO2) {
      await table
          .insert({'name': dto.name, 'number': dto.number, 'machine_id': []});
    }
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select().order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectId(int id) {
    return table.select().eq('id', id);
  }

  Future<List<Map<String, dynamic>>> selectListId(List<int> areaId) {
    String filters = '';
    for (var i = 0; i < areaId.length; i++) {
      if (i == (areaId.length - 1)) {
        filters += 'id.eq.${areaId[i]}';
      } else {
        filters += 'id.eq.${areaId[i]},';
      }
    }
    return table.select().or(filters);
  }

  @override
  Future<void> update(int id, Dto dto) async {
    if (dto is AreaDTO2) {
      await table.update({'name': dto.name, 'number': dto.number}).eq('id', id);
    }
  }

  Future<List<Map<String, dynamic>>> selectById({required areaId}) async {
    return await table.select().eq('id', areaId);
  }

  Future<void> addMachine({int? areaId, required int machineId}) async {
    if (areaId != null) {
      var data = await table.select().eq('id', areaId);
      List<dynamic> machinesList = data[0]['machine_id'];
      machinesList.add(machineId);
      await table.update({'machine_id': machinesList}).eq('id', areaId);
    }
  }

  Future<void> removeMachine(
      {required int areaId, required int machineId}) async {
    print(areaId);
    var data = await table.select().eq('id', areaId);
    print(data[0]['machine_id']);
    List<dynamic> machinesList = data[0]['machine_id'];
    machinesList.remove(machineId);
    print(machinesList);
    await table.update({'machine_id': machinesList}).eq('id', areaId);
  }

  Future<void> changeMachineArea(
      {required int oldAreaId,
       int? newAreaId,
      required int machineId}) async {
   if (newAreaId != null){
     await removeMachine(areaId: oldAreaId, machineId: machineId);
     await addMachine(areaId: newAreaId, machineId: machineId);
   }
  }

  stream() {
    return table.stream(primaryKey: ['id']);
  }
}
