import 'package:flutter/material.dart';

// class DialogFilterChois extends StatefulWidget {
//   const DialogFilterChois({super.key});

//   @override
//   State<DialogFilterChois> createState() => _DialogFilterChoisState();
// }

// class _DialogFilterChoisState extends State<DialogFilterChois> {
//   TextEditingController controller = TextEditingController();
//   int code = 0;

//   String getName(int code){
//     String res = '';
//     switch (code){
//       case 1: res = 'по номеру чертежа';
//       case 2: res = 'по наименованию чертежа';
//       case 3: res = 'по номеру этапа';
//       case 4: res = 'по наименованию операции';
//       case 5: res = 'по приоритету';
//       default: '';
//     }
//     return res;
//   }
//   @override
//   Widget build(BuildContext context) {  
//     return AlertDialog(
//                 title: Text(code == 0 ? 'Выбор категории фильтрации' : 'Введите текст для фильтрации'),
//                 content: code == 0 ? null : TextFormField(controller: controller),
//                 titleTextStyle: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,fontSize: 20),
//                 actionsOverflowButtonSpacing: 10,
//                 actionsAlignment: MainAxisAlignment.center,
//                 actions: [
//                   code == 0 ? Column(children: [
//                     SizedBox(width: double.maxFinite, child: ElevatedButton(onPressed: () => setState(() {code = 1;}), child: const Text('По номеру чертежа'))),
//                     const SizedBox(height: 8),
//                     SizedBox(width: double.maxFinite, child: ElevatedButton(onPressed: () => setState(() {code = 2;}), child: const Text('По наименованию чертежа'))),
//                     const SizedBox(height: 8),
//                     SizedBox(width: double.maxFinite, child: ElevatedButton(onPressed: () => setState(() {code = 3;}), child: const Text('По номеру этапа'))),
//                     const SizedBox(height: 8),
//                     SizedBox(width: double.maxFinite, child: ElevatedButton(onPressed: () => setState(() {code = 4;}), child: const Text('По наименованию операции'))),
//                     const SizedBox(height: 8),
//                     SizedBox(width: double.maxFinite, child: ElevatedButton(onPressed: () => setState(() {code = 5;}), child: const Text('По приоритету'))),
//                   ],)
//                   : Column(children: [
//                     SizedBox(width: double.maxFinite, child: ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: Text('Применить фильтр ${getName(code)}'))),
//                     const SizedBox(height: 8),
//                     SizedBox(width: double.maxFinite, child: ElevatedButton(onPressed: () => Navigator.pop(context, 'clear'), child: const Text('Сбросить фильтр')))
//                   ],)
//                 ],
//             );
// }
// }

class DialogFilterChois extends StatelessWidget {
  const DialogFilterChois({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return AlertDialog(
                title: const Text('Введите текст для фильтрации'),
                content: TextFormField(controller: controller),
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,fontSize: 20),
                actionsOverflowButtonSpacing: 10,
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  Column(children: [
                    SizedBox(width: double.maxFinite, child: ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Применить фильтр'))),
                    const SizedBox(height: 8),
                    SizedBox(width: double.maxFinite, child: ElevatedButton(onPressed: () => Navigator.pop(context, 'clear'), child: const Text('Сбросить фильтр')))
                  ],)
                ],
            );
  }
}