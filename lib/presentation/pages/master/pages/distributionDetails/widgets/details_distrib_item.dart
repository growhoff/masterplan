import 'package:flutter/material.dart';
import 'dropdawn_custom.dart';

class ListContetnDetails extends StatelessWidget {
  const ListContetnDetails(this.index, {super.key});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Этап № [stageNumber]'),
            const SizedBox(height: 8),
            const Text('[planNumber]'),
            const SizedBox(height: 8),
            const Text('[operationName]'),
            const SizedBox(height: 8),
            const Text('кол-во на участке: [quantity]'),
            const SizedBox(height: 8),
            const DropdownButtonCustom(["Нож", "Булавка", "Бумага", "Ручка"]),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('введите кол-во деталей, передаваемое на станок:'),
                SizedBox(width: 100, child: TextFormField())
              ],
            )
          ],
        ),
      ),
    );
  }
}