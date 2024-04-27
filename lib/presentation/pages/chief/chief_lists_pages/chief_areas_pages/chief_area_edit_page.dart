import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../../domain/model/area.dart';
import 'chief_areas_cubit/chief_areas_cubit.dart';

class ChiefAreaEditPage extends StatelessWidget {
  const ChiefAreaEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final area = ModalRoute.of(context)!.settings.arguments as Area;

    return BlocProvider(
      create: (context) => ChiefAreasCubit(),
      child: ChiefAreaEditPageView(area: area),
    );
  }
}

class ChiefAreaEditPageView extends StatefulWidget {
  const ChiefAreaEditPageView({required this.area, super.key});

  final Area area;

  @override
  State<ChiefAreaEditPageView> createState() =>
      _ChiefAreaEditPageViewState();
}

class _ChiefAreaEditPageViewState extends State<ChiefAreaEditPageView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: const Text('редактирование участка')),
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
                    const Text('Номер участка', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 5),
                    TextField(
                      decoration:
                          InputDecoration(hintText: widget.area.number),
                      controller:
                          context.read<ChiefAreasCubit>().numberController,
                    ),
                    const SizedBox(height: 20),
                    const Text('Название', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 5),
                    TextField(
                      decoration: InputDecoration(hintText: widget.area.name),
                      controller:
                          context.read<ChiefAreasCubit>().nameController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<ChiefAreasCubit>()
                            .updateArea(area: widget.area);
                        Navigator.pop(context, false);
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                                alignment: Alignment.center,
                                height: 50,
                                child: const Text('участок изменен')));
                      },
                      child: const Text('редактировать'),
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
