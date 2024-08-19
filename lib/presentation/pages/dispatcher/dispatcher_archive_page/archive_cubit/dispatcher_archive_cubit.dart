import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/transfer_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/batch_archive_table.dart';
import 'package:master_plan/data/repositories/supabase/service/batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/transfer_table.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/stage.dart';
import 'package:master_plan/domain/model/transfer.dart';

import '../../../../../data/repositories/local/service/excel_service.dart';
import '../../../../../data/repositories/supabase/dto/batch_archive_dto.dart';
import '../../../../../data/repositories/supabase/dto/operation_archive_dto.dart';
import '../../../../../data/repositories/supabase/dto/stage_archive_dto.dart';
import '../../../../../data/repositories/supabase/service/operation_archive_table.dart';
import '../../../../../data/repositories/supabase/service/stage_archive_table.dart';
import '../../../../../domain/model/batch_archive.dart';
import '../../../../../domain/model/operation.dart';
import '../../../../../domain/model/operation_archive.dart';
import '../../../../../domain/model/stage_archive.dart';

part 'dispatcher_archive_state.dart';

class DispatcherArchiveCubit extends Cubit<DispatcherArchiveState> {
  DispatcherArchiveCubit() : super(const DispatcherArchiveState());

  final _batchArchiveTable = BatchArchiveTable();
  final _stageArchiveTable = StageArchiveTable();
  final _operationArchiveTable = OperationArchiveTable();
  final _transferTable = TransferTable();

  final _excelService = ExcelService();

  Future<void> fetchStages({required int batchArchiveId}) async {
    List<StageArchive> stagesList = [];

    try {
      var fetchedStagesList =
          await _stageArchiveTable.selectByBatchArchiveId(batchArchiveId);
      for (var fetchedStage in fetchedStagesList) {
        final stageArchiveDto = StageArchiveDTO.fromMap(fetchedStage);
        final stageArchive = convertStageArchiveDtoToModel(stageArchiveDto);
        stagesList.add(stageArchive);
      }

      print('stagesList : $stagesList');
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
    List<OperationArchive> operationsList = [];

    var fetchedOperationsList =
        await _operationArchiveTable.selectByStageArchiveId(stageId);

    for (var fetchedOperation in fetchedOperationsList) {
      final operationArchiveDto = OperationArchiveDto.fromMap(fetchedOperation);
      final operationArchive =
          convertOperationArchiveDtoToModel(operationArchiveDto);
      operationsList.add(operationArchive);
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
    } catch (e) {
      print('ошибка : $e');
    }
  }

  Future deleteBatchArchive(int batchId) async {
    await _batchArchiveTable.delete(batchId);
    await fetchBatches();
  }

  convertStageArchiveDtoToModel(StageArchiveDTO dto) {
    return StageArchive(
        id: dto.id,
        number: dto.number,
        name: dto.name,
        batchArchiveId: dto.batchArchiveId);
  }

  convertOperationArchiveDtoToModel(OperationArchiveDto dto) {
    return OperationArchive(
        id: dto.id,
        number: dto.number,
        name: dto.name,
        code: dto.code,
        timepz: dto.timepz,
        stageArchiveId: dto.stageArchiveId,
        timeSH: dto.timeSH);
  }
}
