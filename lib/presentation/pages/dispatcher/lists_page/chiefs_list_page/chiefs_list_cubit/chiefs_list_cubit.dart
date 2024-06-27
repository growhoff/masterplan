import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/position_staff_table.dart';
import 'package:master_plan/data/repositories/supabase/service/staff_table.dart';
import 'package:master_plan/data/repositories/supabase/service/unit_table.dart';
import 'package:master_plan/domain/model/position_staff.dart';
import 'package:master_plan/domain/model/unit.dart';

import '../../../../../../data/repositories/supabase/dto/position_staff_dto.dart';
import '../../../../../../domain/model/staff.dart';

part 'chiefs_list_state.dart';

class ChiefsListCubit extends Cubit<ChiefsListState> {
  ChiefsListCubit() : super(const ChiefsListState());

  Unit selectedUnit = Unit.empty;

  final _unitTable = UnitTable();
  final _positionStaffTable = PositionStaffTable();

  Future fetchChiefsList() async {
    List<PositionStaffModel> chiefsList = [];

    var fetchedList =
        await _positionStaffTable.selectChiefOnUnit(selectedUnit.id);
    for (var fetchedStaff in fetchedList) {
      final staffDto = PositionStaffDTO.fromMap(fetchedStaff);
      final staff = PositionStaffModel.fromDTO(staffDto);
      chiefsList.add(staff);
    }

    emit(state.copyWith(
        status: ChiefsListStatus.success, chiefsList: chiefsList));
  }

  Future fetchUnits() async {
    List<Unit> unitsList = [];
    var fetchedList = await _unitTable.select();

    for (var fetchedUnit in fetchedList) {
      final unitDto = UnitDTO.fromMap(fetchedUnit);
      final unit = Unit(
          id: unitDto.id,
          name: unitDto.name,
          number: unitDto.number,
          companyId: unitDto.companyId);
      unitsList.add(unit);
    }

    selectedUnit = unitsList.first;

    emit(
        state.copyWith(status: ChiefsListStatus.success, unitsList: unitsList));

    fetchChiefsList();
  }
}
