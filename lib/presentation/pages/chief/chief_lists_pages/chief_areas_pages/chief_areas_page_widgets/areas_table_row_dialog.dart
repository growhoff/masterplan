import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/area.dart';

class AreasTableDialog extends StatefulWidget {
  const AreasTableDialog(
      {required this.area, required this.deleteRegion, super.key});

  final Area area;
  final VoidCallback deleteRegion;

  @override
  State<AreasTableDialog> createState() => _AreasTableDialogState();
}

class _AreasTableDialogState extends State<AreasTableDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(5),
      title: Text('${widget.area.name}\nномер: ${widget.area.number}'),
      children: [
        const SizedBox(
          height: 5,
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, false);
            Navigator.pushNamed(context, '/chiefAreaEditPage',
                arguments: widget.area);
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
            widget.deleteRegion();
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
