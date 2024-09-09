import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/name_index.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/usecase/convert_dto_model.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/batch_to_stage.dart';
import '../model/item_id.dart';
import '../model/item_machine.dart';
import '../model/item_oper.dart';
import '../../../../../../data/repositories/supabase/service/chief_batch_table.dart';
import 'state.dart';
import 'package:collection/collection.dart';

class CubitReadyDetails extends Cubit<StateReadyDetails> {
  final tableOperations = OperatorOperationsTable();
  final distribStageTable = DistributionStageTable();
  final chiefBatchTable = ChiefBatchTable();
  final List<AreaMachine> listAreaMachine;

  CubitReadyDetails(this.listAreaMachine) : super(const StateReadyDetails()) {
    emit(state.copyWith(listAreaMachine: listAreaMachine));
    setListItemDrop();
    tableOperations.table
        .stream(primaryKey: ['id'])
        .inFilter('machine_id', listAreaMachine[state.activeArea].idListMachine)
        .listen((event) {})
        .onData((data) async {
          if (state.isActiveStream) await getQuere(data);
        });
  }

  Future<void> getQuere(List<Map<String, dynamic>>? data) async {
    emit(state.copyWith(isLoading: true));
    List<int> listId = [];
    for (var element in data!) {
      if (element['status_id'] as int == 6) listId.add(element['id']);
    }
    final quere = await tableOperations.selectListIdOrder(listId);
    List<OperatorOperationsDTO> readyList = [];
    for (var item in quere) {
      readyList.add(OperatorOperationsDTO.fromMap(item));
    }

    List<ItemOperReady> listB = [];
    var newMap = groupBy(readyList, (el) => el.optimalPart);
    newMap.forEach((key, value) {
      List<OperatorOperations> list = [];
      List<int> listId = [];
      for (var element in value) {
        list.add(ConvertDtoModel.convertToOperatorOperations(element));
        listId.add(element.id);
      }
      listB.add(ItemOperReady(
          idPath: key!,
          list: list,
          listId: listId,
          timeWorking: list.first.timeworking ?? 0));
    });

    List<ItemMachine> listMachine = [];
    // List<List<StatusNext>> statusList = [];
    for (var machine in listAreaMachine[state.activeArea].listMachine) {
      int timeWorking = 0;
      List<ItemOperReady> list = [];
      // List<StatusNext> intList = [];
      for (var operList in listB) {
        if (operList.list.first.machine!.id == machine.id) {
          list.add(operList);
          timeWorking += operList.timeWorking;
          // intList.add(StatusNext(status: 0, count: 1, comment: ''));
        }
      }
      listMachine.add(ItemMachine(machine: machine, listOper: list, time: timeWorking ~/ 60));
      // statusList.add(intList);
    }
    emit(state.copyWith(listMachine: listMachine, isLoading: false));
  }

  void setListItemDrop() {
    List<NameIndex> listItemArea = [];
    List<NameIndex> listItemMachine = [];
    if (state.listAreaMachine.isNotEmpty) {
      for (var i = 0; i < state.listAreaMachine.length; i++) {
        listItemArea.add(NameIndex(name: state.listAreaMachine[i].area.name, index: i));
      }

      if (state.listAreaMachine[state.activeArea].listMachine.isNotEmpty) {
        var listMachine = state.listAreaMachine[state.activeArea].listMachine;
        for (var i = 0; i < listMachine.length; i++) {
          listItemMachine.add(NameIndex(name: listMachine[i].name, index: i));
        }
      }
    }
    emit(state.copyWith(listItemArea: listItemArea, listItemMachine: listItemMachine));
  }

  void setActiveMachine(int index) {
    emit(state.copyWith(activeMachine: index));
  }

  Future<void> setActiveArea(int index) async{
    emit(state.copyWith(activeArea: index, activeMachine: 0, listMachine: []));
    setListItemDrop();
    final queue = await tableOperations.selectListMachineId(state.listAreaMachine[index].idListMachine);
    await getQuere(queue);
  }

  Future<void> toggleBrak(ItemOperReady oper, String countStr, String comment) async{
    int count = int.parse(countStr);
    List<int> listIdOperBrak = [];
    List<OperatorOperations> listOperBrak = [];
    for (var i = 0; i < count; i++) {
      listIdOperBrak.add(oper.listId[i]);
      listOperBrak.add(oper.list[i]);
    }
    //меняем статус по этим id в брак
    await tableOperations.updateMasterBrakListCount(listIdOperBrak, comment);
    await updateStatusBatchChiefBatchStage(listOperBrak, false);
  }


  Future<void> toggleModific(ItemOperReady oper, String countStr, String comment) async{
    int count = int.parse(countStr);
    List<int> operList = [];
    for (var i = 0; i < count; i++) {
      operList.add(oper.listId[i]);
    }
    await tableOperations.updateMasterModificateListCount(operList, comment);
  }

  Future<void> toggleReady(ItemOperReady oper) async{
      emit(state.copyWith(isActiveStream: false));
      //тут выгрузка
      await tableOperations.updateMasterStatisticReadyList(oper.listId);
      await updateStatusBatchChiefBatchStage(oper.list, true);
      await checkIsDetailReady(listOperatorOperations: oper.list);
      emit(state.copyWith(isActiveStream: true));
  }

  List<ItemId> getListIdFromQueue(List<Map<String, dynamic>> data) {
    List<ItemId> listB = [];
    var newMap = groupBy(data, (el) => el['chief_batch_id']);
    newMap.forEach((key, value) {
      List<int> listId = [];
      for (var element in value) {
        if (element['status_id'] == 2 || element['status_id'] == 3 || element['status_id'] == 4) listId.add(element['id']);
      }
      listB.add(ItemId(list: listId, idBatchId: key));
    });
    return listB;
  }

  // проверка на готовность детали
  Future<void> checkIsDetailReady({required List<OperatorOperations> listOperatorOperations}) async {
    List<int> listId = [];
    for (var element in listOperatorOperations) {listId.add(element.chiefBatchId!);}
    //new
    final tableStage = DistributionStageTable();
    //по chief_batch_id выгрузку. меняем статус status_id на 3. сравнение со stage_id
    //надо сделать что б при выгрузке у мастера еще в таблице distribution_stage статус менялся
    //если операция последняя в этапе и она готова то статус меняется на готово(3)
    final chiefOperationTable = ChiefOperationTable();
    final chiefBatchTable = ChiefBatchTable();
    // получает лист операциюй в деталях
    final litOperationInBatch = await chiefOperationTable.fetchLastOperationInBatchList(listChiefBatchId: listId);
    List<BatchToStage> listBatchToStage = [];
    var groupChiefBatch = groupBy(litOperationInBatch, (el) => el['chief_batch_id']);
    groupChiefBatch.forEach((keyBatch, valueChief) {
      var groupStage = groupBy(valueChief, (el) => el['stage_id']);
      List<ChiefOperationDto> listDto = [];
      groupStage.forEach((key, valueStage) {
        final model = ChiefOperationDto.fromMap(valueStage.last);
        listDto.add(model);
      });
      listBatchToStage.add(BatchToStage(chiefBatchId: keyBatch, listDto: listDto));
    });
    List<int> listStageId = [];
    // List<int> listIdOrder = [];
    List<ChiefOperationDto> lastIdStage = [];
    List<ChiefOperationDto> lastIdBatch = [];
    for (var i = 0; i < listOperatorOperations.length; i++) {
      for (var batchToStage in listBatchToStage) {
        if (listOperatorOperations[i].chiefBatchId == batchToStage.chiefBatchId) {
          //проверка конечных stage
          for (var element in batchToStage.listDto) {
            if (element.operationId == listOperatorOperations[i].operation.id) {
              lastIdStage.add(element);
              listStageId.add(listOperatorOperations[i].stage.id);
              // listIdOrder.add(listOperatorOperations[i].batch.orderId!);
            }
          }
          //проверка на конец
          if (batchToStage.listDto.last.operationId == listOperatorOperations[i].operation.id) {lastIdBatch.add(batchToStage.listDto.last);}
        }
      }
    }
    // final orderTable = OrderTable();
    final batchTable = BatchTable();

    List<int> listStagechiefBatchIdLast = [];
    for (var stage in lastIdStage) {listStagechiefBatchIdLast.add(stage.chiefBatchId);}
    for (var i = 0; i < listStageId.length; i++) {
      await tableStage.updateStatusReady(listStageId[i], listStagechiefBatchIdLast[i]);
    }
    
    List<int> listChiefBatchLast = [];
    List<int> listIdBatch = [];
    for (var batch in lastIdBatch) {
      listChiefBatchLast.add(batch.chiefBatchId);
      listIdBatch.add(batch.id);
    }
    await chiefBatchTable.updateStatusReady(listChiefBatchLast);
    await batchTable.updateStatusReady(listIdBatch);
    // await orderTable.updateStatusReady(listIdOrder);
  }

  Future<void> updateStatusBatchChiefBatchStage(List<OperatorOperations> listOperatorOperations, bool isReady)async{
      List<int> listIdBatch = [];
      List<int> listIdChiefBatch = [];
      for (var e in listOperatorOperations) {
        listIdBatch.add(e.batch.id);
        listIdChiefBatch.add(e.chiefBatchId!);
      }
      if (!isReady) {
        await chiefBatchTable.updateStatusBrak(listIdChiefBatch);
        for (var e in listOperatorOperations) {
          {await distribStageTable.updateStatusBrak(e.stage.id, e.chiefBatchId!);}
        }
      }
  }
}
