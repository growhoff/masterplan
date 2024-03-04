import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/master/widgets/change_list_operator.dart';
import 'widgets/calendar.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/app/bloc/cubit.dart';
// import 'package:master_plan/presentation/app/bloc/state.dart';

class MasterPage extends StatelessWidget {
  const MasterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [  
                  
                  const Card(child: Calendar()),
                  const SizedBox(height: 8),
                  const Text('Распределение на станки'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: (){}, child: const Text('1 смена')),
                      ElevatedButton(onPressed: (){}, child: const Text('2 смена'))
                    ],
                  ),
                  const SizedBox(height: 8),
                  ChangeListOperator(['a1', 'f2', 'g4']),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/choosingOperatorPage');}, child: const Text('Назначить')),
                  )
                ],
              ),
              ),
          ),
        );
  }
}
