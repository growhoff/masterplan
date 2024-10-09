import 'package:master_plan/domain/model/group_opt_path.dart';
import 'package:master_plan/domain/usecase/color_priority.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/tableInfo/table_info_page.dart';
// import 'package:master_plan/presentation/pages/master/bloc/cubit.dart';
import 'package:master_plan/theme/theme.dart';
import './reorderable_icon_widget.dart';
// import '../../tableInfo/table_info_page.dart';
import '../bloc/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Reorder extends StatelessWidget {
  const Reorder(this.list, this.isGroup, {super.key});
  final List<GroupOptPath> list;
  final bool isGroup;
  @override
  Widget build(BuildContext context) {    
    return (list.isEmpty) 
    ? const Center(child: Text('Список операций пуст')) 
    : Column(
      children: [
        ReorderableListView.builder(
        buildDefaultDragHandles: false,
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          bool? mod = list[index].listOptPath.first.list.first.modific;
          bool active = list[index].isChoise;
          int priority = list[index].listOptPath.first.list.first.batch.order == null ? 0 : list[index].listOptPath.first.list.first.batch.order!.priority;
          return Card(
            key: ValueKey(index),
            color:  active ? const Color.fromARGB(255, 175, 250, 178) : AppColors.notModific,
            child: GestureDetector(
              onLongPress: () => context.read<CubitQueueMaster>().choiseOptPath(index),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TableInfoPage(list[index].listOptPath.first.list))),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: ReorderableIconWidget(index, list[index].listOptPath.length > 1)),
                Expanded(child: Padding(padding: const EdgeInsets.all(8), child: CircleAvatar(backgroundColor: ColorPriority.getColor(priority), radius: 15,child: Text('$priority')))),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${list[index].listOptPath.first.list.first.batch.numberRS} ${list[index].listOptPath.first.list.first.batch.name}', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w700, color: mod != null ? AppColors.modific : AppColors.black)),
                      Text('${list[index].listOptPath.first.list.first.operation.number} ${list[index].listOptPath.first.list.first.operation.name}', textAlign: TextAlign.left, style: TextStyle(color: mod != null ? AppColors.modific : AppColors.black)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Text((list[index].listOptPath.first.list.first.operation.timeSH + (list[index].listOptPath.first.list.first.operation.timepz / list[index].listOptPath.length)).toStringAsFixed(2), style: TextStyle(color: mod != null ? AppColors.modific : AppColors.black)),//T шт. + Т п. з./кол-во
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${list[index].listOptPath.length > 1 ? '-' : list[index].listOptPath.first.list.length}', textAlign: TextAlign.center, style: TextStyle(color: mod != null ? AppColors.modific : AppColors.black)),
                            Text('${list[index].listOptPath.length == 1 ? '-' : list[index].count}', textAlign: TextAlign.center, style: TextStyle(color: mod != null ? AppColors.modific : AppColors.black)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                // Expanded(flex: 2, child: Text('${list[index].listOptPath.first.list.first.batch.order?.number}.${list[index].listOptPath.first.list.first.batch.number}.${list[index].listOptPath.first.list.first.stage.number}', textAlign: TextAlign.center)),
                // Expanded(flex: 3, child: Text('${list[index].listOptPath.first.time}', textAlign: TextAlign.center)),
                
                //инфо
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //передать на готовые детали
                        IconButton(onPressed: isGroup ? null : () => context.read<CubitQueueMaster>().updateOperationReady(list[index].listOptPath), icon: Icon(Icons.check_circle, color: isGroup ? Colors.black12 : Colors.black)),
                        //передать на распределение
                        IconButton(onPressed: isGroup ? null : () => context.read<CubitQueueMaster>().updateOperationDistribMaster(list[index].listOptPath.first.idPath), icon: Icon(Icons.cancel_rounded, color: isGroup ? Colors.black12 : Colors.black)),
                      ],
                    ),
                  ),
                ),
                ],
              ),
            ),
          );
        },
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) {newIndex = newIndex - 1;}
          final element  = list.removeAt(oldIndex);
          list.insert(newIndex, element);
          //save
          // context.read<CubitMaster>().setList(list);
          context.read<CubitQueueMaster>().saver(list);
          context.read<CubitMain>().toggleSaverQuere(true);
        }
      )
      ],
    );
  }
}