import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto2/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/z_operation_table.dart';

import 'package:master_plan/domain/model/z_operation.dart';
import 'package:master_plan/domain/model/z_stage.dart';

import '../../../../../data/repositories/supabase/service/z_stage_table.dart';

part 'chief_check_state.dart';

class ChiefCheckCubit extends Cubit<ChiefCheckState> {
  ChiefCheckCubit() : super(const ChiefCheckState());

  final ZStageTable _stageTable = ZStageTable();
  final ZOperationTable _operationTable = ZOperationTable();

  final _stagesStream = ZStageTable().stream();

  Future<void> fetchStages()async{

    _stagesStream.listen((stages) async{

      List<ZStage> stagesList = [];
      for (var stage in stages){
        final stageDto = StageDTO2.fromMap(stage);
        final List<ZOperation> operationsList = [];
        final fetchedOperations = await _operationTable.selectListId(stageDto.operationId);
        for (var operation in fetchedOperations){
          final operationDto = OperationDTO2.fromMap(operation);
          operationsList.add(ZOperation(id: operationDto.id,
            number: operationDto.number,
            name: operationDto.name,
            code: operationDto.code,
            isready: operationDto.isready,
            transferList: [],
            transferListId: []));
        }
        stagesList.add(ZStage(
        id: stageDto.id,
        number: stageDto.number,
        name: stageDto.name,
        code: stageDto.code,
        operationList: operationsList,
        operationListId: stageDto.operationId,
      ));
      }
      emit(state.copyWith(stagesList: stagesList));
    });
  }

//   Future<void> fetchStages() async {
//     final fetchedStagesList = await _stageTable.select();
//
//     print(fetchedStagesList.length);
//     List<ZStage> stagesList = [];
//     List<ZOperation> operationsList = [];
//     for (var stage in fetchedStagesList) {
//       final StageDTO2 stageDto = StageDTO2.fromMap(stage);
//       final fetchedOperationsList =
//           await _operationTable.selectListId(stageDto.operationId);
//       operationsList = [];
//       for (var operation in fetchedOperationsList) {
//         final OperationDTO2 operationDto = OperationDTO2.fromMap(operation);
//         operationsList.add(ZOperation(
//             id: operationDto.id,
//             number: operationDto.number,
//             name: operationDto.name,
//             code: operationDto.code,
//             isready: operationDto.isready,
//             transferList: [],
//             transferListId: []));
//       }
//       stagesList.add(ZStage(
//         id: stageDto.id,
//         number: stageDto.number,
//         name: stageDto.name,
//         code: stageDto.code,
//         operationList: operationsList,
//         operationListId: stageDto.operationId,
//       ));
//     }
//     print(stagesList.length);
//     emit(state.copyWith(stagesList: stagesList));
//   }
// }


}
