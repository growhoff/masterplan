import 'package:flutter/material.dart';

class ChiefPage extends StatelessWidget {
  const ChiefPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChiefPageView();
  }
}

class ChiefPageView extends StatelessWidget {
  const ChiefPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SafeArea(
        child: Container(
            padding: const EdgeInsets.all(16),
            width: double.maxFinite,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      //context.pushNamed('EquipmentListPage');
                      child: const Text('Список оборудования')),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: () {},
                      // context.pushNamed('StaffListPage');
                      child: const Text('Список персонала')),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: () {},
                      //context.pushNamed('RegionsListPage');
                      child: const Text('Список участков')),
                ],
              ),
            )),
      ),
    );
  }
}
