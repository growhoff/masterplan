import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/chief_page.dart';
import 'package:master_plan/presentation/pages/login/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/login/login_page.dart';
import 'package:master_plan/presentation/pages/master/maste_page.dart';
import 'package:master_plan/presentation/pages/master/pages/choosingOperator/choosing_operator_page.dart';
import 'package:master_plan/presentation/pages/master/widgets/navbar_custom.dart';
import 'package:master_plan/presentation/pages/operator/operator_page.dart';
import '../../theme/theme.dart';
import 'bloc/cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: createTheme(),
      routes: {
        '/loginPage':(BuildContext context) => const LoginPage(),
        '/operatorPage':(BuildContext context) => const OperatorPage(),
        '/masterPage':(BuildContext context) => const MasterPage(),
        '/chiefPage':(BuildContext context) => const ChiefPage(),
        '/choosingOperatorPage':(BuildContext context) => const ChoosingOperatorPage(),
      },
      home: MultiBlocProvider(providers: [
        BlocProvider<CubitMain>(create: (context) => CubitMain()),
        BlocProvider<CubitLogin>(create: (context) => CubitLogin()),
      ], 
      // child: const LoginPage(),

      child: const NavBarCustom(),
      )
    );
  }
}
//
