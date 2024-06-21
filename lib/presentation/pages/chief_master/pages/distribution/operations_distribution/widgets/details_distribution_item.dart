import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:master_plan/domain/model/chief_distribution_operations_model.dart';
import 'package:master_plan/presentation/pages/chief/model/distribution_operation_model.dart';

import '../chief_distribution_cubit/chief_distribution_cubit.dart';

class ChiefOperationDistributionTitleItem extends StatelessWidget {
  const ChiefOperationDistributionTitleItem(this.operation, {super.key});

  final ChiefDistributionOperation operation;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Этап № ${operation.stage.number}\n${operation.stage.name}'),
            const SizedBox(height: 8),
            Text(
                'Деталь № ${operation.batch.technology}\n${operation.batch.name} ${operation.batch.number}'),
            const SizedBox(height: 8),
            Text(
                'Операция: ${operation.operation.number} ${operation.operation.name}'),
            const SizedBox(height: 8),
            Text('Кол-во деталей: ${operation.quantity}'),
          ],
        ),
      ),
    );
  }
}

class ChiefOperationDistributionBodyItem extends StatefulWidget {
  const ChiefOperationDistributionBodyItem(
      {required this.operation, super.key});

  final ChiefDistributionOperation operation;

  @override
  State<ChiefOperationDistributionBodyItem> createState() =>
      _ChiefOperationDistributionBodyItemState();
}

class _ChiefOperationDistributionBodyItemState
    extends State<ChiefOperationDistributionBodyItem> {
  String? activeValue;
  bool _isChecked = false;
  bool _validateTextField = true;
  bool _validateDropDown = true;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                      child: DropdownButton<String>(
                          onTap: () => _validateDropDown = true,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          isExpanded: true,
                          underline: Container(),
                          borderRadius: BorderRadius.circular(12),
                          value: activeValue,
                          hint: const Text('Выберите участок'),
                          items: context
                              .read<ChiefDistributionChMCubit>()
                              .areasNamesList
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          selectedItemBuilder: (context) => context
                              .read<ChiefDistributionChMCubit>()
                              .areasNamesList
                              .map((e) => Center(
                                    child: Text(e),
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
                                .read<ChiefDistributionChMCubit>()
                                .operationsForDistributionList
                                .removeWhere((operation) =>
                                    operation.chiefOperationId ==
                                    widget.operation.id);
                          });
                        } else {
                          if (_textEditingController.text == '' ||
                              int.parse(_textEditingController.text) >
                                  widget.operation.quantity) {
                            _validateTextField = false;
                          }
                          activeValue == null
                              ? _validateDropDown = false
                              : _validateDropDown = true;
                          if (_validateDropDown == true &&
                              _validateTextField == true) {
                            _isChecked = value!;
                            context
                                .read<ChiefDistributionChMCubit>()
                                .operationsForDistributionList
                                .add(DistributionOperationModel(
                                    oldQuantity: widget.operation.quantity,
                                    chiefOperationId: widget.operation.id,
                                    batchId: widget.operation.batchId,
                                    operationId: widget.operation.operationId,
                                    quantity:
                                        int.parse(_textEditingController.text),
                                    stageId: widget.operation.stageId,
                                    areaId: context
                                        .read<ChiefDistributionChMCubit>()
                                        .areasMap[activeValue],
                                    timePlan:
                                        widget.operation.operation.timeSH ??
                                            0));

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
                        'Введите кол-во деталей, передаваемое на участок:')),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: 100,
                    child: TextField(
                      onTap: () => setState(() {
                        _validateTextField = true;
                        print(context.read<ChiefDistributionChMCubit>().areasMap);
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
  }
}
