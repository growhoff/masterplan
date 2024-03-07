// import '/backend/schema/structs/index.dart';
// import '/backend/supabase/supabase.dart';
// import '/components/stage_distribution_operation_master_component_widget.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '/custom_code/actions/index.dart' as actions;
// import '/custom_code/widgets/index.dart' as custom_widgets;
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import 'stage_distributiun_details_model.dart';
// export 'stage_distributiun_details_model.dart';

// class StageDistributiunDetailsWidget extends StatefulWidget {
//   const StageDistributiunDetailsWidget({super.key});

//   @override
//   State<StageDistributiunDetailsWidget> createState() =>
//       _StageDistributiunDetailsWidgetState();
// }

// class _StageDistributiunDetailsWidgetState
//     extends State<StageDistributiunDetailsWidget> {
//   late StageDistributiunDetailsModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => StageDistributiunDetailsModel());

//     // On page load action.
//     SchedulerBinding.instance.addPostFrameCallback((_) async {
//       await actions.fetchEquipmentList();
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
//                   'Распределение деталей',
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
//                 padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SingleChildScrollView(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.max,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             FutureBuilder<List<StageMasterOperationsRow>>(
//                               future: StageMasterOperationsTable().queryRows(
//                                 queryFn: (q) => q
//                                     .eq(
//                                       'company',
//                                       FFAppState().companyName,
//                                     )
//                                     .eq(
//                                       'isDistributed',
//                                       true,
//                                     )
//                                     .eq(
//                                       'region',
//                                       FFAppState().masterRegionNumber,
//                                     )
//                                     .neq(
//                                       'region_quantity',
//                                       0,
//                                     )
//                                     .order('id', ascending: true),
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
//                                 List<StageMasterOperationsRow>
//                                     listViewStageMasterOperationsRowList =
//                                     snapshot.data!;
//                                 return ListView.builder(
//                                   padding: EdgeInsets.zero,
//                                   shrinkWrap: true,
//                                   scrollDirection: Axis.vertical,
//                                   itemCount:
//                                       listViewStageMasterOperationsRowList
//                                           .length,
//                                   itemBuilder: (context, listViewIndex) {
//                                     final listViewStageMasterOperationsRow =
//                                         listViewStageMasterOperationsRowList[
//                                             listViewIndex];
//                                     return StageDistributionOperationMasterComponentWidget(
//                                       key: Key(
//                                           'Keyhni_${listViewIndex}_of_${listViewStageMasterOperationsRowList.length}'),
//                                       quantity: valueOrDefault<int>(
//                                         listViewStageMasterOperationsRow
//                                             .operationsIdList.length,
//                                         0,
//                                       ),
//                                       distributionOperationId:
//                                           listViewStageMasterOperationsRow
//                                               .distributionOperationId!,
//                                       masterOperationId:
//                                           listViewStageMasterOperationsRow.id,
//                                       operationsIdList:
//                                           listViewStageMasterOperationsRow
//                                               .operationsIdList,
//                                       stageId: listViewStageMasterOperationsRow
//                                           .stageId!,
//                                       operationNumber:
//                                           listViewStageMasterOperationsRow
//                                               .operationNumber!,
//                                       totalQuantity:
//                                           listViewStageMasterOperationsRow
//                                               .regionQuantity!,
//                                     );
//                                   },
//                                 );
//                               },
//                             ),
//                             Align(
//                               alignment: AlignmentDirectional(0, 1),
//                               child: Padding(
//                                 padding: EdgeInsetsDirectional.fromSTEB(
//                                     0, 25, 0, 75),
//                                 child: FFButtonWidget(
//                                   onPressed: () async {
//                                     await actions
//                                         .insertStageOperatorsOperations(
//                                       FFAppState()
//                                           .operatorsOperationsList
//                                           .toList(),
//                                     );
//                                     setState(() {
//                                       FFAppState().operatorsOperationsList = [];
//                                     });
//                                   },
//                                   text: 'Отправить в работу',
//                                   options: FFButtonOptions(
//                                     height: 40,
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         24, 0, 24, 0),
//                                     iconPadding: EdgeInsetsDirectional.fromSTEB(
//                                         0, 0, 0, 0),
//                                     color: FlutterFlowTheme.of(context).primary,
//                                     textStyle: FlutterFlowTheme.of(context)
//                                         .titleSmall
//                                         .override(
//                                           fontFamily: 'Inter',
//                                           color: Colors.white,
//                                         ),
//                                     elevation: 3,
//                                     borderSide: BorderSide(
//                                       color: Colors.transparent,
//                                       width: 1,
//                                     ),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                               ),
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
//                 child: Container(
//                   width: double.infinity,
//                   height: 50,
//                   child: custom_widgets.MasterNavBar(
//                     width: double.infinity,
//                     height: 50,
//                     monitoringPageAction: () async {
//                       context.pushNamed('monitoringPageMaster');
//                     },
//                     putDetailsAction: () async {
//                       context.pushNamed('PutStageDetailsPage');
//                     },
//                     distributionDetailAction: () async {
//                       context.pushNamed('StageDistributiunDetails');
//                     },
//                     queueAction: () async {
//                       context.pushNamed('QueuePageMaster');
//                     },
//                     setState: () async {
//                       setState(() {});
//                     },
//                     readyDetailsAction: () async {
//                       context.pushNamed('readyDetailsInfoPage');
//                     },
//                     staffDistributionAction: () async {
//                       context.pushNamed('MasterListChange');
//                     },
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
