// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ButtonStatus {
  final List<String> listStatus;
  ButtonStatus({
    this.listStatus = const ['Все', 'Пауза', 'Переналадка', 'Уборка', 'Поломка', 'НетУП', 'НетЧертеж', 'В работе' , 'Отключено'],
  });

  String toggleStatus(String status, String oldStatus){
    String res = status;
    // switch (status) {
    //   case 'Все': res = 'Все'; break;
    //   case 'Пауза': res = 'Пауза'; break;
    //   case 'Переналадка': res = 'Переналадка'; break;
    //   case 'Уборка': res = 'Уборка'; break;
    //   case 'Поломка': res = 'Поломка'; break;
    //   case 'НетУП': res = 'НетУП'; break;
    //   case 'НетЧертеж': res = 'НетЧертеж'; break;
    //   default: res = 'Все';
    // }
    if (status != 'Пауза' && oldStatus != 'Пауза') if (status == oldStatus) res = 'Все';
    return res;
  }

  int getIdStatus(String status){
    int res;
    switch (status) {
      case 'Все': res = -1; break;
      case 'Пауза': res = -2; break;
      case 'В работе': res = 1; break;
      case 'Простой': res = 2; break;
      case 'Переналадка': res = 3; break;
      case 'Поломка': res = 4; break;
      case 'Уборка': res = 5; break;
      case 'ОтсутствиеИнструмента': res = 6; break;
      case 'НетУП': res = 7; break;
      case 'НетЧертеж': res = 9; break;
      default: res = 2;
    }
    return res;
  }

  Color getColorStatus(String status){
    Color colorStatus;
    switch (status) {
      case 'Все': colorStatus = Colors.red; break;
      case 'Пауза': colorStatus = Colors.green; break;
      case 'В работе': colorStatus = Colors.green; break;
      case 'Простой': colorStatus = Colors.red; break;
      case 'Переналадка': colorStatus = Colors.yellow; break;
      case 'Поломка': colorStatus = Colors.orange; break;
      case 'Уборка': colorStatus = Colors.purple; break;
      case 'ОтсутствиеИнструмента': colorStatus = Colors.blueAccent; break;
      case 'НетУП': colorStatus = Colors.blue; break;
      case 'НетЧертеж': colorStatus = Colors.purpleAccent; break;
      default: colorStatus = const Color.fromARGB(255, 207, 207, 207);
    }
    return colorStatus;
  }
}
