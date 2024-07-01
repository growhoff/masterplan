import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/dispatcher/lists_page/units_list_page/units_cubit/units_cubit.dart';

import '../../../../../domain/model/staff.dart';
import '../../../../../domain/model/unit.dart';

class AddUnitPage extends StatelessWidget {
  const AddUnitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UnitsCubit(),
      child: AddUnitPageView(),
    );
  }
}

class AddUnitPageView extends StatefulWidget {
  const AddUnitPageView({ super.key});


  @override
  State<AddUnitPageView> createState() => _AddUnitPageViewState();
}

class _AddUnitPageViewState extends State<AddUnitPageView> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    context
        .read<UnitsCubit>()
        .fetchChiefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: const Text('добавление цеха')),
      body: BlocBuilder<UnitsCubit, UnitsState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Номер цеха', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 5),
                    TextField(

                      controller:
                      context.read<UnitsCubit>().unitNumberController,
                    ),
                    const SizedBox(height: 20),
                    const Text('Название', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 5),
                    TextField(

                      controller: context.read<UnitsCubit>().unitNameController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('кол-во участков в цеху',
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(

                        controller:
                        context.read<UnitsCubit>().areasQuantityController,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('кол-во рабочих в цеху',
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(

                        controller: context
                            .read<UnitsCubit>()
                            .operatorsQuantityController,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('начальник цеха',
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(
                      height: 5,
                    ),
                    DropdownButton<Staff>(
                        value: context.read<UnitsCubit>().selectedStaff,
                        items: state.chiefsList
                            .map((Staff staff) => DropdownMenuItem(
                            value: staff, child: Text(staff.user.fio)))
                            .toList(),
                        onChanged: (value) => {
                          setState(() {
                            context.read<UnitsCubit>().selectedStaff =
                                value ?? Staff.empty;
                          }),
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<UnitsCubit>().addUnit();
                            Navigator.pop(context, false);
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    child: const Text('цех изменен')));
                          },
                          child: const Text('добавить'),
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

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }
}
