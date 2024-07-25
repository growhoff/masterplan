import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:master_plan/domain/usecase/chief_unit_service.dart';
import 'package:master_plan/presentation/pages/chief/stages_in_unit_page/stages_in_unit_cubit/stages_in_unit_cubit.dart';
import 'package:master_plan/presentation/pages/chief/stages_in_unit_page/widgets/stages_in_unit_title_item.dart';

class StagesInUnitPage extends StatelessWidget {
  const StagesInUnitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StagesInUnitCubit(),
      child: StagesInUnitPageView(),
    );
  }
}

class StagesInUnitPageView extends StatefulWidget {
  @override
  State<StagesInUnitPageView> createState() => _StagesInUnitPageViewState();
}

class _StagesInUnitPageViewState extends State<StagesInUnitPageView> {
  @override
  void initState() {
    context.read<StagesInUnitCubit>().fetchStages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: BlocBuilder<StagesInUnitCubit, StagesInUnitState>(
        builder: (context, state) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 10,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        '№ этапа',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        '№ чертежа',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        'Наименование',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        '% выполнения этапа',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        'Состояние этапа',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => StagesInUnitTitleItem(
                        state.stagesList[index],
                        setState: () => setState(() {
                          Navigator.pop(context);
                          context.read<StagesInUnitCubit>().fetchStages();
                        }),
                      ),
                  separatorBuilder: (context, i) => SizedBox(height: 10),
                  itemCount: state.stagesList.length),
            ),
          ),
        ],
      );
    }));
  }
}
