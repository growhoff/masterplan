import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MachineTable extends SupabaseTable{

  final table = Supabase.instance.client.from('z_machine');

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<void> insert(Dto dto) {
    return table.insert(dto);
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select();
  }

  Future<List<Map<String, dynamic>>> selectId(int id) {
    return table.select().eq('id', id);
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
  Future<void> update(int id, Dto dto) {
   return table.update({'name': '1'}).eq('id', id);
  }

}