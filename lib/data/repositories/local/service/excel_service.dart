import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:master_plan/data/repositories/local/service/excel_cell_styles.dart';
import 'package:master_plan/data/repositories/local/service/reports_headers_lists.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_archive_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/order_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/transfer_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operation_archive_table.dart';
import 'package:master_plan/data/repositories/supabase/service/order_table.dart';
import 'package:master_plan/data/repositories/supabase/service/stage_archive_table.dart';
import 'package:master_plan/data/repositories/supabase/service/transfer_table.dart';
import 'package:master_plan/domain/usecase/chief_unit_service.dart';
import 'package:master_plan/domain/usecase/staff_service.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';
import 'package:master_plan/presentation/pages/master/pages/analytics_page/analytics_operation_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../domain/model/distribution_stage.dart';
import '../../../../domain/model/report_items_models/monitoring_statuses_model.dart';
import '../../../../presentation/pages/chief/chief_analytics_page/chief_stage_report_model.dart';
import '../../../../presentation/pages/chief/chief_analytics_page/statistics_stage_model.dart';
import '../../supabase/dto/batch_dto.dart';
import '../../supabase/dto/chief_operation_dto.dart';
import '../../supabase/dto/operation_archive_dto.dart';
import '../../supabase/dto/operation_dto.dart';
import '../../supabase/dto/stage_archive_dto.dart';
import '../../supabase/dto/stage_dto.dart';
import '../../supabase/dto/transfer_archive_dto.dart';
import '../../supabase/dto/uploaded_report_dto.dart';
import '../../supabase/service/batch_archive_table.dart';
import '../../supabase/service/batch_table.dart';
import '../../supabase/service/operation_table.dart';
import '../../supabase/service/stage_table.dart';
import '../../supabase/service/transfer_archive_table.dart';
import '../../supabase/service/uploaded_report_table.dart';
import '../dto/filters_info_model.dart';

class ExcelService {
  final staff = StaffService.instance.staff;

  final _batchTable = BatchTable();
  final _batchArchiveTable = BatchArchiveTable();
  final _stageTable = StageTable();
  final _distributionStageTable = DistributionStageTable();
  final _operationTable = OperationTable();
  final _chiefDistributionOperationsTable = ChiefDistributionOperationsTable();
  final _chiefBatchTable = ChiefBatchTable();
  final _chiefOperationTable = ChiefOperationTable();
  final _transferTable = TransferTable();
  final _transferArchiveTable = TransferArchiveTable();
  final _orderTable = OrderTable();
  final _stageArchiveTable = StageArchiveTable();
  final _operationArchiveTable = OperationArchiveTable();
  final _unitId = ChiefUnitService.instance.unitId ?? 1;
  final _timeConverter = TimeConverter.instance;

  List<ChiefOperationDto> chiefOperationsList = [];
  List<int> stagesIdForDistributionStagesList = [];
  final _uploadedReportTable = UploadedReportTable();
  List<int> chiefDistributionsOperationsIdList = [];
  List<int> batchesIdsList = [];
  List<BatchDTO> batchesDtosList = [];
  int serviceBatchId = 0;
  int serviceQuantity = 0;

  final _cellHeaderStyle = ExcelCellStyles.headerCellStyle;

  final _cellBoldTextStyle = ExcelCellStyles.boldTextCellStyle;

  final _cellTextStyle = ExcelCellStyles.cellStyle;

  final _cellDefectTextStyle = ExcelCellStyles.defectCellStyle;

  final _cellModificationTextStyle = ExcelCellStyles.modificationCellStyle;

  final _cellFocusTextStyle = ExcelCellStyles.focusCellStyle;

  final _horizontalBorderBoldCellStyle =
      ExcelCellStyles.horizontalBorderBoldCellStyle;

  final _rightBorderBoldCellStyle = ExcelCellStyles.rightBorderBoldCellStyle;

  final _stageHeadersList = ReporstHeadersLists.stagesHeaderList;

  final _operationsHeaderList = ReporstHeadersLists.operationsHeaderList;

  final _readyOperationsHeaderList =
      ReporstHeadersLists.readyOperationsHeaderList;

  final _totalNumberReadyOperationsReportHeadersList =
      ReporstHeadersLists.totalNumberReadyOperationsReportHeadersList;

  final _filtersInfoHeadersList = ReporstHeadersLists.filtersInfoHeadersList;

  final _readyAndDefectDetailsInStagesReportHeadersList =
      ReporstHeadersLists.readyAndDefectDetailsInStagesReportHeadersList;

  final _monitoringStatusesReportHeadersList =
      ReporstHeadersLists.monitoringStatusesReportHeadersList;

  Future dispatcherLoadOrder() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    var path = pickedFile?.paths.first;

    if (pickedFile != null) {
      var bytes = File(path!).readAsBytesSync();

      var excel = Excel.decodeBytes(bytes);

      var table = excel.tables.keys.first;
      String customer = excel.tables[table]!.rows[3][0]!.value.toString();
      String orderNumber = excel.tables[table]!.rows[3][1]!.value.toString();

      int orderId = await _orderTable.insert(OrderDTO(
          id: 0,
          number: orderNumber,
          priority: 4,
          statusId: 1,
          customer: customer));

      print('insert order: $orderNumber и возвращаем orderId : $orderId');

      String batchNumber = excel.tables[table]!.rows[3][2]!.value.toString();
      int quantity =
          int.parse(excel.tables[table]!.rows[3][3]!.value.toString());

      String planNumber = excel.tables[table]!.rows[3][4]!.value.toString();
      String batchName = excel.tables[table]!.rows[3][5]!.value.toString();
      String batchCode = excel.tables[table]!.rows[3][6]!.value.toString();
      String technologyNumber =
          excel.tables[table]!.rows[3][7]!.value.toString();
      String description = excel.tables[table]!.rows[3][8]!.value.toString();

      int batchId = await _batchTable.insert(BatchDTO(
        id: 0,
        orderId: orderId,
        numberRS: planNumber,
        number: batchNumber,
        description: description,
        name: batchName,
        count: quantity,
        code: batchCode,
        technology: technologyNumber,
      ));

      BatchDTO insertedBatchDto = BatchDTO(
        id: batchId,
        orderId: orderId,
        numberRS: planNumber,
        number: batchNumber,
        description: description,
        name: batchName,
        count: quantity,
        code: batchCode,
        technology: technologyNumber,
      );

      batchesDtosList.add(insertedBatchDto);

      print(
          'insert batch: $batchNumber $batchName и возвращаем batchId : $batchId');

      String? stageNumber = excel.tables[table]!.rows[3][9]!.value.toString();
      String? stageName = excel.tables[table]!.rows[3][10]!.value.toString();

      int stageId = await _stageTable.insert(StageDTO(
          id: 0, number: stageNumber, name: stageName, batchId: batchId));

      print(
          'insert stage: $stageNumber $stageName и возвращает stageId : $stageId');

      String? operationCode =
          excel.tables[table]!.rows[3][11]!.value.toString();
      String? operationNumber =
          excel.tables[table]!.rows[3][12]!.value.toString();
      String? operationName =
          excel.tables[table]!.rows[3][13]!.value.toString();
      int timePZ = (int.parse(
          (excel.tables[table]!.rows[3][16]!.value ?? 0).toString()));
      int transferTimeSH =
          int.parse((excel.tables[table]!.rows[3][17]!.value ?? 0).toString());

      int operationTimeSH = transferTimeSH;

      int operationId = await _operationTable.insert(OperationDTO(
          id: 0,
          number: operationNumber,
          name: operationName,
          code: operationCode,
          timepz: timePZ,
          stageId: stageId,
          timeSH: operationTimeSH));

      print(
          'insert operation  $operationNumber $operationName и вернули operationId : $operationId');

      String transferCode = excel.tables[table]!.rows[3][14]!.value.toString();
      String? transferName = excel.tables[table]!.rows[3][15]!.value.toString();

      if (excel.tables[table]!.rows[3][14]?.value != null) {
        await _transferTable.insert(TransferDTO(
            id: 0,
            name: transferName,
            code: transferCode,
            timesh: transferTimeSH,
            operationId: operationId));
        print('insert transfer $transferCode $transferName');
      }

      for (int i = 4; i < excel.tables[table]!.maxRows; i++) {
        var row = excel.tables[table]!.rows;

        if (row[i][1]?.value != null) {
          customer = excel.tables[table]!.rows[i][0]!.value.toString();
          orderNumber = excel.tables[table]!.rows[i][1]!.value.toString();
          orderId = await _orderTable.insert(OrderDTO(
              id: 0,
              number: orderNumber,
              priority: 4,
              statusId: 1,
              customer: customer));

          print('insert order: $orderNumber и возвращаем orderId : $orderId');
        }

        if (row[i][2]?.value != null) {
          print('row[$i][2] != null');
          batchNumber = row[i][2]!.value.toString();
          quantity = int.parse(row[i][3]!.value.toString());
          planNumber = row[i][4]!.value.toString();
          batchName = row[i][5]!.value.toString();
          batchCode = row[i][6]!.value.toString();
          technologyNumber = row[i][7]!.value.toString();
          description = row[i][8]!.value.toString();

          batchId = await _batchTable.insert(BatchDTO(
            id: 0,
            orderId: orderId,
            numberRS: planNumber,
            number: batchNumber,
            description: description,
            name: batchName,
            count: quantity,
            code: batchCode,
            technology: technologyNumber,
          ));

          BatchDTO insertedBatchDto = BatchDTO(
            id: batchId,
            orderId: orderId,
            numberRS: planNumber,
            number: batchNumber,
            description: description,
            name: batchName,
            count: quantity,
            code: batchCode,
            technology: technologyNumber,
          );

          batchesDtosList.add(insertedBatchDto);
        }

        if (row[i][9]?.value != null) {
          stageNumber = row[i][9]?.value.toString();
          stageName = row[i][10]?.value.toString();
          stageId = await _stageTable.insert(StageDTO(
            id: 0,
            number: stageNumber ?? '',
            name: stageName ?? '',
            areaId: 0,
            batchId: batchId,
          ));

          stagesIdForDistributionStagesList.add(stageId);
          print('инсерт этап $stageNumber, $stageName, $stageId');
        }

        if (row[i][11]?.value != null) {
          operationCode = row[i][11]?.value.toString();
          operationNumber = row[i][12]?.value.toString();
          operationName = row[i][13]?.value.toString();
          if (row[i][16]?.value != null) {
            timePZ = (int.parse(row[i][16]!.value.toString()));
          }
          operationTimeSH = int.parse(row[i][17]!.value.toString());
          print(
              'добавляю операцию: $operationCode, $operationNumber, $operationName, operationTimeSH: $operationTimeSH');
          operationId = await _operationTable.insert(OperationDTO(
            id: 0,
            number: operationNumber ?? '',
            name: operationName ?? '',
            code: operationCode ?? '',
            timepz: timePZ,
            timeSH: operationTimeSH,
            stageId: stageId,
          ));
        }

        if (row[i][14]?.value != null) {
          transferCode = row[i][14]!.value.toString();
          transferName = row[i][15]?.value.toString();
          transferTimeSH = int.parse(row[i][17]!.value.toString());
          operationTimeSH = operationTimeSH + transferTimeSH;
          print('operationTimeSH : $operationTimeSH');
          _transferTable.insert(TransferDTO(
              id: 0,
              number: 0,
              name: transferName ?? '',
              code: transferCode,
              timesh: transferTimeSH,
              operationId: operationId));
          print(
              'сейчас буду обновлять  operationId: $operationId,  operationTimeSH : $operationTimeSH');
          _operationTable.updateTimeSH(operationId, operationTimeSH);
          print('инсерт переход для операции $operationId : $transferName');
        }
      }
    }
    finishDispatcherOrderLoading();
  }

  Future finishDispatcherOrderLoading() async {
    print('start finish dispatcher loading');
    List<ChiefBatchDTO> chiefBatchesDtosList = [];
    print('batchesDtosList : $batchesDtosList');
    for (var batchDto in batchesDtosList) {
      for (int i = 0; i < batchDto.count; i++) {
        chiefBatchesDtosList
            .add(ChiefBatchDTO(id: 0, batchId: batchDto.id, batch: batchDto));
      }
    }

    chiefBatchesDtosList
        .forEach((chiefBatch) => print('${chiefBatch.batchId}'));

    await _chiefBatchTable.bulkInsertFromList(dtosList: chiefBatchesDtosList);
  }

  Future<int> stageExcelFunction() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    var path = pickedFile?.paths.first;

    if (pickedFile != null) {
      var bytes = File(path!).readAsBytesSync();

      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        int quantity =
            int.parse(excel.tables[table]!.rows[1][13]!.value.toString());
        print('quantity: $quantity');
        serviceQuantity = quantity;

        String code = excel.tables[table]!.rows[1][0]!.value
            .toString(); // присваивается значение первой ячейки столбца номер чертежа

        String technologyNumber =
            excel.tables[table]!.rows[1][1]!.value.toString();

        String planNumberRS = excel.tables[table]!.rows[1][2]!.value.toString();

        int batchNumber = 1;

        String planName = excel.tables[table]!.rows[1][3]!.value.toString();

        print('вставляю бетч архив');
        int batchArchiveId = await _batchArchiveTable.insert(BatchArchiveDto(
            code: code,
            id: 0,
            number: planNumberRS,
            name: planName,
            technologyNumber: technologyNumber,
            companyId: 0));

        print(batchArchiveId);

        int batchId = await _batchTable.insert(BatchDTO(
          id: 0,
          numberRS: planNumberRS,
          number: batchNumber.toString(),
          name: planName,
          count: quantity,
          code: code,
          technology: technologyNumber,
          orderId: null,
        ));

        serviceBatchId = batchId;

        String? stageNumber =
            excel.tables[table]!.rows[1][14]?.value.toString();
        String? stageName = excel.tables[table]!.rows[1][5]?.value.toString();

        int stageId = await _stageTable.insert(StageDTO(
          id: 0,
          number: stageNumber ?? '',
          name: stageName ?? '',
          areaId: 0,
          batchId: batchId,
        ));

        print('инсерт stage: $stageNumber,  $stageName, $stageId');

        stagesIdForDistributionStagesList.add(stageId);

        String? operationCode =
            excel.tables[table]!.rows[1][6]?.value.toString();
        String? operationNumber =
            excel.tables[table]!.rows[1][7]?.value.toString();
        String? operationName =
            excel.tables[table]!.rows[1][8]?.value.toString();
        int timepz = (int.parse(
            (excel.tables[table]!.rows[1][11]!.value ?? 0).toString()));
        int transferTimeSH = int.parse(
            (excel.tables[table]!.rows[1][12]!.value ?? 0).toString());

        int operationTimeSH = transferTimeSH;

        int operationId = await _operationTable.insert(OperationDTO(
          id: 0,
          number: operationNumber ?? '',
          name: operationName ?? '',
          code: operationCode ?? '',
          timepz: timepz,
          timeSH: operationTimeSH,
          stageId: stageId,
        ));

        print(
            'инсерт операцию: $operationCode, $operationNumber, $operationName, transferTimeSH: ${operationTimeSH}');

        int distributionOperationId = await _chiefDistributionOperationsTable
            .insert(ChiefDistributionOperationsDTO(
                id: 0,
                operationId: operationId,
                stageId: stageId,
                stage: StageDTO.empty,
                operation: OperationDTO.empty,
                batchId: batchId,
                unitId: _unitId,
                batch: BatchDTO.empty,
                quantity: 0));
        chiefDistributionsOperationsIdList.add(distributionOperationId);

        chiefOperationsList.add(ChiefOperationDto(
            id: 0,
            operation: OperationDTO.empty,
            stage: StageDTO.empty,
            operationId: operationId,
            stageId: stageId,
            chiefBatch: ChiefBatchDTO(id: 0, batchId: 0, batch: BatchDTO.empty),
            chiefBatchId: 0));

        String? transferCode;
        String? transferName;
        if (excel.tables[table]!.rows[1][9]?.value != null) {
          transferCode = excel.tables[table]!.rows[1][9]!.value.toString();
          transferName = excel.tables[table]!.rows[1][10]?.value.toString();
          _transferTable.insert(TransferDTO(
              id: 0,
              number: 0,
              name: transferName ?? '',
              code: transferCode,
              timesh: 0,
              operationId: operationId));
          print('инсерт переход для операции $operationId : $transferName');
        }

        for (int i = 2; i < excel.tables[table]!.maxRows; i++) {
          var row = excel.tables[table]!.rows;

          if (row[i][4]?.value != null) {
            stageNumber = row[i][14]?.value.toString();
            stageName = row[i][5]?.value.toString();
            stageId = await _stageTable.insert(StageDTO(
              id: 0,
              number: stageNumber ?? '',
              name: stageName ?? '',
              areaId: 0,
              batchId: batchId,
            ));

            stagesIdForDistributionStagesList.add(stageId);
            print('инсерт этап $stageNumber, $stageName, $stageId');
          }

          if (row[i][6]?.value != null) {
            operationCode = row[i][6]?.value.toString();
            operationNumber = row[i][7]?.value.toString();
            operationName = row[i][8]?.value.toString();
            if (row[i][11]?.value != null) {
              timepz = (int.parse(row[i][11]!.value.toString()));
            }
            operationTimeSH = int.parse(row[i][12]!.value.toString());
            print(
                'добавляю операцию: $operationCode, $operationNumber, $operationName, operationTimeSH: $operationTimeSH');
            operationId = await _operationTable.insert(OperationDTO(
              id: 0,
              number: operationNumber ?? '',
              name: operationName ?? '',
              code: operationCode ?? '',
              timepz: timepz,
              timeSH: operationTimeSH,
              stageId: stageId,
            ));
            distributionOperationId = await _chiefDistributionOperationsTable
                .insert(ChiefDistributionOperationsDTO(
                    operationId: operationId,
                    stageId: stageId,
                    stage: StageDTO.empty,
                    operation: OperationDTO.empty,
                    batchId: batchId,
                    unitId: _unitId,
                    batch: BatchDTO.empty,
                    quantity: 0,
                    id: 0));

            chiefDistributionsOperationsIdList.add(distributionOperationId);

            chiefOperationsList.add(ChiefOperationDto(
                id: 0,
                operation: OperationDTO.empty,
                stage: StageDTO.empty,
                operationId: operationId,
                stageId: stageId,
                chiefBatch:
                    ChiefBatchDTO(id: 0, batchId: 0, batch: BatchDTO.empty),
                chiefBatchId: 0));
          }

          if (row[i][9]?.value != null) {
            transferCode = row[i][9]!.value.toString();
            transferName = row[i][10]?.value.toString();
            transferTimeSH = int.parse(row[i][12]!.value.toString());
            operationTimeSH = operationTimeSH + transferTimeSH;
            print('operationTimeSH : $operationTimeSH');
            _transferTable.insert(TransferDTO(
                id: 0,
                number: 0,
                name: transferName ?? '',
                code: transferCode,
                timesh: transferTimeSH,
                operationId: operationId));
            print(
                'сейчас буду обновлять  operationId: $operationId,  operationTimeSH : $operationTimeSH');
            _operationTable.updateTimeSH(operationId, operationTimeSH);
            print('инсерт переход для операции $operationId : $transferName');
          }
        }
      }
    }
    finishLoading();
    return 1;
  }

  Future<void> finishLoading() async {
    print('начали финищ лоадинг');
    List<ChiefBatchDTO> chiefBatchDtosList = [];
    List<ChiefOperationDto> chiefOperationDtosList = [];
    List<DistributionStage> distributionStagesList = [];
    List<int> chiefBatchIdsList = [];
    for (int i = 0; i < serviceQuantity; i++) {
      print('$i');

      chiefBatchDtosList.add(
          ChiefBatchDTO(id: 0, batchId: serviceBatchId, batch: BatchDTO.empty));
    }

    chiefBatchIdsList =
        await _chiefBatchTable.bulkInsertFromList(dtosList: chiefBatchDtosList);

    for (int chiefBatchId in chiefBatchIdsList) {
      for (var stageId in stagesIdForDistributionStagesList) {
        distributionStagesList.add(DistributionStage(
            id: 0, chiefBatchId: chiefBatchId, stageId: stageId, statusId: 1));
      }
    }

    var fetchedDistributionStagesList = await _distributionStageTable
        .chiefBulkInsert(distributionStagesList: distributionStagesList);

    for (var stage in fetchedDistributionStagesList) {
      for (var operation in chiefOperationsList) {
        if (operation.stageId == stage['stage_id']) {
          chiefOperationDtosList.add(ChiefOperationDto(
              id: 0,
              operation: OperationDTO.empty,
              stage: StageDTO.empty,
              operationId: operation.operationId,
              stageId: operation.stageId,
              distributionStageId: stage['id'],
              chiefBatch:
                  ChiefBatchDTO(id: 0, batchId: 0, batch: BatchDTO.empty),
              chiefBatchId: stage['chief_batch_id']));
        }
      }
    }

    print('финиш лоадинг булк инсерт начал');
    await _chiefOperationTable.bulkInsert(dtosList: chiefOperationDtosList);

    for (var element in chiefDistributionsOperationsIdList) {
      _chiefDistributionOperationsTable.updateQuantity(
          chiefOperationId: element, newQuantity: serviceQuantity);
    }

    serviceBatchId = 0;
    chiefOperationsList = [];
    serviceQuantity = 0;
    chiefDistributionsOperationsIdList = [];
    print('финиш лоадинг закончил');
  }

  Future technologistExcelLoader() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    var path = pickedFile?.paths.first;

    if (pickedFile != null) {
      var bytes = File(path!).readAsBytesSync();

      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        String planNumber = excel.tables[table]!.rows[3][4]!.value.toString();
        String planName = excel.tables[table]!.rows[3][5]!.value.toString();
        String batchCode = excel.tables[table]!.rows[3][6]!.value.toString();
        String technologyNumber =
            excel.tables[table]!.rows[3][7]!.value.toString();
        String description = excel.tables[table]!.rows[3][8]!.value.toString();



        int batchArchiveId = await _batchArchiveTable.insert(BatchArchiveDto(
          code: batchCode,
          id: 0,
          number: planNumber,
          name: planName,
          technologyNumber: technologyNumber,
          companyId: 0,
        ));

        String stageNumber = excel.tables[table]!.rows[3][9]!.value.toString();
        String stageName = excel.tables[table]!.rows[3][10]!.value.toString();

        int stageArchiveId = await _stageArchiveTable.insert(StageArchiveDTO(
          id: 0,
          number: stageNumber.toString(),
          name: stageName,
          batchArchiveId: batchArchiveId,
        ));

        String operationCode =
            excel.tables[table]!.rows[3][11]!.value.toString();
        String operationNumber =
            excel.tables[table]!.rows[3][12]!.value.toString();
        String operationName =
            excel.tables[table]!.rows[3][13]!.value.toString();

        int timepz = (int.parse(
            (excel.tables[table]!.rows[3][16]!.value ?? 0).toString()));
        int transferTimeSH = int.parse(
            (excel.tables[table]!.rows[3][17]!.value ?? 0).toString());

        int operationTimeSH = transferTimeSH;

        int operationArchiveId =
            await _operationArchiveTable.insert(OperationArchiveDto(
          id: 0,
          number: operationNumber,
          name: operationName,
          code: operationCode,
          timepz: timepz,
          timeSH: operationTimeSH,
          stageArchiveId: stageArchiveId,
        ));

        String? transferCode;
        String? transferName;

        if (excel.tables[table]!.rows[3][14]?.value != null) {
          transferCode = excel.tables[table]!.rows[3][14]!.value.toString();
          print('transferCode : ${transferCode}');
          transferName = excel.tables[table]!.rows[3][15]!.value.toString();
          await _transferArchiveTable.insert(TransferArchiveDto(
              id: 0,
              name: transferName,
              code: transferCode,
              timeSH: transferTimeSH,
              operationArchiveId: operationArchiveId));
          print(
              'инсерт переход для операции $operationArchiveId : $transferName');
        }

        for (int i = 4; i < excel.tables[table]!.maxRows; i++) {
          var row = excel.tables[table]!.rows;

          if (row[i][4]?.value != null) {
            planNumber = row[i][4]!.value.toString();

            planName = row[i][5]!.value.toString();

            batchCode = row[i][6]!.value.toString();

            technologyNumber = row[i][7]!.value.toString();

            description = row[i][8]!.value.toString();

            batchArchiveId = await _batchArchiveTable.insert(BatchArchiveDto(
              code: batchCode,
              id: 0,
              number: planNumber,
              name: planName,
              technologyNumber: technologyNumber,
              companyId: 0,
            ));
          }

          if (row[i][9]?.value != null) {
            stageNumber = row[i][9]!.value.toString();
            stageName = row[i][10]!.value.toString();

            stageArchiveId = await _stageArchiveTable.insert(StageArchiveDTO(
              id: 0,
              number: stageNumber.toString(),
              name: stageName,
              batchArchiveId: batchArchiveId,
            ));
          }

          if (row[i][11]?.value != null) {
            operationCode = excel.tables[table]!.rows[i][11]!.value.toString();
            operationNumber =
                excel.tables[table]!.rows[i][12]!.value.toString();
            operationName = excel.tables[table]!.rows[i][13]!.value.toString();

            if (row[i][16]?.value != null) {
              timepz = (int.parse(
                  (excel.tables[table]!.rows[i][16]!.value).toString()));
              print('[$i][16] : ${excel.tables[table]!.rows[i][16]!.value}');
            }
            operationTimeSH = int.parse(row[i][17]!.value.toString());
            print('[$i][17] : ${excel.tables[table]!.rows[i][17]!.value}');
            print(
                'operation code: $operationCode,  operationNumber: $operationNumber, operationName: $operationName');

            operationArchiveId =
                await _operationArchiveTable.insert(OperationArchiveDto(
              id: 0,
              number: operationNumber,
              name: operationName,
              code: operationCode,
              timepz: timepz,
              timeSH: operationTimeSH,
              stageArchiveId: stageArchiveId,
            ));
          }

          if (row[i][14]?.value != null) {
            transferCode = row[i][14]!.value.toString();
            transferName = row[i][15]!.value.toString();
            transferTimeSH = int.parse(row[i][17]!.value.toString());
            operationTimeSH = operationTimeSH + transferTimeSH;

            await _transferArchiveTable.insert(TransferArchiveDto(
                id: 0,
                name: transferName,
                code: transferCode,
                timeSH: transferTimeSH,
                operationArchiveId: operationArchiveId));

            _operationArchiveTable.updateTimeSH(
                operationArchiveId, operationTimeSH);
          }
        }
      }
    }
  }

  Future loadDetailToArchive() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    var path = pickedFile?.paths.first;

    if (pickedFile != null) {
      var bytes = File(path!).readAsBytesSync();

      var excel = Excel.decodeBytes(bytes);
      int stageNumber = 1;
      print(excel.tables.keys);
      for (var table in excel.tables.keys) {
        print('в цикле');
        String code = excel.tables[table]!.rows[1][0]!.value
            .toString(); // присваивается значение первой ячейки столбца номер чертежа

        String technologyNumber =
            excel.tables[table]!.rows[1][1]!.value.toString();

        print('technology: $technologyNumber');
        String planNumberRS = excel.tables[table]!.rows[1][2]!.value.toString();

        print(planNumberRS);
        String planName = excel.tables[table]!.rows[1][3]!.value.toString();

        print(planName);
        int batchArchiveId = await _batchArchiveTable.insert(BatchArchiveDto(
          code: code,
          id: 0,
          number: planNumberRS,
          name: planName,
          technologyNumber: technologyNumber,
          companyId: 0,
        ));

        print(batchArchiveId);
        String? stageName = excel.tables[table]!.rows[1][5]?.value.toString();

        print(stageName);
        print('stageNumber: $stageNumber');
        int stageArchiveId = await _stageArchiveTable.insert(StageArchiveDTO(
          id: 0,
          number: stageNumber.toString(),
          name: stageName ?? '',
          batchArchiveId: batchArchiveId,
        ));

        print('инсерт stage: $stageNumber,  $stageName, $stageArchiveId');

        String? operationCode =
            excel.tables[table]!.rows[1][6]?.value.toString();
        String? operationNumber =
            excel.tables[table]!.rows[1][7]?.value.toString();
        String? operationName =
            excel.tables[table]!.rows[1][8]?.value.toString();
        int timepz = (int.parse(
            (excel.tables[table]!.rows[1][11]!.value ?? 0).toString()));
        int transferTimeSH = int.parse(
            (excel.tables[table]!.rows[1][12]!.value ?? 0).toString());

        int operationTimeSH = transferTimeSH;

        int operationArchiveId =
            await _operationArchiveTable.insert(OperationArchiveDto(
          id: 0,
          number: operationNumber ?? '',
          name: operationName ?? '',
          code: operationCode ?? '',
          timepz: timepz,
          timeSH: operationTimeSH,
          stageArchiveId: stageArchiveId,
        ));

        print(
            'инсерт операцию: $operationCode, $operationNumber, $operationName, transferTimeSH: ${operationTimeSH}');

        String? transferCode;
        String? transferName;
        if (excel.tables[table]!.rows[1][9]?.value != null) {
          transferCode = excel.tables[table]!.rows[1][9]!.value.toString();
          transferName = excel.tables[table]!.rows[1][10]?.value.toString();
          _transferArchiveTable.insert(TransferArchiveDto(
              id: 0,
              name: transferName ?? '',
              code: transferCode,
              timeSH: transferTimeSH,
              operationArchiveId: operationArchiveId));
          print(
              'инсерт переход для операции $operationArchiveId : $transferName');
        }

        for (int i = 2; i < excel.tables[table]!.maxRows; i++) {
          print('max rows: ${excel.tables[table]!.maxRows}');
          var row = excel.tables[table]!.rows;

          if (row[i][4]?.value != null) {
            stageNumber++;
            stageName = row[i][5]?.value.toString();
            stageArchiveId = await _stageArchiveTable.insert(StageArchiveDTO(
                id: 0,
                number: stageNumber.toString(),
                name: stageName ?? '',
                batchArchiveId: batchArchiveId));

            print('инсерт этап $stageNumber, $stageName, $stageArchiveId');
          }

          if (row[i][6]?.value != null) {
            operationCode = row[i][6]?.value.toString();
            operationNumber = row[i][7]?.value.toString();
            operationName = row[i][8]?.value.toString();
            if (row[i][11]?.value != null) {
              timepz = (int.parse(row[i][11]!.value.toString()));
            }
            operationTimeSH = int.parse(row[i][12]!.value.toString());

            operationArchiveId =
                await _operationArchiveTable.insert(OperationArchiveDto(
              id: 0,
              number: operationNumber ?? '',
              name: operationName ?? '',
              code: operationCode ?? '',
              timepz: timepz,
              timeSH: operationTimeSH,
              stageArchiveId: stageArchiveId,
            ));
          }

          if (row[i][9]?.value != null) {
            transferCode = row[i][9]!.value.toString();
            transferName = row[i][10]?.value.toString();
            transferTimeSH = int.parse(row[i][12]!.value.toString());
            operationTimeSH = operationTimeSH + transferTimeSH;

            _transferArchiveTable.insert(TransferArchiveDto(
                id: 0,
                name: transferName ?? '',
                code: transferCode,
                timeSH: transferTimeSH,
                operationArchiveId: operationArchiveId));

            _operationArchiveTable.updateTimeSH(
                operationArchiveId, operationTimeSH);
          }
        }
      }
    }
  }

  Future<String> uploadReport(
      {required List<StatisticsStageModel> stagesList}) async {
    var excel = Excel.createExcel();
    excel.rename('Sheet1', 'Этапы');

    Sheet stageExcel = excel['Этапы'];
    Sheet operationsExcel = excel['Ход выполнения операций'];
    Sheet readyOperationsExcel = excel['Выполненные операции'];

    List<CellValue> headerList = [];

    stageExcel.merge(
        CellIndex.indexByString('J1'), CellIndex.indexByString('L1'),
        customValue: TextCellValue('детали'));

    (stageExcel.cell(CellIndex.indexByString('J1'))).cellStyle =
        _cellHeaderStyle;

    stageExcel.merge(
        CellIndex.indexByString('M1'), CellIndex.indexByString('O1'),
        customValue: TextCellValue('операции'));

    (stageExcel.cell(CellIndex.indexByString('M1'))).cellStyle =
        _cellHeaderStyle;

    int operationRowIndex = 0;
    int readyOperationRowIndex = 0;

    for (int stageRowIndex = 0;
        stageRowIndex < stagesList.length;
        stageRowIndex++) {
      for (int stageColumnIndex = 0;
          stageColumnIndex < _stageHeadersList.length;
          stageColumnIndex++) {
        if (stageRowIndex == 1) {
          final cell = stageExcel.cell(CellIndex.indexByColumnRow(
              columnIndex: stageColumnIndex, rowIndex: stageRowIndex));
          cell.value = TextCellValue(_stageHeadersList[stageColumnIndex]);
          cell.cellStyle = _cellHeaderStyle;
        }
        final cell = stageExcel.cell(CellIndex.indexByColumnRow(
            columnIndex: stageColumnIndex, rowIndex: stageRowIndex + 2));

        final operationCell = operationsExcel.cell(CellIndex.indexByColumnRow(
            columnIndex: stageColumnIndex, rowIndex: operationRowIndex));

        switch (stageColumnIndex) {
          case 0:
            cell.value = IntCellValue(stageRowIndex + 1);

            operationCell.value = IntCellValue(stageRowIndex + 1);

          case 1:
            cell.value =
                TextCellValue('${stagesList[stageRowIndex].stage.number}');

            operationCell.value =
                TextCellValue('${stagesList[stageRowIndex].stage.number}');
          //   cell.cellStyle = _cellTextStyle;
          case 2:
            cell.value = TextCellValue(
                '${stagesList[stageRowIndex].stage.batch?.numberRS} ${stagesList[stageRowIndex].stage.name}');
            operationCell.value = TextCellValue(
                '${stagesList[stageRowIndex].stage.batch?.numberRS} ${stagesList[stageRowIndex].stage.name}');
          //    cell.cellStyle = _cellTextStyle;
          case 3:
            cell.value =
                TextCellValue('${stagesList[stageRowIndex].stage.batch?.code}');
            operationCell.value = TextCellValue(
                '${stagesList[stageRowIndex].stage.batch?.count}');
          //   cell.cellStyle = _cellTextStyle;
          case 4:
            cell.value = TextCellValue(
                '${stagesList[stageRowIndex].stage.batch?.count}');

            operationCell.value =
                TextCellValue('${stagesList[stageRowIndex].stage.batch?.code}');
          //    cell.cellStyle = _cellTextStyle;
          //case 5:
          case 6:
            cell.value = TextCellValue(
                '${stagesList[stageRowIndex].stage.batch?.count}');
          //  cell.cellStyle = _cellTextStyle;
          //case 7:
          //case 8:
          case 9:
            cell.value = IntCellValue(
                stagesList[stageRowIndex].readyDetailsQuantity ?? 0);
          // cell.cellStyle = _cellTextStyle;
          case 10:
            cell.value = IntCellValue(
                stagesList[stageRowIndex].readyDetailsPercent ?? 0);
          //   cell.cellStyle = _cellTextStyle;
          case 11:
            cell.value = IntCellValue(
                stagesList[stageRowIndex].defectDetailsQuantity ?? 0);
          //  cell.cellStyle = _cellTextStyle;
          case 12:
            cell.value = IntCellValue(
                stagesList[stageRowIndex].readyOperationsQuantity ?? 0);
          //  cell.cellStyle = _cellTextStyle;
          case 13:
            cell.value = IntCellValue(
                stagesList[stageRowIndex].operationsList.length ?? 0);
          // cell.cellStyle = _cellTextStyle;
          case 14:
            cell.value = IntCellValue(
                stagesList[stageRowIndex].readyOperationsPercent ?? 0);
          //cell.cellStyle = _cellTextStyle;
        }
        cell.cellStyle = _cellTextStyle;
        operationCell.cellStyle = _cellTextStyle;
      }

      for (var operation in stagesList[stageRowIndex].operationsList) {
        for (int operationColumnIndex = 0;
            operationColumnIndex < _operationsHeaderList.length;
            operationColumnIndex++) {
          if (operationRowIndex == 0) {
            final cell = operationsExcel.cell(CellIndex.indexByColumnRow(
                columnIndex: operationColumnIndex,
                rowIndex: operationRowIndex));
            cell.value =
                TextCellValue(_operationsHeaderList[operationColumnIndex]);
            cell.cellStyle = _cellHeaderStyle;
          } else {
            final cell = operationsExcel.cell(CellIndex.indexByColumnRow(
                columnIndex: operationColumnIndex,
                rowIndex: operationRowIndex));
            switch (operationColumnIndex) {
              case 6:
                cell.value = TextCellValue(
                    '${operation.operation.number} ${operation.operation.name}');
                cell.cellStyle = _cellTextStyle;
              case 7:
                cell.value = TextCellValue(operation.operation.code);
                cell.cellStyle = _cellTextStyle;
              case 8:
                cell.value = IntCellValue(operation.statusMap[6]!);
                cell.cellStyle = _cellTextStyle;
              case 9:
                cell.value = IntCellValue(operation.statusMap[7]!);
                cell.cellStyle = _cellTextStyle;
              case 10:
                cell.value = IntCellValue(operation.statusMap[5]!);
                cell.cellStyle = _cellTextStyle;
              case 11:
                cell.value = IntCellValue(operation.statusMap[4]!);
                cell.cellStyle = _cellTextStyle;
            }
          }
        }
        operationRowIndex++;
        print('readyOperationsList: ${operation.readyOperationsList.length}');
        for (var readyOperation in operation.readyOperationsList) {
          print('readyOperationRowIndex: ${readyOperationRowIndex}');
          for (int readyOperationsColumnIndex = 0;
              readyOperationsColumnIndex < _readyOperationsHeaderList.length;
              readyOperationsColumnIndex++) {
            if (readyOperationRowIndex == 0) {
              final cell = readyOperationsExcel.cell(CellIndex.indexByColumnRow(
                  columnIndex: readyOperationsColumnIndex,
                  rowIndex: readyOperationRowIndex));
              cell.value = TextCellValue(
                  _readyOperationsHeaderList[readyOperationsColumnIndex]);
              cell.cellStyle = _cellHeaderStyle;
            } else {
              final cell = readyOperationsExcel.cell(CellIndex.indexByColumnRow(
                  columnIndex: readyOperationsColumnIndex,
                  rowIndex: readyOperationRowIndex));
              switch (readyOperationsColumnIndex) {
                case 0:
                  cell.value = TextCellValue(operation.operation.code);
                  cell.cellStyle = _cellTextStyle;
                case 2:
                  cell.value = TextCellValue(
                      '${operation.operation.number} ${operation.operation.name}');
                  cell.cellStyle = _cellTextStyle;
                case 7:
                  cell.value = IntCellValue(operation
                          .readyOperationsList[readyOperationRowIndex]
                          .timePlan ??
                      0);
                  cell.cellStyle = _cellTextStyle;
                case 8:
                  cell.value = IntCellValue(operation
                          .readyOperationsList[readyOperationRowIndex]
                          .timeFact ??
                      0);
                  cell.cellStyle = _cellTextStyle;
                case 9:
                  cell.value = TextCellValue(operation
                          .readyOperationsList[readyOperationRowIndex]
                          .machine
                          ?.name ??
                      'нет данных');
                  cell.cellStyle = _cellTextStyle;
                case 10:
                  cell.value = IntCellValue(operation
                          .readyOperationsList[readyOperationRowIndex]
                          .machine
                          ?.inventoryNumber ??
                      0);
                  cell.cellStyle = _cellTextStyle;

                case 11:
                  cell.value = TextCellValue(operation
                      .readyOperationsList[readyOperationRowIndex].staff.fio);
                  cell.cellStyle = _cellTextStyle;
              }
            }
          }
        }
      }
    }
    var fileBytes = excel.save();
    var directory = await getDownloadsDirectory();

    final granted = await requestPermissions();
    if (granted) {
      Directory? downloadsDirectory = await DownloadsPath.downloadsDirectory();
      String? downloadsDirectoryPath =
          (await DownloadsPath.downloadsDirectory())?.path;
      print(downloadsDirectoryPath);
      final fileName = '${downloadsDirectoryPath}/Отчет о производстве.xlsx';

      File(fileName).writeAsBytes(fileBytes!);

      print('вывелось');
      return downloadsDirectoryPath ?? '';
    }

    return '';
  }

  Future<bool> requestPermissions() async {
    var status = await Permission.storage.status;
    print("=> storage permission satus: $status");
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    return status == PermissionStatus.granted;
  }

  Future<String> uploadChiefStagesReport(
      {required List<ChiefStageForReportModel> stagesList}) async {
    var excel = Excel.createExcel();
    excel.rename('Sheet1', 'Этапы');

    Sheet stageExcel = excel['Этапы'];

    stageExcel.merge(
        CellIndex.indexByString('J1'), CellIndex.indexByString('L1'),
        customValue: TextCellValue('детали'));

    (stageExcel.cell(CellIndex.indexByString('J1'))).cellStyle =
        _cellHeaderStyle;

    stageExcel.merge(
        CellIndex.indexByString('M1'), CellIndex.indexByString('O1'),
        customValue: TextCellValue('операции'));

    (stageExcel.cell(CellIndex.indexByString('M1'))).cellStyle =
        _cellHeaderStyle;

    for (int stageRowIndex = 0;
        stageRowIndex < stagesList.length;
        stageRowIndex++) {
      print('stageRowIndex: $stageRowIndex');
      for (int stageColumnIndex = 0;
          stageColumnIndex < _stageHeadersList.length;
          stageColumnIndex++) {
        if (stageRowIndex == 0) {
          final cell = stageExcel.cell(CellIndex.indexByColumnRow(
              columnIndex: stageColumnIndex, rowIndex: 1));

          cell.value = TextCellValue(_stageHeadersList[stageColumnIndex]);
          cell.cellStyle = _cellHeaderStyle;
        }
        final cell = stageExcel.cell(CellIndex.indexByColumnRow(
            columnIndex: stageColumnIndex, rowIndex: stageRowIndex + 2));

        switch (stageColumnIndex) {
          case 0:
            cell.value = IntCellValue(stageRowIndex + 1);

          case 1:
            cell.value = TextCellValue(stagesList[stageRowIndex].stageNumber);

          case 2:
            cell.value = TextCellValue(
                '${stagesList[stageRowIndex].batchNumber} ${stagesList[stageRowIndex].batchName}');

          case 3:
            cell.value = TextCellValue(stagesList[stageRowIndex].code);

          case 4:
            cell.value =
                TextCellValue('${stagesList[stageRowIndex].detailsQuantity}');
          case 6:
            cell.value =
                TextCellValue('${stagesList[stageRowIndex].detailsQuantity}');
          case 7:
            cell.value = IntCellValue(stagesList[stageRowIndex].semisQuantity);
          case 8:
            cell.value =
                IntCellValue(stagesList[stageRowIndex].missingSemisQuantity);
          case 9:
            cell.value =
                IntCellValue(stagesList[stageRowIndex].readyDetailsQuantity);

          case 10:
            cell.value =
                IntCellValue(stagesList[stageRowIndex].readyDetailsPercent);

          case 11:
            cell.value =
                IntCellValue(stagesList[stageRowIndex].defectDetailsQuantity);

          case 12:
            cell.value =
                IntCellValue(stagesList[stageRowIndex].readyOperationsQuantity);

          case 13:
            cell.value =
                IntCellValue(stagesList[stageRowIndex].operationsQuantity);

          case 14:
            cell.value =
                IntCellValue(stagesList[stageRowIndex].readyOperationsPercent);
        }
        cell.cellStyle = _cellTextStyle;
      }
    }

    var fileBytes = excel.save();

    final granted = await requestPermissions();
    if (granted) {
      String? downloadsDirectoryPath =
          (await DownloadsPath.downloadsDirectory())?.path;
      print(downloadsDirectoryPath);
      final fileName = '${downloadsDirectoryPath}/Этапы.xlsx';

      File(fileName).writeAsBytes(fileBytes!);

      print('вывелось');
      return downloadsDirectoryPath ?? '';
    }

    return '';
  }

  Future<String> uploadChiefOperationsReport(
      {required List<ChiefStageForReportModel> stagesList}) async {
    var excel = Excel.createExcel();
    excel.rename('Sheet1', 'Ход выполнения операций');

    Sheet operationsExcel = excel['Ход выполнения операций'];

    int operationRowIndex = 0;

    for (int stageNumber = 0; stageNumber < stagesList.length; stageNumber++) {
      for (int stageColumnIndex = 0;
          stageColumnIndex < _stageHeadersList.length;
          stageColumnIndex++) {
        final operationCell = operationsExcel.cell(CellIndex.indexByColumnRow(
            columnIndex: stageColumnIndex, rowIndex: operationRowIndex + 1));

        switch (stageColumnIndex) {
          case 0:
            operationCell.value = IntCellValue(stageNumber + 1);
          case 1:
            operationCell.value =
                TextCellValue('${stagesList[stageNumber].stageNumber}');

          case 2:
            operationCell.value = TextCellValue(
                '${stagesList[stageNumber].batchNumber} ${stagesList[stageNumber].batchName}');

          case 3:
            operationCell.value =
                TextCellValue('${stagesList[stageNumber].detailsQuantity}');

          case 4:
            operationCell.value =
                TextCellValue('${stagesList[stageNumber].batchCode}');
        }

        operationCell.cellStyle = _cellTextStyle;
      }

      for (var operation in stagesList[stageNumber].operationsList) {
        for (int operationColumnIndex = 0;
            operationColumnIndex < _operationsHeaderList.length;
            operationColumnIndex++) {
          if (operationRowIndex == 0) {
            final cell = operationsExcel.cell(CellIndex.indexByColumnRow(
                columnIndex: operationColumnIndex,
                rowIndex: operationRowIndex));
            cell.value =
                TextCellValue(_operationsHeaderList[operationColumnIndex]);
            cell.cellStyle = _cellHeaderStyle;
          }
          final cell = operationsExcel.cell(CellIndex.indexByColumnRow(
              columnIndex: operationColumnIndex,
              rowIndex: operationRowIndex + 1));
          switch (operationColumnIndex) {
            case 5:
              cell.value =
                  TextCellValue('${operation.number} ${operation.name}');

            case 6:
              cell.value = TextCellValue(operation.code);

            case 7:
              cell.value = IntCellValue(operation.readyQuantity);

            case 8:
              cell.value = IntCellValue(operation.readyPercent);

            case 9:
              cell.value = IntCellValue(operation.distributed +
                  operation.onDistribution +
                  operation.onMachinesQuantity +
                  operation.onCheckQuantity);
            case 10:
              cell.value = IntCellValue(operation.defectQuantity);
            case 11:
              cell.value = IntCellValue(operation.modificationQuantity);
          }
          cell.cellStyle = _cellTextStyle;
        }
        operationRowIndex++;
      }
    }
    var fileBytes = excel.save();

    final granted = await requestPermissions();
    if (granted) {
      String? downloadsDirectoryPath =
          (await DownloadsPath.downloadsDirectory())?.path;
      print(downloadsDirectoryPath);
      final fileName = '${downloadsDirectoryPath}/Ход выполнения операций.xlsx';

      File(fileName).writeAsBytes(fileBytes!);

      print('вывелось');
      return downloadsDirectoryPath ?? '';
    }
    return '';
  }

  Future<String> uploadReadyOperationsReport(
      {required List<AnalyticsOperationModel> analyticsOperationsList,
      FiltersInfoModel? filtersInfo}) async {
    var excel = Excel.createExcel();
    excel.rename('Sheet1', 'Отчет о выполненных операциях');

    Sheet readyOperationsExcel = excel['Отчет о выполненных операциях'];

    //название отчета
    readyOperationsExcel.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
        CellIndex.indexByColumnRow(
            columnIndex:
                _totalNumberReadyOperationsReportHeadersList.length - 1,
            rowIndex: 0));
    print('мердж названия');
    final cell = readyOperationsExcel
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    cell.value = TextCellValue('Отчет о выполненных операциях');
    cell.cellStyle = _cellHeaderStyle;

    readyOperationsExcel.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
        CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1));

    readyOperationsExcel.merge(
        CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 1),
        CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 1));

    for (int filterInfoColumnIndex = 0;
        filterInfoColumnIndex <
            _totalNumberReadyOperationsReportHeadersList.length;
        filterInfoColumnIndex++) {
      final cellFilterInfo = readyOperationsExcel.cell(
          CellIndex.indexByColumnRow(
              columnIndex: filterInfoColumnIndex, rowIndex: 1));

      switch (filterInfoColumnIndex) {
        case 0:
          cellFilterInfo.value = TextCellValue('Цех');
        case 3:
          cellFilterInfo.value =
              TextCellValue('${filtersInfo?.unitsNumbersList}');
        case 4:
          cellFilterInfo.value = TextCellValue('Участок');
        case 5:
          cellFilterInfo.value =
              TextCellValue('${filtersInfo?.areasNumbersList}');
        case 6:
          cellFilterInfo.value = TextCellValue('Период');
        case 7:
          cellFilterInfo.value = TextCellValue(
              '${filtersInfo?.timeStart} - ${filtersInfo?.timeEnd}');
      }

      cellFilterInfo.cellStyle = _cellTextStyle;
    }
    print('перед пустой строкой');
    //пустая строка
    readyOperationsExcel.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2),
        CellIndex.indexByColumnRow(
            columnIndex:
                _totalNumberReadyOperationsReportHeadersList.length - 1,
            rowIndex: 2));

    for (int operationRowIndex = 0;
        operationRowIndex < analyticsOperationsList.length;
        operationRowIndex++) {
      for (int operationColumnIndex = 0;
          operationColumnIndex < _readyOperationsHeaderList.length;
          operationColumnIndex++) {
        if (operationRowIndex == 3) {
          final cell = readyOperationsExcel.cell(CellIndex.indexByColumnRow(
              columnIndex: operationColumnIndex, rowIndex: 3));

          cell.value =
              TextCellValue(_readyOperationsHeaderList[operationColumnIndex]);
          cell.cellStyle = _cellHeaderStyle;
        }
        final cell = readyOperationsExcel.cell(CellIndex.indexByColumnRow(
            columnIndex: operationColumnIndex,
            rowIndex: operationRowIndex + 3));

        switch (operationColumnIndex) {
          case 0:
            cell.value = TextCellValue(
                '${analyticsOperationsList[operationRowIndex].batch.order?.number ?? '_'}.${analyticsOperationsList[operationRowIndex].batch.number}.${analyticsOperationsList[operationRowIndex].stage.number}');
            cell.cellStyle = _cellTextStyle;
          case 1:
            cell.value = TextCellValue(
                '${analyticsOperationsList[operationRowIndex].detailNumber}');
            cell.cellStyle = _cellHeaderStyle;
          case 2:
            cell.value = TextCellValue(
                '${analyticsOperationsList[operationRowIndex].detailName}');
            cell.cellStyle = _cellHeaderStyle;
          case 3:
            cell.value = TextCellValue(
                '${analyticsOperationsList[operationRowIndex].operationNumber} ${analyticsOperationsList[operationRowIndex].operationName}');
            cell.cellStyle = _cellTextStyle;
          case 4:
            cell.value = TextCellValue('');
            cell.cellStyle = _cellTextStyle;
          case 5:
            cell.value = TextCellValue(
                '${_timeConverter.convertTimeFromMinutes(analyticsOperationsList[operationRowIndex].timePlan)}');
            cell.cellStyle = _cellFocusTextStyle;
          case 6:
            cell.value = TextCellValue(
                '${_timeConverter.convertTimeFromSeconds(analyticsOperationsList[operationRowIndex].timeFact)}');
            cell.cellStyle = _cellFocusTextStyle;
          case 7:
            cell.value = TextCellValue(
                analyticsOperationsList[operationRowIndex].machineName);
            cell.cellStyle = _cellTextStyle;
          case 8:
            cell.value = IntCellValue(analyticsOperationsList[operationRowIndex]
                .machineInventoryNumber);
            cell.cellStyle = _cellTextStyle;
          case 9:
            cell.value =
                TextCellValue(analyticsOperationsList[operationRowIndex].fio);
            cell.cellStyle = _cellTextStyle;
          case 10:
            cell.value =
                TextCellValue(analyticsOperationsList[operationRowIndex].code);
            cell.cellStyle = _cellTextStyle;
          case 11:
            cell.value = TextCellValue(
                analyticsOperationsList[operationRowIndex].dateStart);
            cell.cellStyle = _cellTextStyle;
          case 12:
            cell.value = TextCellValue(
                analyticsOperationsList[operationRowIndex].timeStart);
            cell.cellStyle = _cellTextStyle;
          case 13:
            cell.value = TextCellValue(
                analyticsOperationsList[operationRowIndex].dateEnd);
            cell.cellStyle = _cellTextStyle;
          case 14:
            cell.value = TextCellValue(
                analyticsOperationsList[operationRowIndex].timeEnd);
            cell.cellStyle = _cellTextStyle;
          case 15:
            cell.value =
                IntCellValue(analyticsOperationsList[operationRowIndex].change);
            cell.cellStyle = _cellTextStyle;
          case 16:
            cell.value = TextCellValue(
                analyticsOperationsList[operationRowIndex].areaNumber);
            cell.cellStyle = _cellTextStyle;
          case 17:
            cell.value = IntCellValue(
                analyticsOperationsList[operationRowIndex].defectQuantity);
            cell.cellStyle = _cellDefectTextStyle;

          case 18:
            cell.value = IntCellValue(analyticsOperationsList[operationRowIndex]
                .modificationQuantity);
            cell.cellStyle = _cellModificationTextStyle;
          case 19:
            cell.value = IntCellValue(
                analyticsOperationsList[operationRowIndex].quantity);
            cell.cellStyle = _cellFocusTextStyle;
          case 20:
            cell.value = TextCellValue(
                analyticsOperationsList[operationRowIndex].comment);
            cell.cellStyle = _cellTextStyle;
        }
      }
    }

    var fileBytes = excel.save();

    final granted = await requestPermissions();
    if (granted) {
      String? downloadsDirectoryPath =
          (await DownloadsPath.downloadsDirectory())?.path;
      print(downloadsDirectoryPath);

      int reportNumber = await insertReportInfoIntoDatabase(1);

      final fileName =
          '${downloadsDirectoryPath}/Отчет о выполненных операциях $reportNumber ${staff?.fio} (${filtersInfo?.timeStart} - ${filtersInfo?.timeEnd}).xlsx';

      File(fileName).writeAsBytes(fileBytes!);

      print('вывелось');
      return fileName ?? '';
    }

    return '';
  }

  Future<String> uploadReadyOperationsReportNew(
      {required List<AnalyticsOperationModel> analyticsOperationsList,
      FiltersInfoModel? filtersInfo}) async {
    var excel = Excel.createExcel();
    excel.rename('Sheet1', 'Отчет о выполненных операциях');

    Sheet readyOperationsExcel = excel['Отчет о выполненных операциях'];

    //название отчета
    readyOperationsExcel.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
        CellIndex.indexByColumnRow(
            columnIndex:
                _totalNumberReadyOperationsReportHeadersList.length - 1,
            rowIndex: 0));
    print('мердж названия');
    final cell = readyOperationsExcel
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    cell.value = TextCellValue('Отчет о выполненных операциях');
    cell.cellStyle = _cellHeaderStyle;

    readyOperationsExcel.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
        CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1));

    readyOperationsExcel.merge(
        CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 1),
        CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 1));

    for (int filterInfoColumnIndex = 0;
        filterInfoColumnIndex <
            _totalNumberReadyOperationsReportHeadersList.length;
        filterInfoColumnIndex++) {
      final cellFilterInfo = readyOperationsExcel.cell(
          CellIndex.indexByColumnRow(
              columnIndex: filterInfoColumnIndex, rowIndex: 1));

      switch (filterInfoColumnIndex) {
        case 0:
          cellFilterInfo.value = TextCellValue('Цех');
        case 3:
          cellFilterInfo.value =
              TextCellValue('${filtersInfo?.unitsNumbersList}');
        case 4:
          cellFilterInfo.value = TextCellValue('Участок');
        case 5:
          cellFilterInfo.value =
              TextCellValue('${filtersInfo?.areasNumbersList}');
        case 6:
          cellFilterInfo.value = TextCellValue('Период');
        case 7:
          cellFilterInfo.value = TextCellValue(
              '${filtersInfo?.timeStart} - ${filtersInfo?.timeEnd}');
      }

      cellFilterInfo.cellStyle = _cellTextStyle;
    }
    print('перед пустой строкой');
    //пустая строка
    readyOperationsExcel.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2),
        CellIndex.indexByColumnRow(
            columnIndex:
                _totalNumberReadyOperationsReportHeadersList.length - 1,
            rowIndex: 2));


    //заголовок
    for (int headerColumnIndex = 0;
        headerColumnIndex < _readyOperationsHeaderList.length;
        headerColumnIndex++){

      final cell = readyOperationsExcel.cell(CellIndex.indexByColumnRow(
          columnIndex: headerColumnIndex, rowIndex: 3));
      cell.value =
          TextCellValue(_readyOperationsHeaderList[headerColumnIndex]);
      cell.cellStyle = _cellHeaderStyle;

    }



      int rowIndex = 4;

    for (int operationIndex = 0;
        operationIndex < analyticsOperationsList.length;
        operationIndex++) {
      for (int operationColumnIndex = 0;
          operationColumnIndex < _readyOperationsHeaderList.length;
          operationColumnIndex++) {
        final cell = readyOperationsExcel.cell(CellIndex.indexByColumnRow(
            columnIndex: operationColumnIndex, rowIndex: rowIndex));


          switch (operationColumnIndex) {
            case 0:
              cell.value = TextCellValue(
                  '${analyticsOperationsList[operationIndex].batch.order?.number ?? '_'}.${analyticsOperationsList[operationIndex].batch.number}.${analyticsOperationsList[operationIndex].stage.number}');
              cell.cellStyle = _horizontalBorderBoldCellStyle;
            case 1:
              cell.value = TextCellValue(
                  '${analyticsOperationsList[operationIndex].detailNumber}');
              cell.cellStyle = _cellBoldTextStyle;
            case 2:
              cell.value = TextCellValue(
                  '${analyticsOperationsList[operationIndex].detailName}');
              cell.cellStyle = _cellTextStyle;
            case 3:
              cell.value = TextCellValue(
                  '${analyticsOperationsList[operationIndex].operationNumber} ${analyticsOperationsList[operationIndex].operationName}');
              cell.cellStyle = _cellTextStyle;
            case 4:
              cell.value = TextCellValue('');
              cell.cellStyle = _rightBorderBoldCellStyle;
            case 5:
              cell.value = TextCellValue(
                  analyticsOperationsList[operationIndex].transfersList.isEmpty
                      ? analyticsOperationsList[operationIndex].code
                      : '');
              cell.cellStyle = _cellTextStyle;
            case 6:
              cell.value = TextCellValue(
                  '${_timeConverter.convertTimeFromMinutes(analyticsOperationsList[operationIndex].timePlan)}');
              cell.cellStyle = _cellFocusTextStyle;
            case 7:
              cell.value = TextCellValue(
                  '${_timeConverter.convertTimeFromSeconds(analyticsOperationsList[operationIndex].timeFact)}');
              cell.cellStyle = analyticsOperationsList[operationIndex]
                          .timeFact >
                      (analyticsOperationsList[operationIndex].timePlan * 60)
                  ? _cellDefectTextStyle
                  : _cellFocusTextStyle;
            case 8:
              cell.value = TextCellValue(
                  analyticsOperationsList[operationIndex].dateStart);
              cell.cellStyle = _cellTextStyle;
            case 9:
              cell.value = TextCellValue(
                  analyticsOperationsList[operationIndex].timeStart);
              cell.cellStyle = _cellTextStyle;
            case 10:
              cell.value = TextCellValue(
                  analyticsOperationsList[operationIndex].dateEnd);
              cell.cellStyle = _cellTextStyle;

            case 11:
              cell.value = TextCellValue(
                  analyticsOperationsList[operationIndex].timeEnd);
              cell.cellStyle = _rightBorderBoldCellStyle;
            case 12:
              cell.value = TextCellValue(
                  analyticsOperationsList[operationIndex].machineName);
              cell.cellStyle = _cellTextStyle;
            case 13:
              cell.value = IntCellValue(analyticsOperationsList[operationIndex]
                  .machineInventoryNumber);
              cell.cellStyle = _rightBorderBoldCellStyle;
            case 14:
              cell.value =
                  TextCellValue(analyticsOperationsList[operationIndex].fio);
              cell.cellStyle = _cellTextStyle;
            case 15:
              cell.value =
                  IntCellValue(analyticsOperationsList[operationIndex].change);
              cell.cellStyle = _cellTextStyle;
            case 16:
              cell.value = TextCellValue(
                  analyticsOperationsList[operationIndex].unitNumber);
              cell.cellStyle = _cellTextStyle;
            case 17:
              cell.value = TextCellValue(
                  analyticsOperationsList[operationIndex].areaNumber);
              cell.cellStyle = _rightBorderBoldCellStyle;
            case 18:
              cell.value = IntCellValue(
                  analyticsOperationsList[operationIndex].defectQuantity);
              cell.cellStyle =
                  analyticsOperationsList[operationIndex].defectQuantity != 0
                      ? _cellDefectTextStyle
                      : _cellTextStyle;

            case 19:
              cell.value = IntCellValue(
                  analyticsOperationsList[operationIndex].modificationQuantity);
              cell.cellStyle = analyticsOperationsList[operationIndex]
                          .modificationQuantity !=
                      0
                  ? _cellModificationTextStyle
                  : _cellTextStyle;
            case 20:
              cell.value = IntCellValue(
                  analyticsOperationsList[operationIndex].quantity);
              cell.cellStyle = _cellFocusTextStyle;
            case 21:
              cell.value = TextCellValue(
                  analyticsOperationsList[operationIndex].comment);
              cell.cellStyle = _rightBorderBoldCellStyle;
          }
        }


      if (analyticsOperationsList[operationIndex].transfersList.isNotEmpty &&
          rowIndex != 3) {
        for (int transferIndex = 0;
            transferIndex <
                analyticsOperationsList[operationIndex].transfersList.length;
            transferIndex++) {
          for (int transferColumnIndex = 0;
              transferColumnIndex < _readyOperationsHeaderList.length;
              transferColumnIndex++) {
            final cell = readyOperationsExcel.cell(CellIndex.indexByColumnRow(
                columnIndex: transferColumnIndex, rowIndex: rowIndex));

            switch (transferColumnIndex) {
              case 0:
                cell.cellStyle = _horizontalBorderBoldCellStyle;
              case 1:
                cell.cellStyle = _cellTextStyle;
              case 2:
                cell.cellStyle = _cellTextStyle;
              case 3:
                cell.cellStyle = _cellTextStyle;
              case 4:
                cell.value = TextCellValue(
                    '${analyticsOperationsList[operationIndex].transfersList[transferIndex].id} ${analyticsOperationsList[operationIndex].transfersList[transferIndex].name}');
                cell.cellStyle = _rightBorderBoldCellStyle;
              case 5:
                cell.value = TextCellValue(
                    '${analyticsOperationsList[operationIndex].transfersList[transferIndex].code}');
                cell.cellStyle = _cellTextStyle;
              case 6:
                cell.value = TextCellValue(
                    '${_timeConverter.convertTimeFromMinutes(analyticsOperationsList[operationIndex].transfersList[transferIndex].timePlan)}');
                cell.cellStyle = _cellFocusTextStyle;
              case 7:
                cell.value = TextCellValue(
                    '${_timeConverter.convertTimeFromSeconds(analyticsOperationsList[operationIndex].transfersList[transferIndex].timeFact)}');
                cell.cellStyle = analyticsOperationsList[operationIndex]
                            .transfersList[transferIndex]
                            .timeFact >
                        (analyticsOperationsList[operationIndex]
                                .transfersList[transferIndex]
                                .timePlan *
                            60)
                    ? _cellDefectTextStyle
                    : _cellFocusTextStyle;
              case 8:
                cell.value = TextCellValue(
                    '${analyticsOperationsList[operationIndex].transfersList[transferIndex].dateStart}');
                cell.cellStyle = _cellTextStyle;
              case 9:
                cell.value = TextCellValue(
                    '${analyticsOperationsList[operationIndex].transfersList[transferIndex].timeStart}');
                cell.cellStyle = _cellTextStyle;
              case 10:
                cell.value = TextCellValue(
                    '${analyticsOperationsList[operationIndex].transfersList[transferIndex].dateEnd}');
                cell.cellStyle = _cellTextStyle;
              case 11:
                cell.value = TextCellValue(
                    '${analyticsOperationsList[operationIndex].transfersList[transferIndex].timeEnd}');
                cell.cellStyle = _rightBorderBoldCellStyle;
              case 12:
                cell.value = TextCellValue(
                    '${analyticsOperationsList[operationIndex].transfersList[transferIndex].machineName}');
                cell.cellStyle = _cellTextStyle;
              case 13:
                cell.value = TextCellValue(
                    '${analyticsOperationsList[operationIndex].transfersList[transferIndex].machineInventoryNumber}');
                cell.cellStyle = _rightBorderBoldCellStyle;
              case 14:
                cell.value = TextCellValue(
                    '${analyticsOperationsList[operationIndex].transfersList[transferIndex].fio}');
                cell.cellStyle = _cellTextStyle;
              case 15:
                cell.value = TextCellValue(
                    '${analyticsOperationsList[operationIndex].transfersList[transferIndex].change}');
                cell.cellStyle = _cellTextStyle;
              case 16:
                cell.value = TextCellValue(
                    '${analyticsOperationsList[operationIndex].transfersList[transferIndex].unitNumber}');
                cell.cellStyle = _cellTextStyle;
              case 17:
                cell.value = TextCellValue(
                    '${analyticsOperationsList[operationIndex].transfersList[transferIndex].areaNumber}');
                cell.cellStyle = _rightBorderBoldCellStyle;
              case 18:
                cell.cellStyle = _cellTextStyle;
              case 19:
                cell.cellStyle = _cellTextStyle;
              case 20:
                cell.cellStyle = _cellTextStyle;
              case 21:
                cell.cellStyle = _rightBorderBoldCellStyle;
            }
          }
          rowIndex++;
        }
      }
      rowIndex++;
    }

    var fileBytes = excel.save();

    final granted = await requestPermissions();

    if (granted) {
      String? downloadsDirectoryPath =
          (await DownloadsPath.downloadsDirectory())?.path;
      print(downloadsDirectoryPath);

      int reportNumber = await insertReportInfoIntoDatabase(1);

      final fileName =
          '${downloadsDirectoryPath}/Отчет о выполненных операциях $reportNumber ${staff?.fio} (${filtersInfo?.timeStart} - ${filtersInfo?.timeEnd}).xlsx';

      File(fileName).writeAsBytes(fileBytes!);

      print('вывелось');
      return fileName;
    }

    return '';
  }

  Future<String> uploadTotalNumberReadyOperationsReport(
      {required List<TotalNumberReadyOperationModel>
          totalNumberReadyOperationModelsList,
      FiltersInfoModel? filtersInfo}) async {
    var excel = Excel.createExcel();
    excel.rename('Sheet1', 'Отчет суммарного количества выполненных операций');

    Sheet totalNumberReadyOperationsExcel =
        excel['Отчет суммарного количества выполненных операций'];

    //название отчета
    totalNumberReadyOperationsExcel.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
        CellIndex.indexByColumnRow(
            columnIndex:
                _totalNumberReadyOperationsReportHeadersList.length - 1,
            rowIndex: 0));
    print('мердж названия');
    final cell = totalNumberReadyOperationsExcel
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    cell.value = TextCellValue('Отчет суммарного кол-ва выполненных операций');
    cell.cellStyle = _cellHeaderStyle;

    totalNumberReadyOperationsExcel.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
        CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1));

    totalNumberReadyOperationsExcel.merge(
        CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 1),
        CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 1));

    for (int filterInfoColumnIndex = 0;
        filterInfoColumnIndex <
            _totalNumberReadyOperationsReportHeadersList.length;
        filterInfoColumnIndex++) {
      final cellFilterInfo = totalNumberReadyOperationsExcel.cell(
          CellIndex.indexByColumnRow(
              columnIndex: filterInfoColumnIndex, rowIndex: 1));

      switch (filterInfoColumnIndex) {
        case 0:
          cellFilterInfo.value = TextCellValue('Цех');
        case 3:
          cellFilterInfo.value =
              TextCellValue('${filtersInfo?.unitsNumbersList}');
        case 4:
          cellFilterInfo.value = TextCellValue('Участок');
        case 5:
          cellFilterInfo.value =
              TextCellValue('${filtersInfo?.areasNumbersList}');
        case 6:
          cellFilterInfo.value = TextCellValue('Период');
        case 7:
          cellFilterInfo.value = TextCellValue(
              '${filtersInfo?.timeStart} - ${filtersInfo?.timeEnd}');
      }

      cellFilterInfo.cellStyle = _cellTextStyle;
    }
    print('перед пустой строкой');
    //пустая строка
    totalNumberReadyOperationsExcel.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2),
        CellIndex.indexByColumnRow(
            columnIndex:
                _totalNumberReadyOperationsReportHeadersList.length - 1,
            rowIndex: 2));

    for (int operationRowIndex = 0;
        operationRowIndex < totalNumberReadyOperationModelsList.length;
        operationRowIndex++) {
      print('вошли в цикл');
      for (int operationColumnIndex = 0;
          operationColumnIndex <
              _totalNumberReadyOperationsReportHeadersList.length;
          operationColumnIndex++) {
        if (operationRowIndex == 3) {
          final cell = totalNumberReadyOperationsExcel.cell(
              CellIndex.indexByColumnRow(
                  columnIndex: operationColumnIndex, rowIndex: 3));

          cell.value = TextCellValue(
              _totalNumberReadyOperationsReportHeadersList[
                  operationColumnIndex]);
          cell.cellStyle = _cellHeaderStyle;
        }

        final cell = totalNumberReadyOperationsExcel.cell(
            CellIndex.indexByColumnRow(
                columnIndex: operationColumnIndex,
                rowIndex: operationRowIndex + 3));

        print(
            'stageNumber : ${totalNumberReadyOperationModelsList[operationRowIndex].stageNumber}');

        switch (operationColumnIndex) {
          case 0:
            cell.value = TextCellValue(
                '${totalNumberReadyOperationModelsList[operationRowIndex].stageNumber}');
            cell.cellStyle = _cellTextStyle;
          case 1:
            cell.value = TextCellValue(
                '${totalNumberReadyOperationModelsList[operationRowIndex].unitNumber}');
            cell.cellStyle = _cellTextStyle;

          case 2:
            cell.value = TextCellValue(
                '${totalNumberReadyOperationModelsList[operationRowIndex].areaNumber}');
            cell.cellStyle = _cellTextStyle;

          case 3:
            cell.value = TextCellValue(
                '${totalNumberReadyOperationModelsList[operationRowIndex].planNumber}');
            cell.cellStyle = _cellHeaderStyle;
          case 4:
            cell.value = TextCellValue(
                '${totalNumberReadyOperationModelsList[operationRowIndex].planName}');
            cell.cellStyle = _cellHeaderStyle;
          case 5:
            cell.value = TextCellValue(
                '${totalNumberReadyOperationModelsList[operationRowIndex].operationName}');
            cell.cellStyle = _cellTextStyle;
          case 6:
            cell.value = TextCellValue(
                '${totalNumberReadyOperationModelsList[operationRowIndex].code}');
            cell.cellStyle = _cellTextStyle;
          case 7:
            cell.value = TextCellValue(totalNumberReadyOperationModelsList[
                            operationRowIndex]
                        .stageNumber !=
                    ''
                ? '${totalNumberReadyOperationModelsList[operationRowIndex].defectQuantity}'
                : '');
            cell.cellStyle =
                totalNumberReadyOperationModelsList[operationRowIndex]
                            .stageNumber ==
                        ''
                    ? _cellTextStyle
                    : _cellDefectTextStyle;
          case 8:
            cell.value = TextCellValue(totalNumberReadyOperationModelsList[
                            operationRowIndex]
                        .stageNumber !=
                    ''
                ? '${totalNumberReadyOperationModelsList[operationRowIndex].modificationQuantity}'
                : '');
            cell.cellStyle =
                totalNumberReadyOperationModelsList[operationRowIndex]
                            .stageNumber ==
                        ''
                    ? _cellTextStyle
                    : _cellModificationTextStyle;

          case 9:
            cell.value = TextCellValue(totalNumberReadyOperationModelsList[
                            operationRowIndex]
                        .stageNumber !=
                    ''
                ? '${totalNumberReadyOperationModelsList[operationRowIndex].totalQuantity}'
                : '');
            cell.cellStyle =
                totalNumberReadyOperationModelsList[operationRowIndex]
                            .stageNumber ==
                        ''
                    ? _cellTextStyle
                    : _cellFocusTextStyle;
        }
      }
    }

    var fileBytes = excel.save();

    final granted = await requestPermissions();
    if (granted) {
      String? downloadsDirectoryPath =
          (await DownloadsPath.downloadsDirectory())?.path;
      print(downloadsDirectoryPath);

      int reportNumber = await insertReportInfoIntoDatabase(2);

      final fileName =
          '${downloadsDirectoryPath}/Отчет суммарного количества выполненных операций $reportNumber ${staff?.fio} (${filtersInfo?.timeStart} - ${filtersInfo?.timeEnd}).xlsx';

      File(fileName).writeAsBytes(fileBytes!);

      print('вывелось');
      return fileName;
    }

    return '';
  }

  Future uploadMonitoringStatusesReport(
      {required List<MonitoringStatusesModel> monitoringStatusesModelsList,
      FiltersInfoModel? filtersInfo}) async {
    var excel = Excel.createExcel();
    excel.rename('Sheet1', 'Статусы мониторинга');

    Sheet readyOperationsExcel = excel['Статусы мониторинга'];

    //название отчета
    readyOperationsExcel.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
        CellIndex.indexByColumnRow(
            columnIndex: _monitoringStatusesReportHeadersList.length - 1,
            rowIndex: 0));
    print('мердж названия');
    final cell = readyOperationsExcel
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    cell.value = TextCellValue('Статусы мониторинга');
    cell.cellStyle = _cellHeaderStyle;

    readyOperationsExcel.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
        CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1));

    readyOperationsExcel.merge(
        CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 1),
        CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 1));

    for (int filterInfoColumnIndex = 0;
        filterInfoColumnIndex < _monitoringStatusesReportHeadersList.length;
        filterInfoColumnIndex++) {
      final cellFilterInfo = readyOperationsExcel.cell(
          CellIndex.indexByColumnRow(
              columnIndex: filterInfoColumnIndex, rowIndex: 1));

      switch (filterInfoColumnIndex) {
        case 0:
          cellFilterInfo.value = TextCellValue('Цех');
        case 3:
          cellFilterInfo.value =
              TextCellValue('${filtersInfo?.unitsNumbersList}');
        case 4:
          cellFilterInfo.value = TextCellValue('Участок');
        case 5:
          cellFilterInfo.value =
              TextCellValue('${filtersInfo?.areasNumbersList}');
        case 6:
          cellFilterInfo.value = TextCellValue('Период');
        case 7:
          cellFilterInfo.value = TextCellValue(
              '${filtersInfo?.timeStart} - ${filtersInfo?.timeEnd}');
      }

      cellFilterInfo.cellStyle = _cellTextStyle;
    }
    print('перед пустой строкой');
    //пустая строка
    readyOperationsExcel.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2),
        CellIndex.indexByColumnRow(
            columnIndex: _monitoringStatusesReportHeadersList.length - 1,
            rowIndex: 2));

    int rowIndex = 3;

    for (int operationIndex = 0;
        operationIndex < monitoringStatusesModelsList.length;
        operationIndex++) {
      for (int operationColumnIndex = 0;
          operationColumnIndex < _monitoringStatusesReportHeadersList.length;
          operationColumnIndex++) {
        final cell = readyOperationsExcel.cell(CellIndex.indexByColumnRow(
            columnIndex: operationColumnIndex, rowIndex: rowIndex));

        if (rowIndex == 3) {
          cell.value = TextCellValue(
              _monitoringStatusesReportHeadersList[operationColumnIndex]);
          cell.cellStyle = _cellHeaderStyle;
        } else {
          switch (operationColumnIndex) {
            case 0:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].optimalBatchId}');
              cell.cellStyle = _cellTextStyle;
            case 1:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].stageNumber}');
              cell.cellStyle = _cellTextStyle;
            case 2:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].batchNumber}');
              cell.cellStyle = _cellTextStyle;
            case 3:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].batchName}');
              cell.cellStyle = _cellTextStyle;
            case 4:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].operationName}');
              cell.cellStyle = _cellTextStyle;
            case 5:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].statusName}');
              cell.cellStyle = _cellTextStyle;
            case 6:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].unitNumber} ${monitoringStatusesModelsList[operationIndex].unitName} ');
              cell.cellStyle = _cellTextStyle;
            case 7:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].areaNumber} ${monitoringStatusesModelsList[operationIndex].areaName}');
              cell.cellStyle = _cellTextStyle;
            case 8:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].inventoryNumber}');
              cell.cellStyle = _cellTextStyle;
            case 9:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].machineName}');
              cell.cellStyle = _cellTextStyle;
            case 10:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].dateStart}');
              cell.cellStyle = _cellTextStyle;
            case 11:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].timeStart}');
              cell.cellStyle = _cellTextStyle;
            case 12:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].dateEnd}');
              cell.cellStyle = _cellTextStyle;
            case 13:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].dateEnd}');
              cell.cellStyle = _cellTextStyle;
            case 14:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].duration}');
              cell.cellStyle = _cellTextStyle;
            case 15:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].fio}');
              cell.cellStyle = _cellTextStyle;
            case 16:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].change}');
              cell.cellStyle = _cellTextStyle;
            case 17:
              cell.value = TextCellValue(
                  '${monitoringStatusesModelsList[operationIndex].comment}');
              cell.cellStyle = _cellTextStyle;
          }
        }
      }

      rowIndex++;
    }

    var fileBytes = excel.save();

    final granted = await requestPermissions();

    if (granted) {
      String? downloadsDirectoryPath =
          (await DownloadsPath.downloadsDirectory())?.path;
      print(downloadsDirectoryPath);

      int reportNumber = await insertReportInfoIntoDatabase(1);

      final fileName =
          '${downloadsDirectoryPath}/Статусы мониторинга $reportNumber ${staff?.fio} (${filtersInfo?.timeStart} - ${filtersInfo?.timeEnd}).xlsx';

      File(fileName).writeAsBytes(fileBytes!);

      print('вывелось');
      return fileName;
    }

    return '';
  }

  Future<int> insertReportInfoIntoDatabase(int reportTypeId) async {
    final lastReportNumber = await _uploadedReportTable.fetchLastNumber();

    print('lastReportNumber : $lastReportNumber');

    print('staff id : ${staff?.id}');

    await _uploadedReportTable.insert(UploadedReportDTO(
        number: lastReportNumber + 1,
        staffId: staff?.id,
        reportTypeId: reportTypeId));

    return lastReportNumber + 1;
  }
}
