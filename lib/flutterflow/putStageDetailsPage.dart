// import '/backend/supabase/supabase.dart';
// import '/components/put_stage_operations_master_component_widget.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '/custom_code/widgets/index.dart' as custom_widgets;
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import 'put_stage_details_page_model.dart';
// export 'put_stage_details_page_model.dart';

// class PutStageDetailsPageWidget extends StatefulWidget {
//   const PutStageDetailsPageWidget({super.key});

//   @override
//   State<PutStageDetailsPageWidget> createState() =>
//       _PutStageDetailsPageWidgetState();
// }

// class _PutStageDetailsPageWidgetState extends State<PutStageDetailsPageWidget> {
//   late PutStageDetailsPageModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => PutStageDetailsPageModel());

//     // On page load action.
//     SchedulerBinding.instance.addPostFrameCallback((_) async {
//       setState(() {
//         FFAppState().stageMastersOperationsIdsList = [];
//       });
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
//                   'Отправка на станок',
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
//           child: Container(
//             width: double.infinity,
//             child: Stack(
//               children: [
//                 SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SingleChildScrollView(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Padding(
//                               padding:
//                                   EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
//                               child:
//                                   FutureBuilder<List<StageMasterOperationsRow>>(
//                                 future: StageMasterOperationsTable().queryRows(
//                                   queryFn: (q) => q
//                                       .eq(
//                                         'company',
//                                         FFAppState().companyName,
//                                       )
//                                       .eq(
//                                         'region',
//                                         FFAppState().masterRegionNumber,
//                                       )
//                                       .eq(
//                                         'isDistributed',
//                                         false,
//                                       )
//                                       .order('id', ascending: true),
//                                 ),
//                                 builder: (context, snapshot) {
//                                   // Customize what your widget looks like when it's loading.
//                                   if (!snapshot.hasData) {
//                                     return Center(
//                                       child: SizedBox(
//                                         width: 50,
//                                         height: 50,
//                                         child: CircularProgressIndicator(
//                                           valueColor:
//                                               AlwaysStoppedAnimation<Color>(
//                                             FlutterFlowTheme.of(context)
//                                                 .primary,
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                   List<StageMasterOperationsRow>
//                                       columnStageMasterOperationsRowList =
//                                       snapshot.data!;
//                                   return SingleChildScrollView(
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.max,
//                                       children: List.generate(
//                                           columnStageMasterOperationsRowList
//                                               .length, (columnIndex) {
//                                         final columnStageMasterOperationsRow =
//                                             columnStageMasterOperationsRowList[
//                                                 columnIndex];
//                                         return PutStageOperationsMasterComponentWidget(
//                                           key: Key(
//                                               'Keyezm_${columnIndex}_of_${columnStageMasterOperationsRowList.length}'),
//                                           quantity: valueOrDefault<int>(
//                                             columnStageMasterOperationsRow
//                                                 .regionQuantity,
//                                             0,
//                                           ),
//                                           masterOperationId:
//                                               columnStageMasterOperationsRow.id,
//                                           operationIdListCount:
//                                               valueOrDefault<int>(
//                                             columnStageMasterOperationsRow
//                                                 .operationsIdList.length,
//                                             0,
//                                           ),
//                                           distributionOperationId:
//                                               columnStageMasterOperationsRow
//                                                   .distributionOperationId!,
//                                           operationNumber:
//                                               columnStageMasterOperationsRow
//                                                   .operationNumber!,
//                                           stageId:
//                                               columnStageMasterOperationsRow
//                                                   .stageId!,
//                                         );
//                                       }).divide(SizedBox(height: 10)),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             Align(
//                               alignment: AlignmentDirectional(0, 1),
//                               child: Padding(
//                                 padding: EdgeInsetsDirectional.fromSTEB(
//                                     0, 25, 0, 75),
//                                 child: FFButtonWidget(
//                                   onPressed: () async {
//                                     await StageMasterOperationsTable().update(
//                                       data: {
//                                         'isDistributed': true,
//                                       },
//                                       matchingRows: (rows) => rows
//                                           .in_(
//                                             'id',
//                                             FFAppState()
//                                                 .stageMastersOperationsIdsList,
//                                           )
//                                           .eq(
//                                             'company',
//                                             FFAppState().companyName,
//                                           ),
//                                     );
//                                     setState(() {
//                                       FFAppState()
//                                           .stageMastersOperationsIdsList = [];
//                                     });
//                                   },
//                                   text: 'Отправить на распределение',
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
//                 Align(
//                   alignment: AlignmentDirectional(0, 1),
//                   child: Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
//                     child: Container(
//                       width: double.infinity,
//                       height: 50,
//                       child: custom_widgets.MasterNavBar(
//                         width: double.infinity,
//                         height: 50,
//                         monitoringPageAction: () async {
//                           context.pushNamed('monitoringPageMaster');
//                         },
//                         putDetailsAction: () async {
//                           context.pushNamed('PutStageDetailsPage');
//                         },
//                         distributionDetailAction: () async {
//                           context.pushNamed('StageDistributiunDetails');
//                         },
//                         queueAction: () async {
//                           context.pushNamed('QueuePageMaster');
//                         },
//                         setState: () async {
//                           setState(() {});
//                         },
//                         readyDetailsAction: () async {
//                           context.pushNamed('readyDetailsInfoPage');
//                         },
//                         staffDistributionAction: () async {
//                           context.pushNamed('MasterListChange');
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
