import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/batches_page/batches_cubit/batches_cubit.dart';

import '../../../../../../domain/model/batch.dart';

class BatchToFormDialogButton extends StatelessWidget {
  const BatchToFormDialogButton(this.batch, {required this.fetchBatches,super.key});

  final Batch batch;
  final VoidCallback fetchBatches;

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider(
      create: (context) => BatchesCubit(stateMain.user!.positionId == 3, stateMain.user!.area!.number),
      child: BlocBuilder<BatchesCubit, BatchesState>(builder: (context, state) {
        switch (batch.batchStatusId) {
          case 5:
            return SimpleDialogOption(
                child: Row(
                  children: [
                    Icon(Icons.format_indent_increase_rounded),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'сформировать',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                onPressed: () async{
                  await context.read<BatchesCubit>().formBatch(batch);
                  fetchBatches();
                  Navigator.pop(context);
                });
          case 6:
            return SimpleDialogOption(
                child: Row(
                  children: [
                    Icon(Icons.format_indent_decrease_rounded),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'расформировать',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                onPressed: () async{
                  await context.read<BatchesCubit>().disbandBatch(batch);
                  fetchBatches();
                  Navigator.pop(context);
                });

          default:
            return Container();
        }
      }),
    );
  }
}
