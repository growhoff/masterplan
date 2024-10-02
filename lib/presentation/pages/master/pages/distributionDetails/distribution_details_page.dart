import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/widgets/dialog_filter_chois.dart';
import 'widgets/content_distribution_det.dart';

class DetailDistribPage extends StatelessWidget {
  const DetailDistribPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider(
      create: (context) => CubitDistributionDetails(stateMain.listAreaMachine!),
      child: Scaffold(
        body: const DetailDistribContent(), 
        appBar: AppBar(
          title: const Text('Распределение\nдеталей', textAlign: TextAlign.center),
          actions: [
            BlocBuilder<CubitDistributionDetails, StateDistributionDetails>(
              builder: (context, state) => IconButton(
                onPressed: state.pathListOper.isEmpty ? null : () async{
                  String? value = await showDialog(context: context, builder: (context) => const DialogFilterChois());
                  if (value != null){ if (context.mounted) context.read<CubitDistributionDetails>().getFilterList(value);}
                },
                icon: Icon(Icons.filter_alt_outlined, color: state.pathListOper.isNotEmpty ? Colors.amber : Colors.black12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
