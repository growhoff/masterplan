import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chief_areas_cubit/chief_areas_cubit.dart';

class ChiefAreaInsertPage extends StatelessWidget {
  const ChiefAreaInsertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChiefAreasCubit(),
      child: const ChiefAreaInsertPageView(),
    );
  }
}

class ChiefAreaInsertPageView extends StatefulWidget {
  const ChiefAreaInsertPageView({super.key});

  @override
  State<ChiefAreaInsertPageView> createState() =>
      _ChiefAreaInsertPageViewState();
}

class _ChiefAreaInsertPageViewState extends State<ChiefAreaInsertPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: const Text('добавление участка')),
      body: BlocBuilder<ChiefAreasCubit, ChiefAreasState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Номер участка',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller:
                          context.read<ChiefAreasCubit>().numberController,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Название',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller:
                          context.read<ChiefAreasCubit>().nameController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: ElevatedButton(
                      onPressed: () {
                        context.read<ChiefAreasCubit>().insertArea();
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                                alignment: Alignment.center,
                                height: 50,
                                child: Text('оборудование добавлено')));
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
