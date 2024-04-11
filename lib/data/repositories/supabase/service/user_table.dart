import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../dto2/user_dto.dart';

class UserTable extends SupabaseTable{

    final table = Supabase.instance.client.from('z_user');
  
  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

    @override
    Future<int> insert(Dto dto) async {
      if (dto is UserDTO2) {
        var data = await table.insert({
          'fio': dto.fio,
          'position_id': dto.positionId,
          'area_id': dto.areaId,
          'company_id': dto.companyId,
          'photo': dto.photo,
        }).select('id');
        return data[0]['id'];
      }
      return 0;
    }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select();
  }

  Future<Map<String, dynamic>> selectId(int id) async{
    var usersList = await table.select().eq('id', id);
    return usersList[0];
  }

  Future<List<Map<String, dynamic>>> selectEqOperator({required int regionId, required int companyId}) {
    return table.select().eq('region_id', regionId).eq('company_id', companyId).eq('position_id', 3);
  }

  @override
  Future<void> update(int id, Dto dto) {
   return table.update({'name': '1'}).eq('id', id);
  }

  stream(){
    return table.stream(primaryKey: ['id']);
  }

}