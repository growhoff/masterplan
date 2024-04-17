import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/local/service/excel_stage_load_service.dart';
import 'package:master_plan/data/repositories/supabase/dto2/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/z_details_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_operation_table.dart';
import 'package:master_plan/domain/model/z_detail.dart';

import 'package:master_plan/domain/model/z_operation.dart';
import 'package:master_plan/domain/model/z_stage.dart';

import '../../../../../data/repositories/supabase/dto2/detail_dto.dart';
import '../../../../../data/repositories/supabase/service/z_stage_table.dart';

part 'chief_check_state.dart';

class ChiefCheckCubit extends Cubit<ChiefCheckState> {
  ChiefCheckCubit() : super(const ChiefCheckState());

  final ZStageTable _stageTable = ZStageTable();
  final ZDetailTable _detailsTable = ZDetailTable();
  final ZOperationTable _operationTable = ZOperationTable();

  List<int> checkedStagesIdList = [];

  final _excelStageLoadService = ExcelStageLoadService();

  final _stagesStream = ZStageTable().stream();

  Future<void> fetchStages() async {

      final stages = await _stageTable.selectNotDistributed();

      List<ZStage> stagesList = [];
      for (var stage in stages) {
        final stageDto = StageDTO2.fromMap(stage);

        final List<ZOperation> operationsList = [];
        final fetchedOperations =
        await _operationTable.selectListId(stageDto.operationId);
        for (var operation in fetchedOperations) {
          final operationDto = OperationDTO2.fromMap(operation);
          operationsList.add(ZOperation(
              id: operationDto.id,
              number: operationDto.number,
              name: operationDto.name,
              code: operationDto.code,
              isready: operationDto.isready,
              transferList: [],
              transferListId: []));
        }

        final fetchedDetail =
        await _detailsTable.selectById(detailId: stageDto.detailId);
        final detailDto = DetailDto.fromMap(fetchedDetail);
        stagesList.add(ZStage(
          id: stageDto.id,
          number: stageDto.number,
          name: stageDto.name,
          operationList: operationsList,
          operationListId: stageDto.operationId,
          detailId: stageDto.detailId,
          detail: DetailModel(
              id: detailDto.id,
              code: detailDto.code,
              technologyNumber: detailDto.technologyNumber,
              planNumber: detailDto.planNumber,
              planName: detailDto.planName),
        ));
      }

      emit(state.copyWith(stagesList: stagesList));

  }

  Future<void> loadStageFromExcel()async{
    await _excelStageLoadService.stageExcelFunction();
    fetchStages();
  }

  Future<void> sendStagesToDistribution() async {
    for (var id in checkedStagesIdList) {
      await _stageTable.updateDistribution(id: id);
    }

    checkedStagesIdList.clear();
    await fetchStages();
  }
}
