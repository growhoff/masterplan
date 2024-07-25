import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';

class MonitoringTimeList{
  final List<int> listTime;
  TimeConverter timeConverter = TimeConverter();

  MonitoringTimeList({required this.listTime});

//функция получение листа по нужной смене
  List<MonitoringMachine> getListForChange(List<MonitoringMachine> listStatus, int change){
    List<MonitoringMachine> res = [];
    for (var element in listStatus){
      if (element.changeId == change) res.add(element);
    }
    return res;
  }

  DateTime getDateTimeHH(DateTime date, int h, int day){
    DateTime data = DateTime(date.year, date.month, date.day, h, 0, 0);
    data = data.add(Duration(days: day));
    return data;
  }

  int getDateTimeSinceEpoch(DateTime date, int h, int day){
    DateTime data = DateTime(date.year, date.month, date.day, h, 0, 0);
    data = data.add(Duration(days: day));
    return data.millisecondsSinceEpoch;
  }

  int getTimeWorking(int timeStart, int timeStop){
    if (timeStop < timeStart) {return 0;}
    else {return timeConverter.getTimeWorking(timeStart, timeStop);}
  }

  MonitoringMachine createMonitoringMachine(int timeStart, int timeStop, UserDTO user, int change, {required int? firstStartBatch, required StatusMachineDTO? status, required BatchDTO? batch, required String? comment}) {
    return MonitoringMachine(
      timeStart: timeStart,
      timeStop: timeStop,
      timeWorking: getTimeWorking(timeStart, timeStop),
      changeId: change,
      date: DateTime.fromMillisecondsSinceEpoch(timeStart),
      statusMachine: status ?? StatusMachineDTO(id: 2, name: 'Простой'),
      batch: batch,
      comment: comment == null ? '-' : comment,
      user: user,
      firstStartBatch: firstStartBatch,
    );
  }


  bool getBoolDataEndDataNow(int time1, int time2){
    return timeConverter.getStringDataYYMMDDint(time1) == timeConverter.getStringDataYYMMDDint(time2);
  }


  List<MonitoringMachine> convertTimeStatus(List<MonitoringMachine> listStatus, int change) {
    List<MonitoringMachine> newList = [];
    List<MonitoringMachine> listStatusChange = getListForChange(listStatus,change);
    if (listStatusChange.isNotEmpty){
      int lengthList = listStatusChange.length;
      UserDTO user = listStatusChange.first.user!;
      DateTime date = DateTime.fromMillisecondsSinceEpoch(listStatusChange.first.timeStart);
      int dateStartCh = getDateTimeSinceEpoch(date, change == 1 ? listTime[change - 1] : listTime[change-1], 0);
      int dateStopCh = getDateTimeSinceEpoch(date, change == 1 ? listTime[change] : listTime[change - 2], change == 1 ? 0 : 1);
      int dateStop = listStatusChange.first.timeStop;
      final dateNow = DateTime.now().millisecondsSinceEpoch;
      //если пустой лист по данной смене, то выдаст пустой список

      //если в листе только один элемент
      if (lengthList == 1){
        //проверка ставить в начале элемент
        if (listStatusChange.first.timeStart > dateStartCh) newList.add(createMonitoringMachine(dateStartCh, listStatusChange.first.timeStart, user, change, status: null, batch: null, comment: null, firstStartBatch: null));
        if (dateStop != 0) {
          //добавляем сам элемент
          newList.add(listStatusChange.first);
          //проверка ставить в конце элемент
          // if (dateStop < dateStopCh) newList.add(createMonitoringMachine(dateStop, dateStopCh, user, change, status: null, batch: null, comment: null));
          if (getBoolDataEndDataNow(dateStopCh,dateStop) && dateStop != dateStopCh) {newList.add(createMonitoringMachine(dateStop, dateNow, user, change, status: null, batch: null, comment: null, firstStartBatch: null));}
        } else {
          // final dateNow = DateTime.now().millisecondsSinceEpoch;
          if (dateNow <= dateStopCh){
            newList.add(createMonitoringMachine(listStatusChange.first.timeStart, dateNow, user, change, status: listStatusChange.first.statusMachine, batch: listStatusChange.first.batch, comment: listStatusChange.first.comment, firstStartBatch: listStatusChange.first.firstStartBatch));
          }
          else {
            newList.add(createMonitoringMachine(listStatusChange.first.timeStart, dateStopCh, user, change, status: listStatusChange.first.statusMachine, batch: listStatusChange.first.batch, comment: listStatusChange.first.comment, firstStartBatch: listStatusChange.first.firstStartBatch));
          }
        }
      }

      //если элементов больше одного
      if (lengthList > 1){

        for (var i = 0; i < lengthList; i++){
          dateStop = listStatusChange[i].timeStop;
          //последний элемент
          if (i == lengthList - 1){
            if (listStatusChange[i].timeStart > dateStartCh) newList.add(createMonitoringMachine(dateStartCh, listStatusChange[i].timeStart, user, change, status: null, batch: null, comment: null, firstStartBatch: null));
            if (dateStop != 0) {
              //добавляем сам элемент
              newList.add(listStatusChange[i]);
              //проверка ставить в конце элемент
              if (getBoolDataEndDataNow(dateNow,dateStop) && dateStop != dateStopCh) {newList.add(createMonitoringMachine(dateStop, dateNow, user, change, status: null, batch: null, comment: null, firstStartBatch: null));}
              else {if (dateStop < dateStopCh) newList.add(createMonitoringMachine(dateStop, dateStopCh, user, change, status: null, batch: null, comment: null, firstStartBatch: null));}
            } else {
              if (dateNow <= dateStopCh){
                newList.add(createMonitoringMachine(listStatusChange[i].timeStart, dateNow, user, change, status: listStatusChange[i].statusMachine, batch: listStatusChange[i].batch, comment: listStatusChange[i].comment, firstStartBatch: listStatusChange[i].firstStartBatch));
              }
              else {
                newList.add(createMonitoringMachine(listStatusChange[i].timeStart, dateStopCh, user, change, status: listStatusChange[i].statusMachine, batch: listStatusChange[i].batch, comment: listStatusChange[i].comment, firstStartBatch: listStatusChange[i].firstStartBatch));
              }
            }
          } else{
            if (listStatusChange[i].timeStart > dateStartCh) newList.add(createMonitoringMachine(dateStartCh, listStatusChange[i].timeStart, user, change, status: null, batch: null, comment: null, firstStartBatch: null));
            dateStartCh = listStatusChange[i].timeStop;
            newList.add(listStatusChange[i]);
          }
        }
      }
    }
    //очередь у начальника ПКМ

    return newList;
  }



  List<MonitoringMachine> convertTimeStatusLast(List<MonitoringMachine> listStatus, int change) {
    List<MonitoringMachine> newList = [];
    List<MonitoringMachine> listStatusChange = getListForChange(listStatus,change);
    if (listStatusChange.isNotEmpty){
      int lengthList = listStatusChange.length;
      UserDTO user = listStatusChange.first.user!;
      DateTime date = DateTime.fromMillisecondsSinceEpoch(listStatusChange.first.timeStart);
      // int dateStartCh = getDateTimeSinceEpoch(date, change == 1 ? listTime[change - 1] : listTime[change-1], 0);
      int dateStopCh = getDateTimeSinceEpoch(date, change == 1 ? listTime[change] : listTime[change - 2], change == 1 ? 0 : 1);
      int dateStop = listStatusChange.first.timeStop;
      final dateNow = DateTime.now().millisecondsSinceEpoch;
      //если пустой лист по данной смене, то выдаст пустой список

      //если в листе только один элемент
      if (lengthList == 1){
        //проверка ставить в начале элемент
        if (dateStop != 0) {
          //добавляем сам элемент
          newList.add(listStatusChange.first);
        } else {
          // final dateNow = DateTime.now().millisecondsSinceEpoch;
          if (dateNow <= dateStopCh){
            newList.add(createMonitoringMachine(listStatusChange.first.timeStart, dateNow, user, change, status: listStatusChange.first.statusMachine, batch: listStatusChange.first.batch, comment: listStatusChange.first.comment, firstStartBatch: listStatusChange.first.firstStartBatch));
          }
          else {
            newList.add(createMonitoringMachine(listStatusChange.first.timeStart, dateStopCh, user, change, status: listStatusChange.first.statusMachine, batch: listStatusChange.first.batch, comment: listStatusChange.first.comment, firstStartBatch: listStatusChange.first.firstStartBatch));
          }
        }
      }

      //если элементов больше одного
      if (lengthList > 1){

        for (var i = 0; i < lengthList; i++){
          dateStop = listStatusChange[i].timeStop;
          //последний элемент
          if (i == lengthList - 1){
            if (dateStop != 0) {
              //добавляем сам элемент
              newList.add(listStatusChange[i]);
            } else {
              if (dateNow <= dateStopCh){
                newList.add(createMonitoringMachine(listStatusChange[i].timeStart, dateNow, user, change, status: listStatusChange[i].statusMachine, batch: listStatusChange[i].batch, comment: listStatusChange[i].comment, firstStartBatch: listStatusChange[i].firstStartBatch));
              }
              else {
                newList.add(createMonitoringMachine(listStatusChange[i].timeStart, dateStopCh, user, change, status: listStatusChange[i].statusMachine, batch: listStatusChange[i].batch, comment: listStatusChange[i].comment, firstStartBatch: listStatusChange[i].firstStartBatch));
              }
            }
          } else{
            newList.add(listStatusChange[i]);
          }
        }
      }
    }
    //очередь у начальника ПКМ

    return newList;
  }


}