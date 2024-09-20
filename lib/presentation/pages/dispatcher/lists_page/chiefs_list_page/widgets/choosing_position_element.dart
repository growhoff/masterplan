import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../domain/model/area.dart';
import '../../../../../../domain/model/unit.dart';
import '../chiefs_list_cubit/chiefs_list_cubit.dart';

class ChoosingPositionElement extends StatefulWidget {
  const ChoosingPositionElement(
      {required this.cubit, required this.index, super.key});

  final ChiefsListCubit cubit;
  final int index;

  @override
  State<ChoosingPositionElement> createState() =>
      _ChoosingPositionElementState();
}

class _ChoosingPositionElementState extends State<ChoosingPositionElement> {
  Unit? _selectedUnit;
  List<Area?>? _selectedAreasList;
  bool _isShowAreaPanel = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: 3,
            color: Colors.black,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Начальник цеха:',
            style: TextStyle(fontSize: 18),
          ),
          DropdownButton<Unit>(
            hint: Text('выберите цех'),
            isExpanded: true,
            value: _selectedUnit,
            onChanged: (Unit? unit) async {
              await widget.cubit.selectUnit(widget.index, unit);

              setState(() {
                _selectedAreasList = [null];
                _selectedUnit = unit;

                _isShowAreaPanel = true;
              });
              print(widget.cubit.positionsList[widget.index].availableAreasList);
            },
            items: widget.cubit.state.unitsList
                .map((Unit unit) => DropdownMenuItem(
                      value: unit,
                      child: Text('${unit.number} ${unit.name}'),
                    ))
                .toList(),
          ),
          _isShowAreaPanel
              ? SingleChildScrollView(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.cubit.positionsList[widget.index]
                              .selectedAreasList.length +
                          1,
                      itemBuilder: (context, index) => Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Мастер участка:',
                                  style: TextStyle(fontSize: 18),
                                ),
                                DropdownButton<Area>(
                                  hint: Text('выберите участок'),
                                  isExpanded: true,
                                  value: _selectedAreasList?[index],
                                  onChanged: (Area? area) => setState(() {
                                    setState(() {
                                      if (index + 1 ==
                                          _selectedAreasList!.length) {
                                        _selectedAreasList?.add(null);
                                      }
                                      _selectedAreasList?[index] = area;
                                      widget.cubit.addAreaToList(area,
                                          modelIndex: widget.index,
                                          areaIndex: index);
                                    });
                                  }),
                                  items: widget.cubit.positionsList[widget.index]
                                      .availableAreasList
                                      .map((Area area) => DropdownMenuItem(
                                            value: area,
                                            child: Text(
                                                '${area.number} ${area.name}'),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          )),
                )
              : Container(),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
