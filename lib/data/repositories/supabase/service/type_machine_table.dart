import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TypeMachineTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_type_machine');

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<int> insert(Dto dto) async {
    // if (dto is MachineDTO) {
    //   var data = await table.insert({
    //     'name': dto.name,
    //     'inventory_number': dto.inventoryNumber,
    //     'area_id': dto.areaId
    //   }).select('id');
    //   return data[0]['id'];
    // }
    return 0;
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select('*');
  }


  Future<List<Map<String, dynamic>>> selectId(int id) {
    return table.select().eq('id', id);
  }


  @override
  Future update(int id, Dto dto) async {
    // if (dto is MachineDTO) {
    //   await table.update({
    //     'name': dto.name,
    //     'inventory_number': dto.inventoryNumber,
    //     'area_id': dto.areaId
    //   }).eq('id', id);
    // }
  }
}
