// import '/backend/supabase/supabase.dart';
// import '/components/queue_component_widget.dart';
// import '/flutter_flow/flutter_flow_icon_button.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '/custom_code/actions/index.dart' as actions;
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import 'queue_operator_page_model.dart';
// export 'queue_operator_page_model.dart';

// class QueueOperatorPageWidget extends StatefulWidget {
//   const QueueOperatorPageWidget({
//     super.key,
//     required this.region,
//   });

//   final int? region;

//   @override
//   State<QueueOperatorPageWidget> createState() =>
//       _QueueOperatorPageWidgetState();
// }

// class _QueueOperatorPageWidgetState extends State<QueueOperatorPageWidget> {
//   late QueueOperatorPageModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => QueueOperatorPageModel());

//     // On page load action.
//     SchedulerBinding.instance.addPostFrameCallback((_) async {
//       await actions.fetchEquipmentLoading();
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
//           leading: FlutterFlowIconButton(
//             borderColor: Colors.transparent,
//             borderRadius: 30,
//             borderWidth: 1,
//             buttonSize: 60,
//             icon: Icon(
//               Icons.arrow_back_rounded,
//               color: Colors.white,
//               size: 30,
//             ),
//             onPressed: () async {
//               context.pop();
//             },
//           ),
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
//                   'Очередь',
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
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
//                         child: Container(
//                           decoration: BoxDecoration(),
//                           child: Padding(
//                             padding: EdgeInsets.all(10),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.max,
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 Text(
//                                   'Загрузка станка',
//                                   style: FlutterFlowTheme.of(context)
//                                       .headlineSmall,
//                                 ),
//                                 Text(
//                                   valueOrDefault<String>(
//                                     FFAppState().equipmentLoading.toString(),
//                                     '33',
//                                   ),
//                                   style: FlutterFlowTheme.of(context)
//                                       .headlineSmall,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Column(
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
//                             child: FutureBuilder<List<OperatorsOperationsRow>>(
//                               future: OperatorsOperationsTable().queryRows(
//                                 queryFn: (q) => q
//                                     .eq(
//                                       'equipment_name',
//                                       FFAppState().equipmentName,
//                                     )
//                                     .not(
//                                       'status',
//                                       'is',
//                                       null,
//                                     )
//                                     .eq(
//                                       'region',
//                                       FFAppState().userInfo.region,
//                                     )
//                                     .eq(
//                                       'company',
//                                       FFAppState().companyName,
//                                     )
//                                     .neq(
//                                       'status',
//                                       'ready',
//                                     )
//                                     .order('order', ascending: true),
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
//                                 List<OperatorsOperationsRow>
//                                     listViewOperatorsOperationsRowList =
//                                     snapshot.data!;
//                                 return ListView.builder(
//                                   padding: EdgeInsets.zero,
//                                   shrinkWrap: true,
//                                   scrollDirection: Axis.vertical,
//                                   itemCount:
//                                       listViewOperatorsOperationsRowList.length,
//                                   itemBuilder: (context, listViewIndex) {
//                                     final listViewOperatorsOperationsRow =
//                                         listViewOperatorsOperationsRowList[
//                                             listViewIndex];
//                                     return Padding(
//                                       padding: EdgeInsetsDirectional.fromSTEB(
//                                           0, 8, 0, 0),
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: Color(0xFFFFED7D),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               blurRadius: 3,
//                                               color: Color(0x33000000),
//                                               offset: Offset(0, 1),
//                                             )
//                                           ],
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           shape: BoxShape.rectangle,
//                                         ),
//                                         child: Padding(
//                                           padding:
//                                               EdgeInsetsDirectional.fromSTEB(
//                                                   5, 5, 5, 5),
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.max,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceAround,
//                                             children: [
//                                               Column(
//                                                 mainAxisSize: MainAxisSize.max,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     'Деталь',
//                                                     style: FlutterFlowTheme.of(
//                                                             context)
//                                                         .bodyMedium
//                                                         .override(
//                                                           fontFamily: 'Inter',
//                                                           color: Colors.black,
//                                                         ),
//                                                   ),
//                                                   Text(
//                                                     valueOrDefault<String>(
//                                                       listViewOperatorsOperationsRow
//                                                           .planNumber,
//                                                       '0',
//                                                     ),
//                                                     style: FlutterFlowTheme.of(
//                                                             context)
//                                                         .bodyMedium
//                                                         .override(
//                                                           fontFamily: 'Inter',
//                                                           color: Colors.black,
//                                                         ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Column(
//                                                 mainAxisSize: MainAxisSize.max,
//                                                 children: [
//                                                   Text(
//                                                     'Операция',
//                                                     style: FlutterFlowTheme.of(
//                                                             context)
//                                                         .bodyMedium
//                                                         .override(
//                                                           fontFamily: 'Inter',
//                                                           color: Colors.black,
//                                                         ),
//                                                   ),
//                                                   Text(
//                                                     valueOrDefault<String>(
//                                                       listViewOperatorsOperationsRow
//                                                           .operationNumber
//                                                           ?.toString(),
//                                                       '0',
//                                                     ),
//                                                     style: FlutterFlowTheme.of(
//                                                             context)
//                                                         .bodyMedium
//                                                         .override(
//                                                           fontFamily: 'Inter',
//                                                           color: Colors.black,
//                                                         ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Column(
//                                                 mainAxisSize: MainAxisSize.max,
//                                                 children: [
//                                                   Text(
//                                                     'Время обработки',
//                                                     style: FlutterFlowTheme.of(
//                                                             context)
//                                                         .bodyMedium
//                                                         .override(
//                                                           fontFamily: 'Inter',
//                                                           color: Colors.black,
//                                                         ),
//                                                   ),
//                                                   Text(
//                                                     valueOrDefault<String>(
//                                                       listViewOperatorsOperationsRow
//                                                           .time,
//                                                       '0',
//                                                     ),
//                                                     style: FlutterFlowTheme.of(
//                                                             context)
//                                                         .bodyMedium
//                                                         .override(
//                                                           fontFamily: 'Inter',
//                                                           color: Colors.black,
//                                                         ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 );
//                               },
//                             ),
//                           ),
//                           Align(
//                             alignment: AlignmentDirectional(-1, 0),
//                             child: Padding(
//                               padding:
//                                   EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
//                               child:
//                                   FutureBuilder<List<OperatorsOperationsRow>>(
//                                 future: OperatorsOperationsTable().queryRows(
//                                   queryFn: (q) => q
//                                       .eq(
//                                         'equipment_name',
//                                         FFAppState().equipmentName,
//                                       )
//                                       .is_(
//                                         'status',
//                                         null,
//                                       )
//                                       .eq(
//                                         'region',
//                                         widget.region,
//                                       )
//                                       .eq(
//                                         'company',
//                                         FFAppState().companyName,
//                                       )
//                                       .order('order', ascending: true),
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
//                                   List<OperatorsOperationsRow>
//                                       listViewOperatorsOperationsRowList =
//                                       snapshot.data!;
//                                   return ListView.builder(
//                                     padding: EdgeInsets.zero,
//                                     shrinkWrap: true,
//                                     scrollDirection: Axis.vertical,
//                                     itemCount:
//                                         listViewOperatorsOperationsRowList
//                                             .length,
//                                     itemBuilder: (context, listViewIndex) {
//                                       final listViewOperatorsOperationsRow =
//                                           listViewOperatorsOperationsRowList[
//                                               listViewIndex];
//                                       return QueueComponentWidget(
//                                         key: Key(
//                                             'Keyenw_${listViewIndex}_of_${listViewOperatorsOperationsRowList.length}'),
//                                         planNumber:
//                                             listViewOperatorsOperationsRow
//                                                 .planNumber!,
//                                         operationNumber:
//                                             listViewOperatorsOperationsRow
//                                                 .operationNumber!,
//                                         operationTime:
//                                             listViewOperatorsOperationsRow
//                                                 .time!,
//                                       );
//                                     },
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
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
