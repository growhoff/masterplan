import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_cubit/chief_staff_cubit.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_list_widgets/chief_staff_list_element.dart';
import 'package:master_plan/presentation/pages/dispatcher/lists_page/chiefs_list_page/chiefs_list_cubit/chiefs_list_cubit.dart';
import 'package:master_plan/presentation/pages/dispatcher/lists_page/chiefs_list_page/widgets/chief_list_element.dart';

import '../../../../../domain/model/unit.dart';

class ChiefsListPage extends StatelessWidget {
  const ChiefsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChiefsListCubit(),
      child: const ChiefsListPageView(),
    );
  }
}

class ChiefsListPageView extends StatefulWidget {
  const ChiefsListPageView({super.key});

  @override
  State<ChiefsListPageView> createState() => _ChiefsListPageViewState();
}

class _ChiefsListPageViewState extends State<ChiefsListPageView> {
  @override
  void initState() {
    context.read<ChiefsListCubit>().initChiefsListsPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список начальников'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/dispatcherAddChiefPage'),
              icon: Icon(
                Icons.add,
                size: 35,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ChiefsListCubit, ChiefsListState>(
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                      height: 60,
                      child: DropdownButton<Unit>(
                          value: context.read<ChiefsListCubit>().selectedUnit,
                          items: state.unitsList
                              .map((Unit unit) => DropdownMenuItem(
                                    child: Text('${unit.number} ${unit.name}'),
                                    value: unit,
                                  ))
                              .toList(),
                          onChanged: (Unit? value) => setState(() {
                                context.read<ChiefsListCubit>().selectedUnit =
                                    value ?? Unit.empty;

                                context
                                    .read<ChiefsListCubit>()
                                    .fetchChiefsList();
                              }))),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.separated(
                        addAutomaticKeepAlives: false,
                        itemBuilder: (context, index) => ChiefListElement(
                              fetchStaff: () {
                                setState(() {
                                  context
                                      .read<ChiefsListCubit>()
                                      .fetchChiefsList();
                                });
                              },
                              positionStaff: state.chiefsList[index],
                              deleteStaff: () => setState(() {}),
                            ),
                        separatorBuilder: (ctx, i) => SizedBox(
                              height: 10,
                            ),
                        itemCount: state.chiefsList.length),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
