import 'package:flutter/material.dart';

import '../../../../../../domain/model/area.dart';
import '../../../../../../domain/model/unit.dart';
import '../unit_model.dart';

class UnitTableDialog extends StatefulWidget {
  const UnitTableDialog(
      {required this.unit,
      required this.fetchUnits,
      required this.deleteUnit,
      super.key});

  final UnitModel unit;
  final VoidCallback deleteUnit;
  final VoidCallback fetchUnits;

  @override
  State<UnitTableDialog> createState() => _UnitTableDialogState();
}

class _UnitTableDialogState extends State<UnitTableDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(5),
      title: Text('${widget.unit.unitNumber} ${widget.unit.unitName}'),
      children: [
        const SizedBox(
          height: 5,
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, false);
            Navigator.pushNamed(context, '/dispatcherEditUnitPage',
                    arguments: widget.unit)
                .then((context) => widget.fetchUnits());
          },
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.edit_rounded),
              SizedBox(
                width: 5,
              ),
              Text(
                'редактировать',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
        const Divider(
          height: 1,
        ),
        SimpleDialogOption(
          onPressed: () {
            widget.deleteUnit();
            Navigator.pop(context, false);
          },
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.delete_rounded),
              SizedBox(
                width: 5,
              ),
              Text(
                'удалить',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
      ],
    );
  }
}
