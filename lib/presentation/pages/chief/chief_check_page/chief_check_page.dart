// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/pages/chief/chief_check_page/chief_check_cubit/chief_check_cubit.dart';

// import '../widgets/stage_check_element.dart';

// class ChiefCheckPage extends StatelessWidget {
//   const ChiefCheckPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ChiefCheckCubit(),
//       child: ChiefCheckPageView(),
//     );
//   }
// }

// class ChiefCheckPageView extends StatefulWidget {
//   const ChiefCheckPageView({
//     super.key,
//   });

//   @override
//   State<ChiefCheckPageView> createState() => _ChiefCheckPageViewState();
// }

// class _ChiefCheckPageViewState extends State<ChiefCheckPageView> {

//   @override
//   void initState() {
//     context.read<ChiefCheckCubit>().fetchStages();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ChiefCheckCubit, ChiefCheckState>(
//       builder: (context, state) {
//         if (state.stagesList.isNotEmpty){
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//               //   const SizedBox(
//               //     height: 10,
//               //   ),
//               //   ElevatedButton(
//               //     onPressed: () {},
//               //     style: ElevatedButton.styleFrom(
//               //         padding: const EdgeInsets.symmetric(
//               //             horizontal: 15, vertical: 10)),
//               //     child: const Text('Загрузить этап (excel)',
//               //         style: TextStyle(fontSize: 18)),
//               //   ),
//               //   const SizedBox(height: 10),
//               //   Expanded(
//               //     child: ListView.separated(
//               //       shrinkWrap: true,
//               //       itemBuilder: (context, index) => StageCheckElement(
//               //           stageNumber: "${state.stagesList[index].number}",
//               //           planNumber: "${state.stagesList[index].number}",
//               //           planName: "${state.stagesList[index].id}",
//               //           operationsCount: state.stagesList[index].operationList.length,
//               //           detailsCount: index),
//               //       itemCount: state.stagesList.length,
//               //       separatorBuilder: (context, index) => const SizedBox(
//               //         height: 10,
//               //       ),
//               //     ),
//               //   ),
//               //   const SizedBox(
//               //     height: 10,
//               //   ),
//               //   ElevatedButton(
//               //     onPressed: () {},
//               //     style: ElevatedButton.styleFrom(
//               //         padding: const EdgeInsets.symmetric(
//               //             horizontal: 15, vertical: 10)),
//               //     child: const Text('отправить на распределение',
//               //         style: TextStyle(fontSize: 18)),
//               //   ),
//               //   const SizedBox(height: 10)
//               ],
//             ),
//           );
//         }
//         else{return Center(child: CircularProgressIndicator(),);}
//       },
//     );
//   }
// }
