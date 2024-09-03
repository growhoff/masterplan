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
            Text('${operation.batch.id}'),
            Text(
                'Этап № ${operation.batch.order?.number ?? '_'}.${operation.batch.number}.${operation.stage.number}\n${operation.stage.name}'),
            const SizedBox(height: 8),
            Text(
                'Деталь № ${operation.batch.technology}\n${operation.batch.name} ${operation.batch.numberRS}'),
            const SizedBox(height: 8),
            Text(
                'Операция: ${operation.operation.number} ${operation.operation.name}'),
            const SizedBox(height: 8),
            Text(
                'Кол-во деталей: ${operation.quantity} / ${operation.batch.count}'),
            const SizedBox(height: 8),
            Text(
                'Т п.з.: ${operation.operation.timepz} / Т шт.: ${operation.operation.timeSH} / Т шт.к.: ${(operation.operation.timepz + operation.operation.timeSH) / operation.quantity}')
          ],
        ),
      ),
    );
  }
}

class ChiefOperationDistributionBodyItem extends StatefulWidget {
  const ChiefOperationDistributionBodyItem(
      {required this.operation, required this.cubit, super.key});

  final ChiefDistributionOperation operation;
  final ChiefDistributionCubit cubit;

  @override
  State<ChiefOperationDistributionBodyItem> createState() =>
      _ChiefOperationDistributionBodyItemState();
}

class _ChiefOperationDistributionBodyItemState
    extends State<ChiefOperationDistributionBodyItem> {
  String? activeValue;
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
                              .read<ChiefDistributionCubit>()
                              .areasNamesList
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          selectedItemBuilder: (context) => context
                              .read<ChiefDistributionCubit>()
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
                        print(context.read<ChiefDistributionCubit>().areasMap);
                      }),
                      controller: _textEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          fillColor:
                              _validateTextField ? null : Colors.red[200]),
                    )),
              ],
            ),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      widget.cubit.distributeOperation(
                          quantity: int.parse(_textEditingController.text),
                          chiefDistributionOperation: widget.operation,
                          selectedAreaName: activeValue ?? '');
                    },
                    child: Text('отправить в работу')))
          ],
        ),
      ),
    );
  }
}
