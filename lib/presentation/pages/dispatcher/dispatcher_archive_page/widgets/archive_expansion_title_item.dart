import 'package:flutter/material.dart';

import '../../../../../domain/model/batch.dart';

class ArchiveExpansionTitleItem extends StatelessWidget {
  const ArchiveExpansionTitleItem(this.batch, {super.key});

  final Batch batch;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('№ чертежа: ${batch.numberRS}'),
            const SizedBox(height: 10,),
            Text('Наименование: ${batch.name}'),
            const SizedBox(height: 10,),
            Text('Номер технологии: ${batch.technology}'),
            const SizedBox(height: 10,),
            Text('Код детали: ${batch.code}')
          ],
        ),
      ),
    );
  }
}