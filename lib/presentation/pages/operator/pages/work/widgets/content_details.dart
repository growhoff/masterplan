import 'package:flutter/material.dart';
import 'line_text_spawn.dart';
import 'timer.dart';
import 'elevated_button_castom.dart';

class ContentDetail extends StatelessWidget {
  const ContentDetail({super.key, required this.detail, required this.operations, required this.time});
  final String detail;
  final String operations;
  final int time;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
              LineTextSpawn(title: 'Деталь', text: detail),
              const SizedBox(height: 8),
              LineTextSpawn(title: 'Операция', text: operations),
              const SizedBox(height: 50),
              TimerWidget(time),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButtonCastom(text: 'Переналадка', color: Colors.amber, onPressed: (){},),
                  ElevatedButtonCastom(text: 'Уборка', color: Colors.blueGrey, onPressed: (){},),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButtonCastom(text: 'Деталь', color: Colors.green, onPressed: (){},),
              const SizedBox(height: 8),
              ElevatedButtonCastom(text: 'Поломка', color: Colors.red, onPressed: (){},)
      ],
    );
  }
}