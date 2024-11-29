// import '/backend/schema/structs/index.dart';
// import '/backend/supabase/supabase.dart';
// import '/flutter_flow/flutter_flow_icon_button.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_timer.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '/flutter_flow/instant_timer.dart';
// import '/custom_code/actions/index.dart' as actions;
// import '/custom_code/widgets/index.dart' as custom_widgets;
// import '/flutter_flow/custom_functions.dart' as functions;
// import 'package:stop_watch_timer/stop_watch_timer.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import 'operator_page_model.dart';
// export 'operator_page_model.dart';

// class OperatorPageWidget extends StatefulWidget {
//   const OperatorPageWidget({
//     super.key,
//     required this.equipmentList,
//   });

//   final List<String>? equipmentList;

//   @override
//   State<OperatorPageWidget> createState() => _OperatorPageWidgetState();
// }

// class _OperatorPageWidgetState extends State<OperatorPageWidget> {
//   late OperatorPageModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => OperatorPageModel());

//     // On page load action.
//     SchedulerBinding.instance.addPostFrameCallback((_) async {
//       setState(() {
//         FFAppState().equipmentName = widget.equipmentList!.first;
//       });
//       await actions.fetchOperatorsOperationsList();
//       _model.timerController.timer.setPresetTime(
//         mSec: FFAppState().timerTime,
//         add: false,
//       );
//       _model.timerController.onResetTimer();

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
//           automaticallyImplyLeading: true,
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
//                   'Оператор',
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
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Container(
//                 decoration: BoxDecoration(),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       height: 50,
//                       child: custom_widgets.EquimentTapBar(
//                         width: double.infinity,
//                         height: 50,
//                         equipmentList: widget.equipmentList!,
//                         setStateAction: () async {
//                           setState(() {});
//                         },
//                         pageAction: () async {
//                           await actions.fetchOperatorsOperationsList();
//                         },
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
//                       child: RichText(
//                         textScaleFactor: MediaQuery.of(context).textScaleFactor,
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Деталь ',
//                               style: FlutterFlowTheme.of(context)
//                                   .headlineSmall
//                                   .override(
//                                     fontFamily: 'Readex Pro',
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                             ),
//                             TextSpan(
//                               text: FFAppState()
//                                   .operatorsWorkingOperations[FFAppState()
//                                       .operatorsOperationsActiveIndex]
//                                   .planNumber,
//                               style: FlutterFlowTheme.of(context)
//                                   .headlineSmall
//                                   .override(
//                                     fontFamily: 'Readex Pro',
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                             )
//                           ],
//                           style: FlutterFlowTheme.of(context).bodyMedium,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
//                       child: RichText(
//                         textScaleFactor: MediaQuery.of(context).textScaleFactor,
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Операция ',
//                               style: FlutterFlowTheme.of(context).headlineSmall,
//                             ),
//                             TextSpan(
//                               text: FFAppState()
//                                   .operatorsWorkingOperations[FFAppState()
//                                       .operatorsOperationsActiveIndex]
//                                   .operationName,
//                               style: FlutterFlowTheme.of(context).headlineSmall,
//                             )
//                           ],
//                           style: FlutterFlowTheme.of(context).bodyMedium,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
//                       child: FlutterFlowTimer(
//                         initialTime: _model.timerMilliseconds,
//                         getDisplayTime: (value) =>
//                             StopWatchTimer.getDisplayTime(
//                           value,
//                           hours: false,
//                           milliSecond: false,
//                         ),
//                         controller: _model.timerController,
//                         updateStateInterval: Duration(milliseconds: 1000),
//                         onChanged: (value, displayTime, shouldUpdate) {
//                           _model.timerMilliseconds = value;
//                           _model.timerValue = displayTime;
//                           if (shouldUpdate) setState(() {});
//                         },
//                         textAlign: TextAlign.start,
//                         style:
//                             FlutterFlowTheme.of(context).displaySmall.override(
//                                   fontFamily: 'Readex Pro',
//                                   fontSize: 40,
//                                 ),
//                       ),
//                     ),
//                     Stack(
//                       alignment: AlignmentDirectional(0, 0),
//                       children: [
//                         Align(
//                           alignment: AlignmentDirectional(0, 0),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.max,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               if (_model.isTimerPause == true)
//                                 Padding(
//                                   padding: EdgeInsetsDirectional.fromSTEB(
//                                       0, 0, 20, 0),
//                                   child: FlutterFlowIconButton(
//                                     borderColor:
//                                         FlutterFlowTheme.of(context).primary,
//                                     borderRadius: 20,
//                                     borderWidth: 1,
//                                     buttonSize: 53,
//                                     fillColor:
//                                         FlutterFlowTheme.of(context).accent1,
//                                     icon: Icon(
//                                       Icons.play_arrow,
//                                       color: FlutterFlowTheme.of(context)
//                                           .primaryText,
//                                       size: 24,
//                                     ),
//                                     onPressed: () async {
//                                       _model.timerController.onStartTimer();
//                                       _model.isTimerPause = false;
//                                     },
//                                   ),
//                                 ),
//                               FlutterFlowIconButton(
//                                 borderColor:
//                                     FlutterFlowTheme.of(context).primary,
//                                 borderRadius: 20,
//                                 borderWidth: 1,
//                                 buttonSize: 53,
//                                 fillColor: FlutterFlowTheme.of(context).accent1,
//                                 icon: Icon(
//                                   Icons.pause,
//                                   color:
//                                       FlutterFlowTheme.of(context).primaryText,
//                                   size: 24,
//                                 ),
//                                 onPressed: () async {
//                                   _model.timerController.onStopTimer();
//                                   setState(() {
//                                     _model.isTimerPause = true;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                         Align(
//                           alignment: AlignmentDirectional(1, 0),
//                           child: Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
//                             child: FlutterFlowIconButton(
//                               borderColor: FlutterFlowTheme.of(context).primary,
//                               borderRadius: 20,
//                               borderWidth: 1,
//                               buttonSize: 40,
//                               fillColor: FlutterFlowTheme.of(context).accent1,
//                               icon: Icon(
//                                 Icons.list,
//                                 color: FlutterFlowTheme.of(context).primaryText,
//                                 size: 24,
//                               ),
//                               onPressed: () async {
//                                 context.pushNamed(
//                                   'QueueOperatorPage',
//                                   queryParameters: {
//                                     'region': serializeParam(
//                                       FFAppState().userInfo.region,
//                                       ParamType.int,
//                                     ),
//                                   }.withoutNulls,
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: AlignmentDirectional(-1, 0),
//                           child: Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
//                             child: FlutterFlowIconButton(
//                               borderColor: FlutterFlowTheme.of(context).primary,
//                               borderRadius: 20,
//                               borderWidth: 1,
//                               buttonSize: 40,
//                               fillColor: FlutterFlowTheme.of(context).accent1,
//                               icon: Icon(
//                                 Icons.replay,
//                                 color: FlutterFlowTheme.of(context).primaryText,
//                                 size: 24,
//                               ),
//                               onPressed: () async {
//                                 await actions.fetchOperatorsOperationsList();
//                                 setState(() {});
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
//                       child: Stack(
//                         children: [
//                           Align(
//                             alignment: AlignmentDirectional(0, 0),
//                             child: FFButtonWidget(
//                               onPressed: () async {
//                                 _model.timerController.onResetTimer();

//                                 _model.timerController.onStartTimer();
//                                 setState(() {
//                                   _model.isTimerPause = false;
//                                 });
//                                 if (FFAppState().timerTime == 0) {
//                                   await OperatorsOperationsTable().update(
//                                     data: {
//                                       'status': 'at_work',
//                                       'time_start': dateTimeFormat(
//                                           'H:mm d.M.y', getCurrentTimestamp),
//                                     },
//                                     matchingRows: (rows) => rows
//                                         .eq(
//                                           'id',
//                                           FFAppState()
//                                               .operatorsWorkingOperations[
//                                                   FFAppState()
//                                                       .operatorsOperationsActiveIndex]
//                                               .mastersOperationId,
//                                         )
//                                         .eq(
//                                           'company',
//                                           FFAppState().companyName,
//                                         ),
//                                   );
//                                 } else {
//                                   await OperatorsOperationsTable().update(
//                                     data: {
//                                       'status': 'at_work',
//                                     },
//                                     matchingRows: (rows) => rows
//                                         .eq(
//                                           'id',
//                                           FFAppState()
//                                               .operatorsWorkingOperations[
//                                                   FFAppState()
//                                                       .operatorsOperationsActiveIndex]
//                                               .mastersOperationId,
//                                         )
//                                         .eq(
//                                           'company',
//                                           FFAppState().companyName,
//                                         ),
//                                   );
//                                 }

//                                 _model.updateTimeReadjustment?.cancel();
//                                 _model.updateTimeCleaning?.cancel();
//                                 _model.updateTimeBreakdown?.cancel();
//                                 _model.updateTime = InstantTimer.periodic(
//                                   duration: Duration(milliseconds: 1000),
//                                   callback: (timer) async {
//                                     if (_model.timerMilliseconds > 1) {
//                                       await OperatorsOperationsTable().update(
//                                         data: {
//                                           'working_time':
//                                               _model.timerMilliseconds,
//                                         },
//                                         matchingRows: (rows) => rows
//                                             .eq(
//                                               'id',
//                                               FFAppState()
//                                                   .operatorsWorkingOperations[
//                                                       FFAppState()
//                                                           .operatorsOperationsActiveIndex]
//                                                   .mastersOperationId,
//                                             )
//                                             .eq(
//                                               'company',
//                                               FFAppState().companyName,
//                                             ),
//                                       );
//                                     }
//                                   },
//                                   startImmediately: false,
//                                 );
//                               },
//                               text: 'начать работу',
//                               options: FFButtonOptions(
//                                 height: 40,
//                                 padding: EdgeInsetsDirectional.fromSTEB(
//                                     24, 0, 24, 0),
//                                 iconPadding:
//                                     EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                                 color: FlutterFlowTheme.of(context).primary,
//                                 textStyle: FlutterFlowTheme.of(context)
//                                     .titleSmall
//                                     .override(
//                                       fontFamily: 'Inter',
//                                       color: Colors.white,
//                                     ),
//                                 elevation: 3,
//                                 borderSide: BorderSide(
//                                   color: Colors.transparent,
//                                   width: 1,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(10, 25, 10, 0),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           FFButtonWidget(
//                             onPressed: () async {
//                               _model.timerController.onResetTimer();

//                               _model.timerController.onStartTimer();
//                               setState(() {
//                                 _model.isTimerPause = false;
//                               });
//                               await OperatorsOperationsTable().update(
//                                 data: {
//                                   'status': 'readjustment',
//                                 },
//                                 matchingRows: (rows) => rows
//                                     .eq(
//                                       'id',
//                                       FFAppState()
//                                           .operatorsWorkingOperations[FFAppState()
//                                               .operatorsOperationsActiveIndex]
//                                           .mastersOperationId,
//                                     )
//                                     .eq(
//                                       'company',
//                                       FFAppState().companyName,
//                                     ),
//                               );
//                               _model.updateTime?.cancel();
//                               _model.updateTimeCleaning?.cancel();
//                               _model.updateTimeBreakdown?.cancel();
//                               _model.updateTimeReadjustment =
//                                   InstantTimer.periodic(
//                                 duration: Duration(milliseconds: 1000),
//                                 callback: (timer) async {
//                                   await OperatorsOperationsTable().update(
//                                     data: {
//                                       'working_time': _model.timerMilliseconds,
//                                     },
//                                     matchingRows: (rows) => rows
//                                         .eq(
//                                           'id',
//                                           FFAppState()
//                                               .operatorsWorkingOperations[
//                                                   FFAppState()
//                                                       .operatorsOperationsActiveIndex]
//                                               .mastersOperationId,
//                                         )
//                                         .eq(
//                                           'company',
//                                           FFAppState().companyName,
//                                         ),
//                                   );
//                                 },
//                                 startImmediately: false,
//                               );
//                             },
//                             text: 'Переналадка',
//                             options: FFButtonOptions(
//                               height: 40,
//                               padding:
//                                   EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                               iconPadding:
//                                   EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                               color: Color(0xFFFFFA00),
//                               textStyle: FlutterFlowTheme.of(context)
//                                   .titleSmall
//                                   .override(
//                                     fontFamily: 'Inter',
//                                     color: FlutterFlowTheme.of(context)
//                                         .primaryText,
//                                   ),
//                               elevation: 3,
//                               borderSide: BorderSide(
//                                 color: Colors.transparent,
//                                 width: 1,
//                               ),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           FFButtonWidget(
//                             onPressed: () async {
//                               _model.timerController.onResetTimer();

//                               _model.timerController.onStartTimer();
//                               setState(() {
//                                 _model.isTimerPause = false;
//                               });
//                               await OperatorsOperationsTable().update(
//                                 data: {
//                                   'status': 'cleaning',
//                                 },
//                                 matchingRows: (rows) => rows
//                                     .eq(
//                                       'id',
//                                       FFAppState()
//                                           .operatorsWorkingOperations[FFAppState()
//                                               .operatorsOperationsActiveIndex]
//                                           .mastersOperationId,
//                                     )
//                                     .eq(
//                                       'company',
//                                       FFAppState().companyName,
//                                     ),
//                               );
//                               _model.updateTime?.cancel();
//                               _model.updateTimeReadjustment?.cancel();
//                               _model.updateTimeBreakdown?.cancel();
//                               _model.updateTimeCleaning = InstantTimer.periodic(
//                                 duration: Duration(milliseconds: 1000),
//                                 callback: (timer) async {
//                                   await OperatorsOperationsTable().update(
//                                     data: {
//                                       'working_time': _model.timerMilliseconds,
//                                     },
//                                     matchingRows: (rows) => rows
//                                         .eq(
//                                           'id',
//                                           FFAppState()
//                                               .operatorsWorkingOperations[
//                                                   FFAppState()
//                                                       .operatorsOperationsActiveIndex]
//                                               .mastersOperationId,
//                                         )
//                                         .eq(
//                                           'company',
//                                           FFAppState().companyName,
//                                         ),
//                                   );
//                                 },
//                                 startImmediately: false,
//                               );
//                             },
//                             text: 'Уборка',
//                             options: FFButtonOptions(
//                               height: 40,
//                               padding:
//                                   EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                               iconPadding:
//                                   EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                               color: Color(0xFFFFFA00),
//                               textStyle: FlutterFlowTheme.of(context)
//                                   .titleSmall
//                                   .override(
//                                     fontFamily: 'Inter',
//                                     color: FlutterFlowTheme.of(context)
//                                         .primaryText,
//                                   ),
//                               elevation: 3,
//                               borderSide: BorderSide(
//                                 color: Colors.transparent,
//                                 width: 1,
//                               ),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
//                       child: FFButtonWidget(
//                         onPressed: () async {
//                           _model.timerController.onResetTimer();

//                           setState(() {
//                             _model.isTimerPause = false;
//                           });
//                           await OperatorsOperationsTable().update(
//                             data: {
//                               'status': 'ready',
//                             },
//                             matchingRows: (rows) => rows
//                                 .eq(
//                                   'id',
//                                   FFAppState()
//                                       .operatorsWorkingOperations[FFAppState()
//                                           .operatorsOperationsActiveIndex]
//                                       .id,
//                                 )
//                                 .eq(
//                                   'company',
//                                   FFAppState().companyName,
//                                 ),
//                           );
//                           _model.readyOperation =
//                               await actions.fetchOperationInfo(
//                             FFAppState()
//                                 .operatorsWorkingOperations[
//                                     FFAppState().operatorsOperationsActiveIndex]
//                                 .id
//                                 .toString(),
//                           );
//                           await ReadyOperationsTable().insert({
//                             'operation_name':
//                                 _model.readyOperation?.operationName,
//                             'time_plan': _model.readyOperation?.time,
//                             'time_fact': functions.timeConverter(
//                                 _model.readyOperation!.workingTime),
//                             'equipment': _model.readyOperation?.equipmentName,
//                             'operator': FFAppState().userInfo.number,
//                             'region': _model.readyOperation?.region?.toString(),
//                             'time_start': _model.readyOperation?.timeStart,
//                             'time_stop': dateTimeFormat(
//                                 'H:mm d.M.y', getCurrentTimestamp),
//                             'company': FFAppState().companyName,
//                             'detail_number': _model.readyOperation?.planNumber,
//                             'stage_operation_id':
//                                 _model.readyOperation?.stageOperationId,
//                           });
//                           _model.updateTime?.cancel();
//                           await actions.fetchOperatorsOperationsList();
//                           _model.timerController.timer.setPresetTime(
//                             mSec: FFAppState().timerTime,
//                             add: false,
//                           );
//                           _model.timerController.onResetTimer();

//                           await actions.addOperationInMastersOperationsList(
//                             _model.readyOperation!.stageOperationId,
//                             _model.readyOperation!.region,
//                           );

//                           setState(() {});
//                         },
//                         text: 'Деталь готова',
//                         options: FFButtonOptions(
//                           height: 40,
//                           padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                           iconPadding:
//                               EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                           color: Color(0xFF00FF38),
//                           textStyle: FlutterFlowTheme.of(context)
//                               .titleSmall
//                               .override(
//                                 fontFamily: 'Inter',
//                                 color: FlutterFlowTheme.of(context).primaryText,
//                               ),
//                           elevation: 3,
//                           borderSide: BorderSide(
//                             color: Colors.transparent,
//                             width: 1,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
//                       child: FFButtonWidget(
//                         onPressed: () async {
//                           _model.timerController.onResetTimer();

//                           _model.timerController.onStartTimer();
//                           setState(() {
//                             _model.isTimerPause = false;
//                           });
//                           await OperatorsOperationsTable().update(
//                             data: {
//                               'status': 'breakdown',
//                             },
//                             matchingRows: (rows) => rows
//                                 .eq(
//                                   'id',
//                                   FFAppState()
//                                       .operatorsWorkingOperations[FFAppState()
//                                           .operatorsOperationsActiveIndex]
//                                       .mastersOperationId,
//                                 )
//                                 .eq(
//                                   'company',
//                                   FFAppState().companyName,
//                                 ),
//                           );
//                           _model.updateTime?.cancel();
//                           _model.updateTimeReadjustment?.cancel();
//                           _model.updateTimeCleaning?.cancel();
//                           _model.updateTimeBreakdown = InstantTimer.periodic(
//                             duration: Duration(milliseconds: 1000),
//                             callback: (timer) async {
//                               await OperatorsOperationsTable().update(
//                                 data: {
//                                   'working_time': _model.timerMilliseconds,
//                                 },
//                                 matchingRows: (rows) => rows
//                                     .eq(
//                                       'id',
//                                       FFAppState()
//                                           .operatorsWorkingOperations[FFAppState()
//                                               .operatorsOperationsActiveIndex]
//                                           .mastersOperationId,
//                                     )
//                                     .eq(
//                                       'company',
//                                       FFAppState().companyName,
//                                     ),
//                               );
//                             },
//                             startImmediately: false,
//                           );
//                         },
//                         text: 'Поломка',
//                         options: FFButtonOptions(
//                           height: 40,
//                           padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                           iconPadding:
//                               EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                           color: Color(0xFFFF0000),
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
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
