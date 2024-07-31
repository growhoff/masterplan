import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/batch_to_stage.dart';
import '../model/item_id.dart';
import '../model/item_machine.dart';
import '../model/item_oper.dart';
import '../model/status_next.dart';
import '../../../../../../data/repositories/supabase/service/chief_batch_table.dart';
import 'state.dart';
import 'package:collection/collection.dart';

class CubitReadyDetails extends Cubit<StateReadyDetails> {
  final List<Machine>? machineList;
  final List<int> machineIdList;
  final tableOperations = OperatorOperationsTable();

  CubitReadyDetails(this.machineList, this.machineIdList)
      : super(const StateReadyDetails()) {
    tableOperations.table
        .stream(primaryKey: ['id'])
        .inFilter('machine_id', machineIdList)
        .listen((event) {})
        .onData((data) async {
          await getQuere(data);
        });
  }

  Future<void> getQuere(List<Map<String, dynamic>>? data) async {
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
        list.add(convertDto(element));
        listId.add(element.id);
      }
      listB.add(ItemOperReady(
          idPath: key!,
          list: list,
          listId: listId,
          timeWorking: list.first.timeworking ?? 0));
    });

    List<ItemMachine> listMachine = [];
    List<List<StatusNext>> statusList = [];
    for (var machine in machineList!) {
      int timeWorking = 0;
      List<ItemOperReady> list = [];
      List<StatusNext> intList = [];
      for (var operList in listB) {
        if (operList.list.first.machine!.id == machine.id) {
          list.add(operList);
          timeWorking += operList.timeWorking;
          intList.add(StatusNext(status: 0, count: 1, comment: ''));
        }
      }
      listMachine.add(ItemMachine(
          machine: machine, listOper: list, time: timeWorking ~/ 60));
      statusList.add(intList);
    }
    emit(state.copyWith(listMachine: listMachine, statusList: statusList));
  }

  OperatorOperations convertDto(OperatorOperationsDTO dto) {
    return OperatorOperations(
      id: dto.id,
      area: dto.area!,
      operation: dto.operation,
      stage: dto.stage!,
      timeplan: dto.timeplan ?? 0,
      timeFirstStart: dto.timeFirstStart ?? 0,
      timestart: dto.timestart,
      timestop: dto.timestop,
      timeworking: dto.timeworking,
      chiefBatchId: dto.chiefBatchId,
      chiefOperationId: dto.chiefOperationId,
      optimalPart: dto.optimalPart,
      status: Status(id: dto.status.id, name: dto.status.name),
      batch: Batch(
          id: dto.batch.id,
          number: dto.batch.number,
          name: dto.batch.name,
          count: dto.batch.count,
          code: dto.batch.code,
          orderId: dto.batch.orderId,
          technology: dto.batch.technology,
          isready: dto.batch.isready,
          numberRS: dto.batch.numberRS),
      order: dto.order,
      machine: Machine(
          id: dto.machine!.id,
          isActivated: dto.machine!.isActivated,
          inventoryNumber: dto.machine!.inventoryNumber,
          name: dto.machine!.name,
          areaId: dto.areaId),
    );
  }

  void setActivePage(int index) {
    emit(state.copyWith(activePage: index));
  }

  void toggleBrak(int indexOper, String countStr, String comment) {
    int count = int.parse(countStr);
    int length =
        state.listMachine![state.activePage].listOper[indexOper].list.length;
    if (count > length) {
      count = length;
    }
    if (count < 0) {
      count = 0;
    }
    List<List<StatusNext>> l = [...state.statusList];
    int it = l[state.activePage][indexOper].status;
    if (it == 0 || it == 2) {
      it = 1;
    } else {
      it = 0;
    }
    List<StatusNext> item = l[state.activePage];
    item.removeAt(indexOper);
    item.insert(
        indexOper, StatusNext(status: it, count: count, comment: comment));
    l.removeAt(state.activePage);
    l.insert(state.activePage, item);
    emit(state.copyWith(statusList: l, count: state.count + 1));
  }

  void toggleModific(int indexOper, String countStr, String comment) {
    int count = int.parse(countStr);
    int length =
        state.listMachine![state.activePage].listOper[indexOper].list.length;
    if (count > length) {
      count = length;
    }
    if (count < 0) {
      count = 0;
    }
    List<List<StatusNext>> l = [...state.statusList];
    int it = l[state.activePage][indexOper].status;
    if (it == 0 || it == 1) {
      it = 2;
    } else {
      it = 0;
    }
    List<StatusNext> item = l[state.activePage];
    item.removeAt(indexOper);
    item.insert(
        indexOper, StatusNext(status: it, count: count, comment: comment));
    l.removeAt(state.activePage);
    l.insert(state.activePage, item);
    emit(state.copyWith(statusList: l, count: state.count + 1));
  }

  Future<void> updateOperation() async {
    final table = OperatorOperationsTable();
    final chiefBatchTable = ChiefBatchTable();
    final listOper = state.listMachine![state.activePage].listOper;
    if (listOper.isNotEmpty) {
      final listStatus = state.statusList[state.activePage];
      final List<int> listIdStatusReady = [];
      final List<OperatorOperations> listChiefBatchId = [];
      // final List<int> listChiefOperationId = [];
      for (var i = 0; i < listOper.length; i++) {
        //доработка
        if (listStatus[i].status == 2) {
          List<int> listSt2 = [];
          int count = listStatus[i].count;
          for (var e in listOper[i].list) {
            if (count == 0) {
              listIdStatusReady.add(e.id);
              listChiefBatchId.add(e);
            } else {
              listSt2.add(e.id);
              count--;
            }
          }
          await table.updateMasterModificateListCount(
              listSt2, listStatus[i].comment);
        }

        //брак
        if (listStatus[i].status == 1) {
          List<int> listSt1 = [];
          int count = listStatus[i].count;

          for (var j = 0; j < listOper[i].list.length; j++) {
            if (count == 0) {
              listIdStatusReady.add(listOper[i].listId[j]);
              listChiefBatchId.add(listOper[i].list[j]);
            } else {
              listSt1.add(listOper[i].listId[j]);
              count--;
            }
          }
          //меняем статус по этим id в брак
          await table.updateMasterBrakListCount(listSt1, listStatus[i].comment);
          List<OperatorOperations> chOperId =
              listOper[i].list.getRange(0, listStatus[i].count).toList();
          List<int> chId = [];
          for (var e in chOperId) {
            chId.add(e.chiefBatchId!);
          }
          await chiefBatchTable.updateChiefBatchStatusToDefectList(
              chiefBatchId: chId);
        }

        //готово
        if (listStatus[i].status == 0) {
          listIdStatusReady.addAll(listOper[i].listId);
          for (var element in listOper[i].list) {
            listChiefBatchId.add(element);
          }
        }
      }
      //тут выгрузка
      checkIsDetailReady(listChiefBatch: listChiefBatchId);
      await table.updateMasterStatisticReadyList(listIdStatusReady);
    }
    List<ItemMachine> listMachine = state.listMachine!;
    List<List<StatusNext>> listStatus = state.statusList;
    listStatus[state.activePage].clear();
    listMachine[state.activePage].listOper.clear();
    emit(state.copyWith(
        listMachine: listMachine,
        statusList: listStatus,
        count: state.count + 1));
  }

  List<ItemId> getListIdFromQueue(List<Map<String, dynamic>> data) {
    List<ItemId> listB = [];
    var newMap = groupBy(data, (el) => el['chief_batch_id']);
    newMap.forEach((key, value) {
      List<int> listId = [];
      for (var element in value) {
        if (element['status_id'] == 2 ||
            element['status_id'] == 3 ||
            element['status_id'] == 4) listId.add(element['id']);
      }
      listB.add(ItemId(list: listId, idBatchId: key));
    });

    return listB;
  }

  // проверка на готовность детали
  Future<void> checkIsDetailReady(
      {required List<OperatorOperations> listChiefBatch}) async {
    List<int> listId = [];
    for (var element in listChiefBatch) {
      listId.add(element.chiefBatchId!);
    }
    //new
    final tableStage = DistributionStageTable();
    //по chief_batch_id выгрузку. меняем статус status_id на 3. сравнение со stage_id
    //надо сделать что б при выгрузке у мастера еще в таблице distribution_stage статус менялся
    //если операция последняя в этапе и она готова то статус меняется на готово(3)
    final chiefOperationTable = ChiefOperationTable();
    final chiefBatchTable = ChiefBatchTable();
    // получает лист операциюй в деталях
    final litOperationInBatch = await chiefOperationTable
        .fetchLastOperationInBatchList(listChiefBatchId: listId);
    List<BatchToStage> listBatchToStage = [];
    var groupChiefBatch =
        groupBy(litOperationInBatch, (el) => el['chief_batch_id']);
    groupChiefBatch.forEach((keyBatch, valueChief) {
      var groupStage = groupBy(valueChief, (el) => el['stage_id']);
      List<ChiefOperationDto> listDto = [];
      groupStage.forEach((key, valueStage) {
        final model = ChiefOperationDto.fromMap(valueStage.last);
        listDto.add(model);
      });
      listBatchToStage
          .add(BatchToStage(chiefBatchId: keyBatch, listDto: listDto));
    });
    List<int> listStageId = [];
    List<ChiefOperationDto> lastIdStage = [];
    List<ChiefOperationDto> lastIdBatch = [];
    for (var i = 0; i < listChiefBatch.length; i++) {
      for (var batchToStage in listBatchToStage) {
        if (listChiefBatch[i].chiefBatchId == batchToStage.chiefBatchId) {
          //проверка конечных stage
          for (var element in batchToStage.listDto) {
            if (element.operationId == listChiefBatch[i].operation.id) {
              lastIdStage.add(element);
              listStageId.add(listChiefBatch[i].stage.id);
            }
          }
          //проверка на конец
          if (batchToStage.listDto.last.operationId ==
              listChiefBatch[i].operation.id) {
            lastIdBatch.add(batchToStage.listDto.last);
          }
        }
      }
    }

    // //создаём список с последними операциями и заносим их соотвественно
    // List<ChiefOperationDto> listLast = [];
    // int chifBatch = litOperationInBatch.first['chief_batch_id'];
    // for (var i = 0; i < litOperationInBatch.length; i++) {
    //   final model = ChiefOperationDto.fromMap(litOperationInBatch[i]);
    //   if (i == litOperationInBatch.length - 1){
    //     listLast.add(ChiefOperationDto.fromMap(litOperationInBatch[i]));
    //   }
    //   else{
    //     if (model.chiefBatchId != chifBatch){
    //       listLast.add(ChiefOperationDto.fromMap(litOperationInBatch[i-1]));
    //       chifBatch = model.chiefBatchId;
    //     }
    //   }

    // }
    // // final lastOperationInBatchDto = ChiefOperationDto.fromMap(fetchedLastOperationInBatch);
    // List<int> listChiefBatchLast = [];
    // for (var elLast in listLast) {
    //   for (var elChiefOper in listChiefBatch) {
    //     if (elLast.id == elChiefOper.chiefOperationId) listChiefBatchLast.add(elLast.chiefBatchId);
    //   }
    // }
    List<int> listStagechiefBatchIdLast = [];
    for (var stage in lastIdStage) {
      listStagechiefBatchIdLast.add(stage.chiefBatchId);
    }
    for (var i = 0; i < listStageId.length; i++) {
      await tableStage.updateStatus(
          listStageId[i], listStagechiefBatchIdLast[i]);
    }

    List<int> listChiefBatchLast = [];
    for (var batch in lastIdBatch) {
      listChiefBatchLast.add(batch.chiefBatchId);
    }
    await chiefBatchTable.updateChiefBatchStatusToReadyList(
        listChiefBatchId: listChiefBatchLast);
    // если id последней операции в детали равен chiefOperationId у операции из operator_operations, то меняет статус детали на готово(2)
    // if (lastOperationInBatchDto.id == chiefOperationId){

    // }
  }
}
