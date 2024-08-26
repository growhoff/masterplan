import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
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
import 'package:master_plan/presentation/pages/master/pages/analytics_page/analytics_operation_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../domain/model/distribution_stage.dart';
import '../../../../presentation/pages/chief/chief_analytics_page/chief_stage_report_model.dart';
import '../../../../presentation/pages/chief/chief_analytics_page/statistics_stage_model.dart';
import '../../supabase/dto/batch_dto.dart';
import '../../supabase/dto/chief_operation_dto.dart';
import '../../supabase/dto/operation_archive_dto.dart';
import '../../supabase/dto/operation_dto.dart';
import '../../supabase/dto/stage_archive_dto.dart';
import '../../supabase/dto/stage_dto.dart';
import '../../supabase/dto/transfer_archive_dto.dart';
import '../../supabase/service/batch_archive_table.dart';
import '../../supabase/service/batch_table.dart';
import '../../supabase/service/operation_table.dart';
import '../../supabase/service/stage_table.dart';
import '../../supabase/service/transfer_archive_table.dart';

class ExcelService {
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

  List<ChiefOperationDto> chiefOperationsList = [];
  List<int> stagesIdForDistributionStagesList = [];
  List<int> chiefDistributionsOperationsIdList = [];
  List<int> batchesIdsList = [];
  List<BatchDTO> batchesDtosList = [];
  int serviceBatchId = 0;
  int serviceQuantity = 0;

  final CellStyle _cellHeaderStyle = CellStyle(
    textWrapping: TextWrapping.WrapText,
    bold: true,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
    topBorder: Border(borderStyle: BorderStyle.Thin),
    bottomBorder: Border(borderStyle: BorderStyle.Thin),
  );

  final CellStyle _cellTextStyle = CellStyle(
    textWrapping: TextWrapping.WrapText,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
    topBorder: Border(borderStyle: BorderStyle.Thin),
    bottomBorder: Border(borderStyle: BorderStyle.Thin),
  );

  final CellStyle _cellDefectTextStyle = CellStyle(
    backgroundColorHex: ExcelColor.red100,
    textWrapping: TextWrapping.WrapText,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
    topBorder: Border(borderStyle: BorderStyle.Thin),
    bottomBorder: Border(borderStyle: BorderStyle.Thin),
  );

  final CellStyle _cellModificationTextStyle = CellStyle(
    backgroundColorHex: ExcelColor.yellow50,
    textWrapping: TextWrapping.WrapText,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
    topBorder: Border(borderStyle: BorderStyle.Thin),
    bottomBorder: Border(borderStyle: BorderStyle.Thin),
  );

  final CellStyle _cellFocusTextStyle = CellStyle(
    backgroundColorHex: ExcelColor.orange100,
    textWrapping: TextWrapping.WrapText,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
    topBorder: Border(borderStyle: BorderStyle.Thin),
    bottomBorder: Border(borderStyle: BorderStyle.Thin),
  );

  static const List<String> stagesHeaderList = [
    '№ п/п',
    '№ Этапа',
    '№ чертежа, наименование',
    'Код детали',
    'Кол-во деталей в партии',
    'Добавлено деталей',
    'Общее кол-во деталей',
    'Общее кол-во полуфабрикатов в работе (в этапе)',
    'Недостающие заготовки',
    'кол-во выполненных деталей (в этапе)',
    '% выполненных деталей',
    'Кол-во бракованных деталей (в этапе)',
    'Кол-во выполненных операций (в этапе)',
    'Общее кол-во операций (в этапе)',
    '% вып.',
  ];

  static const List<String> operationsHeaderList = [
    '№ п/п',
    '№ Этапа',
    '№ чертежа, наименование',
    'Общее кол-во деталей',
    'Код детали',
    'Наименование операции',
    '№ оп.',
    'Кол-во выполненных деталей',
    '% выполнено',
    'В работе',
    'Брак',
    'Доработка'
  ];

  static const List<String> readyOperationsHeaderList = [
    '№ этапа',
    '№ чертежа',
    'Наименование чертежа',
    'наименование операции',
    'наименование перехода',
    'T план',
    'Т факт',
    'Оборудование',
    'Инв. №',
    'ФИО оператора',
    'Код',
    'Дата начала',
    'Время начала',
    'Дата окончания',
    'Время окончания',
    'Смена',
    '№ участка',
    'Брак',
    'Доработка',
    'Кол-во',
    'Комментарий'
  ];

  static const List<String> totalNumberReadyOperationsReportHeadersList = [
    '№ этапа',
    'Чертежный номер',
    'Наименование чертежа',
    'Наименование операции',
    'Код',
    'Брак',
    'Доработка',
    'Кол-во',
  ];

  Future dispatcherLoadOrder() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    var path = pickedFile?.paths.first;

    if (pickedFile != null) {
      var bytes = File(path!).readAsBytesSync();

      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
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
            isready: false));

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
            isready: false);

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
        int transferTimeSH = int.parse(
            (excel.tables[table]!.rows[3][17]!.value ?? 0).toString());

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

        String transferCode =
            excel.tables[table]!.rows[3][14]!.value.toString();
        String? transferName =
            excel.tables[table]!.rows[3][15]!.value.toString();

        await _transferTable.insert(TransferDTO(
            id: 0,
            name: transferName,
            code: transferCode,
            timesh: transferTimeSH,
            operationId: operationId));
        print('insert transfer $transferCode $transferName');

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
                isready: false));

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
                isready: false);

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
    }
    finishDispatcherOrderLoading();
  }

  Future finishDispatcherOrderLoading() async {
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
          isready: false,
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
            (excel.tables[table]!.rows[1][16]!.value ?? 0).toString()));
        int transferTimeSH = int.parse(
            (excel.tables[table]!.rows[1][17]!.value ?? 0).toString());

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

        if (excel.tables[table]!.rows[1][9]?.value != null) {
          transferCode = excel.tables[table]!.rows[3][14]!.value.toString();
          transferName = excel.tables[table]!.rows[3][15]!.value.toString();
          _transferArchiveTable.insert(TransferArchiveDto(
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
            }
            operationTimeSH = int.parse(row[i][17]!.value.toString());


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
          stageColumnIndex < stagesHeaderList.length;
          stageColumnIndex++) {
        if (stageRowIndex == 1) {
          final cell = stageExcel.cell(CellIndex.indexByColumnRow(
              columnIndex: stageColumnIndex, rowIndex: stageRowIndex));
          cell.value = TextCellValue(stagesHeaderList[stageColumnIndex]);
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
            operationColumnIndex < operationsHeaderList.length;
            operationColumnIndex++) {
          if (operationRowIndex == 0) {
            final cell = operationsExcel.cell(CellIndex.indexByColumnRow(
                columnIndex: operationColumnIndex,
                rowIndex: operationRowIndex));
            cell.value =
                TextCellValue(operationsHeaderList[operationColumnIndex]);
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
              readyOperationsColumnIndex < readyOperationsHeaderList.length;
              readyOperationsColumnIndex++) {
            if (readyOperationRowIndex == 0) {
              final cell = readyOperationsExcel.cell(CellIndex.indexByColumnRow(
                  columnIndex: readyOperationsColumnIndex,
                  rowIndex: readyOperationRowIndex));
              cell.value = TextCellValue(
                  readyOperationsHeaderList[readyOperationsColumnIndex]);
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
          stageColumnIndex < stagesHeaderList.length;
          stageColumnIndex++) {
        if (stageRowIndex == 0) {
          final cell = stageExcel.cell(CellIndex.indexByColumnRow(
              columnIndex: stageColumnIndex, rowIndex: 1));

          cell.value = TextCellValue(stagesHeaderList[stageColumnIndex]);
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
          stageColumnIndex < stagesHeaderList.length;
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
            operationColumnIndex < operationsHeaderList.length;
            operationColumnIndex++) {
          if (operationRowIndex == 0) {
            final cell = operationsExcel.cell(CellIndex.indexByColumnRow(
                columnIndex: operationColumnIndex,
                rowIndex: operationRowIndex));
            cell.value =
                TextCellValue(operationsHeaderList[operationColumnIndex]);
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
      {required List<AnalyticsOperationModel> analyticsOperationsList}) async {
    var excel = Excel.createExcel();
    excel.rename('Sheet1', 'Выполненные операции');

    Sheet readyOperationsExcel = excel['Выполненные операции'];

    for (int operationRowIndex = 0;
        operationRowIndex < analyticsOperationsList.length;
        operationRowIndex++) {
      for (int operationColumnIndex = 0;
          operationColumnIndex < readyOperationsHeaderList.length;
          operationColumnIndex++) {
        if (operationRowIndex == 0) {
          final cell = readyOperationsExcel.cell(CellIndex.indexByColumnRow(
              columnIndex: operationColumnIndex, rowIndex: 0));

          cell.value =
              TextCellValue(readyOperationsHeaderList[operationColumnIndex]);
          cell.cellStyle = _cellHeaderStyle;
        }
        final cell = readyOperationsExcel.cell(CellIndex.indexByColumnRow(
            columnIndex: operationColumnIndex,
            rowIndex: operationRowIndex + 1));

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
                analyticsOperationsList[operationRowIndex].timePlan);
            cell.cellStyle = _cellFocusTextStyle;
          case 6:
            cell.value = TextCellValue(
                analyticsOperationsList[operationRowIndex].timeFact);
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
      final fileName = '${downloadsDirectoryPath}/Выполненные операции.xlsx';

      File(fileName).writeAsBytes(fileBytes!);

      print('вывелось');
      return downloadsDirectoryPath ?? '';
    }

    return '';
  }

  Future<String> uploadTotalNumberReadyOperationsReport(
      {required List<AnalyticsOperationModel> analyticsOperationsList}) async {
    var excel = Excel.createExcel();
    excel.rename('Sheet1', 'Отчет суммарного количества выполненных операций');

    Sheet totalNumberReadyOperationsExcel =
        excel['Отчет суммарного количества выполненных операций'];

    for (int operationRowIndex = 0;
        operationRowIndex < analyticsOperationsList.length;
        operationRowIndex++) {
      for (int operationColumnIndex = 0;
          operationColumnIndex <
              totalNumberReadyOperationsReportHeadersList.length;
          operationColumnIndex++) {
        if (operationRowIndex == 0) {
          final cell = totalNumberReadyOperationsExcel.cell(
              CellIndex.indexByColumnRow(
                  columnIndex: operationColumnIndex, rowIndex: 0));

          cell.value = TextCellValue(
              totalNumberReadyOperationsReportHeadersList[
                  operationColumnIndex]);
          cell.cellStyle = _cellHeaderStyle;
        }
        final cell = totalNumberReadyOperationsExcel.cell(
            CellIndex.indexByColumnRow(
                columnIndex: operationColumnIndex,
                rowIndex: operationRowIndex + 1));

        switch (operationColumnIndex) {
          case 0:
            cell.value = TextCellValue(
                '${analyticsOperationsList[operationRowIndex].batch.order?.number}.${analyticsOperationsList[operationRowIndex].batch.number}.${analyticsOperationsList[operationRowIndex].stage.number}');
            cell.cellStyle = _cellTextStyle;
          case 1:
            cell.value = TextCellValue(
                '${analyticsOperationsList[operationRowIndex].detailNumber}');
            cell.cellStyle = _cellHeaderStyle;

          case 2:
            cell.value = TextCellValue(
                '   ${analyticsOperationsList[operationRowIndex].detailName}');
            cell.cellStyle = _cellHeaderStyle;

          case 3:
            cell.value = TextCellValue(
                '${analyticsOperationsList[operationRowIndex].operationNumber} ${analyticsOperationsList[operationRowIndex].operationName}');
            cell.cellStyle = _cellTextStyle;
          case 4:
            cell.value = TextCellValue(
                '${analyticsOperationsList[operationRowIndex].batch.code}.${analyticsOperationsList[operationRowIndex].code}');
            cell.cellStyle = _cellTextStyle;
          case 5:
            cell.value = TextCellValue(
                '${analyticsOperationsList[operationRowIndex].defectQuantity}');
            cell.cellStyle = _cellDefectTextStyle;
          case 6:
            cell.value = TextCellValue(
                '${analyticsOperationsList[operationRowIndex].modificationQuantity}');
            cell.cellStyle = _cellModificationTextStyle;
          case 7:
            cell.value = TextCellValue(
                '${analyticsOperationsList[operationRowIndex].quantity}');
            cell.cellStyle = _cellFocusTextStyle;
        }
      }
    }

    var fileBytes = excel.save();

    final granted = await requestPermissions();
    if (granted) {
      String? downloadsDirectoryPath =
          (await DownloadsPath.downloadsDirectory())?.path;
      print(downloadsDirectoryPath);
      final fileName =
          '${downloadsDirectoryPath}/Отчет суммарного количества выполненных операций.xlsx';

      File(fileName).writeAsBytes(fileBytes!);

      print('вывелось');
      return downloadsDirectoryPath ?? '';
    }

    return '';
  }
}
