import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChiefOperationTabel extends SupabaseTable {
  final table = Supabase.instance.client.from('z_chief_operation');

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> insert(Dto dto) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> select() async {
    return await table
        .select('*, z_chief_batch(*, z_batch(*)), z_stage(*), z_operation(*)');
  }

  @override
  Future<void> update(int id, Dto dto) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
