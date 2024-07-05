import 'package:master_plan/data/repositories/supabase/dto/position_staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:master_plan/domain/usecase/chief_unit_service.dart';
import 'package:master_plan/domain/usecase/company_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PositionStaffTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_position_staff');
  final _companyId = CompanyService.instance.companyId ?? 1;
  final _unitId = ChiefUnitService.instance.unitId ?? 1;

  @override
  Future<void> delete(int id) async {
    await table.delete().eq('id', id);
  }

  Future<void> deleteByStaffId({required int staffId}) async {
    await table.delete().eq('staff_id', staffId);
  }

  Future<bool> checkForAnotherRoles({required int staffId}) async {
    var res = await table.select().eq('staff_id', staffId).count();

    if (res.count > 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> insert(Dto dto) async {
    if (dto is PositionStaffDTO) {
      await table.insert({
        'position_id': dto.positionId,
        'staff_id': dto.staffId,
        'area_id': dto.areaId,
        'unit_id': _unitId,
      });
    }
  }

  @override
  Future<List<Map<String, dynamic>>> select() async {
    return await table.select(
        '*,z_unit(*), z_area(*),z_position(*),z_staff(*, z_user(*, z_position(*)))');
  }

  Future<List<Map<String, dynamic>>> selectStaffByUnitsIdList(
      List<int> unitsIdList) async {
    return await table
        .select(
            '*,z_staff(*,z_user(*, z_position(*))), z_area!inner(*), z_position(*)')
        .inFilter('z_area.unit_id', unitsIdList);
  }

  Future<List<Map<String, dynamic>>> selectChiefOnUnit(int unitId) async {
    print('unitId: $unitId');
    print('company: $_companyId');
    var res = await table
        .select(
            '*, z_area(*),z_position(*),z_staff!inner(*, z_user!inner(*, z_position(*)))')
        .eq('position_id', 2)
        .eq('z_staff.z_user.company_id', _companyId)
        .eq('unit_id', unitId);


    return res;
  }

  Future<List<Map<String, dynamic>>> selectAllChiefs() async {
    return await table
        .select(
            '*, z_area(*),z_position(*),z_staff!inner(*, z_user!inner(*, z_position(*)))')
        .eq('position_id', 2)
        .eq('z_staff.z_user.company_id', _companyId);
  }

  Future<List<Map<String, dynamic>>> selectByStaffId(
      {required int staffId}) async {
    return await table
        .select(
            '*,z_unit(*), z_position(*),z_staff(*, z_user(*, z_position(*))), z_area(*)')
        .eq('staff_id', staffId)
        .order('position_id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectChiefAndMastersByStaffId(
      {required int staffId}) async {
    return await table
        .select(
            '*,z_unit(*), z_position(*),z_staff(*, z_user(*, z_position(*))), z_area(*)')
        .eq('staff_id', staffId)
        .inFilter('position_id', [2, 3]).order('position_id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectChiefByStaffId(
      {required int staffId}) async {
    return await table
        .select(
            '*,z_unit(*), z_position(*),z_staff(*, z_user(*, z_position(*))), z_area(*)')
        .eq('staff_id', staffId)
        .eq('position_id', 2);
  }

  Future<List<Map<String, dynamic>>> selectMastersOnArea(
      {required int areaId}) async {
    return await table
        .select(
            '*, z_position(*),z_staff!inner(*, z_user!inner(*, z_position(*)))')
        .eq('position_id', 3)
        .eq('z_staff.z_user.company_id', _companyId)
        .eq('area_id', areaId);
  }

  Future<List<Map<String, dynamic>>> selectOperatorsOnArea(
      {required int areaId}) async {
    return await table
        .select(
            '*, z_position(*),z_staff!inner(*, z_user!inner(*, z_position(*)))')
        .eq('position_id', 4)
        .eq('z_staff.z_user.company_id', _companyId)
        .eq('area_id', areaId);
  }

  Future<List<Map<String, dynamic>>> selectOperators() async {
    return await table.select().eq('position_id', 3);
  }

  @override
  Future<void> update(int id, Dto dto) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future updateUnit({required int id, required int unitId}) async {
    await table.update({'unit_id': unitId}).eq('id', id);
  }
}
