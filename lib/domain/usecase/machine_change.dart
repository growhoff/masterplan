import 'package:master_plan/domain/model/machine.dart';

class MachineChange{
  MachineChange();

  static List<int> getListChange(Machine machine){
    List<int> listTime = [];
    if (machine.shiftSchedule != null){
      listTime.add(machine.shiftSchedule!.timeFirst);
      for (var i = 1; i < machine.shiftSchedule!.count; i++) {
        int next = listTime[i-1] + machine.shiftSchedule!.timeChange;
        listTime.add(next);
      }
    }
    return listTime;
  }
}