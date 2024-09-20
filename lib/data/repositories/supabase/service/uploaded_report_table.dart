import 'package:master_plan/data/repositories/supabase/dto/uploaded_report_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:master_plan/domain/usecase/company_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadedReportTable extends SupabaseTable {
  final _table = Supabase.instance.client.from('z_uploaded_report');
  final _companyId = CompanyService.instance.companyId ?? 0;

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> insert(Dto dto) async {
    if (dto is UploadedReportDTO) {
      await _table.insert({
        'number': dto.number,
        'staff_id': dto.staffId,
        'report_type_id': dto.reportTypeId
      });
    }
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    // TODO: implement select
    throw UnimplementedError();
  }

  Future<int> fetchLastNumber() async {
    var res = await _table
        .select('*, z_staff!inner(*)')
        .eq('z_staff.company_id', _companyId);
    if (res.isEmpty) {
      return 0;
    } else {
      return res.last['number'];
    }
  }

  @override
  Future<void> update(int id, Dto dto) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
