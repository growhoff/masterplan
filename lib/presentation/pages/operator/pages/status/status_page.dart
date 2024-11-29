import 'package:flutter/material.dart';
import 'package:master_plan/domain/usecase/button_status.dart';
import 'widgets/elevated_button_castom.dart';

class StatusPage extends StatelessWidget {
  const StatusPage(this.statusBtn, this.isError, {super.key});
  final String statusBtn; 
  final bool isError;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(title: const Text('Выбор статуса')),
        body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child:  SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: GridView(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    crossAxisSpacing: 16, 
                    mainAxisSpacing: 16,
                    childAspectRatio: 1
                  ),
                  children: [
        Visibility(
          visible: !isError,
          child: ElevatedButtonCastom(
            assets: 'assets/images/operator/perenalad.jpg',
            text: 'Переналадка',
            isActive: (statusBtn == 'Все') || (statusBtn == 'Переналадка'),
            color: ButtonStatus().getColorStatus('Переналадка'),
            onPressed: () async {Navigator.pop(context, 'Переналадка');}),
        ),

        ElevatedButtonCastom(
          assets: 'assets/images/operator/polomka.jpg',
          text: 'Поломка',
          isActive: (statusBtn == 'Все') ||
              (statusBtn == 'В работе') ||
              (statusBtn == 'Простой') ||
              (statusBtn == 'Поломка'),
          color: ButtonStatus().getColorStatus('Поломка'),
          onPressed: () async {Navigator.pop(context, 'Поломка');}),
        
        Visibility(
          visible: !isError,
          child: ElevatedButtonCastom(
            assets: 'assets/images/operator/clear.jpg',
            text: 'Уборка',
            isActive: (statusBtn == 'Все') || (statusBtn == 'Уборка'),
            color: ButtonStatus().getColorStatus('Уборка'),
            onPressed: () async {Navigator.pop(context, 'Уборка');}),
        ),

        Visibility(
          visible: !isError,
          child: ElevatedButtonCastom(
            assets: 'assets/images/operator/otsutyp.jpg',
            text: 'Отсутствует УП',
            isActive: (statusBtn == 'Все') || (statusBtn == 'НетУП'),
            color: ButtonStatus().getColorStatus('НетУП'),
            onPressed: () async {Navigator.pop(context, 'НетУП');}),
        ),

        Visibility(
          visible: !isError,
          child: ElevatedButtonCastom(
            assets: 'assets/images/operator/notkdandtd.jpg',
            text: 'Нет КД или ТД',
            isActive: (statusBtn == 'Все') || (statusBtn == 'НетЧертеж'),
            color: ButtonStatus().getColorStatus('НетЧертеж'),
            onPressed: () async {Navigator.pop(context, 'НетЧертеж');}),
        ),
                  ],
                ),
              ),
              ),
            ),
      ),
    );
  }
}

