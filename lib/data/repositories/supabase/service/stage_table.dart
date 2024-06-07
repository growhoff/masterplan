import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../dto/stage_dto.dart';

class StageTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_stage');

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<int> insert(Dto dto) async {
    if (dto is StageDTO) {
      var stage = await table.insert({
        'number': dto.number,
        'name': dto.name,
        'area_id': 1,
        'batch_id': dto.batchId
      }).select('id');
      return stage[0]['id'];
    }
    return 0;
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select();
  }

  Future<List<Map<String, dynamic>>> selectNotDistributed() async {
    return await table
        .select('*, z_batch:batch_id(*)')
        .eq('is_distributed', false)
        .order('id', ascending: true);
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

  Future<List<Map<String, dynamic>>> selectNotDistributedListId(
      List<int> listId) {
    String filters = '';
    for (var i = 0; i < listId.length; i++) {
      if (i == (listId.length - 1)) {
        filters += 'id.eq.${listId[i]}';
      } else {
        filters += 'id.eq.${listId[i]},';
      }
    }
    return table.select().or(filters).eq('is_distributed', false);
  }

  @override
  Future<void> update(int id, Dto dto) {
    return table.update({'name': '1'}).eq('id', id);
  }

  stream() {
    return table.stream(primaryKey: ['id']);
  }

  Future<List<Map<String, dynamic>>> selectByBatchId(
      {required int batchId}) async {
    return table.select().eq('batch_id', batchId);
  }
}
