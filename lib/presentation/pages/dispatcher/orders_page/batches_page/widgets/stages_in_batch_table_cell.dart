
import 'package:flutter/material.dart';

import '../batch_model.dart';

class StagesInBatchTableCell extends StatelessWidget {
  const StagesInBatchTableCell(this.cellText,
      {required this.stageModel,
      bool? isSelected,
      bool? isFirstInRow,
      bool? isLastInRow,
      super.key})
      : _isSelected = isSelected ?? false,
        _isFirstInRow = isFirstInRow ?? false,
        _isLastInRow = isLastInRow ?? false;

  final StageModel stageModel;
  final String cellText;
  final bool _isSelected;
  final bool _isFirstInRow;
  final bool _isLastInRow;

  @override
  Widget build(BuildContext context) {
    return TableCell(
        verticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(
              context, '/dispatcherOperationsInStagePage',
              arguments: stageModel),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: showBorder(_isSelected, _isFirstInRow, _isLastInRow)),
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              cellText,
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}

showBorder(bool isSelected, bool isFirstInRow, bool isLastInRow) {
  if (isSelected) {
    if (isFirstInRow) {
      return const Border(
          left: BorderSide(width: 3, color: Colors.red),
          top: BorderSide(width: 3, color: Colors.red),
          bottom: BorderSide(width: 3, color: Colors.red));
    }
    if (isLastInRow) {
      return const Border(
          right: BorderSide(width: 3, color: Colors.red),
          top: BorderSide(width: 3, color: Colors.red),
          bottom: BorderSide(width: 3, color: Colors.red));
    } else {
      return const Border.symmetric(
          horizontal: BorderSide(width: 3, color: Colors.red));
    }
  } else {
    return const Border();
  }
}
