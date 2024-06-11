import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/master/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/widgets/navbar_master.dart';

class MasterPage extends StatelessWidget {
  const MasterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CubitMaster>(
      create: (context) => CubitMaster(),
      child: const NavbarMaster(),
    );
  }
}
