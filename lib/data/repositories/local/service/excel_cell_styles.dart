import 'package:excel/excel.dart';

class ExcelCellStyles {
  static final headerCellStyle = CellStyle(
    textWrapping: TextWrapping.WrapText,
    bold: true,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Medium),
    rightBorder: Border(borderStyle: BorderStyle.Medium),
    topBorder: Border(borderStyle: BorderStyle.Medium),
    bottomBorder: Border(borderStyle: BorderStyle.Medium),
  );

  static final boldTextCellStyle = CellStyle(
    textWrapping: TextWrapping.WrapText,
    bold: true,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
    topBorder: Border(borderStyle: BorderStyle.Thin),
    bottomBorder: Border(borderStyle: BorderStyle.Thin),
  );

  static final cellStyle = CellStyle(
    textWrapping: TextWrapping.WrapText,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
    topBorder: Border(borderStyle: BorderStyle.Thin),
    bottomBorder: Border(borderStyle: BorderStyle.Thin),
  );

  static final defectCellStyle = CellStyle(
    backgroundColorHex: ExcelColor.red100,
    textWrapping: TextWrapping.WrapText,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
    topBorder: Border(borderStyle: BorderStyle.Thin),
    bottomBorder: Border(borderStyle: BorderStyle.Thin),
  );

  static final modificationCellStyle = CellStyle(
    backgroundColorHex: ExcelColor.yellow50,
    textWrapping: TextWrapping.WrapText,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
    topBorder: Border(borderStyle: BorderStyle.Thin),
    bottomBorder: Border(borderStyle: BorderStyle.Thin),
  );

  static final focusCellStyle = CellStyle(
    backgroundColorHex: ExcelColor.lightGreen100,
    textWrapping: TextWrapping.WrapText,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
    topBorder: Border(borderStyle: BorderStyle.Thin),
    bottomBorder: Border(borderStyle: BorderStyle.Thin),
  );

  static final horizontalBorderBoldCellStyle = CellStyle(
    textWrapping: TextWrapping.WrapText,
    bold: true,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Medium),
    rightBorder: Border(borderStyle: BorderStyle.Medium),
    topBorder: Border(borderStyle: BorderStyle.Thin),
    bottomBorder: Border(borderStyle: BorderStyle.Thin),
  );

  static final rightBorderBoldCellStyle = CellStyle(
    textWrapping: TextWrapping.WrapText,
    bold: true,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Medium),
    topBorder: Border(borderStyle: BorderStyle.Thin),
    bottomBorder: Border(borderStyle: BorderStyle.Thin),
  );
}
