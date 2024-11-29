import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/chief_master/pages/ready/readyDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/chief_master/pages/ready/readyDetails/ready_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';


class ReadyPage extends StatelessWidget {
  const ReadyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubitMain = context.read<CubitMain>().state;
    return BlocProvider<CubitReadyDetailsChM>(
      create: (context) => CubitReadyDetailsChM(cubitMain.listAreaMachineMaster!),
      child: const ReadyDetailsContent(),
    );
  }
}
