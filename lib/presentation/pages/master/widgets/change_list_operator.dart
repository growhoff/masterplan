
import 'package:flutter/material.dart';

class ChangeListOperator extends StatelessWidget {
  const ChangeListOperator(this.list, {super.key});
  final List<String> list;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
                  height: 220,
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) =>  Column(
                      children: [
                        const Text('Станок'),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(list[index]),
                                Row(
                              children: [
                                IconButton(onPressed: (){}, icon: const Icon(Icons.add)),
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