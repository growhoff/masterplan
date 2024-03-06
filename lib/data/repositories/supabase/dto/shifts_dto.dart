import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ShiftsDTO {
  final int id;
  final int userId;
  final DateTime timeStart;
  final DateTime timeEnd;
  ShiftsDTO({
    required this.id,
    required this.userId,
    required this.timeStart,
    required this.timeEnd,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'time_start': timeStart.millisecondsSinceEpoch,
      'time_end': timeEnd.millisecondsSinceEpoch,
    };
  }

  factory ShiftsDTO.fromMap(Map<String, dynamic> map) {
    return ShiftsDTO(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      timeStart: DateTime.fromMillisecondsSinceEpoch(map['time_start'] as int),
      timeEnd: DateTime.fromMillisecondsSinceEpoch(map['time_end'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShiftsDTO.fromJson(String source) => ShiftsDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
