import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
// import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/operatoroperations.dart';
import 'state.dart';

class CubitWork extends Cubit<StateWork> { 
  CubitWork() : super(StateWork(operatorOperations: [OperatorOperations(id: -1, order: -1, region: 'none', company: 'none', time: -1, timeStart: -1, timeWorking: -1, status: 'none', stageOperationId: -1, stageMasterOperationId: -1, equipment: 'none', details: 'none')])){
    // getOperatorOperations();
  }

  // Future<void> getOperatorOperations() async{
  //   final tableOperatorOperations = OperatorOperationsTable(); 
  //   final queryOperatorOperations = await tableOperatorOperations.select();
  //   List<OperatorOperationsDTO> listOperatorOperationsDto = [];
  //   for (var element in queryOperatorOperations) {
  //     final dto = OperatorOperationsDTO.fromMap(element);
  //     listOperatorOperationsDto.add(dto);
  //   }

  //   List<OperatorOperations> listOperatorOperations = [];
  //   for (var dto in listOperatorOperationsDto) {
  //     listOperatorOperations.add(OperatorOperations(id: dto.id, order: dto.order, region: dto.regionId.name, company: dto.companyId.shortName, time: dto.time, timeStart: dto.timeStart, timeWorking: dto.timeWorking, status: dto.statusId.name, stageOperationId: dto.stageOperationId, stageMasterOperationId: dto.stageMasterOperationId, equipment: dto.equipmentId.name, details: '${dto.detailsId.planNumber} ${dto.detailsId.planName}'));
  //   }

  //   emit(state.copyWith(operatorOperations: listOperatorOperations));
  // }

}