import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';

import '../../../../../domain/model/batch.dart';
import '../../../../../domain/model/batch_archive.dart';
// import '../../../../../domain/model/order.dart';
import 'batches_cubit/batches_cubit.dart';

class EditBatchPage extends StatelessWidget {
  const EditBatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    final batch = ModalRoute.of(context)?.settings.arguments as Batch;
    return BlocProvider(
        create: (context) => BatchesCubit(stateMain.user!.positionId == 3, stateMain.user!.area!.number),
        child: EditBatchPageView(batch: batch,));
  }
}

class EditBatchPageView extends StatefulWidget {
  const EditBatchPageView({required this.batch,super.key});

  final Batch batch;

  @override
  State<EditBatchPageView> createState() =>
      _EditBatchPageViewState();
}

class _EditBatchPageViewState extends State<EditBatchPageView> {
  @override
  void initState() {
    context.read<BatchesCubit>().initEditBatchPage(widget.batch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Редактирование детали'),
        ),
        body: BlocBuilder<BatchesCubit, BatchesState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'выберите деталь',
                      style: TextStyle(fontSize: 20),
                    ),
                    DropdownButton<BatchArchive>(
                        isExpanded: true,
                        value: context.read<BatchesCubit>().selectedBatch,
                        items: state.batchesArchiveList
                            .map((BatchArchive batch) => DropdownMenuItem(
                                value: batch,
                                child: Text('${batch.number} ${batch.name}')))
                            .toList(),
                        onChanged: (value) => {
                              setState(() {
                                context.read<BatchesCubit>().selectedBatch =
                                    value ?? state.batchesArchiveList.first;
                              })
                            }),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              softWrap: true,
                              textAlign: TextAlign.center,
                              'общее кол-во',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 150,
                            child: TextField(
                              controller: context
                                  .read<BatchesCubit>()
                                  .quantityController,
                              keyboardType: TextInputType.number,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              textAlign: TextAlign.center,
                              softWrap: true,
                              'объем оптимальной партии',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 150,
                            child: TextField(
                              controller: context
                                  .read<BatchesCubit>()
                                  .optimalBatchController,
                              keyboardType: TextInputType.number,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await context.read<BatchesCubit>().editBatch(widget.batch);
                        Navigator.pop(context, true);

                      },
                      child: Text(
                        'редактировать',
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.all(10))),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
