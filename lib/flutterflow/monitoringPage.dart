// import '/backend/supabase/supabase.dart';
// import '/components/master_monitoring_component_widget.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '/flutter_flow/instant_timer.dart';
// import '/custom_code/actions/index.dart' as actions;
// import '/custom_code/widgets/index.dart' as custom_widgets;
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import 'monitoring_page_master_model.dart';
// export 'monitoring_page_master_model.dart';

// class MonitoringPageMasterWidget extends StatefulWidget {
//   const MonitoringPageMasterWidget({super.key});

//   @override
//   State<MonitoringPageMasterWidget> createState() =>
//       _MonitoringPageMasterWidgetState();
// }

// class _MonitoringPageMasterWidgetState
//     extends State<MonitoringPageMasterWidget> {
//   late MonitoringPageMasterModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => MonitoringPageMasterModel());

//     // On page load action.
//     SchedulerBinding.instance.addPostFrameCallback((_) async {
//       await actions.fetchRegionsList();
//       setState(() {
//         FFAppState().regionNumber = FFAppState().masterRegionNumber;
//       });
//       _model.instantTimer = InstantTimer.periodic(
//         duration: Duration(milliseconds: 1000),
//         callback: (timer) async {
//           setState(() {});
//         },
//         startImmediately: true,
//       );
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
//   }

//   @override
//   void dispose() {
//     _model.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     context.watch<FFAppState>();

//     return GestureDetector(
//       onTap: () => _model.unfocusNode.canRequestFocus
//           ? FocusScope.of(context).requestFocus(_model.unfocusNode)
//           : FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         key: scaffoldKey,
//         backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
//         appBar: AppBar(
//           backgroundColor: FlutterFlowTheme.of(context).primary,
//           automaticallyImplyLeading: false,
//           title: Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 25,
//                 decoration: BoxDecoration(),
//                 child: Align(
//                   alignment: AlignmentDirectional(-1, 0),
//                   child: AutoSizeText(
//                     '${FFAppState().userInfo.number} ${FFAppState().userInfo.fio} ${FFAppState().userInfo.position} ${FFAppState().userInfo.regionNumber}',
//                     style: FlutterFlowTheme.of(context).headlineMedium.override(
//                           fontFamily: 'Readex Pro',
//                           color: Colors.white,
//                           fontSize: 22,
//                         ),
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: AlignmentDirectional(-1, 0),
//                 child: Text(
//                   'Мониторинг участка',
//                   style: FlutterFlowTheme.of(context).headlineMedium.override(
//                         fontFamily: 'Readex Pro',
//                         color: Colors.white,
//                         fontSize: 22,
//                       ),
//                 ),
//               ),
//             ],
//           ),
//           actions: [],
//           centerTitle: false,
//           elevation: 2,
//         ),
//         body: SafeArea(
//           top: true,
//           child: Stack(
//             children: [
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       SingleChildScrollView(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.max,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             FutureBuilder<List<EquipmentRow>>(
//                               future: EquipmentTable().queryRows(
//                                 queryFn: (q) => q
//                                     .eq(
//                                       'region',
//                                       FFAppState().masterRegionNumber,
//                                     )
//                                     .eq(
//                                       'company',
//                                       FFAppState().companyName,
//                                     ),
//                               ),
//                               builder: (context, snapshot) {
//                                 // Customize what your widget looks like when it's loading.
//                                 if (!snapshot.hasData) {
//                                   return Center(
//                                     child: SizedBox(
//                                       width: 50,
//                                       height: 50,
//                                       child: CircularProgressIndicator(
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                           FlutterFlowTheme.of(context).primary,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }
//                                 List<EquipmentRow> columnEquipmentRowList =
//                                     snapshot.data!;
//                                 return SingleChildScrollView(
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.max,
//                                     children: List.generate(
//                                         columnEquipmentRowList.length,
//                                         (columnIndex) {
//                                       final columnEquipmentRow =
//                                           columnEquipmentRowList[columnIndex];
//                                       return MasterMonitoringComponentWidget(
//                                         key: Key(
//                                             'Keyq0o_${columnIndex}_of_${columnEquipmentRowList.length}'),
//                                         equipmentName:
//                                             columnEquipmentRow.equipmentName,
//                                       );
//                                     }).divide(SizedBox(height: 10)),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: AlignmentDirectional(0, 1),
//                 child: Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
//                   child: Container(
//                     width: double.infinity,
//                     height: 50,
//                     child: custom_widgets.MasterNavBar(
//                       width: double.infinity,
//                       height: 50,
//                       monitoringPageAction: () async {
//                         context.pushNamed('monitoringPageMaster');
//                       },
//                       putDetailsAction: () async {
//                         context.pushNamed('PutStageDetailsPage');
//                       },
//                       distributionDetailAction: () async {
//                         context.pushNamed('StageDistributiunDetails');
//                       },
//                       queueAction: () async {
//                         context.pushNamed('QueuePageMaster');
//                       },
//                       setState: () async {
//                         setState(() {});
//                       },
//                       readyDetailsAction: () async {
//                         context.pushNamed('readyDetailsInfoPage');
//                       },
//                       staffDistributionAction: () async {
//                         context.pushNamed('MasterListChange');
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
