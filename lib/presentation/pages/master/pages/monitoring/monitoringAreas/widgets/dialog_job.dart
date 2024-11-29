import 'package:flutter/material.dart';

class DialogJob extends StatelessWidget {
  const DialogJob({super.key});
  @override
  Widget build(BuildContext context) {   
    return const AlertDialog(
                title: Text('Информация'),
                content: Text('Данный функционал в разработке'),
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,fontSize: 20),
                actionsOverflowButtonSpacing: 20,
                actionsAlignment: MainAxisAlignment.center,
            );
}
}