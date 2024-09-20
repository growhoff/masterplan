import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/chief_distirbution_cubit/chief_distribution_cubit.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/distribution_operation_model.dart';

import '../../../../../domain/model/area.dart';

class DistributionOperationsListItem extends StatefulWidget {
  DistributionOperationsListItem(
      {super.key,
      required this.cubit,
      required this.operation,
      required this.index,
      required this.availableOperationsQuantity,
      required this.areasList});

  final ChiefDistributionCubit cubit;
  final DistributionOperationModel operation;
  final int index;
  final int availableOperationsQuantity;
  final List<Area> areasList;

  @override
  State<DistributionOperationsListItem> createState() =>
      _DistributionOperationsListItemState();
}

class _DistributionOperationsListItemState
    extends State<DistributionOperationsListItem> {
  Area? _selectedArea = null;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _textEditingController.text = widget.operation.availableQuantity.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: [
            Divider(
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.operation.operationNumber} ${widget.operation.operationName}',
                          style: TextStyle(fontSize: 18),
                        ),
                        FittedBox(
                          fit: BoxFit.fill,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Тп.з.=${widget.operation.timePZ}'),
                              const SizedBox(
                                width: 5,
                              ),
                              Text('Тшт.=${widget.operation.timeSH}'),
                              const SizedBox(
                                width: 5,
                              ),
                              Text('Тшт.к.=${widget.operation.timeSHC}')
                            ],
                          ),
                        ),
                        Text(
                          'Введите количество деталей, передаваемых на участок',
                          softWrap: true,
                        ),
                      ],
                    )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton<Area>(
                            borderRadius: BorderRadius.circular(10),
                            isExpanded: true,
                            value: _selectedArea,
                            hint: Center(
                                child: Text(
                              'выберите участок',
                            )),
                            iconSize: 0,
                            items: widget.areasList
                                .map((area) => DropdownMenuItem(
                                    value: area,
                                    child: Text('${area.number} ${area.name}')))
                                .toList(),
                            onChanged: (area) => setState(() {
                                  _selectedArea = area;
                                  widget
                                      .cubit
                                      .operationsForDistributionsList[
                                          widget.index]
                                      .area = area ?? Area.empty;
                                })),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textEditingController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                                '${widget.operation.availableQuantity} / ${widget.availableOperationsQuantity}'),
                            const SizedBox(
                              width: 5,
                            ),
                            IconButton(
                              onPressed: _selectedArea == null
                                  ? null
                                  : () {
                                      widget.cubit.distributeOperation(
                                          quantity: int.parse(
                                              _textEditingController.text),
                                          area: _selectedArea ?? Area.empty,
                                          chiefDistributionOperation: widget
                                              .operation
                                              .chiefDistributionOperation);
                                    },
                              icon: Icon(Icons.check_circle),
                              iconSize: 32,
                            )
                          ],
                        )
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
