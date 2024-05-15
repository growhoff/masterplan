import 'package:master_plan/data/repositories/supabase/dto/chief_batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChiefBatchTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_chief_batch');

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<int> insert(Dto dto) async{
    if (dto is ChiefBatchDTO){
      var chiefBatch = await table.insert({'batch_id': dto.batchId}).select('id');
      return chiefBatch[0]['id'];
    }
    return 0;
  }

  @override
  Future<List<Map<String, dynamic>>> select() async {
    return await table.select('*, z_batch(*)');
  }

  @override
  Future<void> update(int id, Dto dto) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
