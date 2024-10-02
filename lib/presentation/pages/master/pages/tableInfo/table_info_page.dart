import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/usecase/color_priority.dart';
import 'package:master_plan/presentation/pages/master/pages/tableInfo/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/tableInfo/widgets/table_info_2.dart';
import 'package:master_plan/theme/theme.dart';
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
    int priority = oper.first.batch.order == null ? 0 : oper.first.batch.order!.priority;
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Последовательность\nопераций', textAlign: TextAlign.center)
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Card(
                  color: AppColors.greyMaket,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(flex: 10, child: Text('${oper.first.batch.order?.number}.${oper.first.batch.number}.${oper.first.stage.number} ${oper.first.stage.name}\n${oper.first.batch.numberRS} ${oper.first.batch.name}')),
                            Expanded(child: Padding(padding: const EdgeInsets.all(8), child: CircleAvatar(backgroundColor: ColorPriority.getColor(priority), radius: 15,child: Text('$priority'))))
                          ],
                        ),
                        const DashLine(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Количество: ${oper.length}'),
                            Text('ТП: ${oper.first.batch.technology}')
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                BlocBuilder<CubitTableInfo, StateTableInfo>(
                      builder: (context, state) => 
                      state.listTable == null 
                      ? const Center(child: CircularProgressIndicator())  
                      : TableInfoNew(state.listTable!, state.activeItem!)
                      ),
              ],
            )
          ),
        ),
      ),
    );
  }
}

class DashLine extends StatelessWidget {
  const DashLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(150 ~/ 1,
          (index) => Expanded(
                child: Container(
                  color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                  height: 2,
                ),
              )),
    );
  }
}
