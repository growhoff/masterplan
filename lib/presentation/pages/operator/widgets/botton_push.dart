import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/bloc/state.dart';
// import 'package:master_plan/presentation/pages/operator/widgets/dialog_change.dart';

class ButtonPush extends StatelessWidget {
  const ButtonPush({super.key});
  @override
  Widget build(BuildContext context) {
    // final stateMain = context.read<CubitMain>().state;
    return BlocBuilder<CubitOperator, StateOperator>(
      builder: (context, state) => ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
          backgroundColor: WidgetStatePropertyAll(!state.isStart ? const Color.fromARGB(112, 95, 210, 255) : const Color.fromARGB(111, 255, 95, 95))
        ), 
        onPressed: (){
          context.read<CubitOperator>().toggleBtn();
          // if (stateMain.machineIdList != null){
          //   if (!state.isStart && stateMain.machineIdList!.isNotEmpty) Navigator.pushNamed(context, '/workPage');
          //   context.read<CubitOperator>().toggleBtn();
          // } else {
          //   showDialog( context: context, builder: (BuildContext context) => const DialogChange());
          // } 
        }, 
        child: Text(!state.isStart ? 'Начать смену' : 'Завершить смену', style: const TextStyle(color: Colors.black),),
      ),
    );
  }
}

// class ButtomStart extends StatelessWidget {
//   const ButtomStart({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final stateMain = context.read<CubitMain>().state;
//     return BlocBuilder<CubitOperator, StateOperator>(
//           builder: (context, state) => ElevatedButton(
//                 onPressed: () {
//                   if (stateMain.machineIdList != null){
//                     if (!state.isStart && stateMain.machineIdList!.isNotEmpty) Navigator.pushNamed(context, '/workPage');
//                     context.read<CubitOperator>().toggleBtn();
//                   } else {
//                     showDialog( context: context, builder: (BuildContext context) => const DialogChange());
//                   }                 
//                 },
//                 child: Text(!state.isStart ? 'Начать смену' : 'Закончить смену'),
//               ));
//   }
// }