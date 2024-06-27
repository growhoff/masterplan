import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/chief_master/pages/ready/readyDetails/ready_details.dart';

class ReadyPage extends StatelessWidget {
  const ReadyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Готовые этапы')),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReadyDetailsPageChM(),)), child: const Text('Готовые детали')),
            ],
        ),
      ),
    ));
  }
}
