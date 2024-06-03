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

    String time =
        '$hours : ${minutes - hours * 60} : ${seconds - minutes * 60}';

    return time;
  }


  String convertTimeFromMinutes(int timeMin) {

    var minutes = timeMin;

    var hours = minutes ~/ 60;

    String time =
        '$hours : ${minutes - hours * 60} : 0';

    return time;
  }
}
