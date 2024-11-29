import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/widgets/custom_navbar.dart';
import './bloc/cubit.dart';

class ChiefPage extends StatelessWidget {
  const ChiefPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CubitChief>(
      create: (context) => CubitChief(),
      child: const NavBarCustomChief(),
    );
  }
}
