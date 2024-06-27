import 'package:flutter/material.dart';

class DispatcherListsPage extends StatelessWidget {
  const DispatcherListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DispatcherListsPageView();
  }
}

class DispatcherListsPageView extends StatefulWidget {
  const DispatcherListsPageView({super.key});

  @override
  State<DispatcherListsPageView> createState() =>
      _DispatcherListsPageViewState();
}

class _DispatcherListsPageViewState extends State<DispatcherListsPageView> {
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
                      onPressed: () => Navigator.pushNamed(
                          context, '/chiefMachinesListPage'),
                      child: const Text('Список цехов')),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                          context, '/dispatcherChiefListPage'),
                      child: const Text('Список начальников')),
                  const SizedBox(height: 8),

                ],
              ),
            )),
      ),
    );
  }
}
