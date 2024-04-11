import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_list_page.dart';
import 'package:master_plan/presentation/pages/chief/chief_widgets/custom_navbar.dart';
import 'package:master_plan/presentation/pages/login/login_page.dart';
import 'package:master_plan/presentation/pages/master/pages/addOperation/add_operation_page.dart';
import 'package:master_plan/presentation/pages/master/pages/choosingOperator/choosing_operator_page.dart';
import 'package:master_plan/presentation/pages/master/widgets/navbar_custom.dart';
import 'package:master_plan/presentation/pages/operator/operator_page.dart';
import 'package:master_plan/presentation/pages/operator/pages/queue/queue_page.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/work_page.dart';
import '../../theme/theme.dart';
import '../pages/chief/chief_lists_pages/chief_areas_pages/chief_area_edit_page.dart';
import '../pages/chief/chief_lists_pages/chief_areas_pages/chief_area_insert_page.dart';
import '../pages/chief/chief_lists_pages/chief_areas_pages/chief_areas_cubit/chief_areas_cubit.dart';
import '../pages/chief/chief_lists_pages/chief_areas_pages/chief_areas_page.dart';
import '../pages/chief/chief_lists_pages/chief_machines_list_page/chief_equipment_add_page.dart';
import '../pages/chief/chief_lists_pages/chief_machines_list_page/chief_machine_cubit/chief_machine_cubit.dart';
import '../pages/chief/chief_lists_pages/chief_machines_list_page/chief_machine_edit_page.dart';
import '../pages/chief/chief_lists_pages/chief_machines_list_page/chief_machines_list_page.dart';
import '../pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_add_page.dart';
import 'bloc/cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CubitMain(),
        ),
        BlocProvider(create: (context) => ChiefAreasCubit()),
        BlocProvider(create: (context) => ChiefMachineCubit())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: createTheme(),
        routes: {
          '/loginPage': (BuildContext context) => const LoginPage(),
          '/operatorPage': (BuildContext context) => const OperatorPage(),
          '/masterPage': (BuildContext context) => const NavBarCustomMaster(),
          '/chiefPage': (BuildContext context) => const NavBarCustomChief(),
          '/choosingOperatorPage': (BuildContext context) =>
              const ChoosingOperatorPage(),
          '/workPage': (BuildContext context) => const WorkPage(),
          '/queuePage': (BuildContext context) => const QueuePage(),
          '/addOperationPage': (BuildContext context) =>
              const AddOperationPage(),
          '/chiefAreasPage': (BuildContext context) => const ChiefAreasPage(),
          '/chiefAreaInsertPage': (BuildContext context) => const ChiefAreaInsertPage(),
          '/chiefAreaEditPage': (BuildContext context) => const ChiefAreaEditPage(),
          '/chiefMachinesListPage': (BuildContext context) => const ChiefMachinesListPage(),
          '/chiefMachineInsertPage': (BuildContext context) => const ChiefMachineInsertPage(),
          '/chiefMachineEditPage': (BuildContext context) => const ChiefMachineEditPage(),
          '/chiefStaffListPage': (BuildContext context) => const ChiefStaffListPage(),
          '/chiefStaffAddPage': (BuildContext context) => const ChiefStaffAddPage(),







        },
        home: const LoginPage(),
      ),
    );
  }
}
