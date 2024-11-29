// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/type_machine_dto.dart';

class ViewMachine {
  final int id;
  final int number;
  final String name;
  final List<TypeMachineDTO> listType;
  ViewMachine({
    required this.id,
    required this.number,
    required this.name,
    required this.listType,
  });
}
