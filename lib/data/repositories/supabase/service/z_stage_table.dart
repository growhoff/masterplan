import 'package:master_plan/data/repositories/supabase/dto2/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ZStageTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_stage');

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<int> insert(Dto dto) async {
    if (dto is StageDTO2) {
      var stage = await table.insert({
        'number': dto.number,
        'operation_id': dto.operationId,
        'name': dto.name,
      }).select('id');
      return stage[0]['id'];
    }
    return 0;
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select();
  }

  Future<List<Map<String, dynamic>>> selectNotDistributed() {
    return table.select().eq('is_distributed', false);
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

  stream() {
    return table.stream(primaryKey: ['id']);
  }

  Future<void> updateDistributionByListId(
      {required List<int> stagesIdList}) async {
    for (var id in stagesIdList) {
      await table.update({'is_distributed': true}).eq('id', id);
    }
  }

  Future<void> updateDistribution({required int id}) async {
    await table.update({'is_distributed': true}).eq('id', id);
  }
}
