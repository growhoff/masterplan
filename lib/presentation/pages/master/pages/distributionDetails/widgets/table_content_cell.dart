import 'package:flutter/material.dart';

class TableContentCells extends StatelessWidget {
  const TableContentCells(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Text(
            text,
            softWrap: true,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ));
  }
}

class TableContentCellsBorder extends StatelessWidget {
  const TableContentCellsBorder(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black))
        ),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Text(
            text,
            softWrap: true,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ));
  }
}

class TableContentCellsRotait extends StatelessWidget {
  const TableContentCellsRotait(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: FittedBox(
          fit: BoxFit.fill,
          child: RotatedBox(
             quarterTurns: 3,
            child: Text(
              text,
              softWrap: true,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}

class TableContentCellsLeft extends StatelessWidget {
  const TableContentCellsLeft(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Text(
            text,
            softWrap: true,
            maxLines: 2,
            textAlign: TextAlign.left,
          ),
        ));
  }
}

class TableContentCellsCircle extends StatelessWidget {
  const TableContentCellsCircle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.circle, color: Colors.greenAccent, semanticLabel: text,);
    // Container(
    //     decoration: BoxDecoration(
    //       color: Colors.green.withOpacity(0.25), // border color
    //       shape: BoxShape.circle,
    //     ),
    //     // alignment: Alignment.centerLeft,
        
    //     child: Container(
    //       padding: const EdgeInsets.all(2),
    //       child: Text(
    //         text,
    //         softWrap: true,
    //         maxLines: 2,
    //         textAlign: TextAlign.left,
    //       ),
    //     ));
  }
}
