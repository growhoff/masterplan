import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/staff_table.dart';
import 'package:master_plan/data/repositories/supabase/service/user_table.dart';
import 'package:master_plan/domain/usecase/chief_unit_service.dart';
import 'package:master_plan/domain/usecase/company_service.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';

import '../../../../../../data/repositories/supabase/dto/area_dto.dart';
import '../../../../../../data/repositories/supabase/service/area_table.dart';
import '../../../../../../domain/model/area.dart';

part 'chief_areas_state.dart';

class ChiefAreasCubit extends Cubit<ChiefAreasState> {
  ChiefAreasCubit() : super(ChiefRegionsInitial());

  final AreaTable _areaTable = AreaTable();
  final MachineTable _machineTable = MachineTable();

  final areaStream = AreaTable().streamForChief();

  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Future<void> fetchAreas() async {
    print(ChiefUnitService.instance.unitId);
    areaStream.listen((list) async {
      List<Area> newAreasList = [];
      for (var item in list) {
        final areaDTO = AreaDTO.fromMap(item);

        final int machinesQuantity =
            await _machineTable.fetchMachinesQuantityOnArea(areaId: areaDTO.id);
        newAreasList.add(Area(
            id: areaDTO.id,
            name: areaDTO.name,
            number: areaDTO.number,
            unitId: areaDTO.unitId,
            machinesQuantity: machinesQuantity));
      }

      emit(ChiefRegionsSuccess(areas: newAreasList));
    });
  }

  Future<void> deleteArea({required areaId}) async {
    await _areaTable.delete(areaId);
  }

  Future<void> insertArea() async {
    await _areaTable.insert(AreaDTO(
      id: 0,
      name: nameController.text,
      number: numberController.text,
      unitId: 0,
    ));

    numberController.clear();
    nameController.clear();
  }

  Future updateArea({required Area area}) async {
    final AreaDTO newArea = AreaDTO(
      id: area.id,
      name: nameController.text == '' ? area.name : nameController.text,
      number: numberController.text == '' ? area.number : numberController.text,
      unitId: 0,
    );

    await _areaTable.update(area.id, newArea);
  }

  Future fio() async {
    final staffTable = StaffTable();
    final userTable = UserTable();

    var fetchedStaffList = await staffTable.select();

    for (var staff in fetchedStaffList) {
      final staffDto = StaffDTO.fromMap(staff);

      final fetchedUser = await userTable.selectId(staffDto.userId);

      final userDto = UserDTO.fromMap(fetchedUser.first);

      await staffTable.updateFio(staffDto.id, userDto.fio);
      print(staffDto.id);
    }
  }
}
