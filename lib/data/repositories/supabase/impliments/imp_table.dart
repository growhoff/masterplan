abstract class SupabaseTable{
  Future<List<Map<String, dynamic>>> select();
  Future<void> update();
  Future<void> delete();
  Future<void> insert();
}