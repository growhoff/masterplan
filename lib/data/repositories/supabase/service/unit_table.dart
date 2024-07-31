import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:master_plan/domain/usecase/company_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UnitTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_unit');
  final _companyId = CompanyService.instance.companyId ?? 0;

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<void> insert(Dto dto) async {
    if (dto is UnitDTO) {
      await table.insert({
        'name': dto.name,
        'number': dto.number,
        'areas_quantity': dto.areasQuantity,
        'operators_quantity': dto.operatorsQuantity,
        'staff_id': dto.staffId,
        'company_id': _companyId
      });
    }
  }

  @override
  Future<List<Map<String, dynamic>>> select() async {
    return await table
        .select('*, z_staff(*, z_position(*))')
        .eq('company_id', _companyId);
  }

  Future<List<Map<String, dynamic>>> selectId(int id) {
    return table.select().eq('id', id);
  }

  @override
  Future<void> update(int id, Dto dto) async {
    if (dto is UnitDTO) {
      return await table.update({
        'name': dto.name,
        'number': dto.number,
        'staff_id': dto.staffId,
        'areas_quantity': dto.areasQuantity,
        'operators_quantity': dto.operatorsQuantity,
      }).eq('id', id);
    }
  }
}
