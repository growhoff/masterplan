abstract class SupabaseStorage{

  Future<void> uploadBinary({ required String path, required bytes, required String imageExtension});

  Future<void> getPublicUrl({required String path});

  Future<void> remove({required String path});

}