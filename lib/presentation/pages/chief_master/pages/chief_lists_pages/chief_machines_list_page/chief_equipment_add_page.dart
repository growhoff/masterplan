import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chief_machine_cubit/chief_machine_cubit.dart';

class ChiefMachineInsertPage extends StatelessWidget {
  const ChiefMachineInsertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChiefMachineCubit(),
      child: ChiefMachineInsertPageView(),
    );
  }
}

class ChiefMachineInsertPageView extends StatefulWidget {
  ChiefMachineInsertPageView({super.key});

  @override
  State<ChiefMachineInsertPageView> createState() =>
      _ChiefMachineInsertPageViewState();
}

class _ChiefMachineInsertPageViewState
    extends State<ChiefMachineInsertPageView> {
  @override
  void initState() {
    context.read<ChiefMachineCubit>().fetchDropDownItems();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('добавление оборудования')),
      body: BlocBuilder<ChiefMachineCubit, ChiefMachineState>(
        builder: (context, state) {
          return SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Название',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller:
                            context.read<ChiefMachineCubit>().nameController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Инвентарный номер',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: context
                            .read<ChiefMachineCubit>()
                            .numberController,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Участок',
                        style: TextStyle(fontSize: 18),
                      ),
                      DropdownButton<String>(
                        value: context
                            .read<ChiefMachineCubit>()
                            .selectedArea,
                        onChanged: (String? value) { setState(() => context
                                .read<ChiefMachineCubit>()
                                .selectedArea =
                            value ??
                                context
                                    .read<ChiefMachineCubit>()
                                    .selectedArea);
                          },
                        items: state.areasNamesList
                            .map((String area) => DropdownMenuItem(
                                  value: area,
                                  child: Text(area),
                                ))
                            .toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                          child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<ChiefMachineCubit>()
                              .insertMachine();
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: Text('оборудование добавлено')));
                          setState(() {});
                        },
                        child: Text('добавить'),
                      ))
                    ],
                  ),
                ),
              ),
            );
        },
      ),
    );
  }
}
