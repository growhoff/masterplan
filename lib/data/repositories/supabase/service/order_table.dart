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
  Future<int> insert(Dto dto) async {
    if (dto is OrderDTO) {
      var res = await table.insert({
        'number': dto.number,
        'customer': dto.customer,
        'date_receipt': dto.dateReceipt,
        'required_completion_date': dto.requiredCompletionDate,
        'calculated_completion_date': dto.calculatedCompletionDate,
        'actual_completion_date': dto.actualCompletionDate,
        'priority': dto.priority,
        'order_status_id': 1,
        'company_id': _companyId,
      }).select('id');

      return res.first['id'];
    }
    return 0;
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

  Future<void> updateOrder(OrderDTO orderDto) async{
    print('ID : ${orderDto.id}');
   await table.update({
      'number': orderDto.number,
      'customer': orderDto.customer,
      'date_receipt': orderDto.dateReceipt,
      'required_completion_date': orderDto.requiredCompletionDate,
      'priority': orderDto.priority,
    }).eq('id', orderDto.id);
  }

  stream() {
    return table
        .stream(primaryKey: ['id'])
        .eq('company_id', _companyId)
        .order('priority', ascending: true);
  }
}
