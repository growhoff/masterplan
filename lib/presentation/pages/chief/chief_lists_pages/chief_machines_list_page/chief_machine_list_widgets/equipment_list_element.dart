import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_machines_list_page/chief_machine_list_widgets/edit_page_arguments.dart';

class MachinesListElement extends StatefulWidget {
  const MachinesListElement(
      {required this.machineModel,
      required this.deleteMachine,

        required this.areaId,
      super.key,
      });


  final Machine machineModel;
  final VoidCallback deleteMachine;

  final int areaId;

  @override
  State<MachinesListElement> createState() => _MachinesListElementState();
}

class _MachinesListElementState extends State<MachinesListElement> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => Card(
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.machineModel.name,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        'инвентарный номер: ${widget.machineModel.inventoryNumber}')
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    IconButton(
                        iconSize: 24,
                        onPressed: () {
                          Navigator.pushNamed(context, '/chiefMachineEditPage',
                              arguments: EditPageArguments(widget.machineModel, widget.areaId));
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        iconSize: 24,
                        onPressed: () {
                          showCupertinoDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('удалить?'),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('${widget.machineModel.name}'),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            'инвент. номер: ${widget.machineModel.inventoryNumber}')
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            widget.deleteMachine();
                                            Navigator.pop(context, true);
                                          },
                                          child: Text(
                                            'да',
                                            style: TextStyle(fontSize: 18),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: Text("нет",
                                              style: TextStyle(fontSize: 18)))
                                    ],
                                  ));
                        },
                        icon: const Icon(Icons.delete_rounded))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
