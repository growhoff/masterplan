import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/data/repositories/supabase/dto2/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/z_area_table.dart';
import 'package:master_plan/domain/model/z_area.dart';


part 'chief_areas_state.dart';

class ChiefAreasCubit extends Cubit<ChiefAreasState> {
  ChiefAreasCubit() : super(ChiefRegionsInitial());

  final ZAreaTable _areaTable = ZAreaTable();

  final areaStream = ZAreaTable().stream();

  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Future<void> fetchAreas() async {
    areaStream.listen((list) {
      List<ZArea> newAreasList = [];
      for (var item in list) {
        final areaDTO = AreaDTO2.fromMap(item);
        newAreasList.add(ZArea(
            id: areaDTO.id,
            name: areaDTO.name,
            number: areaDTO.number,
            machineList: [],
            machineListId: areaDTO.machineId));
      }

      emit(ChiefRegionsSuccess(regions: newAreasList));
    });
  }

  Future<void> deleteArea({required areaId}) async {
    await _areaTable.delete(areaId);
  }

  Future<void> insertArea() async {
    await _areaTable.insert(AreaDTO2(
      id: 0,
      name: nameController.text,
      number: numberController.text,
      machineId: [],
    ));
  }

  Future updateArea({required ZArea area}) async {
    final AreaDTO2 newArea = AreaDTO2(
      id: area.id,
      name: nameController.text == '' ? area.name : nameController.text,
      number: numberController.text == '' ? area.number : numberController.text,
      machineId: area.machineListId,
    );

    await _areaTable.update(area.id, newArea);
  }
}
