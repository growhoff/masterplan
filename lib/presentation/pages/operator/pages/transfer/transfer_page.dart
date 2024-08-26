import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/item_oper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key, required this.operation});
  final ItemOperOp? operation;
  
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
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Card(
                      color: Colors.amber,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('$index'),
                            Text('${listTransfer[index].number}.${listTransfer[index].name}')
                          ],
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemCount: listTransfer!.length,
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

