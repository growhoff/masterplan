// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/otp_path_operations.dart';

class GroupOptPath {
  final List<OptPathOperations> listOptPath;
  final int count;
  final bool isChoise;
  GroupOptPath({
    required this.listOptPath,
    required this.count,
    required this.isChoise,
  });
}
