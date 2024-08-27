// import 'package:master_plan/domain/model/otp_path_operations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../queue_operations/bloc/cubit.dart';
import '../model/distrib_item.dart';
import 'package:master_plan/presentation/pages/master/pages/tableInfo/table_info_page.dart';
import 'package:master_plan/theme/theme.dart';

// import './../model/item_oper.dart';
// import './../widgets/reorderable_icon_widget.dart';
// import '../bloc/cubit.dart';
import 'row_list_four.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

class Reorder extends StatelessWidget {
  const Reorder(this.list, {super.key});
  final List<DistribItem> list;
  @override
  Widget build(BuildContext context) {
    return (list.isEmpty) 
    ? const Center(child: Text('Список операций пуст')) 
    : Column(
      children: [
        const RowListFour(text0: 'Этап' ,text1: 'Деталь', text2: 'Номер операции', text3: 'Общее \nТ шт.к.', text4: 'Кол-во \nдеталей',),
        const SizedBox(height: 8),
        ReorderableListView.builder(
        buildDefaultDragHandles: false,
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          bool? mod = list[index].listOperat.first.modific;
          return Container(
            key: ValueKey(index),
            color:  mod != null ? AppColors.modific : AppColors.notModific,
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Expanded(child: ReorderableIconWidget(index)),
              Expanded(flex: 3, child: Text('${list[index].listOperat.first.batch.order?.number}.${list[index].listOperat.first.batch.number}.${list[index].listOperat.first.stage.number}', textAlign: TextAlign.center)),
              Expanded(flex: 3, child: Text(list[index].detailNumber, textAlign: TextAlign.center)),
              Expanded(flex: 4, child: Text(list[index].operationName, textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text(list[index].timeShKal.toStringAsFixed(2), textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text('${list[index].count}', textAlign: TextAlign.center)),
              //инфо
              Expanded(child: IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TableInfoPage(list[index].listOperat))), icon: const Icon(Icons.info, color: Colors.blue))),
              //передать на готовые детали
              // Expanded(child: IconButton(onPressed: () {}, icon: const Icon(Icons.check_rounded, color: Colors.green))),
              //передать на распределение
              Expanded(child: IconButton(onPressed: () => context.read<CubitOperatQueueMasterChM>().saveDateList(list[index], index), icon: const Icon(Icons.close, color: Colors.red))),
            ],
                  ),
          );
        },
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) {newIndex = newIndex - 1;}
          final element  = list.removeAt(oldIndex);
          list.insert(newIndex, element);
        }
      )
      ],
    );
  }
}