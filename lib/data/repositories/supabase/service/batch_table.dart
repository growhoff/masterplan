import 'package:master_plan/data/repositories/supabase/dto/batch_archive_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:master_plan/domain/usecase/company_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BatchTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_batch');

  final int? _companyId = CompanyService.instance.companyId;

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<int> insert(Dto dto) async {
    if (dto is BatchDTO) {
      var data = await table.insert({
        'rs_number': dto.numberRS,
        'number': dto.number,
        'name': dto.name,
        'code': dto.code,
        'technology': dto.technology,
        'isready': false,
        'order_id': dto.orderId,
        'count': dto.count,
        'company_id': _companyId,
        'batch_status_id': 5,
      }).select('id');

      return data[0]['id'];
    }
    return 0;
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select().eq('company_id', _companyId ?? 1);
  }

  Future<int> fetchBatchesInOrderQuantity(int orderId) async {
    var res =
        await table.select().eq('order_id', orderId).count(CountOption.exact);

    return res.count;
  }

  Future<List<Map<String, dynamic>>> selectId(int id) {
    return table.select().eq('id', id);
  }

  Future<List<Map<String, dynamic>>> selectByOrderId(int orderId) async {
    return table
        .select('*,z_order(*),z_batch_status(*)')
        .eq('order_id', orderId)
        .order('id', ascending: true);
  }

  @override
  Future<void> update(int id, Dto dto) async {
    if (dto is BatchDTO) {
      await table.update({
        'rs_number': dto.numberRS,
        'name': dto.name,
        'code': dto.code,
        'technology': dto.technology,
        'description': dto.description,
        'count': dto.count
      }).eq('id', id);
    }
  }

  Future<void> updateWithoutNumber(int id, Dto dto) async {
    if (dto is BatchDTO) {
      await table.update({
        'rs_number': dto.numberRS,
        'name': dto.name,
        'code': dto.code,
        'technology': dto.technology,
        'description': dto.description,
        'count': dto.count
      }).eq('id', id);
    }
  }



  Future<void> updateFromBatchArchive(int id, BatchArchiveDto dto) async {
    await table.update({
      'rs_number': dto.number,
      'name': dto.name,
      'code': dto.code,
      'technology': dto.technologyNumber,
    }).eq('id', id);
  }

  Future<void> updateStatusJob(List<int> idList) {
    return table.update({'batch_status_id': 7}).inFilter('id', idList);
  }

  Future<void> updateStatusReady(List<int> idList) {
    return table.update({'batch_status_id': 2}).inFilter('id', idList);
  }

  Future<void> updateStatusBrak(List<int> idList) {
    return table.update({'batch_status_id': 3}).inFilter('id', idList);
  }

  Future<void> updateCount(int id, int quantity) {
    return table.update({'count': quantity}).eq('id', id);
  }

  Future<void> updateStatusToIsFormedByBatchesIdsList(
      List<int> batchesIdsList) {
    return table.update({'batch_status_id': 6}).inFilter('id', batchesIdsList);
  }

  Future<void> updateStatusToFormingByBatchId(int batchId) {
    return table.update({'batch_status_id': 5}).eq('id', batchId);
  }

  Future<void> updateStatusToIsFormedByBatchId(int batchesId) {
    return table.update({'batch_status_id': 6}).eq('id', batchesId);
  }

  stream() {
    return table.stream(primaryKey: ['id']).order('id', ascending: true);
  }
}
