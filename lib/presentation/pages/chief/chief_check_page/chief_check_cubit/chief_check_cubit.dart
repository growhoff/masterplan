import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/operation_table.dart';
import 'package:master_plan/domain/model/operation.dart';
import 'package:master_plan/domain/model/stage.dart';
import '../../../../../data/repositories/supabase/service/stage_table.dart';
part 'chief_check_state.dart';

class ChiefCheckCubit extends Cubit<ChiefCheckState> {
  ChiefCheckCubit() : super(const ChiefCheckState());

  final StageTable stageTable = StageTable();
  final OperationTable _operationTable = OperationTable();

  final _stagesStream = StageTable().stream();

  Future<void> fetchStages()async{

    _stagesStream.listen((stages) async{

      List<Stage> stagesList = [];
      for (var stage in stages){
        final stageDto = StageDTO.fromMap(stage);
        final List<Operation> operationsList = [];
        final fetchedOperations = await _operationTable.selectListId(stageDto.operationId);
        for (var operation in fetchedOperations){
          final operationDto = OperationDTO.fromMap(operation);
          operationsList.add(Operation(id: operationDto.id,
            number: operationDto.number,
            name: operationDto.name,
            code: operationDto.code,
            isready: operationDto.isready,
            transferList: [],
            transferListId: []));
        }
        stagesList.add(Stage(
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
//     final fetchedStagesList = await stageTable.select();
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
