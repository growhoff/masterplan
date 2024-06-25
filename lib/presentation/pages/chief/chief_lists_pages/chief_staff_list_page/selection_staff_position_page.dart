import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectionStaffPositionPage extends StatelessWidget {
  const SelectionStaffPositionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Выбор роли')),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/mastersListPage'),
                  child: Text('Список мастеров')),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/operatorsListPage'),
                  child: Text('Список операторов')),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                  ),
                  onPressed: () {},
                  child: Text('Список кладовщиков')),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/chiefStaffAddPage'),
                  child: Text('Добавить сотрудника'))
            ],
          ),
        ),
      ),
    );
  }
}
