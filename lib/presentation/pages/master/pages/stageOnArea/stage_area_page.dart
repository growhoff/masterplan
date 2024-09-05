import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import './bloc/cubit.dart';
import 'widgets/content_stage_area.dart';



class StageOnAreaPage extends StatelessWidget {
  const StageOnAreaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitStageOnArea>(
      create: (context) => CubitStageOnArea(stateMain.user!.areaId!),
      child: const StageOnAreaContent(),
    );
  }
}
