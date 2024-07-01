// import '/backend/supabase/supabase.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '/custom_code/actions/index.dart' as actions;
// import '/flutter_flow/custom_functions.dart' as functions;
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import 'start_shift_page_model.dart';
// export 'start_shift_page_model.dart';

// class StartShiftPageWidget extends StatefulWidget {
//   const StartShiftPageWidget({super.key});

//   @override
//   State<StartShiftPageWidget> createState() => _StartShiftPageWidgetState();
// }

// class _StartShiftPageWidgetState extends State<StartShiftPageWidget> {
//   late StartShiftPageModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => StartShiftPageModel());

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
//                     '${FFAppState().userInfo.number} ${FFAppState().  } ${FFAppState().userInfo.position} ${FFAppState().userInfo.regionNumber}',
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
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (!FFAppState().isSignin)
//                 Align(
//                   alignment: AlignmentDirectional(0, 0),
//                   child: FFButtonWidget(
//                     onPressed: () async {
//                       _model.equipmentList =
//                           await actions.fetchEquipmentListForOperator();
//                       setState(() {
//                         FFAppState().operatorsOperationsActiveIndex = 0;
//                         FFAppState().equipmentName =
//                             _model.equipmentList!.first;
//                       });
//                       await ShiftsTable().insert({
//                         'id_user': FFAppState().userInfo.number,
//                         'time_start': functions.getDataTimeNow(),
//                       });
//                       setState(() {
//                         FFAppState().isSignin = !FFAppState().isSignin;
//                       });

//                       context.pushNamed(
//                         'OperatorPage',
//                         queryParameters: {
//                           'equipmentList': serializeParam(
//                             _model.equipmentList,
//                             ParamType.String,
//                             true,
//                           ),
//                         }.withoutNulls,
//                       );

//                       setState(() {});
//                     },
//                     text: 'начать смену',
//                     options: FFButtonOptions(
//                       width: 200,
//                       height: 60,
//                       padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                       iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                       color: FlutterFlowTheme.of(context).primary,
//                       textStyle:
//                           FlutterFlowTheme.of(context).titleSmall.override(
//                                 fontFamily: 'Inter',
//                                 color: Colors.white,
//                                 fontSize: 24,
//                               ),
//                       elevation: 3,
//                       borderSide: BorderSide(
//                         color: Colors.transparent,
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(100),
//                     ),
//                   ),
//                 ),
//               if (FFAppState().isSignin)
//                 Align(
//                   alignment: AlignmentDirectional(0, 0),
//                   child: FFButtonWidget(
//                     onPressed: () async {
//                       await ShiftsTable().insert({
//                         'id_user': FFAppState().userInfo.number,
//                         'time_end': functions.getDataTimeNow(),
//                       });
//                       setState(() {
//                         FFAppState().isSignin = !FFAppState().isSignin;
//                       });
//                     },
//                     text: 'закончить смену',
//                     options: FFButtonOptions(
//                       width: 200,
//                       height: 60,
//                       padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                       iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                       color: FlutterFlowTheme.of(context).primary,
//                       textStyle:
//                           FlutterFlowTheme.of(context).titleSmall.override(
//                                 fontFamily: 'Inter',
//                                 color: Colors.white,
//                                 fontSize: 24,
//                               ),
//                       elevation: 3,
//                       borderSide: BorderSide(
//                         color: Colors.transparent,
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(100),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
