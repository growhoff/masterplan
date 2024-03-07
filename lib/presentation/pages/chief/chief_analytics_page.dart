import 'package:flutter/material.dart';


class ChiefAnalyticsPage extends StatelessWidget {
  const ChiefAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChiefAnalyticsPageView();
  }
}

class ChiefAnalyticsPageView extends StatefulWidget {
  const ChiefAnalyticsPageView({
    super.key,
  });

  @override
  State<ChiefAnalyticsPageView> createState() => _ChiefMonitoringPageViewState();
}

class _ChiefMonitoringPageViewState extends State<ChiefAnalyticsPageView> {
  // final int _pageIndex = 4;

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Center(child: Text('аналитика'),));
  }
}
