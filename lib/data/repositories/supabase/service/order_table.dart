import 'package:master_plan/data/repositories/supabase/dto/order_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:master_plan/domain/usecase/company_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_order');

  final _companyId = CompanyService.instance.companyId ?? 1;

  @override
  Future<void> delete(int id) async {
    return await table.delete().eq('id', id);
  }

  @override
  Future<void> insert(Dto dto) async {
    if (dto is OrderDTO) {
      await table.insert({
        'number': dto.number,
        'date_receipt': dto.dateReceipt,
        'required_completion_date': dto.requiredCompletionDate,
        'calculated_completion_date': dto.calculatedCompletionDate,
        'actual_completion_date': dto.actualCompletionDate,
        'priority': dto.priority,
        'order_status_id': 1,
        'company_id': _companyId,
      });
    }
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table
        .select('*, z_order_status(*)')
        .eq('company_id', _companyId)
        .order('priority', ascending: true);
  }




  Future changeStatusToFormed(int orderId) async {
    await table.update({'order_status_id': 2}).eq('id', orderId);
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
    return table
        .stream(primaryKey: ['id'])
        .eq('company_id', _companyId)
        .order('priority', ascending: true);
  }
}
