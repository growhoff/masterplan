import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/app/bloc/cubit.dart';
// import 'package:master_plan/presentation/app/bloc/state.dart';


class ChiefPage extends StatelessWidget {
  const ChiefPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentChief();
  }
}

class ContentChief extends StatelessWidget {
  const ContentChief({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chief cписки'),
          actions: const [
            // BlocBuilder<CubitMain,StateMain>(builder: (context, state) => Text(state.user.fio),)
            // Text('userInfo.number / userInfo.fio / userInfo.position')
          ],
        ),
        body:  SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [   
                ElevatedButton(onPressed: (){}, 
                  //context.pushNamed('EquipmentListPage');
                child: const Text('Список оборудования')),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: (){}, 
                  // context.pushNamed('StaffListPage');
                child: const Text('Список персонала')),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: (){}, 
                  //context.pushNamed('RegionsListPage');
                child: const Text('Список участков')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}