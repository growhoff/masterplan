// import 'dart:async';
// import 'package:flutter/material.dart';

// class TestPage extends StatelessWidget {
//   const TestPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(child: Center(child: TimerMessage(),)),
//     );
//   }
// }


// class TimerMessage extends StatefulWidget {
//   const TimerMessage({super.key});

//   @override
//   State<TimerMessage> createState() => _TimerMessageState();
// }

// class _TimerMessageState extends State<TimerMessage> {
//   late Timer timer;
//   bool swapMsg = false;
//   bool blocMsg = false;
//   @override
//   void initState() {
//     timer = Timer.periodic(const Duration(seconds: 1), (time) {
//       final data = DateTime.now();
//       final h = data.hour;
//       final m = data.minute;
//       // 7:50 19:50
//       // 8:00 20:00
//       // 8:10 20:10
//       if ((h==7 && m==50) || (h==19 && m==50)){ swapMsg = true;}
//       if ((h==8 && m==10) || (h==20 && m==10)){ swapMsg = false;  blocMsg = false;}
//       if ((h==8 && m==00) || (h==20 && m==00)){ blocMsg = true;}
//       setState(() {});
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text('Time: $swapMsg'),
//     );
//   }
// }