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
import '../../../../../data/repositories/supabase/dto/transfer_archive_dto.dart';
import '../../../../../data/repositories/supabase/service/operation_archive_table.dart';
import '../../../../../data/repositories/supabase/service/stage_archive_table.dart';
import '../../../../../data/repositories/supabase/service/transfer_archive_table.dart';
import '../../../../../domain/model/batch_archive.dart';
import '../../../../../domain/model/operation.dart';
import '../../../../../domain/model/operation_archive.dart';
import '../../../../../domain/model/stage_archive.dart';
import '../../../../../domain/model/transfer_archive.dart';

part 'archive_state.dart';

class ArchiveCubit extends Cubit<ArchiveState> {
  ArchiveCubit() : super(const ArchiveState());

  final _batchArchiveTable = BatchArchiveTable();
  final _stageArchiveTable = StageArchiveTable();
  final _operationArchiveTable = OperationArchiveTable();
  final _transferArchiveTable = TransferArchiveTable();

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
          stagesList: stagesList, status: ArchiveStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ArchiveStatus.failure));
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
          batchesList: batchesList, status: ArchiveStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ArchiveStatus.failure));
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
        operationsList: operationsList, status: ArchiveStatus.success));
  }

  Future<int> fetchTransfers({required int operationId}) async {
    //emit(state.copyWith(status: ArchiveStatus.loading));
    var fetchedTransfersList =
        await _transferArchiveTable.selectByOperationArchiveId(operationId);

    print(fetchedTransfersList);

    List<TransferArchive> transfersList = [];
    for (var fetchedTransfer in fetchedTransfersList) {
      final transferArchiveDto = TransferArchiveDto.fromMap(fetchedTransfer);
      final transfer = TransferArchive(
          id: transferArchiveDto.id,
          name: transferArchiveDto.name,
          code: transferArchiveDto.code,
          timesh: transferArchiveDto.timeSH,
          operationId: transferArchiveDto.operationArchiveId);
      transfersList.add(transfer);
    }

    print(transfersList.length);

    emit(state.copyWith(
        transfersList: transfersList, status: ArchiveStatus.success));
    return transfersList.length;
  }

  Future<void> loadDetailToArchive() async {
    emit(state.copyWith(status: ArchiveStatus.loading));
    try {
      print('трай');

      //await _excelService.loadDetailToArchive();

      await _excelService.technologistExcelLoader();

      print('загрузили');
      fetchBatches();
    } catch (e) {
      print('ошибка : $e');
    }
  }

  Future deleteBatchArchive(int batchArchiveId) async {
    await _batchArchiveTable.delete(batchArchiveId);
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
