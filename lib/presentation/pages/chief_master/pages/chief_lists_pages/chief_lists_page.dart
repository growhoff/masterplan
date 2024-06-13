import 'package:flutter/material.dart';

class ChiefListsPageChM extends StatelessWidget {
  const ChiefListsPageChM({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChiefListsPageView();
  }
}

class ChiefListsPageView extends StatefulWidget {
  const ChiefListsPageView({super.key});

  @override
  State<ChiefListsPageView> createState() => _ChiefListsPageViewState();
}

class _ChiefListsPageViewState extends State<ChiefListsPageView> {
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
                      onPressed: () => Navigator.pushNamed(context, '/chiefMachinesListPage'),
                      child: const Text('Список оборудования')),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/selectionStaffPositionPage'),
                      child: const Text('Список персонала')),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/chiefAreasPage'),
                      child: const Text('Список участков')),
                ],
              ),
            )),
      ),
    );
  }
}
