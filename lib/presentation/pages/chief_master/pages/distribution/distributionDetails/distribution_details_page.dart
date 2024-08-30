import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/widgets/content_distribution_det.dart';

class DetailDistribPageChM extends StatelessWidget {
  const DetailDistribPageChM({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider(
      create: (context) => CubitDistributionDetails(stateMain.listAreaMachineMaster!),
      child: Scaffold(
        appBar: AppBar(title: const Text('Распределение деталей'),),
        body: const DetailDistribContent()),
    );
  }
}
