import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/dispatcher/lists_page/units_list_page/widgets/unit_table_dialog.dart';

import '../../../../../../domain/model/unit.dart';
import '../../../../chief/chief_lists_pages/chief_areas_pages/chief_areas_page_widgets/areas_table_row_dialog.dart';
import '../unit_model.dart';

class UnitsTableRowElement extends StatelessWidget {
  const UnitsTableRowElement(this.elementText,
      {super.key, required this.fetchUnits, required this.unit, required this.deleteUnit});

  final String elementText;
  final UnitModel unit;
  final VoidCallback fetchUnits;
  final VoidCallback deleteUnit;

  @override
  Widget build(BuildContext context) {
    return TableRowInkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) =>
              UnitTableDialog(
                  unit: unit,
                  fetchUnits: () => fetchUnits(), deleteUnit: () => deleteUnit(),

              ),
        );
      },
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8),
          child: Text(
            elementText,
            textAlign: TextAlign.center,
          )),
    );
  }
}
