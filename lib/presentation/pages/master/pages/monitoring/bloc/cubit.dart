import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/monitoring_machine_table.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';
// import 'package:master_plan/presentation/pages/master/pages/monitoring/model/item_machine.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/model/item_machine_monitor.dart';
import 'state.dart';
import 'package:intl/intl.dart';

class CubitMonitoring extends Cubit<StateMonitoring> {
  final List<Machine>? machineList;
  final List<int> machineIdList;
  final tableMonitoring = MonitoringMachineTable();
  CubitMonitoring(this.machineList, this.machineIdList): super(StateMonitoring(days: DateTime.now())) {
    // test();
    
    tableMonitoring.table
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
      listId.add(element['id']);
    }
    List<MonitoringMachineDTO> queueList = [];
    if (listId.isNotEmpty) {
      final quere = await tableMonitoring.selectListId(listId, state.days);
      for (var item in quere) {
        queueList.add(MonitoringMachineDTO.fromMap(item));
      }
    }
    List<ItemMachineMonitorMaster> listMonitor = getListMonitor(queueList);
    emit(state.copyWith(listBar: listMonitor));
  }

  Future<void> setDate(DateTime date) async {
    final quere =
        await tableMonitoring.selectListIdMachine(machineIdList, date);
    List<MonitoringMachineDTO> queueList = [];
    for (var item in quere) {
      queueList.add(MonitoringMachineDTO.fromMap(item));
    }
    List<ItemMachineMonitorMaster> listMonitor = getListMonitor(queueList);
    emit(state.copyWith(days: date, listBar: listMonitor));
  }

  List<ItemMachineMonitorMaster> getListMonitor(
      List<MonitoringMachineDTO> queueList) {
    List<ItemMachineMonitorMaster> listMonitor = [];
    for (var machine in machineList!) {
      List<MonitoringMachine> listStatus = [];
      int allTime = 0;
      for (var queueItem in queueList) {
        if (queueItem.machine!.id == machine.id) {
          listStatus.add(converterToMonitorMachine(queueItem));
          allTime += (queueItem.timeStop - queueItem.timeStart);
        }
      }
      //если в последнем статусе конечного времени нуль, тогда в работе, иначе закончил
      StatusMachineDTO? statusActive;
      if (listStatus.isNotEmpty) statusActive = getActiveStatus(listStatus.last);
      //
      List<MonitoringMachine> listStatusNew;
      if (listStatus.isNotEmpty) {
        listStatusNew = convertTimeStatus(listStatus);
      } else {
        listStatusNew = [];
      }

      listMonitor.add(ItemMachineMonitorMaster(
          machine: machine,
          listStatus: listStatusNew,
          allTime: allTime,
          statusActive: statusActive));
    }

    return listMonitor;
  }

  StatusMachineDTO? getActiveStatus(MonitoringMachine status){
    if (status.timeStop == 0) {return status.statusMachine!;}
    else {return null;}
  }

  List<MonitoringMachine> convertTimeStatus(List<MonitoringMachine> listStatus) {
    List<MonitoringMachine> newList = [];
    final change = listStatus.first.changeId;
    final date = DateTime.fromMillisecondsSinceEpoch(listStatus.first.timeStart);
    late int dateFirst;
    late int dateSecond;

    int dateFirstCh1 = DateTime(date.year, date.month, date.day, 8, 0, 0).millisecondsSinceEpoch;
    int dateSecondCh1 = DateTime(date.year, date.month, date.day, 20, 0, 0).millisecondsSinceEpoch;
    int dateFirstCh2 = DateTime(date.year, date.month, date.day, 20, 0, 1).millisecondsSinceEpoch;
    // int dateSecondCh2 = DateTime(date.year, date.month, date.day, 0, 0, 0).millisecondsSinceEpoch;
    int dateSecondCh22 = DateTime(date.year, date.month, date.day + 1, 7, 59, 59).millisecondsSinceEpoch;

    //проверка на первую и втору смену???

    if (change == 1){
      dateFirst = dateFirstCh1;
      dateSecond = dateSecondCh1;
    } else {
      dateFirst = dateFirstCh2;
      dateSecond = dateSecondCh22;
    }

    for (var i = 0; i < listStatus.length; i++) {
      //если конец
      if ((i == (listStatus.length - 1)) && i == 0) {
        if (dateFirst < listStatus[i].timeStart) newList.add(createMonitoringMachine(dateFirst, listStatus[i].timeStart, date, listStatus[i].user!, change));
        //если время последнего ещё не проставлено, то ставим по настоящему времени
        if (listStatus[i].timeStop == 0){
          newList.add(createMonitoringMachineNotEnd(listStatus[i].timeStart, DateTime.now().millisecondsSinceEpoch, date, listStatus[i].user!, listStatus[i].statusMachine!, listStatus[i].batch!, change));
        }
        else {
          // print('timeStop ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(listStatus[i].timeStop))}');
          // print('dateSecond ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(dateSecond))}');
          if (listStatus[i].timeStop < dateSecond) {
            newList.add(listStatus[i]);
            newList.add(createMonitoringMachine(listStatus[i].timeStop, dateSecond, date, listStatus[i].user!, change));
          }
          else{newList.add(listStatus[i]);}
        }
      } 
      //если остальное
      else {
        if (dateFirst < listStatus[i].timeStart) newList.add(createMonitoringMachine(dateFirst, listStatus[i].timeStart, date, listStatus[i].user!, change));
        newList.add(listStatus[i]);
        dateFirst = listStatus[i].timeStop;
      }
    }
    return newList;
  }

  MonitoringMachine createMonitoringMachine(int timeStart, int timeStop, DateTime date, UserDTO user, int change) {
    return MonitoringMachine(
        timeStart: timeStart,
        timeStop: timeStop,
        timeWorking: (timeStop < timeStart)
            ? 0
            : TimeConverter().getTimeWorking(timeStart, timeStop),
        changeId: change,
        date: date,
        statusMachine: StatusMachineDTO(id: 2, name: 'Простой'),
        comment: '-',
        user: user
        );
  }

  MonitoringMachine createMonitoringMachineNotEnd(int timeStart, int timeStop, DateTime date, UserDTO user, StatusMachineDTO status, BatchDTO batch, int change) {
    return MonitoringMachine(
        timeStart: timeStart,
        timeStop: 0,
        timeWorking: (timeStop < timeStart)
            ? 0
            : TimeConverter().getTimeWorking(timeStart, timeStop),
        changeId: change,
        date: date,
        statusMachine: status,
        batch: batch,
        comment: '-',
        user: user
        );
  }


  MonitoringMachine converterToMonitorMachine(MonitoringMachineDTO dto) {
    return MonitoringMachine(
        id: dto.id,
        date: dto.date,
        timeStart: dto.timeStart,
        timeStop: dto.timeStop,
        timeWorking: (dto.timeStop < dto.timeStart)
            ? 0
            : TimeConverter().getTimeWorking(dto.timeStart, dto.timeStop),
        statusMachine: dto.statusMachine!,
        comment: dto.comment,
        changeId: dto.changeId,
        batch: dto.batch,
        user: dto.user,
        operationId: dto.operationId);
  }

  void setChange(int change) {
    emit(state.copyWith(change: change));
  }

  void setActivePage(int index) {
    emit(state.copyWith(activePage: index));
  }

  String convertTimeZone(int time) {
    if (time == 0) {
      return '-';
    } else {
      return TimeConverter().convertMillisecondsSinceEpochToHHMMSS(time);
    }
  }

  String differenceTime(int timeSec) {
    return TimeConverter().convertTimeFromSecondsHHMMSS(timeSec);
  }

  Color convertColor(int status) {
    Color colorStatus;
    switch (status) {
      case 1:
        colorStatus = Colors.green;
      case 2:
        colorStatus = Colors.red;
      case 3:
        colorStatus = Colors.yellow;
      case 4:
        colorStatus = Colors.orange;
      case 5:
        colorStatus = Colors.purple;
      case 6:
        colorStatus = Colors.blueAccent;
      case 7:
        colorStatus = Colors.blue;
      case 8:
        colorStatus = Colors.white;
        break;
      default:
        colorStatus = Colors.white;
    }
    return colorStatus;
  }


  Future<void> test()async{
    // final monitorTable = MonitoringMachineTable();
    // final quereMon = await monitorTable.selectIdMonitor(7, 1, 311, 1719388976094);
    // print(quereMon.toString());
    List<Map<String, dynamic>> q = [
      {
        'id': 523,
        'time_start': 1719234629892,
        'time_stop': 0,
        'status_machine_id': 1,
        'user_id': 7,
        'machine_id': 1,
        'batch_id': 311,
        'comment': '-',
        'change_id': 2,
        'date': '2024-06-25',
        'operation_id': 1719388976094,
        'z_status_machine': {'id': 1, 'name': 'В работе'},
        'z_user': {
          'id': 7,
          'fio': 'Оператор тест 1',
          'position_id': 4,
          'unit_id': null,
          'area_id': 1,
          'company_id': 1,
          'photo': null,
          'z_position': {'id': 4, 'name': 'Оператор'},
          'z_company': {'id': 1, 'name': 'КМЗ', 'code': 'kmz', 'is_paid': true},
          'z_unit': null,
          'z_area': {
            'id': 1,
            'name': 'Тестовый 1',
            'number': '1',
            'unit_id': 1,
            'company_id': 1
          }
        },
        'z_machine': {
          'id': 1,
          'inventory_number': 1,
          'name': 'Токарный станок',
          'area_id': 1
        },
        'z_batch': {
          'id': 311,
          'number': 'ЛАД.2109',
          'name': 'Корпус лады',
          'count': 20,
          'code': '7770',
          'technology': 'КМЗ.01141.00777',
          'order': 0,
          'isready': false,
          'order_id': null,
          'company_id': 1,
          'batch_archive_id': 32
        }
      }
    ];
    late MonitoringMachineDTO model;
    for (var element in q) {
      final model1 = MonitoringMachineDTO.fromMap(element);
      if (model1.timeStop == 0) model = model1;
    }
   
    // final dateNow = DateTime.now();
    // final dateNowSeconds = dateNow.millisecondsSinceEpoch;
    final dateNowSeconds = 1719599529892;
    final dateNow = DateTime.fromMillisecondsSinceEpoch(dateNowSeconds);
    final dateChangeStart = DateTime(dateNow.year, dateNow.month, dateNow.day, 8,0,0).millisecondsSinceEpoch;
    final dateChangeStop = DateTime(dateNow.year, dateNow.month, dateNow.day, 20,0,0).millisecondsSinceEpoch;
    final dayStartOper = DateTime.fromMillisecondsSinceEpoch(model.timeStart).day;
    bool change1 =  (dateNowSeconds >= dateChangeStart) && (dateNowSeconds <= dateChangeStop) ;//(model.changeId == 1) &&

    print('timeStart ${getData(DateTime.fromMillisecondsSinceEpoch(model.timeStart))}');
    print('timeStop 0');
    print('change ${change1 ? 1 : 2}');
    print('timeNow ${getData(DateTime.fromMillisecondsSinceEpoch(dateNowSeconds))}');
    print('---');

    
    //если дни одинаковы
    if (dayStartOper == dateNow.day){
      if (change1) {
        print('return change 1');
        // await monitorTable.updateId(model.id, DateTime.now().millisecondsSinceEpoch);
        if (model.timeStart < dateChangeStart){
          print('${getData(DateTime.fromMillisecondsSinceEpoch(model.timeStart))} to ${DateTime.fromMillisecondsSinceEpoch(dateChangeStart)}');
          print('${getData(DateTime.fromMillisecondsSinceEpoch(dateChangeStart))} to ${getData(DateTime.fromMillisecondsSinceEpoch(dateNowSeconds))}');
        } else {
          print('${getData(DateTime.fromMillisecondsSinceEpoch(model.timeStart))} to ${getData(DateTime.fromMillisecondsSinceEpoch(dateNowSeconds))}');
        }
        }
      else {
        print('return change 2');
        if (model.timeStart > dateChangeStop){
          print('${getData(DateTime.fromMillisecondsSinceEpoch(model.timeStart))} to ${getData(DateTime.fromMillisecondsSinceEpoch(dateNowSeconds))}');
        } else {
          print('${getData(DateTime.fromMillisecondsSinceEpoch(model.timeStart))} to ${getData(DateTime.fromMillisecondsSinceEpoch(dateChangeStop))}');
          print('${getData(DateTime.fromMillisecondsSinceEpoch(dateChangeStop))} to ${getData(DateTime.fromMillisecondsSinceEpoch(dateNowSeconds))}');
        }
        
        //запись окончания в первой смене
        // await monitorTable.updateId(model.id, DateTime(dateNow.year, dateNow.month, dateNow.day, 20, 0, 0).millisecondsSinceEpoch);
        //запись во второй смене со следующим днём
        // await monitorTable.insert(MonitoringMachineDTO(id: 0, timeStart: DateTime(dateNow.year, dateNow.month, dateNow.day, 20, 0, 1).millisecondsSinceEpoch, timeStop: 0, statusMachineId: 1, userId: userId, machineId: oper.machineId, batchId: oper.list.first.batch.id, comment: 'Перенос на сделующий день', date: DateTime(dateNow.year, dateNow.month, dateNow.day + 1), changeId: 2, operationId: oper.idPath));
      }
    }
    //если дни разные
    else {
      final dayDiff = dateNow.day - dayStartOper;
      print('Разница в днях: $dayDiff');
      if (change1){
        print('return change 1 nextDay');
        for (var i = 0; i < dayDiff; i++) {
          //начать вторую смену и закончить
        if (i == dayDiff - 1){
          if (i != 0){
            //если конец
            print('День ${i+1} смена 1:${getData(DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i, 8,0,0))} to ${DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i, 20,0,0)}');
            print('День ${i+1} смена 2:${getData(DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i, 20,0,0))} to ${DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i+1, 8,0,0)}');
            print('День ${i+2} смена 1:${getData(DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i+1, 8,0,0))} to ${dateNow}');
          } else {
            //если только один элемент
            print('День ${i+1} смена 1:${getData(DateTime.fromMillisecondsSinceEpoch(model.timeStart))} to ${DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i + 1, 8,0,0)}');
            print('День ${i+2} смена 1:${getData(DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i+1, 8,0,0))} to ${dateNow}');
            }
          } else {
            if (i == 0){
              final timeEnd = DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff, 20,0,0).millisecondsSinceEpoch;
              if (model.timeStart > timeEnd){
                print('День ${i+1} смена 2: ${getData(DateTime.fromMillisecondsSinceEpoch(model.timeStart))} to ${DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i+1, 8,0,0)}');
              } else {
                print('День ${i+1} смена 1: ${getData(DateTime.fromMillisecondsSinceEpoch(model.timeStart))} to ${getData(DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff, 20,0,0))}');
                print('День ${i+1} смена 2:${getData(DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff, 20,0,0))} to ${DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i+1, 8,0,0)}');
            
              }
            }else{
              print('День ${i+1} смена 1:${getData(DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i, 8,0,0))} to ${DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i, 20,0,0)}');
              print('День ${i+1} смена 2:${getData(DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i, 20,0,0))} to ${DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i+1, 8,0,0)}');
            }
            
          } 
        }
        } else {
        print('return change 2 nextDay');
        //запись окончания
        // await monitorTable.updateId(model.id, DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff, 20, 0, 0).millisecondsSinceEpoch);
        //
        for (var i = 0; i < dayDiff; i++) {
          //начать вторую смену и закончить
        if (i == dayDiff - 1){
          if (i != 0){
            //если конец
            print('День ${i+2} смена 2:${getData(DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i, 20,0,0))} to ${DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i+1, 8,0,0)}');
            print('День ${i+2} смена 1:${getData(DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i+1, 8,0,0))} to ${dateNow}');
          } else {
            //если только один элемент
            }
          } else {
            if (i == 0){
            print('День ${i+1} смена 2: ${getData(DateTime.fromMillisecondsSinceEpoch(model.timeStart))} to ${getData(DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i+1, 8,0,0))}');
            print('День ${i+2} смена 1:${getData(DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i+1, 8,0,0))} to ${DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i+1, 20,0,0)}');
            }else{
              print('День ${i+1} смена 2:${getData(DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i, 20,0,0))} to ${DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i+1, 8,0,0)}');
              print('День ${i+2} смена 1:${getData(DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i+1, 8,0,0))} to ${DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff + i+1, 20,0,0)}');
            }
          } 
        }
        //запись во второй смене со следующим днём
        // await monitorTable.insert(MonitoringMachineDTO(id: 0, timeStart: DateTime(dateNow.year, dateNow.month, dateNow.day - dayDiff, 20, 0, 1).millisecondsSinceEpoch, timeStop: 0, statusMachineId: 1, userId: userId, machineId: oper.machineId, batchId: oper.list.first.batch.id, comment: 'Перенос на сделующий день', date: DateTime(dateNow.year, dateNow.month, dateNow.day), changeId: 2, operationId: oper.idPath));
      
      }
      
    }
    // setBtnStatus(1); 
  }

  String getData(DateTime date){
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }
}
