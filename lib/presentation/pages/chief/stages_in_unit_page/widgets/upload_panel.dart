import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/stages_in_unit_page/stages_in_unit_cubit/stages_in_unit_cubit.dart';

import '../../../dispatcher/orders_page/batches_page/batch_model.dart';

class UploadPanel extends StatefulWidget {
  const UploadPanel(
      {required this.numberController,
      required this.stageModel,
      required this.setState,
      required this.uploadStages,
      super.key});

  final TextEditingController numberController;
  final StageModel stageModel;
  final VoidCallback setState;
  final VoidCallback uploadStages;

  @override
  State<UploadPanel> createState() => _UploadPanelState();
}

class _UploadPanelState extends State<UploadPanel> {
  bool _isValidate = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => StagesInUnitCubit(),
  child: SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context, false);
        setState(() {});
        showDialog(
            context: context,
            builder: (context) => SimpleDialog(
                    title: Column(
                      children: [
                        Text('выгрузка диспетчеру'),
                        Divider(
                          height: 2,
                        ),
                        Text(
                          'этап ${widget.stageModel.stageNumber}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'деталь ${widget.stageModel.batch.number} ${widget.stageModel.batch.name}',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('готово к выгрузке: ',
                                style: TextStyle(fontSize: 16)),
                            Text(
                                '${widget.stageModel.readyToUploadQuantity} / ${widget.stageModel.availableQuantity}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    contentPadding: EdgeInsets.all(5),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('кол-во: '),
                                SizedBox(
                                    width: 100,
                                    child: TextField(
                                      decoration: InputDecoration(
                                          fillColor: _isValidate
                                              ? Colors.white54
                                              : Colors.red[100]),
                                      controller: widget.numberController,
                                      keyboardType: TextInputType.number,
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                int.parse(widget.numberController.text) <=
                                        widget.stageModel.readyToUploadQuantity
                                    ? {
                                        _isValidate = true,
                                        context
                                            .read<StagesInUnitCubit>()
                                            .uploadStages(
                                                distributionStagesIdsList: widget
                                                    .stageModel
                                                    .distributionStagesIdsList),
                                        widget.setState()
                                      }
                                    : setState(() {
                                        _isValidate = false;
                                      });
                              },
                              child: Text('выгрузить'))
                        ],
                      )
                    ]));
      },
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.file_upload_outlined),
          SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              'выгрузить детали на следующий этап',
              style: TextStyle(fontSize: 18),
              softWrap: true,
            ),
          ),
        ],
      ),
    ),
);
  }
}
