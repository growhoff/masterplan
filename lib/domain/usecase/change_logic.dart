// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';
import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/monitoring_machine_table.dart';

class ChangeLogic {
  final int count;
  final int firstTime;
  late List<int> listTime;
  late DateTime dateNow;
  final monitorTable = MonitoringMachineTable();
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

  int getChange({int? time}){
    late DateTime date;
    if (time == null){
      date = dateNow;
      // print('Now: $date');
    } else{
      date = DateTime.fromMillisecondsSinceEpoch(time);
      //  date = DateTime.parse(time);
      // print('Start: $date');
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
    print('${time == null ? 'Now:' : 'Start:'} $date / change $change');
    return change;
  }

    DateTime getDayChange({int? time}){
    late DateTime date;
    if (time == null){
      date = dateNow;
      // print('Now: $date');
    } else{
      date = DateTime.fromMillisecondsSinceEpoch(time);
      // print('Start: $date');
    }

    int day = 0;
    if (!(listTime.length == 1)){
      for (var i = 0; i < listTime.length; i++) {
        if (listTime.length - 1 == i){
          if (date.hour >= listTime[i] && date.hour <= 24) day = 0;
          if (date.hour >= 0 && date.hour < listTime[0]) day = 1;
        } else {
          if (date.hour >= listTime[i] && date.hour < listTime[i+1]) day = 0;
        }
      }
    }
    print('${time == null ? 'Now:' : 'Start:'} $date / day $day');
    return DateTime(date.year, date.month, day);
  }

  bool getTimePeresmen(DateTime nowDat){
    final change = getChange();
    int i = change == count ? 0 : change-1;
    int lastTime = listTime[i];
    final dateEnd = DateTime(dateNow.year, dateNow.month, dateNow.day, lastTime, -5, 0);
    print(getStringData(dateEnd));
    if (dateEnd.hour == nowDat.hour && dateEnd.minute == nowDat.minute) {return true;}
    else {return false;}
  }

  int getDifference(DateTime thisDate){
    int difference;
    if (thisDate.day == dateNow.day){
      difference = 0;
    }
    else {
      final h = dateNow.difference(thisDate).inHours + 3;
      difference = h ~/ 24;
      if (h % 24 != 0) {
        final w = thisDate.hour + (h % 24);
        difference = difference + (w ~/ 24);
        // if ((w % 24) >= dateNow.hour) difference++;
      }
    }
    print('Разница в днях $difference');
    return difference;
  }

  Future<void> setDateNext(int timeStart, MonitoringMachineDTO dto, int userId, int idPath) async{
    final nowChange = getChange();
    final thisChange = getChange(time: timeStart);
    // final thisDate = DateTime.parse(timeStart);
    final thisDate = DateTime.fromMillisecondsSinceEpoch(timeStart);
    final difference = getDifference(thisDate);

    if (difference == 0){
      if (nowChange == thisChange){
        print('${getStringData(thisDate)} to ${getStringData(dateNow)}');
        await monitorTable.updateId(dto.id, dateNow.millisecondsSinceEpoch);
      } else{
        writeDateOne(thisChange: thisChange, thisDate: thisDate, nowChange: nowChange, dto: dto, userId: userId, idPath: idPath);
      }
    }
    if (difference > 0){
      writeDateMore(thisChange: thisChange, thisDate: thisDate, nowChange: nowChange, difference: difference, dto: dto, userId: userId, idPath: idPath);
    }
  }

  Future<void> writeDateOne({required int thisChange, required DateTime thisDate, required int nowChange, required MonitoringMachineDTO dto, required int userId, required int idPath}) async{
    int change = thisChange;
    DateTime firstTime = thisDate;
    int changeOld = thisChange;
    do {
      if (change == listTime.length){change = 1;} else{change ++;}
      final dataNext = getDateTime(listTime[change -1], firstTime, 0);
      print('${getStringData(firstTime)} to ${getStringData(dataNext)} // change $change');
      if (firstTime == thisDate){
        await monitorTable.updateId(dto.id, dataNext.millisecondsSinceEpoch);
      } else {
        await monitorTable.insert(MonitoringMachineDTO(id: 0, timeStart: firstTime.millisecondsSinceEpoch, timeStop: dataNext.millisecondsSinceEpoch, statusMachineId: 1, userId: userId, machineId: dto.machineId, batchId: dto.batch!.id, comment: 'Перенос на следующий день', date: firstTime, changeId: changeOld, operationId: idPath));
      }
      firstTime = dataNext;
      changeOld = change;
    } while (change != nowChange);
    // if (change == listTime.length){change = 1;} else{change ++;}
    print('${getStringData(firstTime)} to ${getStringData(dateNow)} // change $change');
    await monitorTable.insert(MonitoringMachineDTO(id: 0, timeStart: firstTime.millisecondsSinceEpoch, timeStop: dateNow.millisecondsSinceEpoch, statusMachineId: 1, userId: userId, machineId: dto.machineId, batchId: dto.batch!.id, comment: 'Перенос завершен', date: firstTime, changeId: changeOld, operationId: idPath));

  }

  Future<void> writeDateMore({required int thisChange, required DateTime thisDate, required int nowChange, required int difference, required MonitoringMachineDTO dto, required int userId, required int idPath}) async{
    int diffCount = 0;
    int day = 0;
    int change = thisChange;
    DateTime firstTime = thisDate;
    int changeOld = thisChange;
    do {
      if (change == listTime.length){change = 1; day++; diffCount++;} else{change ++; day = 0;}
      final dataNext = getDateTime(listTime[change -1], firstTime, day);
      print('${getStringData(firstTime)} to ${getStringData(dataNext)} // change $change');
      if (firstTime == thisDate){
        await monitorTable.updateId(dto.id, dataNext.millisecondsSinceEpoch);
      } else {
        await monitorTable.insert(MonitoringMachineDTO(id: 0, timeStart: firstTime.millisecondsSinceEpoch, timeStop: dataNext.millisecondsSinceEpoch, statusMachineId: 1, userId: userId, machineId: dto.machineId, batchId: dto.batch!.id, comment: 'Перенос на следующий день', date: firstTime, changeId: changeOld, operationId: idPath));
      }
      firstTime = dataNext;
      changeOld = change;
    } while ((change != nowChange) || (diffCount != (difference)));
    // if (change == listTime.length){change = 1;} else{change ++;}
    print('${getStringData(firstTime)} to ${getStringData(dateNow)} // change $change');
    await monitorTable.insert(MonitoringMachineDTO(id: 0, timeStart: firstTime.millisecondsSinceEpoch, timeStop: dateNow.millisecondsSinceEpoch, statusMachineId: 1, userId: userId, machineId: dto.machineId, batchId: dto.batch!.id, comment: 'Перенос завершен', date: firstTime, changeId: changeOld, operationId: idPath));
  }

  String getStringData(DateTime date){
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  DateTime getDateFromInt(int time){
    return DateTime.fromMillisecondsSinceEpoch(time);
  }

  String getStringDataFromInt(int time){
    print(DateFormat('yyyy-MM-dd HH:mm:ss').format(getDateFromInt(time)));
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(getDateFromInt(time));
  }

  DateTime getDateTime(int hh, DateTime date, int day){
    return DateTime(date.year, date.month, date.day + day, hh,0,0);
  }



//если деталь забыли остановить при

  //////// new просто
  ///
  Future<void> setDateNextSt2(MonitoringMachineDTO dto, int userId, int idPath, String comment) async{
    final nowChange = getChange();
    final thisChange = getChange(time: dto.timeStart);
    // final thisDate = DateTime.parse(timeStart);
    final thisDate = DateTime.fromMillisecondsSinceEpoch(dto.timeStart);
    // final thisDateEnd = DateTime.fromMillisecondsSinceEpoch(dto.timeStop);// всегда нуль
    final difference = getDifference(thisDate);

    if (difference == 0){
      if (nowChange == thisChange){
        print('Смена сейчас == смене статуса. Разница 0 дней');
        print('${getStringData(thisDate)} to ${getStringData(dateNow)} (${dto.statusMachine!.name})');
        await monitorTable.updateId(dto.id, dateNow.millisecondsSinceEpoch);
      } else{
        print('Смена сейчас != смене статуса. Разница 0 дней');
        writeDateOneSt2(thisChange: thisChange, thisDate: thisDate, nowChange: nowChange, dto: dto, userId: userId, idPath: idPath, comment: comment);
      }
    }
    if (difference > 0){
      print('Разница $difference дней');
      writeDateMoreSt2(thisChange: thisChange, thisDate: thisDate, nowChange: nowChange, difference: difference, dto: dto, userId: userId, idPath: idPath, comment: comment);
    }
  }

  Future<void> writeDateOneSt2({required int thisChange, required DateTime thisDate, required int nowChange, required MonitoringMachineDTO dto, required int userId, required int idPath, required String comment}) async{
    int change = thisChange;
    DateTime firstTime = thisDate;
    int changeOld = thisChange;
    do {
      if (change == listTime.length){change = 1;} else{change ++;}
      final dataNext = getDateTime(listTime[change -1], firstTime, 0);
      print('${getStringData(firstTime)} to ${getStringData(dataNext)} -- change $change -- ${dto.statusMachine!.name}');
      if (firstTime == thisDate){
        await monitorTable.updateId(dto.id, dataNext.millisecondsSinceEpoch);
      } else {
        await monitorTable.insert(MonitoringMachineDTO(id: 0, timeStart: firstTime.millisecondsSinceEpoch, timeStop: dataNext.millisecondsSinceEpoch, statusMachineId: dto.statusMachineId, userId: userId, machineId: dto.machineId, batchId: dto.batchId, comment: comment, date: firstTime, changeId: changeOld, operationId: idPath));
      }
      firstTime = dataNext;
      changeOld = change;
    } while (change != nowChange);
    // if (change == listTime.length){change = 1;} else{change ++;}
    print('${getStringData(firstTime)} to ${getStringData(dateNow)} -- change $change -- ${dto.statusMachine!.name}');
    await monitorTable.insert(MonitoringMachineDTO(id: 0, timeStart: firstTime.millisecondsSinceEpoch, timeStop: dateNow.millisecondsSinceEpoch, statusMachineId: dto.statusMachineId, userId: userId, machineId: dto.machineId, batchId: dto.batchId, comment: comment, date: firstTime, changeId: changeOld, operationId: idPath));

  }

  Future<void> writeDateMoreSt2({required int thisChange, required DateTime thisDate, required int nowChange, required int difference, required MonitoringMachineDTO dto, required int userId, required int idPath, required String comment}) async{
    int diffCount = 0;
    int day = 0;
    int change = thisChange;
    DateTime firstTime = thisDate;
    int changeOld = thisChange;
    do {
      if (change == listTime.length){change = 1; day++; diffCount++;} else{change ++; day = 0;}
      final dataNext = getDateTime(listTime[change -1], firstTime, day);
      print('${getStringData(firstTime)} to ${getStringData(dataNext)} -- change $change -- ${dto.statusMachine!.name}');
      if (firstTime == thisDate){
        await monitorTable.updateId(dto.id, dataNext.millisecondsSinceEpoch);
      } else {
        await monitorTable.insert(MonitoringMachineDTO(id: 0, timeStart: firstTime.millisecondsSinceEpoch, timeStop: dataNext.millisecondsSinceEpoch, statusMachineId: dto.statusMachineId, userId: userId, machineId: dto.machineId, batchId: dto.batchId, comment: comment, date: firstTime, changeId: changeOld, operationId: idPath));
      }
      firstTime = dataNext;
      changeOld = change;
    } while ((change != nowChange) || (diffCount != (difference)));
    // if (change == listTime.length){change = 1;} else{change ++;}
    print('${getStringData(firstTime)} to ${getStringData(dateNow)} -- change $change -- ${dto.statusMachine!.name}');
    await monitorTable.insert(MonitoringMachineDTO(id: 0, timeStart: firstTime.millisecondsSinceEpoch, timeStop: dateNow.millisecondsSinceEpoch, statusMachineId: dto.statusMachineId, userId: userId, machineId: dto.machineId, batchId: dto.batchId, comment: comment, date: firstTime, changeId: changeOld, operationId: idPath));
  }
}
