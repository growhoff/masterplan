// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/domain/model/company.dart';
import 'package:master_plan/domain/model/position.dart';
// import 'package:master_plan/domain/model/user.dart';

class Staff {
  final int id;
  final String? photo;
  final String login;
  final String password;
  // final int userId;
  // final User user;
  final String fio;  
  final int? companyId;
  final Company? company;
    // final int positionId;
  final Position position;

  Staff({
    required this.id,
    required this.login,
    // required this.user,
    // required this.userId,
    required this.fio,
    this.photo,
    required this.password,
    this.companyId,
    this.company,
    required this.position,
  });

  static final Staff empty = Staff(id: 0, login: '', fio: '', password: '', position: Position(id: -1, name: ''));


  factory Staff.fromDTO(StaffDTO dto) {
    return Staff(
        id: dto.id,
        login: dto.login,
        fio: dto.fio,
        photo: dto.photo,
        position: Position(id: dto.position?.id ?? 0, name: dto.position?.name ?? ''),
        // user: User.fromDTO(dto.user),
        // userId: dto.userId,
        password: dto.password);
  }
}
