import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../dto2/staff_dto.dart';

class StaffTable extends SupabaseTable{

  // final table = Supabase.instance.client.from('f_staff');
  final table = Supabase.instance.client.from('z_staff');
  
  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<void> insert(Dto dto) async {
    if (dto is StaffDTO2) {
      await table.insert({
        'login': dto.login,
        'password': dto.password,
        'user_id': dto.userId
      });
    }
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select();
  }

  Future<List<Map<String, dynamic>>> selectName({required String login}) {
    return table.select().eq('login', login);
  }

  @override
  Future<void> update(int id, Dto dto) {
   return table.update({'name': '1'}).eq('id', id);
  }

  stream(){
    return table.stream(primaryKey: ['id']);
  }

  Future<List<Map<String, dynamic>>> selectByRegionId({required int regionId}) async{

    var data = await table
        .select('*, z_user:user_id!inner(*, z_position:position_id(*))')
        .eq('z_user.area_id', regionId);

    return data;
  }

  Future<List<Map<String, dynamic>>> selectByLogin({required String login}) async{

    var data = await table
        .select('*, z_user:user_id!inner(*, z_position:position_id(*))')
        .eq('login', login);

    return data;
  }

}