// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class ShiftScheduleDTO extends Dto {
  final int id;
  final int number;
  final int timeChange;
  final int count;
  final int timeFirst;
  final String days;
  final String info;

  ShiftScheduleDTO({
    required this.id,
    required this.number,
    required this.timeChange,
    required this.count,
    required this.timeFirst,
    required this.days,
    required this.info,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'time_change': timeChange,
      'count': count,
      'time_first': timeFirst,
      'days': days,
      'info': info,
    };
  }

  factory ShiftScheduleDTO.fromMap(Map<String, dynamic> map) {
    return ShiftScheduleDTO(
      id: map['id'] as int,
      number: map['number'] as int,
      timeChange: map['time_change'] as int,
      count: map['count'] as int,
      timeFirst: map['time_first'] as int,
      days: map['days'] as String,
      info: map['info'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShiftScheduleDTO.fromJson(String source) => ShiftScheduleDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
