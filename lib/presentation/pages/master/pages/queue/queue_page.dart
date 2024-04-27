import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/bloc/cubit.dart';
// import 'package:master_plan/presentation/pages/master/pages/queue/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/widgets/element_bar.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/widgets/reorderable_icon_widget.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/widgets/row_expand_queue.dart';
// import '../../../../widgets/element_bar.dart';
import 'widgets/row_list_four.dart';

class QueuePageMaster extends StatelessWidget {
  const QueuePageMaster({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitQueueMaster>(
      create: (context) => CubitQueueMaster(stateMain.machineList, stateMain.queueList),
      child: const QueuePageMasterContent(),
    );
  }
}

class QueuePageMasterContent extends StatelessWidget {
  const QueuePageMasterContent({super.key});
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        child: Padding(
            padding:  EdgeInsets.all(16),
            child: ElementBarQueue()),
      ),
    );
  }
}

class ContetnQueue extends StatelessWidget {
  const ContetnQueue({super.key, required this.batchListQueue, required this.machine, required this.timeWorking});
  final List<OperatorOperations> batchListQueue;
  // final List<OperatorOperations> batchListReady;
  final Machine machine;
  final int timeWorking;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text('Время работы станка ${machine.name}: '),
            Text('$timeWorking минут')
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 6,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/addOperationPage'),
                child: const Text('Добавить операцию'),
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 6,
              child: ElevatedButton(
                onPressed: () => context.read<CubitQueueMaster>().saveDate(),
                child: const Text('Сохранить изменения'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(),
        // ListViewOperationsReady(batchListReady),
        const SizedBox(height: 8),
        Reorder(batchListQueue)
      ],
    );
  }
}

class ListViewOperationsReady extends StatelessWidget {
  const ListViewOperationsReady(this.list, {super.key});
  final List<OperatorOperations> list;
  @override
  Widget build(BuildContext context) {
    return (list.isEmpty) 
    ? const Center(child: Text('Список операций пуст')) 
    : Column(
      children: [
        const RowExpandQueue(text1: 'Деталь', text2: 'Операция', text3: 'Время обработки'),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) => Card(
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RowExpandQueue(
                  text1: list[index].batch.number,
                  text2: list[index].operation.name,
                  text3: '${list[index].timefact}'),
            ),
          ),
        ),
      ],
    );
  }
}

class Reorder extends StatelessWidget {
  const Reorder(this.list, {super.key});
  final List<OperatorOperations> list;
  @override
  Widget build(BuildContext context) {
    return (list.isEmpty) 
    ? const Center(child: Text('Список операций пуст')) 
    : Column(
      children: [
        const RowListFour(text1: 'Деталь', text2: 'Номер', text3: 'Время обработки'),
        const SizedBox(height: 8),
        ReorderableListView.builder(
        buildDefaultDragHandles: false,
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) => Row(
          key: ValueKey(index),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: ReorderableIconWidget(index)),
            Expanded(flex: 2, child: Text(list[index].batch.number, textAlign: TextAlign.center)),
            Expanded(flex: 4, child: Text(list[index].operation.name, textAlign: TextAlign.center)),
            Expanded(flex: 2, child: Text('${list[index].timefact}', textAlign: TextAlign.center)),
            //передать на готовые детали
            Expanded(child: IconButton(onPressed: () => context.read<CubitQueueMaster>().updateOperationReady(list[index].id), icon: const Icon(Icons.check_rounded))),
            //передать на распределение
            Expanded(child: IconButton(onPressed: () => context.read<CubitQueueMaster>().updateOperationDistribMaster(list[index].id), icon: const Icon(Icons.close)))
          ],
        ),
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

// class ReorderWidget extends StatefulWidget {
//   const ReorderWidget(this.list, {super.key, required this.header});
//   final List<OperatorOperations> list;
//   final Widget header;
//   @override
//   State<ReorderWidget> createState() => _ReorderWidgetState();
// }

// class _ReorderWidgetState extends State<ReorderWidget> {

//   late List<OperatorOperations> list;

//   @override
//   void initState() {
//     list = widget.list;
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return ReorderableListView.builder(
//         buildDefaultDragHandles: false,
//         shrinkWrap: true,
//         // header: widget.header,
//         itemCount: list.length,
//         itemBuilder: (context, index) => Row(
//           key: ValueKey(index),
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(child: ReorderableIconWidget(index)),
//             Expanded(flex: 2, child: Text(list[index].batch.number)),
//             Expanded(flex: 2, child: Text(list[index].operation.name)),
//             Expanded(flex: 2, child: Text('${list[index].timefact}')),
//             Expanded(child: IconButton(onPressed: () => list.removeAt(index), icon: const Icon(Icons.close)))
//           ],
//         ),
//         onReorder: (oldIndex, newIndex) {
//           if (newIndex > oldIndex) {newIndex = newIndex - 1;}
//           final element  = list.removeAt(oldIndex);
//           list.insert(newIndex, element);
//           setState(() {});
//         }
//       );
//   }
// }