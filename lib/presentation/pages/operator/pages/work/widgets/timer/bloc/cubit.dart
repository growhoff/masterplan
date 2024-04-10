import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class CubitTimer extends Cubit<StateTimer> {
  final int length;
  CubitTimer(this.length) : super(const StateTimer()){
    init();
  }

  void init(){
      emit(state.copyWith(listTick: List.filled(length, 0), listState: List.filled(length, false), listRes: List.filled(length, '00:00:00')));
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

  void start(int index){
    List<bool> listState = [...state.listState];
    listState[index] = true;
    emit(state.copyWith(listState: listState));
  }

  void stop(index) {
    List<bool> listState = [...state.listState];
    listState[index] = false;
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
}



  // String convertXX(int num){
  //   if (num>=10) {return '$num';}
  //   else {return '0$num';}
  // }

  // void timeToString(int time) {
  //   if (time == 60 || time % 60 == 0) {second = 0; minute++;}
  //   else {second++;}
  //   if (minute == 60) {minute = 0; hour++;}
  //   final hourString = convertXX(hour);
  //   final minuteString = convertXX(minute);
  //   final secondString = convertXX(second);
  //   result = '$hourString:$minuteString:$secondString';
  // }

  // void timeToStringNow(int time) {
  //   hour = time ~/ 3600;
  //   minute = (time % 3600) ~/ 60;
  //   second = (time % 3600) % 60;
  //   final hourString = convertXX(hour);
  //   final minuteString = convertXX(minute);
  //   final secondString = convertXX(second);
  //   result = '$hourString:$minuteString:$secondString';
  // }