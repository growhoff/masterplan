import 'dart:async';
import 'package:flutter/material.dart';
import 'buttonIcon.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget(this.timeStart, {super.key});
  final int timeStart;
  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {

  bool isRunning = false;
  int tick = 0;
  int hour = 0;
  int minute = 0;
  int second = 0;
  String result = '00:00:00';
  Timer? timer;

  String convertXX(int num){
    if (num>=10) {return '$num';}
    else {return '0$num';}
  }

  void timeToString(int time) {
    if (time == 60 || time % 60 == 0) {second = 0; minute++;}
    else {second++;}
    if (minute == 60) {minute = 0; hour++;}
    final hourString = convertXX(hour);
    final minuteString = convertXX(minute);
    final secondString = convertXX(second);
    result = '$hourString:$minuteString:$secondString';
  }

  void timeToStringNow(int time) {
    hour = time ~/ 3600;
    minute = (time % 3600) ~/ 60;
    second = (time % 3600) % 60;
    final hourString = convertXX(hour);
    final minuteString = convertXX(minute);
    final secondString = convertXX(second);
    result = '$hourString:$minuteString:$secondString';
  }

  void start(int init){
    if (!isRunning){
      tick = tick + init;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      tick++;
      timeToString(tick);
      setState(() {});
    });
    
    } else{
      timer!.cancel();
      setState(() {});
    }
    isRunning = !isRunning;
    setState(() {});
  }

  // void pause(){
  //   isRunning = false;
  //   timer!.cancel();
  //   setState(() {});
  // }

  void restart(){
    isRunning = false;
    tick = 0;
    hour = 0;
    minute = 0;
    second = 0;
    result = '00:00:00';
    timer!.cancel();
    setState(() {});
  }

  @override
  void initState() {
    tick = widget.timeStart;
    timeToStringNow(tick);
    super.initState();
    setState(() {});
  }

  // @override
  // void dispose() {
  //   timer!.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
            Text(result, style: const TextStyle(fontSize: 40),),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ButtonCircleIcon(onPressed: () => restart(), icon: Icons.restart_alt),
                ButtonCircleIcon(onPressed: () => start(0), icon: !isRunning ? Icons.play_arrow_rounded : Icons.pause),
                // ButtonCircleIcon(onPressed: () => pause(), icon: Icons.pause),
                ButtonCircleIcon(onPressed: () => Navigator.pushNamed(context, '/queuePage'), icon: Icons.list),
              ],
            ),
      ],
    );
  }
}