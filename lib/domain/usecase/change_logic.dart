// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';

class ChangeLogic {
  final int count;
  final int firstTime;
  late List<int> listTime;
  late DateTime dateNow;
  ChangeLogic({
    required this.count,
    required this.firstTime,
  }){
    List<int> listTimeCash = [];
    int lengthTime = (24/count).round();
    int time = firstTime;
    for (var i = 0; i < count; i++) {
      listTimeCash.add(time);
      time += lengthTime;
    }
    listTime = [...listTimeCash];
    print(listTime.toString());

    dateNow = DateTime.now();
  }

  int getChange({String? time}){
    late DateTime date;
    if (time == null){
      date = dateNow;
      print('Now: $date');
    }
    else{
      // dateNow = DateTime.fromMillisecondsSinceEpoch(time);
       date = DateTime.parse(time);
       print('Start: $date');
    }

    int change = 1;
    if (!(listTime.length == 1)){  
      for (var i = 0; i < listTime.length; i++) {
        if (listTime.length - 1 == i){
          if ((date.hour >= listTime[i] && date.hour <= 24) || (date.hour >= 0 && date.hour < listTime[0])) change = i+1;
        } else {
          if (date.hour >= listTime[i] && date.hour < listTime[i+1]) change = i+1;
        }
      }
    }
    print('change $change');
    return change;
  }

  int getDifference(DateTime thisDate){
    int difference;
    // print('dateNow.difference(thisDate).inHours = ${dateNow.difference(thisDate).inHours}');
    if (dateNow.difference(thisDate).inHours >= 24) {
      difference = dateNow.difference(thisDate).inDays;
    }
    else {
      if (dateNow.month != thisDate.month){
        if((thisDate.hour + dateNow.difference(thisDate).inHours)>=24){
          difference = 1;
        } else {
          difference = 0;
        }
      } else {
        difference = dateNow.day - thisDate.day;
      }
    }
    print('Разница в днях $difference');
    return difference;
  }

  void setDateNext(String timeStart){
    // print('Start: ${DateTime.fromMillisecondsSinceEpoch(timeStart)}');
    final nowChange = getChange();
    final thisChange = getChange(time: timeStart);
    final thisDate = DateTime.parse(timeStart);
    final difference = getDifference(thisDate);


  }

/*   
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
  }


*/

  String getData(DateTime date){
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }
}
