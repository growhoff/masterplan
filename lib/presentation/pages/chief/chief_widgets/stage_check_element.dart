import 'package:flutter/material.dart';

class StageCheckElement extends StatefulWidget {
  const StageCheckElement(
      {required this.stageNumber,
      required this.planNumber,
      required this.planName,
      required this.operationsCount,
      required this.detailsCount,
      super.key});

  final String? stageNumber;
  final String? planNumber;
  final String? planName;
  final int? operationsCount;
  final int? detailsCount;

  @override
  State<StageCheckElement> createState() => _StageCheckElementState();
}

class _StageCheckElementState extends State<StageCheckElement> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.fromLTRB(0,5,0,10),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                )
              ],
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Этап: ${widget.stageNumber}'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Чертеж номер ${widget.planNumber}'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Название: ${widget.planName}'),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text('кол-во операций: ${widget.operationsCount}'),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('кол-во деталей: ${widget.detailsCount}')
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'подробнее',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15)),
                    )
                  ],
                ),
                Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    })
              ],
            ),
          ),
        ));
  }
}
