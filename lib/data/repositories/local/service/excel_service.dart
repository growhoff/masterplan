import 'dart:io';

import 'package:excel/excel.dart';

import 'package:file_picker/file_picker.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/transfer_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/transfer_table.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/streams.dart';

import '../../../../presentation/pages/chief/statistics_page/statistics_stage_model.dart';
import '../../supabase/dto/batch_dto.dart';
import '../../supabase/dto/operation_dto.dart';
import '../../supabase/dto/stage_dto.dart';
import '../../supabase/service/batch_table.dart';
import '../../supabase/service/operation_table.dart';
import '../../supabase/service/stage_table.dart';

class ExcelService {
  final _batchTable = BatchTable();
  final _stageTable = StageTable();
  final _operationTable = OperationTable();
  final _chiefOperationsTable = ChiefOperationsTable();
  final _transferTable = TransferTable();

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
    'кол-во выпыполненных деталей (в этапе)',
    '% выполненных деталей',
    'Кол-во бракованных деталей (в этапе)',
    'Кол-во выполненных операций (в этапе)',
    'Общее кол-во операций (в этапе)',
    '% вып.',
  ];

  Future<void> stageExcelFunction() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    var path = pickedFile?.paths.first;

    if (pickedFile != null) {
      var bytes = File(path!).readAsBytesSync();

      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        String code = excel.tables[table]!.rows[1][0]!.value
            .toString(); // присваивается значение первой ячейки столбца номер чертежа

        String technologyNumber =
            excel.tables[table]!.rows[1][1]!.value.toString();

        String planNumber = excel.tables[table]!.rows[1][2]!.value.toString();

        String planName = excel.tables[table]!.rows[1][3]!.value.toString();

        int quantity =
            int.parse(excel.tables[table]!.rows[1][13]!.value.toString());

        int batchId = await _batchTable.insert(BatchDTO(
          id: 0,
          number: planNumber,
          name: planName,
          count: quantity,
          code: code,
          technology: technologyNumber,
          order: 1,
          isready: false,
          packageId: 0,
        ));

        String? stageNumber = excel.tables[table]!.rows[1][4]?.value.toString();
        String? stageName = excel.tables[table]!.rows[1][5]?.value.toString();

        int stageId = await _stageTable.insert(StageDTO(
            id: 0,
            number: int.parse(stageNumber!),
            name: stageName ?? '',
            isdistributed: false,
            areaId: 0,
            batchId: batchId));

        print('инсерт stage: $stageNumber,  $stageName, $stageId');

        String? operationCode =
            excel.tables[table]!.rows[1][6]?.value.toString();
        String? operationNumber =
            excel.tables[table]!.rows[1][7]?.value.toString();
        String? operationName =
            excel.tables[table]!.rows[1][8]?.value.toString();
        int timepz =
            int.parse(excel.tables[table]!.rows[1][11]!.value.toString());

        int operationId = await _operationTable.insert(OperationDTO(
          id: 0,
          number: operationNumber ?? '',
          name: operationName ?? '',
          code: operationCode ?? '',
          timepz: timepz,
          stageId: stageId,
        ));

        print(
            'инсерт операцию: $operationCode, $operationNumber, $operationName');

        await _chiefOperationsTable.insert(ChiefOperationsDTO(
            id: 0,
            operationId: operationId,
            stageId: stageId,
            stage: StageDTO.empty,
            operation: OperationDTO.empty,
            batchId: batchId,
            batch: BatchDTO.empty,
            quantity: quantity));

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
            stageNumber = row[i][4]?.value.toString();
            stageName = row[i][5]?.value.toString();
            stageId = await _stageTable.insert(StageDTO(
                id: 0,
                number: int.parse(stageNumber!),
                name: stageName ?? '',
                isdistributed: false,
                areaId: 0,
                batchId: batchId));

            print('инсерт этап $stageNumber, $stageName, $stageId');
          }

          if (row[i][6]?.value != null) {
            operationCode = row[i][6]?.value.toString();
            operationNumber = row[i][7]?.value.toString();
            operationName = row[i][8]?.value.toString();
            if (row[i][11]?.value != null) {
              timepz = int.parse(row[i][11]!.value.toString());
            }
            print(
                'добавляю операцию: $operationCode, $operationNumber, $operationName');
            operationId = await _operationTable.insert(OperationDTO(
              id: 0,
              number: operationNumber ?? '',
              name: operationName ?? '',
              code: operationCode ?? '',
              timepz: timepz,
              stageId: stageId,
            ));
            await _chiefOperationsTable.insert(ChiefOperationsDTO(
                operationId: operationId,
                stageId: stageId,
                stage: StageDTO.empty,
                operation: OperationDTO.empty,
                batchId: batchId,
                batch: BatchDTO.empty,
                quantity: quantity,
                id: 0));
          }

          if (row[i][9]?.value != null) {
            transferCode = row[i][9]!.value.toString();
            transferName = row[i][10]?.value.toString();
            _transferTable.insert(TransferDTO(
                id: 0,
                number: 0,
                name: transferName ?? '',
                code: transferCode,
                timesh: 0,
                operationId: operationId));
            print('инсерт переход для операции $operationId : $transferName');
          }
        }
      }
    }
  }

  Future<void> uploadReport(
      {required List<StatisticsStageModel> stagesList}) async {
    var excel = Excel.createExcel();
    excel.rename('Sheet1', 'Этапы');

    Sheet stageExcel = excel['Этапы'];

    stageExcel.merge(
        CellIndex.indexByString('J1'), CellIndex.indexByString('L1'),
        customValue: TextCellValue('детали'));

    (stageExcel.cell(CellIndex.indexByString('J1'))).cellStyle =
        CellStyle(bold: true, horizontalAlign: HorizontalAlign.Center);

    stageExcel.merge(
        CellIndex.indexByString('M1'), CellIndex.indexByString('O1'),
        customValue: TextCellValue('операции'));

    (stageExcel.cell(CellIndex.indexByString('M1'))).cellStyle =
        CellStyle(bold: true, horizontalAlign: HorizontalAlign.Center);

    List<CellValue> headerList = [];
    for (int rowIndex = 0; rowIndex < stagesList.length; rowIndex++) {
      for (int columnIndex = 0;
          columnIndex < stagesHeaderList.length;
          columnIndex++) {
        final cell = stageExcel.cell(
            CellIndex.indexByColumnRow(columnIndex: columnIndex, rowIndex: 1));
        cell.value = TextCellValue(stagesHeaderList[columnIndex]);
        cell.cellStyle = CellStyle(
          textWrapping: TextWrapping.WrapText,
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
          verticalAlign: VerticalAlign.Center,
        );
      }

      var fileBytes = excel.save();
      var directory = await getDownloadsDirectory();

      print(directory?.path);
      final fileName = '${directory?.path}/Отчет о производстве.xlsx';

      File(fileName).writeAsBytes(fileBytes!);

      print('вывелось');
    }
  }
}
