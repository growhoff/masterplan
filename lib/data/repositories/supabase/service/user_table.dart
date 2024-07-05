import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../domain/usecase/company_service.dart';

class UserTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_user');

  final _companyId = CompanyService.instance.companyId ?? 1;

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<int> insert(Dto dto) async {
    print(_companyId);
    if (dto is UserDTO) {
      var data = await table.insert({
        'fio': dto.fio,
        'position_id': dto.positionId,
        'area_id': dto.areaId,
        'company_id': _companyId,
        'unit_id': dto.unitId,
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

  Future<List<Map<String, dynamic>>> selectId(int id) {
    return table
        .select('*, z_position(*), z_company(*), z_unit(*), z_area(*)')
        .eq('id', id);
  }

  Future<List<Map<String, dynamic>>> selectEqOperator(
      {required int areaId, required int companyId}) {
    return table
        .select('*, z_position(*), z_company(*), z_unit(*), z_area(*)')
        .eq('area_id', areaId)
        .eq('company_id', companyId)
        .eq('position_id', 4);
  }

  Future<List<Map<String, dynamic>>> selectEqOperatorList(
      {required List<int> listAreaId, required int companyId}) {
    return table
        .select('*, z_position(*), z_company(*), z_unit(*), z_area(*)')
        .inFilter('area_id', listAreaId)
        .eq('company_id', companyId)
        .eq('position_id', 4);
  }

  @override
  Future<void> update(int id, Dto dto) async {
    if (dto is UserDTO) {
      await table.update({
        'fio': dto.fio,
        'position_id': dto.positionId,
        'area_id': dto.areaId
      }).eq('id', id);
    }
  }

  stream() {
    return table.stream(primaryKey: ['id']);
  }

  Future updatePhoto({required int userId, required String? photoUrl}) async {
    await table.update({'photo': photoUrl}).eq('id', userId);
  }
}
