import 'package:flutter/material.dart';
import 'package:master_plan/data/repositories/local/service/notification_service.dart';
import 'package:master_plan/presentation/app/app.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:supabase_init/supabase_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  // await SupabaseInit.init();
  runApp(const MyApp());
}