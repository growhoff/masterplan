import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/item_oper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';

class TransferPage extends StatelessWidget {
  const TransferPage(this.activeTransfer, {super.key, required this.operation});
  final ItemOperOp? operation;
  final int activeTransfer;
  @override
  Widget build(BuildContext context) {
    final listTransfer = operation!.list.first.listTransfer;
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
            final user = state.user!;
            return Column(
            children: [
              const Text('Список переходов'),
              Text('${user.fio} / ${user.position.name}', style: const TextStyle(fontSize: 12)),
            ]);
          }),
        ),
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:  Column(
                children: [
                  Text('Лист переходов операции ${operation!.list.first.operation.number}.${operation!.list.first.operation.name}', style: const TextStyle(fontWeight: FontWeight.w600),),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.white60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(
                    width: double.maxFinite,
                    child: Card(
                      color: Colors.white24,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(children: [
                          Expanded(child: Text('Порядковый номер', textAlign: TextAlign.center)),
                          Expanded(flex: 4, child: Text('Код перехода.Наименование перехода', textAlign: TextAlign.center,))
                        ],),
                    ),),
                  ),
                  const SizedBox(height: 20),
                  ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Card(
                      color: index == activeTransfer ? Colors.amber : index > activeTransfer ? Colors.white70 : Colors.greenAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('$index', textAlign: TextAlign.center)),
                            Expanded(flex: 4, child: Text('${listTransfer[index].number}.${listTransfer[index].name}', textAlign: TextAlign.center,))
                          ],
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(height: 2),
                    itemCount: listTransfer!.length,
                  ),
                        ],
                      ),),
                  ),
                ],
              )
        ),
      ),
    ),
      ),
    );
  }
}

