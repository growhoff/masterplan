import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/app/bloc/cubit.dart';
import './bloc/cubit.dart';
import './widgets/content_brak_details.dart';



class BrakDetailsPage extends StatelessWidget {
  const BrakDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitBrakDetails>(
      create: (context) => CubitBrakDetails(),
      child: const BrakDetailsContent(),
    );
  }
}
