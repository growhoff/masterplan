import 'dart:io';

import 'package:excel/excel.dart';

import 'package:file_picker/file_picker.dart';
import 'package:master_plan/data/repositories/supabase/dto2/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/detail_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/z_batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_stage_table.dart';

class ExcelStageLoadService {
  final _batchTable = ZBatchTable();
  final _stageTable = ZStageTable();
  final _operationTable = ZOperationTable();

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

        List<int> stagesIdList = [];
        List<int> operationsIdList = [];

        String? stageNumber = excel.tables[table]!.rows[1][4]?.value.toString();
        String? stageName = excel.tables[table]!.rows[1][5]?.value.toString();

        String? operationCode =
            excel.tables[table]!.rows[1][6]?.value.toString();
        String? operationNumber =
            excel.tables[table]!.rows[1][7]?.value.toString();
        String? operationName =
            excel.tables[table]!.rows[1][8]?.value.toString();

        int operationId = await _operationTable.insert(OperationDTO2(
            id: 0,
            number: operationNumber ?? '',
            name: operationName ?? '',
            code: operationCode ?? '',
            isready: false,
            transferId: []));

        print(
            'инсерт операцию: $operationCode, $operationNumber, $operationName');
        operationsIdList.add(operationId);
        for (int i = 2; i < excel.tables[table]!.maxRows; i++) {
          var row = excel.tables[table]!.rows;

          if (row[i][4]?.value != null) {
            int stageId = await _stageTable.insert(StageDTO2(
                id: 0,
                number: int.parse(stageNumber!),
                operationId: operationsIdList,
                name: stageName ?? '',
                isDistributed: false));

            print('инсерт этап $stageNumber, $stageName');
            print('операции: $operationsIdList');
            stagesIdList.add(stageId);
            operationsIdList.clear();
            stageNumber = row[i][4]?.value.toString();
            stageName = row[i][5]?.value.toString();
          }

          if (row[i][6]?.value != null) {
            operationCode = row[i][6]?.value.toString();
            operationNumber = row[i][7]?.value.toString();
            operationName = row[i][8]?.value.toString();
            print(
                'добавляю операцию: $operationCode, $operationNumber, $operationName');
            int operationId = await _operationTable.insert(OperationDTO2(
                id: 0,
                number: operationNumber ?? '',
                name: operationName ?? '',
                code: operationCode ?? '',
                isready: false,
                transferId: []));
            operationsIdList.add(operationId);
          }

          if (i == (excel.tables[table]!.maxRows - 1)) {
            print('инсерт этап $stageNumber, $stageName');
            int stageId = await _stageTable.insert(StageDTO2(
                id: 0,
                number: int.parse(stageNumber!),
                operationId: operationsIdList,
                name: stageName ?? '',
                isDistributed: false));
            print('операции: $operationsIdList');
            stagesIdList.add(stageId);
            operationsIdList.clear();
            stageNumber = row[i][4]?.value.toString();
            stageName = row[i][5]?.value.toString();

            await _batchTable.insert(BatchDTO2(
                id: 0,
                number: planNumber,
                name: planName,
                count: 0,
                code: code,
                technology: technologyNumber,
                order: 1,
                isready: false,
                stageId: stagesIdList));
          }
        }
      }
    }
  }
}
