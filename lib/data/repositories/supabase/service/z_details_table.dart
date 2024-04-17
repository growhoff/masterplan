import 'package:master_plan/data/repositories/supabase/dto2/detail_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../impliments/imp_table.dart';

class ZDetailTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_details');

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<int> insert(Dto dto) async {
    if (dto is DetailDto) {
      var detail = await table.insert({
        'code': dto.code,
        'technology_number': dto.technologyNumber,
        'plan_number': dto.planNumber,
        'plan_name': dto.planName
      }).select('id');
      return detail[0]['id'];
    }
    return 0;
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    // TODO: implement select
    throw UnimplementedError();
  }

  @override
  Future<void> update(int id, Dto dto) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> selectById({required int detailId}) async {
    final detailsList = await table.select().eq('id', detailId);
    return detailsList.first;
  }
}
