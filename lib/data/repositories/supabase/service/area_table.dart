import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../domain/usecase/company_service.dart';

class AreaTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_area');
  final _companyId = CompanyService.instance.companyId ?? 1;

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<void> insert(Dto dto) async {
    if (dto is AreaDTO) {
      await table.insert({
        'name': dto.name,
        'number': dto.number,
        'unit_id': _companyId == 1 ? 1 : 7,
        'company_id': _companyId
      });
    }
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select('*, z_unit!inner(*)').eq('z_unit.company_id', _companyId);
  }

  Future<List<Map<String, dynamic>>> selectId(int id) {
    return table.select().eq('id', id);
  }

  Future<List<Map<String, dynamic>>> selectUnitId(int unitId) {
    return table.select().eq('unit_id', unitId);
  }

  Future<List<Map<String, dynamic>>> selectListId(List<int> areaId) {
    String filters = '';
    for (var i = 0; i < areaId.length; i++) {
      if (i == (areaId.length - 1)) {
        filters += 'id.eq.${areaId[i]}';
      } else {
        filters += 'id.eq.${areaId[i]},';
      }
    }
    return table.select().or(filters);
  }

  @override
  Future<void> update(int id, Dto dto) async {
    if (dto is AreaDTO) {
      await table.update({'name': dto.name, 'number': dto.number}).eq('id', id);
    }
  }

  Future<List<Map<String, dynamic>>> selectById({required areaId}) async {
    return await table.select().eq('id', areaId);
  }

  stream() {
    return table.stream(primaryKey: ['id']).eq('company_id', _companyId);
  }
}
