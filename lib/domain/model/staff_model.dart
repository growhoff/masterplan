import 'package:master_plan/domain/model/z_user_model.dart';

class StaffModel {
  StaffModel(
      {required this.id,
      required this.login,
      required this.user,
      required this.userId,
      required this.password});

  final int id;
  final String login;
  final String password;
  final int userId;
  final ZUserModel user;
}
