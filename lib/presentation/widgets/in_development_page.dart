import 'package:flutter/cupertino.dart';

class InDevelopmentPage extends StatelessWidget {
  const InDevelopmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'В разработке',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
