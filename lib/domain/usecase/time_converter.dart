import 'package:intl/intl.dart';

class TimeConverter {
  static final TimeConverter instance = TimeConverter._internal();

  TimeConverter._internal();

  factory TimeConverter() {
    return instance;
  }

  String convertTimeFromSeconds(int timeSec) {
    var seconds = timeSec;
    var minutes = seconds ~/ 60;
    var hours = minutes ~/ 60;
    String time = '$hours : ${minutes - hours * 60} : ${seconds - minutes * 60}';
    return time;
  }


  String convertTimeFromMinutes(int timeMin) {
    var minutes = timeMin;
    var hours = minutes ~/ 60;
    String time = '$hours : ${minutes - hours * 60} : 0';
    return time;
  }


  String convertTimeMinHHMM(int timeMin){
    final h = timeMin ~/ 60;
    final min = timeMin - h * 60;
    final minStr = min > 9 ? '$min' : '0$min';
    final hStr = h > 9 ? '$h' : '0$h';
    return '$hStr:$minStr';
  }

  String convertTimeMinHMin(int timeMin){
    final h = timeMin ~/ 60;
    final min = timeMin - h * 60;
    if (h == 0) {return '$min мин.';}
    else {return '$h ч. $min мин.';}
  }

  String convertTimeFromSecondsHHMMSS(int timeSec) {
    final seconds = timeSec;
    final minutes = seconds ~/ 60;
    final hours = minutes ~/ 60;
    final s = seconds - minutes * 60;
    final m = minutes - hours * 60;
    final secStr = s > 9 ? '$s' : '0$s';
    final minStr = m > 9 ? '$m' : '0$m';
    final hStr = hours > 9 ? '$hours' : '0$hours';
    return '$hStr:$minStr:$secStr';
  }

  String convertMillisecondsSinceEpochToHHMMSS(int time){
    return DateFormat('hh:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(time)).toString();
  }

  int getTimeWorking(int timeStart, int timeStop){
    final date1 = DateTime.fromMillisecondsSinceEpoch(timeStart).toUtc();
    final date2 = DateTime.fromMillisecondsSinceEpoch(timeStop).toUtc();
    final difference = (date2.difference(date1)).inSeconds;
    return difference;
  }
}
