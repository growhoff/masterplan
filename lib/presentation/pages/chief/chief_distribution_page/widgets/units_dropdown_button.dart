import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/chief_distirbution_cubit/chief_distribution_cubit.dart';

import '../../../../../domain/model/unit.dart';

class UnitsDropdownButton extends StatefulWidget {
  const UnitsDropdownButton(
      {required this.unitsList, required this.cubit, super.key});

  final List<Unit> unitsList;
  final ChiefDistributionCubit cubit;

  @override
  State<UnitsDropdownButton> createState() => _UnitsDropdownButtonState();
}

class _UnitsDropdownButtonState extends State<UnitsDropdownButton> {
  @override
  void initState() {
    _selectedUnit = widget.unitsList.first;
    super.initState();
  }

  Unit? _selectedUnit;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Unit>(
        value: _selectedUnit,
        items: widget.unitsList
            .map((unit) => DropdownMenuItem(
                value: unit, child: Text('${unit.number} ${unit.name}')))
            .toList(),
        onChanged: (unit) => setState(() {
              widget.cubit.selectedUnit = _selectedUnit;
            }));
  }
}
