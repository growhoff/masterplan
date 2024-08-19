import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';

import 'package:master_plan/domain/model/chief_distribution_operations_model.dart';
import 'package:master_plan/presentation/pages/chief/model/distribution_operation_model.dart';
import 'package:master_plan/presentation/pages/dispatcher/distribution_page/distribution_cubit/dispatcher_distribution_cubit.dart';

import '../../../../../domain/model/unit.dart';
import '../distribution_stage_model.dart';

class DispatcherDistributionTitleItem extends StatelessWidget {
  const DispatcherDistributionTitleItem(this.stage, {super.key});

  final DistributionStageModel stage;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Деталь № ${stage.batch.numberRS} ${stage.batch.name}'),
            const SizedBox(height: 8),
            Text(
                'Этап № ${stage.batch.order?.number}.${stage.batch.number}.${stage.stageNumber}\n${stage.stageName}'),
            const SizedBox(height: 8),
            Text('количество: ${stage.stagesList?.length} / ${stage.quantity}'),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class DispatcherDistributionBodyItem extends StatefulWidget {
  const DispatcherDistributionBodyItem({required this.stage, super.key});

  final DistributionStageModel stage;

  @override
  State<DispatcherDistributionBodyItem> createState() =>
      _DispatcherDistributionBodyItemState();
}

class _DispatcherDistributionBodyItemState
    extends State<DispatcherDistributionBodyItem> {
  Unit? activeValue;
  bool _isChecked = false;
  bool _validateTextField = true;
  bool _validateDropDown = true;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DispatcherDistributionCubit,
        DispatcherDistributionState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: Container(
                          decoration: BoxDecoration(
                            color: _validateDropDown
                                ? Colors.black12
                                : Colors.red[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<Unit>(
                              onTap: () => _validateDropDown = true,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              isExpanded: true,
                              underline: Container(),
                              borderRadius: BorderRadius.circular(12),
                              value: activeValue,
                              hint: const Text('Выберите цех'),
                              items: state.unitsList
                                  .map(
                                    (Unit unit) => DropdownMenuItem(
                                        value: unit,
                                        child: Text(
                                            '${unit.number} ${unit.name}')),
                                  )
                                  .toList(),
                              selectedItemBuilder: (context) => state.unitsList
                                  .map((unit) => Center(
                                        child:
                                            Text('${unit.number} ${unit.name}'),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  activeValue = value;
                                });
                              }),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            if (_isChecked) {
                              setState(() {
                                _validateTextField = true;
                                _isChecked = value!;
                                context
                                    .read<DispatcherDistributionCubit>()
                                    .stagesForDistributionList
                                    .removeWhere((stage) =>
                                        (stage.batch.numberRS ==
                                                widget.stage.batch.numberRS &&
                                            stage.stageNumber ==
                                                widget.stage.stageNumber));

                                print(context
                                    .read<DispatcherDistributionCubit>()
                                    .stagesForDistributionList);
                              });
                            } else {
                              if (_textEditingController.text == '' ||
                                  int.parse(_textEditingController.text) >
                                      widget.stage.quantity) {
                                _validateTextField = false;
                              }
                              activeValue == null
                                  ? _validateDropDown = false
                                  : _validateDropDown = true;
                              if (_validateDropDown == true &&
                                  _validateTextField == true) {
                                _isChecked = value!;
                                context
                                    .read<DispatcherDistributionCubit>()
                                    .stagesForDistributionList
                                    .add(DistributionStageModel(
                                        batch: widget.stage.batch,
                                        batchId: widget.stage.batchId,
                                        stageArchiveId:
                                            widget.stage.stageArchiveId,
                                        quantity: int.parse(
                                            _textEditingController.text),
                                        stageName: widget.stage.stageName,
                                        stageNumber: widget.stage.stageNumber,
                                        unitId: activeValue?.id,
                                        stagesList: widget.stage.stagesList));
                              }
                              setState(() {});
                            }
                          });
                        })
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                        child: Text(
                            'Введите кол-во деталей, передаваемое в цех:')),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        width: 100,
                        child: TextField(
                          onTap: () => setState(() {
                            _validateTextField = true;
                          }),
                          controller: _textEditingController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              fillColor:
                                  _validateTextField ? null : Colors.red[200]),
                        ))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
