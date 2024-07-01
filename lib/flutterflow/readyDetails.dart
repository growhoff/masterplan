// import '/backend/supabase/supabase.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '/custom_code/actions/index.dart' as actions;
// import '/custom_code/widgets/index.dart' as custom_widgets;
// import '/flutter_flow/custom_functions.dart' as functions;
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import 'ready_details_info_page_model.dart';
// export 'ready_details_info_page_model.dart';

// class ReadyDetailsInfoPageWidget extends StatefulWidget {
//   const ReadyDetailsInfoPageWidget({super.key});

//   @override
//   State<ReadyDetailsInfoPageWidget> createState() =>
//       _ReadyDetailsInfoPageWidgetState();
// }

// class _ReadyDetailsInfoPageWidgetState
//     extends State<ReadyDetailsInfoPageWidget> {
//   late ReadyDetailsInfoPageModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => ReadyDetailsInfoPageModel());

//     // On page load action.
//     SchedulerBinding.instance.addPostFrameCallback((_) async {
//       await actions.fetchEquipmentList();
//       setState(() {
//         FFAppState().equipmentName = FFAppState().equipmentList.first;
//       });
//       await actions.fetchEquipmentTotalReadyTime();
//       setState(() {});
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
//                   'Готовые детали',
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
//               SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SingleChildScrollView(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             width: double.infinity,
//                             height: 50,
//                             child: custom_widgets.EquimentTapBar(
//                               width: double.infinity,
//                               height: 50,
//                               equipmentList: FFAppState().equipmentList,
//                               setStateAction: () async {
//                                 setState(() {});
//                               },
//                               pageAction: () async {
//                                 await actions.fetchEquipmentTotalReadyTime();
//                               },
//                             ),
//                           ),
//                           Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
//                             child: Container(
//                               decoration: BoxDecoration(),
//                               child: Padding(
//                                 padding: EdgeInsets.all(10),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.max,
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceAround,
//                                   children: [
//                                     Text(
//                                       'Время работы станка',
//                                       style: FlutterFlowTheme.of(context)
//                                           .headlineSmall,
//                                     ),
//                                     Text(
//                                       valueOrDefault<String>(
//                                         functions.timeConverter(
//                                             FFAppState().equipmentTotalTime),
//                                         '0',
//                                       ),
//                                       style: FlutterFlowTheme.of(context)
//                                           .headlineSmall,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Align(
//                             alignment: AlignmentDirectional(0, 0),
//                             child: Padding(
//                               padding:
//                                   EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
//                               child: FutureBuilder<List<ReadyOperationsRow>>(
//                                 future: ReadyOperationsTable().queryRows(
//                                   queryFn: (q) => q
//                                       .eq(
//                                         'equipment',
//                                         FFAppState().equipmentName,
//                                       )
//                                       .eq(
//                                         'region',
//                                         FFAppState()
//                                             .masterRegionNumber
//                                             .toString(),
//                                       )
//                                       .eq(
//                                         'company',
//                                         FFAppState().companyName,
//                                       )
//                                       .eq(
//                                         'is_uploaded',
//                                         false,
//                                       ),
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
//                                   List<ReadyOperationsRow>
//                                       columnReadyOperationsRowList =
//                                       snapshot.data!;
//                                   return Column(
//                                     mainAxisSize: MainAxisSize.max,
//                                     children: List.generate(
//                                         columnReadyOperationsRowList.length,
//                                         (columnIndex) {
//                                       final columnReadyOperationsRow =
//                                           columnReadyOperationsRowList[
//                                               columnIndex];
//                                       return Padding(
//                                         padding: EdgeInsetsDirectional.fromSTEB(
//                                             16, 8, 16, 0),
//                                         child: Container(
//                                           width: double.infinity,
//                                           decoration: BoxDecoration(
//                                             color: FlutterFlowTheme.of(context)
//                                                 .secondaryBackground,
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 blurRadius: 3,
//                                                 color: Color(0x20000000),
//                                                 offset: Offset(0, 1),
//                                               )
//                                             ],
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                           ),
//                                           child: Column(
//                                             mainAxisSize: MainAxisSize.max,
//                                             children: [
//                                               Row(
//                                                 mainAxisSize: MainAxisSize.max,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceAround,
//                                                 children: [
//                                                   Column(
//                                                     mainAxisSize:
//                                                         MainAxisSize.max,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         'Деталь',
//                                                         style:
//                                                             FlutterFlowTheme.of(
//                                                                     context)
//                                                                 .bodyMedium,
//                                                       ),
//                                                       Text(
//                                                         valueOrDefault<String>(
//                                                           columnReadyOperationsRow
//                                                               .detailNumber,
//                                                           '0',
//                                                         ),
//                                                         style:
//                                                             FlutterFlowTheme.of(
//                                                                     context)
//                                                                 .bodyMedium,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   Column(
//                                                     mainAxisSize:
//                                                         MainAxisSize.max,
//                                                     children: [
//                                                       Text(
//                                                         'Операция',
//                                                         style:
//                                                             FlutterFlowTheme.of(
//                                                                     context)
//                                                                 .bodyMedium,
//                                                       ),
//                                                       Text(
//                                                         valueOrDefault<String>(
//                                                           columnReadyOperationsRow
//                                                               .operationName,
//                                                           '0',
//                                                         ),
//                                                         style:
//                                                             FlutterFlowTheme.of(
//                                                                     context)
//                                                                 .bodyMedium,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         EdgeInsetsDirectional
//                                                             .fromSTEB(
//                                                                 10, 0, 0, 0),
//                                                     child: Column(
//                                                       mainAxisSize:
//                                                           MainAxisSize.max,
//                                                       children: [
//                                                         Text(
//                                                           'Время обработки',
//                                                           style: FlutterFlowTheme
//                                                                   .of(context)
//                                                               .bodyMedium,
//                                                         ),
//                                                         Text(
//                                                           valueOrDefault<
//                                                               String>(
//                                                             columnReadyOperationsRow
//                                                                 .timeFact,
//                                                             '0',
//                                                           ),
//                                                           style: FlutterFlowTheme
//                                                                   .of(context)
//                                                               .bodyMedium,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     }),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(16, 10, 16, 75),
//                       child: FFButtonWidget(
//                         onPressed: () async {
//                           await actions.uploadReadyOperationsAction();
//                           setState(() {});
//                         },
//                         text: 'Вызгрузить',
//                         options: FFButtonOptions(
//                           width: double.infinity,
//                           height: 40,
//                           padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                           iconPadding:
//                               EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                           color: FlutterFlowTheme.of(context).primary,
//                           textStyle:
//                               FlutterFlowTheme.of(context).titleSmall.override(
//                                     fontFamily: 'Inter',
//                                     color: Colors.white,
//                                   ),
//                           elevation: 3,
//                           borderSide: BorderSide(
//                             color: Colors.transparent,
//                             width: 1,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Align(
//                 alignment: AlignmentDirectional(0, 1),
//                 child: Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
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
