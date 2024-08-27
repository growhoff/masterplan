import 'package:flutter/material.dart';
import '../queue/queue_details/queue_details_page.dart';
import '../queue/queue_operations/queue_operations_page.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QueueOperatPageMasterChM(),)), child: const Text('Очередь операций')),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QueuePageMasterChM(),)), child: const Text('Очередь деталей')),
            ],
        ),
      ),
    ));
  }
}
