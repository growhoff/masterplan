import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/dto2/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class StaffDTO2 extends Dto {
  final int id;
  final String login;
  final String password;
  final int userId;
  final UserDTO2 user;
  StaffDTO2({
    required this.id,
    required this.login,
    required this.password,
    required this.userId,
    required this.user,
  });

  String toJson() => json.encode(toMap());

  factory StaffDTO2.fromJson(String source) => StaffDTO2.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'login': login,
      'password': password,
      'user_id': userId,
      'user': user.toMap(),
    };
  }

  factory StaffDTO2.fromMap(Map<String, dynamic> map) {
    return StaffDTO2(
      id: map['id'] as int,
      login: map['login'] as String,
      password: map['password'] as String,
      userId: map['user_id'] as int,
      user: UserDTO2.fromMap(map['z_user']),
    );
  }
}
