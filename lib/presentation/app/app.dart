import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_areas_pages/chief_area_edit_page.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_areas_pages/chief_area_insert_page.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_areas_pages/chief_areas_page.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_machines_list_page/chief_equipment_add_page.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_machines_list_page/chief_machine_edit_page.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_machines_list_page/chief_machines_list_page.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_add_page.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_edit_page.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_list_page.dart';
import 'package:master_plan/presentation/pages/chief/statistics_page/operations_statistics_page.dart';
import 'package:master_plan/presentation/pages/chief/statistics_page/statistics_page.dart';
import 'package:master_plan/presentation/pages/chief/widgets/custom_navbar.dart';
import 'package:master_plan/presentation/pages/dispatcher/lists_page/chiefs_list_page/add_chief_page.dart';
import 'package:master_plan/presentation/pages/dispatcher/lists_page/chiefs_list_page/edit_chief_page.dart';
import 'package:master_plan/presentation/pages/dispatcher/lists_page/units_list_page/units_list_page.dart';

import 'package:master_plan/presentation/pages/dispatcher/orders_page/create_order_page.dart';
import 'package:master_plan/presentation/pages/login/login_page.dart';
import 'package:master_plan/presentation/pages/master/pages/addOperation/add_operation_page.dart';
import 'package:master_plan/presentation/pages/operator/operator_page.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/work_page.dart';
import 'package:master_plan/presentation/pages/technologist/archive_page/archive_stages_page.dart';
import '../../theme/theme.dart';
import '../pages/chief/chief_lists_pages/chief_staff_list_page/masters_list_page.dart';
import '../pages/chief/chief_lists_pages/chief_staff_list_page/operators_list_page.dart';
import '../pages/chief/chief_lists_pages/chief_staff_list_page/selection_staff_position_page.dart';
import '../pages/chief_master/chief_maste_page.dart';

import '../pages/dispatcher/lists_page/chiefs_list_page/chiefs_list_page.dart';
import '../pages/dispatcher/lists_page/units_list_page/add_unit_page.dart';
import '../pages/dispatcher/lists_page/units_list_page/edit_unit_page.dart';
import '../pages/dispatcher/orders_page/batches_page/add_batch_page.dart';
import '../pages/dispatcher/orders_page/batches_page/batches_page.dart';
import '../pages/dispatcher/widgets/custom_navbar.dart';
import '../pages/master/maste_page.dart';
import '../pages/technologist/archive_page/archive_operations_page.dart';
import '../pages/technologist/archive_page/archive_transfers_page.dart';
import '../pages/technologist/widgets/custom_navbar.dart';
import 'bloc/cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CubitMain>(
      create: (context) => CubitMain(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: createTheme(),
        routes: {
          '/loginPage': (BuildContext context) => const LoginPage(),
          '/operatorPage': (BuildContext context) => const OperatorPage(),
          '/masterPage': (BuildContext context) => const MasterPage(),
          '/chiefPage': (BuildContext context) => const NavBarCustomChief(),
          '/workPage': (BuildContext context) => const WorkPage(),
          '/addOperationPage': (BuildContext context) =>
              const AddOperationPage(),
          '/chiefAreasPage': (BuildContext context) => const ChiefAreasPage(),
          '/chiefAreaInsertPage': (BuildContext context) =>
              const ChiefAreaInsertPage(),
          '/chiefAreaEditPage': (BuildContext context) =>
              const ChiefAreaEditPage(),
          '/chiefMachinesListPage': (BuildContext context) =>
              const ChiefMachinesListPage(),
          '/chiefMachineInsertPage': (BuildContext context) =>
              const ChiefMachineInsertPage(),
          '/chiefMachineEditPage': (BuildContext context) =>
              const ChiefMachineEditPage(),
          // '/chiefStaffListPage': (BuildContext context) => const ChiefStaffListPage(),
          '/selectionStaffPositionPage': (BuildContext context) =>
              const SelectionStaffPositionPage(),
          '/mastersListPage': (BuildContext context) => const MastersListPage(),
          '/operatorsListPage': (BuildContext context) =>
              const OperatorsListPage(),
          '/chiefStaffAddPage': (BuildContext context) =>
              const ChiefStaffAddPage(),
          '/chiefStaffEditPage': (BuildContext context) =>
              const ChiefStaffEditPage(),
          '/chiefOperationsStatisticsPage': (BuildContext context) =>
              const OperationsStatisticsPage(),
          '/chiefStageReport': (BuildContext context) =>
              const ChiefStatisticsPage(),
          '/dispatcherPage': (BuildContext context) =>
              const DispatcherCustomNavBar(),
          '/technologistPage': (BuildContext context) =>
              const TechnologistCustomNavBar(),
          '/archiveStagesPage': (BuildContext context) =>
              const ArchiveStagesPage(),
          '/archiveOperationsPage': (BuildContext context) =>
              const ArchiveOperationsPage(),
          '/archiveTransferPage': (BuildContext context) =>
              const ArchiveTransfersPage(),
          '/chiefMasterPage': (BuildContext context) => const ChiefMasterPage(),
          '/batchesPage': (BuildContext context) => const BatchesPage(),
          '/addBatchPage': (BuildContext context) => const AddBatchPage(),
          '/addOrderPage': (BuildContext context) => const AddOrderPage(),
          '/dispatcherChiefListPage': (BuildContext context) =>
              const ChiefsListPage(),
          '/dispatcherAddChiefPage': (BuildContext context) =>
              const AddChiefPage(),
          '/dispatcherEditChiefPage': (BuildContext context) =>
              const EditChiefPage(),
          '/dispatcherUnitsListPage': (BuildContext context) =>
              const UnitsListPage(),
          '/dispatcherEditUnitPage': (BuildContext context) =>
          const EditUnitPage(),
          '/dispatcherAddUnitPage': (BuildContext context) =>
          const AddUnitPage(),
        },
        home: const LoginPage(),
      ),
    );
  }
}
