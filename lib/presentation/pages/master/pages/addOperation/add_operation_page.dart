import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/app/bloc/cubit.dart';
// import 'package:master_plan/presentation/app/bloc/state.dart';

class AddOperationPage extends StatelessWidget {
  const AddOperationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentAddOperationPage();
  }
}

class ContentAddOperationPage extends StatelessWidget {
  const ContentAddOperationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(title: const Text('Добавить операцию')),
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Чертеж'),
              const SizedBox(height: 8),
              TextFormField(decoration: const InputDecoration(labelText: 'Ввод')),
              const SizedBox(height: 16),

              const Text('Название операции'),
              const SizedBox(height: 8),
              TextFormField(decoration: const InputDecoration(labelText: 'Ввод')),
              const SizedBox(height: 16),

              const Text('Номер операции'),
              const SizedBox(height: 8),
              TextFormField(decoration: const InputDecoration(labelText: 'Ввод')),
              const SizedBox(height: 16),

              const Text('Время операции'),
              const SizedBox(height: 8),
              TextFormField(decoration: const InputDecoration(labelText: 'Ввод')),
              const SizedBox(height: 16),

              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(onPressed: (){}, child: const Text('Ввод')),
              )
            ],
          )
        ),
      ),
    )
      ),
    );
  }
}