import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class StageStatus extends Dto {
  StageStatus({required this.id, required this.name});

  final int id;
  final String name;

  factory StageStatus.fromMap(Map<String, dynamic> map) {
    return StageStatus(
      id: map['id'],
      name: map['name'],
    );
  }
}
