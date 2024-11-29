import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/chief_master/pages/distribution/distributionDetails/distribution_details_page.dart';
import 'package:master_plan/presentation/pages/chief_master/pages/distribution/operations_distribution/distribution_page.dart';

class DistributionPage extends StatelessWidget {
  const DistributionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChiefDistributionPageChM(),)), child: const Text('Распределение операций')),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailDistribPageChM(),)), child: const Text('Распределение деталей')),
            ],
        ),
      ),
    ));
  }
}
