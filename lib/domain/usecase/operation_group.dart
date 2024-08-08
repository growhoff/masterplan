// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:collection/collection.dart';
import 'package:master_plan/domain/model/group_opt_path.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/otp_path_operations.dart';
import 'package:master_plan/domain/usecase/convert_dto_model.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/model/item_machine.dart';

class OperationsGroup {
  OperationsGroup();

  List<OptPathOperations> group(List<OperatorOperationsDTO> listOper){
    List<OptPathOperations> listB = [];
    var newMap = groupBy(listOper, (el) => el.optimalPart);
    newMap.forEach((key, value) {
      List<OperatorOperations> list = [];
      int time = 0;
      for (var element in value) {
        list.add(ConvertDtoModel.convertToOperatorOperations(element));
        if (element.timeplan != null) {time += element.timeplan!;}
      }
      listB.add(OptPathOperations(idPath: key!, list: list, order: list.first.order!, time: time, active: list.first.status.id == 7, batchNumber: list.first.batch.number!, stageNumber:  list.first.stage.number));
    });
    return listB;
  }

  List<ItemMachine> groupMachine(List<Machine> listMachine, List<OptPathOperations> listOper){
    List<ItemMachine> listItem = [];
    for (var machine in listMachine) {
      List<OptPathOperations> listQueue = [];
      int time = 0;
      OptPathOperations? activeOper;
      for (var item in listOper) {
        if (item.list.first.machine!.id == machine.id) {
          if (!item.active!){
            listQueue.add(item);
            time +=item.time;
          }else{
            activeOper = item;
          }
        }
      }
      List<GroupOptPath> listGroup = [];
      for (var element in listQueue) {listGroup.add(GroupOptPath(listOptPath: [element], count: listQueue.length, isChoise: false));}
      listItem.add(ItemMachine(machine: machine, listPathOper: listGroup, time: time, activeOper: activeOper));
    }
    return listItem;
  }

  List<GroupOptPath> groupOperInMachineBatchNum(ItemMachine itemMachine){
    List<GroupOptPath> listNew = [];
    List<OptPathOperations> listActive = regroupOperActive(itemMachine);
    List<GroupOptPath > listUnActive = regroupOper(itemMachine);
    if (listActive.isEmpty){
      listActive = regroupOperNotActive(itemMachine);
      listUnActive = [];
    }
    var newMap = groupBy(listActive, (el) => el.batchNumber);
    newMap.forEach((key, value) {
      int length = 0;
      List<OptPathOperations> list = [];
      for (var element in value) {
        list.add(element);
        length += element.list.length;
      }
      listNew.add(GroupOptPath(listOptPath: list, count: length, isChoise: false));
    });
    listNew.addAll(listUnActive);
    return listNew;
  }

  List<GroupOptPath> groupOperInMachineStageNumber(ItemMachine itemMachine){
    List<GroupOptPath> listNew = [];
    List<OptPathOperations> listActive = regroupOperActive(itemMachine);
    List<GroupOptPath> listUnActive = regroupOper(itemMachine);
    if (listActive.isEmpty){
      listActive = regroupOperNotActive(itemMachine);
      listUnActive = [];
    }
    var newMap = groupBy(listActive, (el) => el.stageNumber);
    newMap.forEach((key, value) {
      int length = 0;
      List<OptPathOperations> list = [];
      for (var element in value) {
        list.add(element);
        length += element.list.length;
      }
      listNew.add(GroupOptPath(listOptPath: list, count: length, isChoise: false));
    });
    listNew.addAll(listUnActive);
    return listNew;
  }

  List<GroupOptPath> groupOperInMachineOptPath(ItemMachine itemMachine){
    List<GroupOptPath> listNew = [];
    // int order = 1;
    for (var optPathOper in itemMachine.listPathOper) {
      List<OptPathOperations> listOper = optPathOper.listOptPath;
      var newMap = groupBy(listOper, (el) => el.idPath);
      newMap.forEach((key, value) {
        List<OptPathOperations> list = [];
        for (var element in value) {
          list.add(element);
        }
        listNew.add(GroupOptPath(listOptPath: list, count: list.length, isChoise: false));
        // order++;
      });
    }
    return listNew;
  }

  List<OptPathOperations> regroupOperActive(ItemMachine itemMachine){
    List<OptPathOperations> list = [];
    for (var optPathOper in itemMachine.listPathOper) {
      if (optPathOper.isChoise) list.addAll(optPathOper.listOptPath);
    }
    return list;
  }

  List<OptPathOperations> regroupOperNotActive(ItemMachine itemMachine){
    List<OptPathOperations> list = [];
    for (var optPathOper in itemMachine.listPathOper) {
      list.addAll(optPathOper.listOptPath);
    }
    return list;
  }

  List<GroupOptPath > regroupOper(ItemMachine itemMachine){
    List<GroupOptPath > list = [];
    for (var optPathOper in itemMachine.listPathOper) {
      if (!optPathOper.isChoise) list.add(optPathOper);
    }
    return list;
  }

  List<GroupOptPath> regroupUp(ItemMachine itemMachine){
    List<GroupOptPath> listNew = [];
    List<GroupOptPath> listActive = [];
    List<GroupOptPath> listUnActive = [];
    for (var group in itemMachine.listPathOper) {
      if (group.isChoise) {listActive.add(group);}
      else {listUnActive.add(group);}
    }
    listNew.addAll(listActive);
    listNew.addAll(listUnActive);
    return listNew;
  }

  List<GroupOptPath> regroupDuwn(ItemMachine itemMachine){
    List<GroupOptPath> listNew = [];
    List<GroupOptPath> listActive = [];
    List<GroupOptPath> listUnActive = [];
    for (var group in itemMachine.listPathOper) {
      if (group.isChoise) {listActive.add(group);}
      else {listUnActive.add(group);}
    }
    listNew.addAll(listUnActive);
    listNew.addAll(listActive);
    return listNew;
  }
}
