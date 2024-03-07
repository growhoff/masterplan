import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChiefDistributionOperationsElement extends StatefulWidget {
  const ChiefDistributionOperationsElement(
      {super.key,
      required this.stageNumber,
        required this.operationsCount,
        required this.operationsNumber,
        required this.operationsName});

  final String? stageNumber;
  final int? operationsCount;
  final int? operationsNumber;
  final String? operationsName;

  @override
  State<ChiefDistributionOperationsElement> createState() =>
      _ChiefDistributionOperationsElementState();
}

class _ChiefDistributionOperationsElementState
    extends State<ChiefDistributionOperationsElement> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('этап №${widget.stageNumber}')),
                const SizedBox(
                  width: 10,
                ),
                Text('общее кол-во: ${widget.operationsCount}')
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text('операция № ${widget.operationsNumber}'),
                const SizedBox(
                  width: 10,
                ),
                Text('${widget.operationsName}')
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: (DropdownMenu(
                  enableFilter: true,
                  enableSearch: true,
                  width: 200,
                  label: Text('выберите участок'),
                  dropdownMenuEntries: <DropdownMenuEntry<int>>[
                    DropdownMenuEntry(value: 1, label: 'участок 1'),
                    DropdownMenuEntry(value: 2, label: 'участок 2'),
                    DropdownMenuEntry(value: 3, label: 'участок 3')
                  ])),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text('кол-во, передаваемое на участок'),
                SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: 100,
                  child: TextField(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
