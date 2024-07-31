import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:intl/intl.dart';

class ShiftsDTO extends Dto {
  final int id;
  final int userId;
  final int timeStart;
  final int timeEnd;
  final bool isActive;
  final int changeId;
  final DateTime date;
  ShiftsDTO({
    required this.id,
    required this.userId,
    required this.timeStart,
    required this.timeEnd,
    required this.isActive,
    required this.changeId,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'time_start': timeStart,
      'time_end': timeEnd,
      'isActive': isActive,
      'change_id': changeId,
      'date': DateFormat('yyyy-MM-dd').format(date),
    };
  }

  factory ShiftsDTO.fromMap(Map<String, dynamic> map) {
    return ShiftsDTO(
      id: map['id'] as int,
      userId: map['staff_id'] as int,
      timeStart: map['time_start'] as int,
      timeEnd: map['time_end'] as int,
      isActive: map['isActive'] as bool,
      changeId: map['change_id'] as int,
      date: DateTime.parse(map['date'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShiftsDTO.fromJson(String source) => ShiftsDTO.fromMap(json.decode(source) as Map<String, dynamic>);


}
