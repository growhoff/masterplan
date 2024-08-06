import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/transfer_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/batch_archive_table.dart';
import 'package:master_plan/data/repositories/supabase/service/batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/transfer_table.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/stage.dart';
import 'package:master_plan/domain/model/transfer.dart';

import '../../../../../data/repositories/local/service/excel_service.dart';
import '../../../../../data/repositories/supabase/dto/batch_archive_dto.dart';
import '../../../../../domain/model/batch_archive.dart';
import '../../../../../domain/model/operation.dart';

part 'dispatcher_archive_state.dart';

class DispatcherArchiveCubit extends Cubit<DispatcherArchiveState> {
  DispatcherArchiveCubit() : super(const DispatcherArchiveState());

  final _batchArchiveTable = BatchArchiveTable();
  final _stageTable = StageTable();
  final _operationTable = OperationTable();
  final _transferTable = TransferTable();

  final _excelService = ExcelService();

  Future<void> fetchStages({required int batchArchiveId}) async {
    List<Stage> stagesList = [];

    try {
      var fetchedStagesList = await _stageTable.selectByBatchArchiveId(
          batchArchiveId: batchArchiveId);
      for (var fetchedStage in fetchedStagesList) {
        final stageDto = StageDTO.fromMap(fetchedStage);
        final stage = convertStageDtoToModel(stageDto);
        stagesList.add(stage);
      }

      emit(state.copyWith(
          stagesList: stagesList, status: DispatcherArchiveStatus.success));
    } catch (e) {
      emit(state.copyWith(status: DispatcherArchiveStatus.failure));
    }
  }

  Future<void> fetchBatches() async {
    List<BatchArchive> batchesList = [];

    var fetchedList = await _batchArchiveTable.select();

    try {
      for (var fetchedBatch in fetchedList) {
        final batchArchiveDto = BatchArchiveDto.fromMap(fetchedBatch);

        final batch = BatchArchive.fromDto(batchArchiveDto);

        batchesList.add(batch);
      }

      emit(state.copyWith(
          batchesList: batchesList, status: DispatcherArchiveStatus.success));
    } catch (e) {
      emit(state.copyWith(status: DispatcherArchiveStatus.failure));
    }
  }

  Future<void> fetchOperations({required int stageId}) async {
    List<Operation> operationsList = [];

    var fetchedOperationsList =
        await _operationTable.selectByStageId(stageId: stageId);

    for (var fetchedOperation in fetchedOperationsList) {
      final operationDto = OperationDTO.fromMap(fetchedOperation);
      final operation = convertOperationDtoToModel(operationDto);
      operationsList.add(operation);
    }
    emit(state.copyWith(
        operationsList: operationsList,
        status: DispatcherArchiveStatus.success));
  }

  Future<void> fetchTransfers({required int operationId}) async {
    var fetchedTransfersList =
        await _transferTable.selectByOperationId(operationId: operationId);

    List<Transfer> transfersList = [];
    for (var fetchedTransfer in fetchedTransfersList) {
      final transferDto = TransferDTO.fromMap(fetchedTransfer);
      final transfer = Transfer(
          id: transferDto.id,
          number: transferDto.number ?? 0,
          name: transferDto.name,
          code: transferDto.code,
          timesh: transferDto.timesh,
          operationId: transferDto.operationId);
      transfersList.add(transfer);
    }

    emit(state.copyWith(
        transfersList: transfersList, status: DispatcherArchiveStatus.success));
  }

  Future<void> loadDetailToArchive() async {
    emit(state.copyWith(status: DispatcherArchiveStatus.loading));
    try {
      print('трай');
      await _excelService.loadDetailToArchive();
      print('загрузили');
      fetchBatches();
    } catch (e) {}
  }

  Future deleteBatchArchive(int batchId)async{
    await _batchArchiveTable.delete(batchId);
    await fetchBatches();
  }

  convertStageDtoToModel(StageDTO dto) {
    return Stage(
        id: dto.id,
        number: dto.number,
        name: dto.name,
        areaId: dto.areaId,
        isdistributed: dto.isdistributed,
        batchId: dto.batchId);
  }

  convertOperationDtoToModel(OperationDTO dto) {
    return Operation(
        id: dto.id,
        number: dto.number,
        name: dto.name,
        code: dto.code,
        timepz: dto.timepz,
        stageId: dto.stageId);
  }
}
