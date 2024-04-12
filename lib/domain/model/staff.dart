// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/user.dart';

class Staff {
  Staff(
      {required this.id,
      required this.login,
      required this.user,
      required this.userId,
      required this.password});

  final int id;
  final String login;
  final String password;
  final int userId;
  final User user;
}