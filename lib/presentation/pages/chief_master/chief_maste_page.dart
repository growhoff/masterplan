import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/cubit.dart';
import 'widgets/navbar_master.dart';

class ChiefMasterPage extends StatelessWidget {
  const ChiefMasterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CubitChiefMaster>(
      create: (context) => CubitChiefMaster(),
      child: const NavbarChiefMaster(),
    );
  }
}
