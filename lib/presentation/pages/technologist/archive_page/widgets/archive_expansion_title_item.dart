import 'package:flutter/material.dart';

import '../../../../../domain/model/batch.dart';
import '../../../../../domain/model/batch_archive.dart';

class DispatcherArchiveExpansionTitleItem extends StatelessWidget {
  const DispatcherArchiveExpansionTitleItem(this.batch, {super.key});

  final BatchArchive batch;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('id: ${batch.id}'),
            const SizedBox(height: 10,),
            Text('№ чертежа: ${batch.number}'),
            const SizedBox(height: 10,),
            Text('Наименование: ${batch.name}'),
            const SizedBox(height: 10,),
            Text('Номер технологии: ${batch.technologyNumber}'),
            const SizedBox(height: 10,),
            Text('Код детали: ${batch.code}')
          ],
        ),
      ),
    );
  }
}