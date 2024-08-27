import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/presentation/pages/master/pages/tableInfo/bloc/state.dart';
import './widgets/table_info.dart';
import './bloc/cubit.dart';

class TableInfoPage extends StatelessWidget {
  const TableInfoPage(this.oper, {super.key});
  final List<OperatorOperations> oper;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CubitTableInfo>(
      create: (context) => CubitTableInfo(oper),
      child: const TableInfoContent(),
    );
  }
}

class TableInfoContent extends StatelessWidget {
  const TableInfoContent({super.key});
  @override
  Widget build(BuildContext context) {
    var oper = context.read<CubitTableInfo>().operationList;
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Последовательность операций')
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Деталь: ${oper.first.batch.numberRS} ${oper.first.batch.name}'),
                const SizedBox(height: 8),
                Text('Этап: ${oper.first.batch.order?.number}.${oper.first.batch.number}.${oper.first.stage.number} ${oper.first.stage.name}'),
                const SizedBox(height: 8),
                Text('Количество: ${oper.length}'),
                const SizedBox(height: 8),
                BlocBuilder<CubitTableInfo, StateTableInfo>(
                      builder: (context, state) => 
                      state.listTable == null 
                      ? const Center(child: CircularProgressIndicator())  
                      : TableInfo(state.listTable!, state.activeItem!)
                      ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
