import 'package:flutter/material.dart';
import './widgets/element_bar.dart';


class ReadyDetailsContent extends StatelessWidget {
  const ReadyDetailsContent({super.key});
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child:  ElementBarReady()
          ),
        ),
      );
  }
}
