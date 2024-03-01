// import '/backend/supabase/supabase.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '/custom_code/actions/index.dart' as actions;
// import '/flutter_flow/custom_functions.dart' as functions;
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import 'shift_edit_user_name_model.dart';
// export 'shift_edit_user_name_model.dart';

// class ShiftEditUserNameWidget extends StatefulWidget {
//   const ShiftEditUserNameWidget({
//     super.key,
//     required this.equipment,
//     required this.data,
//     required this.change,
//     required this.isAdd,
//   });

//   final String? equipment;
//   final DateTime? data;
//   final String? change;
//   final bool? isAdd;

//   @override
//   State<ShiftEditUserNameWidget> createState() =>
//       _ShiftEditUserNameWidgetState();
// }

// class _ShiftEditUserNameWidgetState extends State<ShiftEditUserNameWidget> {
//   late ShiftEditUserNameModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => ShiftEditUserNameModel());

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
//           title: Text(
//             'Выберите оператора',
//             style: FlutterFlowTheme.of(context).headlineMedium.override(
//                   fontFamily: 'Readex Pro',
//                   color: Colors.white,
//                   fontSize: 22,
//                 ),
//           ),
//           actions: [],
//           centerTitle: false,
//           elevation: 2,
//         ),
//         body: SafeArea(
//           top: true,
//           child: Padding(
//             padding: EdgeInsetsDirectional.fromSTEB(26, 8, 26, 8),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
//                     child: Text(
//                       valueOrDefault<String>(
//                         widget.equipment,
//                         'none',
//                       ),
//                       style: FlutterFlowTheme.of(context).headlineMedium,
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         RichText(
//                           textScaleFactor:
//                               MediaQuery.of(context).textScaleFactor,
//                           text: TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: 'Смена № ',
//                                 style:
//                                     FlutterFlowTheme.of(context).headlineSmall,
//                               ),
//                               TextSpan(
//                                 text: valueOrDefault<String>(
//                                   widget.change,
//                                   'none',
//                                 ),
//                                 style:
//                                     FlutterFlowTheme.of(context).headlineSmall,
//                               )
//                             ],
//                             style: FlutterFlowTheme.of(context).headlineSmall,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
//                           child: Text(
//                             valueOrDefault<String>(
//                               dateTimeFormat('d/M/y', widget.data),
//                               'none',
//                             ),
//                             style: FlutterFlowTheme.of(context).headlineSmall,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
//                     child: Builder(
//                       builder: (context) {
//                         final listUsers = FFAppState()
//                             .stafListUsers
//                             .map((e) => e.fio)
//                             .toList();
//                         return ListView.builder(
//                           padding: EdgeInsets.zero,
//                           shrinkWrap: true,
//                           scrollDirection: Axis.vertical,
//                           itemCount: listUsers.length,
//                           itemBuilder: (context, listUsersIndex) {
//                             final listUsersItem = listUsers[listUsersIndex];
//                             return InkWell(
//                               splashColor: Colors.transparent,
//                               focusColor: Colors.transparent,
//                               hoverColor: Colors.transparent,
//                               highlightColor: Colors.transparent,
//                               onTap: () async {
//                                 setState(() {
//                                   FFAppState().activeFioOperator =
//                                       listUsersItem;
//                                 });
//                               },
//                               child: ListTile(
//                                 title: Text(
//                                   listUsersItem,
//                                   style: FlutterFlowTheme.of(context)
//                                       .titleMedium
//                                       .override(
//                                         fontFamily: 'Readex Pro',
//                                         color: FlutterFlowTheme.of(context)
//                                             .primary,
//                                       ),
//                                 ),
//                                 tileColor: functions.getColorIsActive(
//                                     FlutterFlowTheme.of(context)
//                                         .secondaryBackground,
//                                     FlutterFlowTheme.of(context).success,
//                                     FFAppState().activeFioOperator,
//                                     listUsersItem),
//                                 dense: false,
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                   FFButtonWidget(
//                     onPressed: () async {
//                       if (widget.isAdd!) {
//                         await ShiftsDistributionTable().insert({
//                           'user': FFAppState().activeFioOperator,
//                           'change': widget.change,
//                           'data': supaSerialize<DateTime>(widget.data),
//                           'region': FFAppState().masterRegionNumber,
//                           'company': FFAppState().companyName,
//                           'equipment_name': widget.equipment,
//                         });
//                       } else {
//                         await ShiftsDistributionTable().update(
//                           data: {
//                             'user': FFAppState().activeFioOperator,
//                           },
//                           matchingRows: (rows) => rows
//                               .eq(
//                                 'data',
//                                 supaSerialize<DateTime>(widget.data),
//                               )
//                               .eq(
//                                 'change',
//                                 widget.change,
//                               )
//                               .eq(
//                                 'equipment_name',
//                                 widget.equipment,
//                               )
//                               .eq(
//                                 'region',
//                                 FFAppState().masterRegionNumber,
//                               )
//                               .eq(
//                                 'company',
//                                 FFAppState().companyName,
//                               ),
//                         );
//                       }

//                       await actions.fetchShiftsDistribution(
//                         widget.data!,
//                       );
//                       setState(() {
//                         FFAppState().activeFioOperator = '';
//                       });
//                       context.safePop();
//                     },
//                     text: 'Выбрать',
//                     options: FFButtonOptions(
//                       width: double.infinity,
//                       height: 40,
//                       padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                       iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                       color: FlutterFlowTheme.of(context).primary,
//                       textStyle:
//                           FlutterFlowTheme.of(context).titleSmall.override(
//                                 fontFamily: 'Inter',
//                                 color: Colors.white,
//                               ),
//                       elevation: 3,
//                       borderSide: BorderSide(
//                         color: Colors.transparent,
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
