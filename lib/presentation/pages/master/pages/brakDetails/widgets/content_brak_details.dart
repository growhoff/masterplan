import 'package:flutter/material.dart';

class BrakDetailsContent extends StatelessWidget {
  const BrakDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(16),
          child: Center(child: Text('В разработке', style: TextStyle(fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }
}
