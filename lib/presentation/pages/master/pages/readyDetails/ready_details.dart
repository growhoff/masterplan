import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/element_bar.dart';

class BrakReadyDetailsPage extends StatelessWidget {
  const BrakReadyDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubitMain = context.read<CubitMain>().state;
    return BlocProvider<CubitReadyDetails>(
      create: (context) => CubitReadyDetails(cubitMain.listAreaMachine ?? []),
      child: const BrakReadyDetailsContent(),
    );
  }
}

class BrakReadyDetailsContent extends StatelessWidget {
  const BrakReadyDetailsContent({super.key});
  @override
  Widget build(BuildContext context) {
    return  const SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child:  ElementBarReady()
        ),
      ),
    );
  }
}
