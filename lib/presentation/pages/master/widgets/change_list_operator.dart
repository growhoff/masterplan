
import 'package:flutter/material.dart';
import 'package:master_plan/data/repositories/supabase/dto2/shifts_distribution_dto.dart';

class ChangeListOperator extends StatelessWidget {
  const ChangeListOperator(this.list, {super.key});
  final List<ZShiftsDistributionDTO2> list;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
                  height: 220,
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) =>  Column(
                      children: [
                        Text(list[index].machineId.name),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(list[index].userId.fio),
                                Row(
                              children: [
                                IconButton(onPressed: ()=> Navigator.pushNamed(context, '/choosingOperatorPage'), icon: const Icon(Icons.add)),
                                IconButton(onPressed: (){}, icon: const Icon(Icons.delete))
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