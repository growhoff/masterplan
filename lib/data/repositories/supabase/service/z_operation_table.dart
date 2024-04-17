import 'package:master_plan/data/repositories/supabase/dto2/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ZOperationTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_operation');

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<int> insert(Dto dto) async {
    if (dto is OperationDTO2) {
      var operation = await table.insert({
        'number': dto.number,
        'name': dto.name,
        'code': dto.code,
        'transfer_id': dto.transferId,
        'isready': false,
      }).select('id');
      return operation[0]['id'];
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
