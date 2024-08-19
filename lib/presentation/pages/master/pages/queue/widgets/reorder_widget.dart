import 'package:master_plan/domain/model/group_opt_path.dart';
// import 'package:master_plan/domain/model/otp_path_operations.dart';
import 'package:master_plan/presentation/pages/master/bloc/cubit.dart';
import 'package:master_plan/theme/theme.dart';
import './reorderable_icon_widget.dart';
import '../../tableInfo/table_info_page.dart';
import '../bloc/cubit.dart';
// import 'row_list_four.dart';
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
          return Container(
            key: ValueKey(index),
            color:  active ? const Color.fromARGB(255, 175, 250, 178) : mod != null ? AppColors.modific : AppColors.notModific,
            child: GestureDetector(
              onLongPress: () => context.read<CubitQueueMaster>().choiseOptPath(index),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: ReorderableIconWidget(index, list[index].listOptPath.length > 1)),
                Expanded(flex: 2, child: Text(list[index].listOptPath.first.list.first.stage.number, textAlign: TextAlign.center)),
                Expanded(flex: 4, child: Text('${list[index].listOptPath.first.list.first.batch.numberRS} ${list[index].listOptPath.first.list.first.batch.name}', textAlign: TextAlign.center)),
                Expanded(flex: 4, child: Text('${list[index].listOptPath.first.list.first.operation.number} ${list[index].listOptPath.first.list.first.operation.name}', textAlign: TextAlign.center)),
                Expanded(flex: 3, child: Text('${list[index].listOptPath.first.time}', textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text('${list[index].listOptPath.length > 1 ? '-' : list[index].listOptPath.first.list.length}', textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text('${list[index].listOptPath.length == 1 ? '-' : list[index].count}', textAlign: TextAlign.center)),
                //инфо
                Expanded(child: IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TableInfoPage(list[index].listOptPath.first.list),)), icon: const Icon(Icons.info, color: Colors.blue))),
                //передать на готовые детали
                Expanded(child: IconButton(onPressed: isGroup ? null : () => context.read<CubitQueueMaster>().updateOperationReady(list[index].listOptPath.first.idPath), icon: Icon(Icons.check_rounded, color: isGroup ? Colors.black12 : Colors.green))),
                //передать на распределение
                Expanded(child: IconButton(onPressed: isGroup ? null : () => context.read<CubitQueueMaster>().updateOperationDistribMaster(list[index].listOptPath.first.idPath), icon: Icon(Icons.close, color: isGroup ? Colors.black12 : Colors.red))),
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
          context.read<CubitMaster>().setList(list);
        }
      )
      ],
    );
  }
}