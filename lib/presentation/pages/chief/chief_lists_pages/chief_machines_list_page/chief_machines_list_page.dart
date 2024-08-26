import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'chief_machine_cubit/chief_machine_cubit.dart';

import 'chief_machine_list_widgets/equipment_list_element.dart';

class ChiefMachinesListPage extends StatelessWidget {
  const ChiefMachinesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider(
      create: (context) => ChiefMachineCubit(stateMain.controlMachineList ?? [], stateMain.shiftScheduleList ?? [], stateMain.listViewMachine ?? []),
      child: const ChiefMachinesListPageView(),
    );
  }
}

class ChiefMachinesListPageView extends StatefulWidget {
  const ChiefMachinesListPageView({super.key});

  @override
  State<ChiefMachinesListPageView> createState() =>
      _ChiefMachinesListPageViewState();
}

class _ChiefMachinesListPageViewState extends State<ChiefMachinesListPageView> {
  int activeIndex = 0;

  @override
  void initState() {
    context.read<ChiefMachineCubit>().fetchAreasAndMachines();
    print(context.read<ChiefMachineCubit>().activeAreaId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('список оборудования'),
        leading: IconButton(
            onPressed: () => Navigator.pop(context, false),
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: SafeArea(
        child: Center(child: BlocBuilder<ChiefMachineCubit, ChiefMachineState>(
            builder: (context, state) {
          if (state.areasList.isNotEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                activeIndex = index;
                                context.read<ChiefMachineCubit>().activeAreaId =
                                    state.areasList[index].id;
                                context
                                    .read<ChiefMachineCubit>()
                                    .fetchMachinesList();
                                print(context
                                    .read<ChiefMachineCubit>()
                                    .activeAreaId);
                                setState(() {});
                              },
                              child: SizedBox(
                                  width: 200,
                                  child: Card(
                                      color: activeIndex == index
                                          ? Colors.blueGrey
                                          : const Color.fromARGB(0, 0, 0, 0),
                                      child: Center(
                                          child: Text(
                                              '${state.areasList[index].number} ${state.areasList[index].name}')))),
                            ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 5),
                        itemCount: state.areasList.length),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                      context, '/chiefMachineInsertPage')
                                  .then((_) {
                                context
                                    .read<ChiefMachineCubit>()
                                    .fetchAreasAndMachines();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10)),
                            child: Text(
                              'добавить',
                              style: TextStyle(fontSize: 18),
                            )),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10)),
                              onPressed: () {},
                              child: Text(
                                'загрузить(excel)',
                                style: TextStyle(fontSize: 18),
                              )))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocListener<ChiefMachineCubit, ChiefMachineState>(
                  listener: (context, state) {},
                  child: Expanded(
                    child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => MachinesListElement(
                              deleteMachine: () => context
                                  .read<ChiefMachineCubit>()
                                  .deleteMachine(
                                      machineId: state.machinesList[index].id,
                                      areaId: state.machinesList[index].areaId),
                              machineModel: state.machinesList[index],
                            ),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                        itemCount: state.machinesList.length),
                  ),
                )
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        })),
      ),
    );
  }
}
