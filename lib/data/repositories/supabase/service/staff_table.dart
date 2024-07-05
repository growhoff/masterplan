import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../domain/usecase/company_service.dart';

class StaffTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_staff');
  static const selectUser = '*, z_position(*), z_company(*), z_unit(*), z_area(*), z_company(*)';

  final _companyId = CompanyService.instance.companyId ?? 1;

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<int> insert(Dto dto) async {
    if (dto is StaffDTO) {
      var res = await table.insert({
        'login': dto.login,
        'password': dto.password,
        'user_id': dto.userId,
        'company_id': _companyId
      }).select('id');
      return res.first['id'];
    }
    return 0;
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select();
  }

  Future<Map<String, dynamic>?> selectName({required String login, required String company}) async{
    Map<String, dynamic>? res;
    final queue = await table.select('*,z_user(*, z_position(*)), z_company(*)').eq('login', login);
    for (var el in queue) {
      final comp = el['z_company']['code'] as String;
      if (comp == company) res = el;
    }
    return res;
  }

  @override
  Future<void> update(int id, Dto dto) async {
    if (dto is StaffDTO) {
      await table.update({'login': dto.login, 'password': dto.password}).eq('id', id);
    }
  }

  stream() {
    return table.stream(primaryKey: ['id']);
  }

  Future<List<Map<String, dynamic>>> selectByRegionId(
      {required int regionId}) async {
    var data = await table
        .select('*, z_user:user_id!inner(*, z_position:position_id(*), z_unit:unit_id(*))')
        .eq('z_user.area_id', regionId);
    return data;
  }
}
