import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MastersOperationsTable extends SupabaseTable{

  final table = Supabase.instance.client.from('masters_operations');
  
  @override
  Future<void> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> insert() {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select();
  }

  @override
  Future<void> update() {
    // TODO: implement update
    throw UnimplementedError();
  }

}