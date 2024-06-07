import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
// import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_oper.dart';
// import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_operation.dart';

class RowExpandContent extends StatelessWidget {
  const RowExpandContent({super.key, required this.operation, required this.indexOper, required this.intL});
  final ItemOperReady operation;
  final int indexOper;
  final int intL;
  @override
  Widget build(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 4, child: Text('${operation.list.first.batch.number} ${operation.list.first.batch.name}', textAlign: TextAlign.start)),
                Expanded(flex: 4, child: Text('${operation.list.first.operation.number} ${operation.list.first.operation.name}', textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text('${operation.list.first.timeplan}', textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text('${operation.list.length}', textAlign: TextAlign.center)),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 5, horizontal: 5)),
                      backgroundColor: MaterialStateProperty.all(intL == 5 ? Colors.blueGrey : Colors.blue),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () => context.read<CubitReadyDetails>().toggleBrak(indexOper), 
                    child: const Text('Брак'),),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 5, horizontal: 5)),
                      backgroundColor: MaterialStateProperty.all(intL == 4 ? Colors.blueGrey : Colors.blue),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: ()=> context.read<CubitReadyDetails>().toggleModific(indexOper), 
                    child: const Text('Доработка')),
                ),
              ],
            );
  }
}