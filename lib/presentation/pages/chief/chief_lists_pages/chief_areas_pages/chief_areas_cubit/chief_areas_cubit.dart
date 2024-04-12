import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/area_table.dart';
import 'package:master_plan/domain/model/area.dart';


part 'chief_areas_state.dart';

class ChiefAreasCubit extends Cubit<ChiefAreasState> {
  ChiefAreasCubit() : super(ChiefRegionsInitial());

  final AreaTable _areaTable = AreaTable();

  final areaStream = AreaTable().stream();

  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Future<void> fetchAreas() async {
    areaStream.listen((list) {
      List<Area> newAreasList = [];
      for (var item in list) {
        final areaDTO = AreaDTO.fromMap(item);
        newAreasList.add(Area(
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
    await _areaTable.insert(AreaDTO(
      id: 0,
      name: nameController.text,
      number: numberController.text,
      machineId: [],
    ));
  }

  Future updateArea({required Area area}) async {
    final AreaDTO newArea = AreaDTO(
      id: area.id,
      name: nameController.text == '' ? area.name : nameController.text,
      number: numberController.text == '' ? area.number : numberController.text,
      machineId: area.machineListId,
    );

    await _areaTable.update(area.id, newArea);
  }
}
