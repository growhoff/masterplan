import 'package:master_plan/data/repositories/supabase/dto/shifts_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShiftsTable extends SupabaseTable{

  final table = Supabase.instance.client.from('z_shifts');

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<void> insert(Dto dto) async{
    if (dto is ShiftsDTO) await table.insert(dto.toMap()).select();
  }

  Future<int?> insertToInt(Dto dto) async{
    int? id;
    if (dto is ShiftsDTO) {
      final qveru = await table.insert(dto.toMap()).select();
      id = qveru.first['id'] as int;
    } else {id = null;}
    return id;
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select();
  }

  Future<List<Map<String, dynamic>>> selectId(int id) {
    return table.select().eq('id', id);
  }

  Future<List<Map<String, dynamic>>> selectNew(int userId, int changeId, String date) {
    return table.select().eq('user_id', userId).eq('change_id', changeId).eq('date', date);
  }

  @override
  Future<void> update(int id, Dto dto) {
    return table.update({'name': '1'}).eq('id', id);
  }

  Future<void> updateId(int id, DateTime time, bool isActive) {
    return table.update({'time_end': time.millisecondsSinceEpoch, 'isActive': isActive}).eq('id', id);
  }

}