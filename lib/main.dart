import 'package:flutter/material.dart';
import 'package:master_plan/data/repositories/local/service/notification_service.dart';
import 'package:master_plan/presentation/app/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:supabase_init/supabase_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await Supabase.initialize(
    url: 'https://wulwtluxjysnydxrcxwd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind1bHd0bHV4anlzbnlkeHJjeHdkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE2OTE0NzQsImV4cCI6MjAxNzI2NzQ3NH0.WNU1BSGMaHD4bgixS9CWDjEGbmSVch9CW7ULknOGa6g',
  );
  runApp(const MyApp());
}