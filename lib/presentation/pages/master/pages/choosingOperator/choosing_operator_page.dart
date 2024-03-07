import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/app/bloc/cubit.dart';
// import 'package:master_plan/presentation/app/bloc/state.dart';

class ChoosingOperatorPage extends StatelessWidget {
  const ChoosingOperatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentChoosingOperator();
  }
}

class ContentChoosingOperator extends StatelessWidget {
  const ContentChoosingOperator({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Выберите оператора'),
          // actions: const[ Center(child: Text('userInfo.number / userInfo.fio / userInfo.position / userInfo.regionNumber'))],
        ),
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
             const Text('equipment'),
             const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Смена № [change]'),
                Text('d/M/y')
              ],
             ),
             const SizedBox(height: 8),
             ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) => ListTile(
                title: Text('[listUsersItem $index]'),
                onTap: () {},
              ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: (){Navigator.pop(context);},
                  child: const Text('Выбрать'),
                ),
              )
            ],
          )
        ),
      ),
    ),
      ),
    );
  }
}
