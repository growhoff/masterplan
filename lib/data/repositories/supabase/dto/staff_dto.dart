import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class StaffDTO extends Dto {
  final int id;
  final String login;
  final String password;
  final int userId;
  final UserDTO user;
  StaffDTO({
    required this.id,
    required this.login,
    required this.password,
    required this.userId,
    required this.user,
  });

  String toJson() => json.encode(toMap());

  factory StaffDTO.fromJson(String source) => StaffDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'login': login,
      'password': password,
      'user_id': userId,
      'user': user.toMap(),
    };
  }

  factory StaffDTO.fromMap(Map<String, dynamic> map) {
    return StaffDTO(
      id: map['id'] as int,
      login: map['login'] as String,
      password: map['password'] as String,
      userId: map['user_id'] as int,
      user: UserDTO.fromMap(map['z_user'] as Map<String,dynamic>),
    );
  }
}
