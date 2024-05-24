import 'package:flutter/material.dart';

class ChooseReportPage extends StatelessWidget {
  const ChooseReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChooseReportPageView();
  }
}

class ChooseReportPageView extends StatefulWidget {
  const ChooseReportPageView({super.key});

  @override
  State<ChooseReportPageView> createState() => _ChooseReportPageViewState();
}

class _ChooseReportPageViewState extends State<ChooseReportPageView> {
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
                      style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(20))),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/chiefStageReport'),
                      child: const Text('Поэтапный отчет начальника')),
                  const SizedBox(height: 8),
                  ElevatedButton(style: ButtonStyle(
                      padding:
                      MaterialStateProperty.all(EdgeInsets.all(20))),
                      onPressed: () {},
                      child: const Text('Ход выполнения операций')),
                  const SizedBox(height: 8),
                ],
              ),
            )),
      ),
    );
  }
}
