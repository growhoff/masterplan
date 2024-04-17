
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/presentation/pages/master/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/choosingOperator/choosing_operator_page.dart';

class ChangeListOperator extends StatelessWidget {
  const ChangeListOperator(this.list, {super.key});
  final List<ZShiftsDistributionDTO> list;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
                  height: 220,
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) =>  Column(
                      children: [
                        Text(list[index].machine!.name),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(list[index].user!.fio),
                                Row(
                              children: [
                                BlocBuilder<CubitMaster, StateMaster>(builder: (context, state) => IconButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => ChoosingOperatorPage(machine: list[index].machine!, time: state.days, change: state.change,))), icon: const Icon(Icons.add))),
                                Visibility(visible: !(list[index].user!.fio == 'none'), child: IconButton(onPressed: () => context.read<CubitMaster>().deleteShifts(list[index].id), icon: const Icon(Icons.delete)))
                              ],
                            ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ),
                );
  }
}