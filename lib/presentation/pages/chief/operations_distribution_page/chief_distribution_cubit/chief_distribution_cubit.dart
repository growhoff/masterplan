import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/local/service/excel_service.dart';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_dto.dart';

import 'package:master_plan/data/repositories/supabase/service/area_table.dart';

import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/presentation/pages/chief/model/distribution_operation_model.dart';

import '../../../../../domain/model/chief_distribution_operations_model.dart';

part 'chief_distribution_state.dart';

class ChiefDistributionCubit extends Cubit<ChiefDistributionState> {
  ChiefDistributionCubit() : super(const ChiefDistributionState());

  final OperatorOperationsTable _operatorOperationsTable =
      OperatorOperationsTable();

  final AreaTable _areaTable = AreaTable();

  final ChiefDistributionOperationsTable _chiefOperationsTable = ChiefDistributionOperationsTable();

  List<bool> isElementOpenList = [];

  List<String> areasNamesList = [];

  List<DistributionOperationModel> operationsForDistributionList = [];

  Map<String, dynamic> areasMap =
      {}; // ключ - номер участка + его имя, значение - id

  final _excelStageLoadService = ExcelService();

  Future<void> fetchChiefOperations() async {
    isElementOpenList = [];
    List<ChiefDistributionOperation> chiefOperationsList = [];
    var fetchedChiefOperationsList = await _chiefOperationsTable.selectNotDistributed();

    for (var operation in fetchedChiefOperationsList) {
      final chiefOperationDto = ChiefDistributionOperationsDTO.fromMap(operation);
      chiefOperationsList.add(ChiefDistributionOperation(
          operationId: chiefOperationDto.operationId,
          stageId: chiefOperationDto.stageId,
          stage: chiefOperationDto.stage,
          operation: chiefOperationDto.operation,
          batchId: chiefOperationDto.batchId,
          batch: chiefOperationDto.batch,
          quantity: chiefOperationDto.quantity,
          id: chiefOperationDto.id));
      isElementOpenList.add(false);
    }
    emit(state.copyWith(chiefOperationsList: chiefOperationsList, status: DistributionPageStatus.success));
  }

  Future<void> fetchAreas() async {
    areasNamesList = [];
    var fetchedAreasList = await _areaTable.select();

    for (var area in fetchedAreasList) {
      AreaDTO areaDto = AreaDTO.fromMap(area);
      String key = '${areaDto.number} ${areaDto.name}';
      areasNamesList.add(key);
      areasMap[key] = areaDto.id;
    }
  }

  Future<void> loadStageFromExcel() async {
    await _excelStageLoadService.stageExcelFunction();
    fetchChiefOperations();
  }

  Future<void> sendOperationsToDistribution() async {
    for (var operation in operationsForDistributionList) {
      final quantity = operation.quantity;
      for (int i = 0; i < quantity; i++) {
        await _operatorOperationsTable.insert(OperatorOperationsDTO(
            id: 0,
            timeplan: 0,
            timefact: 0,
            statusId: operation.statusId,
            status: StatusDTO(id: 0, name: ''),
            batchId: operation.batchId,
            batch: BatchDTO.empty,
            stageId: operation.stageId,
            stage: StageDTO.empty,
            operationId: operation.operationId,
            operation: OperationDTO.empty,
            areaId: operation.areaId,
            order: i + 1,
            area: AreaDTO(id: 0, name: '', number: '', unitId: 0)));
      }
      _chiefOperationsTable.updateQuantity(
          chiefOperationId: operation.chiefOperationId,
          newQuantity: operation.oldQuantity - quantity);
    }
    emit(state.copyWith(chiefOperationsList: [], status: DistributionPageStatus.loading));
    fetchChiefOperations();
  }
}
