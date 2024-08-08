import 'package:flutter/material.dart';
import 'package:master_plan/domain/usecase/button_status.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/elevated_button_castom.dart';

class DialogButtonSet extends StatelessWidget {
  const DialogButtonSet(this.statusBtn, {super.key});
  final String statusBtn;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Выбор статуса'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: ElevatedButtonCastom(
                text: 'Переналадка',
                isActive: (statusBtn == 'Все') || (statusBtn == 'Переналадка'),
                color: ButtonStatus().getColorStatus('Переналадка'),
                onPressed: () async {
                  // String? val = '';
                  // if (statusBtn != 'Переналадка') {val = await showDialog<String>(context: context,builder: (BuildContext context) => const DialogInputComment());}
                  // else{val = '-';}
                  // if (val != ''){
                  //   if (context.mounted) context.read<CubitWork>().setMonitor('Переналадка', val!, statusBtn != 'Переналадка', operation.idPath);
                  //   if (context.mounted) context.read<CubitTimer>().refreshAndStartStop(astivePage, statusBtn != 'Переналадка');
                  // }
                  Navigator.pop(context, 'Переналадка');
                }),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.maxFinite,
            child: ElevatedButtonCastom(
                text: 'Уборка',
                isActive: (statusBtn == 'Все') || (statusBtn == 'Уборка'),
                color: ButtonStatus().getColorStatus('Уборка'),
                onPressed: () async {
                  // String? val = '';
                  // if (statusBtn != 'Уборка') {val = await showDialog<String>(context: context,builder: (BuildContext context) => const DialogInputComment());}
                  // else{val = '-';}
                  // if (val != ''){
                  //   if (context.mounted) context.read<CubitWork>().setMonitor('Уборка', val!, statusBtn != 'Уборка', operation.idPath);
                  //   if (context.mounted) context.read<CubitTimer>().refreshAndStartStop(astivePage, statusBtn != 'Уборка');
                  // }
                  Navigator.pop(context, 'Уборка');
                }),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.maxFinite,
            child: ElevatedButtonCastom(
                text: 'Поломка',
                isActive: (statusBtn == 'Все') ||
                    (statusBtn == 'В работе') ||
                    (statusBtn == 'Простой') ||
                    (statusBtn == 'Поломка'),
                color: ButtonStatus().getColorStatus('Поломка'),
                onPressed: () async {
                  // String? val = '';
                  // if (statusBtn != 'Поломка') {val = await showDialog<String>(context: context,builder: (BuildContext context) => const DialogInputComment());}
                  // else{val = '-';}
                  // if (val != ''){
                  //   // if (context.mounted) await context.read<CubitWork>().setError(context.read<CubitTimer>().state.listTick[astivePage], operation.idPath);
                  //   if (context.mounted) await context.read<CubitWork>().setMonitor('Поломка', val!, statusBtn != 'Поломка', operation.idPath);
                  //   if (context.mounted) context.read<CubitTimer>().refreshAndStartStop(astivePage, statusBtn != 'Поломка');
                  // }
                  Navigator.pop(context, 'Поломка');
                }),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.maxFinite,
            child: ElevatedButtonCastom(
                text: 'Нет УП',
                isActive: (statusBtn == 'Все') || (statusBtn == 'НетУП'),
                color: ButtonStatus().getColorStatus('НетУП'),
                onPressed: () async {
                  //  String? val = '';
                  //   if (statusBtn != 'НетУП') {val = await showDialog<String>(context: context,builder: (BuildContext context) => const DialogInputComment());}
                  //   else{val = '-';}
                  //   if (val != ''){
                  //     if (context.mounted) await context.read<CubitWork>().setMonitor('НетУП', val!, statusBtn != 'НетУП', operation.idPath);
                  //     if (context.mounted) context.read<CubitTimer>().refreshAndStartStop(astivePage, statusBtn != 'НетУП');
                  //   }
                  Navigator.pop(context, 'НетУП');
                }),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.maxFinite,
            child: ElevatedButtonCastom(
                text: 'Нет чертежа, нет технологии',
                isActive: (statusBtn == 'Все') || (statusBtn == 'НетЧертеж'),
                color: ButtonStatus().getColorStatus('НетЧертеж'),
                onPressed: () async {
                  //  String? val = '';
                  //   if (statusBtn != 'НетЧертеж') {val = await showDialog<String>(context: context,builder: (BuildContext context) => const DialogInputComment());}
                  //   else{val = '-';}
                  //   if (val != ''){
                  //     if (context.mounted) await context.read<CubitWork>().setMonitor('НетЧертеж', val!, statusBtn != 'НетЧертеж', operation.idPath);
                  //     if (context.mounted) context.read<CubitTimer>().refreshAndStartStop(astivePage, statusBtn != 'НетЧертеж');
                  //   }
                  Navigator.pop(context, 'НетЧертеж');
                }),
          ),
        ],
      ),
      titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
      actionsOverflowButtonSpacing: 20,
      actionsAlignment: MainAxisAlignment.center,
      actions: const [],
    );
  }
}
