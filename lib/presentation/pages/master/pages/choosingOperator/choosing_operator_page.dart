import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: 
        BlocBuilder<CubitMain, StateMain>(builder: (context, state) => Column(children: [
            const Text('Выберите оператора'),
            Text('${state.user!.id} / ${state.user!.fio} / ${state.position!.name} / ${state.region!.name}', style: const TextStyle(fontSize: 12)),
          ])),
        ),
      body: SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:  Column(
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
              BlocBuilder<CubitMain, StateMain>(
               builder:(context, state) => ListView.builder(
                shrinkWrap: true,
                itemCount: state.listOperators!.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(state.listOperators![index].fio),
                  onTap: () {},
                ),
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
          ),
        )
      ),
    ),
    );
  }
}
