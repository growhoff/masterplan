import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

abstract class SupabaseTable{
  Future<List<Map<String, dynamic>>> select();
  Future<void> update(int id, Dto dto);
  Future<void> delete(int id);
  Future<void> insert(Dto dto);
}