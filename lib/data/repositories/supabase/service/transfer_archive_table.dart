import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../dto/transfer_archive_dto.dart';

class TransferArchiveTable extends SupabaseTable {
  final _table = Supabase.instance.client.from('z_transfer_archive');

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> insert(Dto dto) async {
    if (dto is TransferArchiveDto) {
      await _table.insert({
        'name': dto.name,
        'code': dto.code,
        'operation_archive_id': dto.operationArchiveId,
        'time_sh': dto.timeSH
      });
    }
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    // TODO: implement select
    throw UnimplementedError();
  }

  Future<List<Map<String, dynamic>>> selectByOperationArchiveId(
      int operationArchiveId) async {
    return await _table
        .select()
        .eq('operation_archive_id', operationArchiveId)
        .order('id', ascending: true);
  }

  @override
  Future<void> update(int id, Dto dto) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
