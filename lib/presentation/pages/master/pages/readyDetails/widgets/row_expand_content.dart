import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_oper.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/dialog_input.dart';
import 'package:master_plan/presentation/pages/master/pages/tableInfo/table_info_page.dart';

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
                Expanded(flex: 10, child: Text('${operation.list.first.batch.number} ${operation.list.first.batch.name}', textAlign: TextAlign.start)),
                Expanded(flex: 10, child: Text('${operation.list.first.operation.number} ${operation.list.first.operation.name}', textAlign: TextAlign.center)),
                Expanded(flex: 6, child: Text('${operation.timeWorking ~/ 60}', textAlign: TextAlign.center)),
                Expanded(flex: 6, child: Text('${operation.list.length}', textAlign: TextAlign.center)),
                Expanded(
                  flex: 3, 
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 5, horizontal: 5)),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TableInfoPage(operation.list),)), 
                  child: const Icon(Icons.info, color: Colors.white,))
                  ),
                const Spacer(),
                Expanded(
                  flex: 3,
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
                    onPressed: () {
                      final state = context.read<CubitReadyDetails>().state;
                      if (state.statusList[state.activePage][indexOper].status == 1){
                      context.read<CubitReadyDetails>().toggleBrak(indexOper, '0', '');}
                      else{
                        showDialog(
                        context: context, 
                        builder: (BuildContext innerContext){
                          return BlocProvider.value(
                            value: context.watch<CubitReadyDetails>(),
                            child: Material(
                              child: BlocBuilder<CubitReadyDetails, StateReadyDetails>(
                                builder: (context, state) => DialogInput(count: operation.list.length, indexOper: indexOper, status: true),
                              )
                            ),
                            );
                        });
                      }
                      
                    }, 
                    child: const Tooltip(message: 'Брак', child: Icon(Icons.report_gmailerrorred_outlined, color: Colors.red))),
                ),
                const Spacer(),
                Expanded(
                  flex: 3,
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
                    onPressed: (){
                      final state = context.read<CubitReadyDetails>().state;
                      if (state.statusList[state.activePage][indexOper].status == 2){
                      context.read<CubitReadyDetails>().toggleModific(indexOper, '0', '');}
                      else{
                        showDialog(
                        context: context, 
                        builder: (BuildContext innerContext){
                          return BlocProvider.value(
                            value: context.watch<CubitReadyDetails>(),
                            child: Material(
                              child: BlocBuilder<CubitReadyDetails, StateReadyDetails>(
                                builder: (context, state) => DialogInput(count: operation.list.length, indexOper: indexOper, status: false),
                              )
                            ),
                            );
                        });
                      }
                      
                    },
                    child: const Tooltip(message: 'Доработка', child: Icon(Icons.refresh, color: Colors.amber,))
                    ),
                ),
              ],
            );
  }
}