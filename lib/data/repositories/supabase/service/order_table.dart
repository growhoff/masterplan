import 'package:master_plan/data/repositories/supabase/dto/order_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_order');

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
        'date_plan_completion': dto.datePlanCompletion,
        'priority': dto.priority,
      });
    }
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select().order('priority', ascending: true);
  }

  Future changeIsFormedToTrue(int orderId) async {
    await table.update({'is_formed': true}).eq('id', orderId);
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
