import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'state.dart';

class CubitTimer extends Cubit<StateTimer> {
  final int length;
  final List<int> timeActive;
  final List<bool> listStartTime;
  final operatorOperTable = OperatorOperationsTable();
  CubitTimer(this.length, this.timeActive, this.listStartTime) : super(const StateTimer()){
    init();
  }

  void init(){
      List<int> listTick = [];
      List<String> listRes = [];
      // List<bool> listState = [];
      for (var tick in timeActive) {
        if (tick == 0){
          listTick.add(0);
          listRes.add('00:00:00');
          // listState.add(false);
        } else {
          // final date1 = DateTime.fromMillisecondsSinceEpoch(tick).toUtc();
          // final date2 = DateTime.now().toUtc();
          // final difference = (date2.difference(date1)).inSeconds;
          listTick.add(tick);
          listRes.add(convertTime(tick));
          // listState.add(true);
        }
      }
      emit(state.copyWith(listTick: listTick, listState: listStartTime, listRes: listRes));
      Timer.periodic(const Duration(seconds: 1), (timer) {
      List<int> listTick = [...state.listTick];
      List<String> listRes = [...state.listRes];
      for (var i = 0; i < state.listTick.length; i++) {
        if (state.listState[i]) {
          listTick[i] ++; 
          listRes[i] = convertTime(listTick[i]);
        }
      }
      emit(state.copyWith(listTick: listTick, listRes: listRes));
    });
  }

  void firstStart(int index, int id){
    List<bool> listState = [...state.listState];
      listState[index] = true;
      operatorOperTable.setFirstTimeStart(id, DateTime.now().millisecondsSinceEpoch);
    emit(state.copyWith(listState: listState));
  }

  void startOrStop(int index, bool isStart, int id){
    List<bool> listState = [...state.listState];
    if (isStart){
      listState[index] = true;
      operatorOperTable.updateTimeStart(id, DateTime.now().millisecondsSinceEpoch);
    }
    else {
      listState[index] = false;
      operatorOperTable.updateTimeStop(id, DateTime.now().millisecondsSinceEpoch, state.listTick[index]);
    }
    emit(state.copyWith(listState: listState));
  }

  void refresh(index) {
    List<bool> listState = [...state.listState];
    List<int> listTick = [...state.listTick];
    List<String> listRes = [...state.listRes];
    listState[index] = false;
    listTick[index] = 0;
    listRes[index] = '00:00:00';
    emit(state.copyWith(listState: listState, listTick: listTick, listRes: listRes));
  }

  String convertTime(int tick){
    Duration duration = Duration(seconds: tick);
    final h = duration.inHours;
    final m = duration.inMinutes - duration.inHours * 60;
    final s = duration.inSeconds - duration.inMinutes * 60;
    return '${convertXX(h)}:${convertXX(m)}:${convertXX(s)}';
  }

  String convertXX(int num){
    if (num>=10) {return '$num';}
    else {return '0$num';}
  }

//
  void refreshAndStartStop(int index, bool isStart){
    //обнуляем нужный таймер
    List<bool> listState = [...state.listState];
    List<int> listTick = [...state.listTick];
    List<String> listRes = [...state.listRes];
    listState[index] = false;
    listTick[index] = 0;
    listRes[index] = '00:00:00';

    if (isStart){
      listState[index] = true;
      // operatorOperTable.updateTimeStart(id, DateTime.now().millisecondsSinceEpoch);
    }
    else {
      listState[index] = false;
      // operatorOperTable.updateTimeStop(id, DateTime.now().millisecondsSinceEpoch);
    }
    emit(state.copyWith(listState: listState, listTick: listTick, listRes: listRes));
  }
}