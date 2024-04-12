import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_list_widgets/staff_element_icon.dart';

import '../../../../../../domain/model/staff_model.dart';

class StaffListElement extends StatefulWidget {
  const StaffListElement(
      {required this.fetchStaff,
      required this.staffModel,
      required this.deleteStaff,
      super.key});

  final StaffModel staffModel;
  final VoidCallback fetchStaff;
  final VoidCallback deleteStaff;

  @override
  State<StaffListElement> createState() => _StaffListElementState();
}

class _StaffListElementState extends State<StaffListElement> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => Card(
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: widget.staffModel.user.photo == null
                    ? Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8)),
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: Image.network(
                          Uri.parse(widget.staffModel.user.photo!)
                              .replace(queryParameters: {
                            't':
                                DateTime.now().millisecondsSinceEpoch.toString()
                          }).toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.staffModel.user.fio,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        'должность: ${widget.staffModel.user.positionId}'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('номер: ${widget.staffModel.login}'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('пароль: ${widget.staffModel.password}')
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
                          Navigator.pushNamed(context, '/chiefStaffEditPage',
                                  arguments: widget.staffModel)
                              .then((_) {
                            widget.fetchStaff();
                          });
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
                                        // Text(widget.staffModel.user.fio),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            'номер: ${widget.staffModel.login}')
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            widget.deleteStaff();
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
