import 'package:flutter/material.dart';
import 'package:master_plan/theme/theme.dart';

class RowList extends StatelessWidget {
  const RowList({super.key, required this.text1, required this.text2, required this.text3, required this.text4, required this.text5, required this.mod, required this.color});
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final String text5;
  final bool? mod;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Spacer(),
            Expanded(flex: 4, child: Text(text1, textAlign: TextAlign.center, style: TextStyle(color: mod != null ? AppColors.amberMaket : Colors.black))),
            Expanded(flex: 4, child: Text(text2, textAlign: TextAlign.center, style: TextStyle(color: mod != null ? AppColors.amberMaket : Colors.black))),
            Expanded(flex: 2, child: Text(text3, textAlign: TextAlign.center, style: TextStyle(color: mod != null ? AppColors.amberMaket : Colors.black))),
            Expanded(flex: 2, child: Text(text4, textAlign: TextAlign.center, style: TextStyle(color: mod != null ? AppColors.amberMaket : Colors.black))),
            Expanded(flex: 2, child: Text(text5, textAlign: TextAlign.center, style: TextStyle(color: mod != null ? AppColors.amberMaket : Colors.black))),
          ],
        ),
      ),
    );
  }
}