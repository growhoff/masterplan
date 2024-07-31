import 'package:master_plan/data/repositories/supabase/dto/position_dto.dart';

class Position {
  final int id;
  final String name;
  Position({
    required this.id,
    required this.name,
  });

  factory Position.fromDTO(PositionDTO dto) {
    return Position(id: dto.id, name: dto.name);
  }

  static final empty = Position(id: 0, name: '');
}
