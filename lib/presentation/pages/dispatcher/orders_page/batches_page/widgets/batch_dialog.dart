import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/dispatcher/dispatcher_analytics_page/dispatcher_analytics_cubit/dispatcher_analytics_cubit.dart';

import '../batch_model.dart';
import '../batches_cubit/batches_cubit.dart';
import '../stages_in_batch_page.dart';

class BatchDialog extends StatelessWidget {
  const BatchDialog({required this.cubit, required this.batch, super.key});

  final BatchesCubit cubit;
  final BatchModel batch;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('${batch.batch.numberRS}\n${batch.batch.name}'),
      children: [
        SimpleDialogOption(
          child: Row(
            children: [
              Icon(Icons.ac_unit),
              const SizedBox(
                width: 10,
              ),
              Text(
                'этапы',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StagesInBatchPage(batch: batch.batch))),
        ),
        Divider(
          height: 1,
        ),
        SimpleDialogOption(
            child: Row(
              children: [
                Icon(Icons.delete_rounded),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'удалить',
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
            onPressed: () {
              cubit.deleteBatch(batch.batch);
              Navigator.pop(context);
            })
      ],
    );
  }
}
