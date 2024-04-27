
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/model/machine.dart';
import 'chief_machine_cubit/chief_machine_cubit.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_machines_list_page/chief_machine_list_widgets/edit_page_arguments.dart';


class ChiefMachineEditPage extends StatelessWidget {
  const ChiefMachineEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as EditPageArguments;

    return BlocProvider(
      create: (context) => ChiefMachineCubit(),
      child: ChiefMachineEditPageView(
        machine: arguments.machineModel,
        areaId: arguments.areaId,
      ),
    );
  }
}

class ChiefMachineEditPageView extends StatefulWidget {
  ChiefMachineEditPageView(
      {required this.machine, required this.areaId, super.key});

  final Machine machine;
  final int areaId;

  @override
  State<ChiefMachineEditPageView> createState() =>
      _ChiefMachineEditPageViewState();
}

class _ChiefMachineEditPageViewState extends State<ChiefMachineEditPageView> {
  @override
  void initState() {
    super.initState();
    context.read<ChiefMachineCubit>().fetchDropDownItems(selectedAreaId: widget.areaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: const Text('редактирование оборудования')),
      body: BlocBuilder<ChiefMachineCubit, ChiefMachineState>(
        builder: (context, state) {
          if (state is ChiefMachineState) {
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
                        decoration:
                            InputDecoration(hintText: widget.machine.name),
                        controller:
                            context.read<ChiefMachineCubit>().nameController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Инвентарный номер',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            hintText: '${widget.machine.inventoryNumber}'),
                        controller:
                            context.read<ChiefMachineCubit>().numberController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Участок',
                        style: TextStyle(fontSize: 18),
                      ),
                      DropdownButton<String>(
                        value: context.read<ChiefMachineCubit>().selectedArea,
                        onChanged: (String? value) => setState(() => context
                                .read<ChiefMachineCubit>()
                                .selectedArea =
                            value ??
                                context.read<ChiefMachineCubit>().selectedArea),
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
                              .updateMachine(machine: widget.machine, oldAreaId: widget.areaId);
                          Navigator.pop(context, false);
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: Text('оборудование изменено')));
                        },
                        child: Text('изменить'),
                      ))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
