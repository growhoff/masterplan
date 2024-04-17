import 'package:master_plan/data/repositories/supabase/impliments/imp_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageStorage extends SupabaseStorage {
  final _imageStorage = Supabase.instance.client.storage.from('images');

  @override
  Future<void> uploadBinary(
      {required String path,
      required bytes,
      required String? imageExtension}) async {
    await _imageStorage.uploadBinary(path, bytes,
        fileOptions: FileOptions(upsert: true, contentType: imageExtension));
  }

  @override
  Future<String?> getPublicUrl({required String path}) async {
    return _imageStorage.getPublicUrl(path);
  }

  @override
  Future<void> remove({required String path}) async {
    await _imageStorage.remove([path]);
  }
}
