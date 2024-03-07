// import '/backend/supabase/supabase.dart';
// import '/flutter_flow/flutter_flow_icon_button.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '/custom_code/actions/index.dart' as actions;
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import 'add_operation_master_page_model.dart';
// export 'add_operation_master_page_model.dart';

// class AddOperationMasterPageWidget extends StatefulWidget {
//   const AddOperationMasterPageWidget({
//     super.key,
//     required this.equipmentName,
//     this.order,
//   });

//   final String? equipmentName;
//   final int? order;

//   @override
//   State<AddOperationMasterPageWidget> createState() =>
//       _AddOperationMasterPageWidgetState();
// }

// class _AddOperationMasterPageWidgetState
//     extends State<AddOperationMasterPageWidget> {
//   late AddOperationMasterPageModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => AddOperationMasterPageModel());

//     // On page load action.
//     SchedulerBinding.instance.addPostFrameCallback((_) async {
//       await actions.fetchEquipmentList();
//       setState(() {
//         FFAppState().equipmentName = FFAppState().equipmentList.first;
//       });
//     });

//     _model.planNumberController ??= TextEditingController();
//     _model.planNumberFocusNode ??= FocusNode();

//     _model.nameController ??= TextEditingController();
//     _model.nameFocusNode ??= FocusNode();

//     _model.operationNumberController ??= TextEditingController();
//     _model.operationNumberFocusNode ??= FocusNode();

//     _model.timeController ??= TextEditingController();
//     _model.timeFocusNode ??= FocusNode();

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
//             borderColor: FlutterFlowTheme.of(context).primary,
//             borderRadius: 20,
//             borderWidth: 1,
//             buttonSize: 40,
//             fillColor: FlutterFlowTheme.of(context).accent1,
//             icon: Icon(
//               Icons.arrow_back_outlined,
//               color: FlutterFlowTheme.of(context).primaryText,
//               size: 24,
//             ),
//             onPressed: () async {
//               context.safePop();
//             },
//           ),
//           title: Align(
//             alignment: AlignmentDirectional(-1, 0),
//             child: Text(
//               'Добавить операцию',
//               style: FlutterFlowTheme.of(context).headlineMedium.override(
//                     fontFamily: 'Readex Pro',
//                     color: Colors.white,
//                     fontSize: 18,
//                   ),
//             ),
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
//               Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   SingleChildScrollView(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Align(
//                           alignment: AlignmentDirectional(-1, 0),
//                           child: Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(10, 25, 10, 0),
//                             child: Text(
//                               'Чертеж',
//                               style: FlutterFlowTheme.of(context).bodyMedium,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(8, 10, 8, 0),
//                           child: TextFormField(
//                             controller: _model.planNumberController,
//                             focusNode: _model.planNumberFocusNode,
//                             autofocus: true,
//                             obscureText: false,
//                             decoration: InputDecoration(
//                               labelText: 'Ввод',
//                               labelStyle:
//                                   FlutterFlowTheme.of(context).labelMedium,
//                               hintStyle:
//                                   FlutterFlowTheme.of(context).labelMedium,
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context).alternate,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context).primary,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context).error,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context).error,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             style: FlutterFlowTheme.of(context).bodyMedium,
//                             validator: _model.planNumberControllerValidator
//                                 .asValidator(context),
//                           ),
//                         ),
//                         Align(
//                           alignment: AlignmentDirectional(-1, 0),
//                           child: Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(10, 25, 10, 0),
//                             child: Text(
//                               'Название операции',
//                               style: FlutterFlowTheme.of(context).bodyMedium,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(8, 10, 8, 0),
//                           child: TextFormField(
//                             controller: _model.nameController,
//                             focusNode: _model.nameFocusNode,
//                             autofocus: true,
//                             obscureText: false,
//                             decoration: InputDecoration(
//                               labelText: 'Ввод',
//                               labelStyle:
//                                   FlutterFlowTheme.of(context).labelMedium,
//                               hintStyle:
//                                   FlutterFlowTheme.of(context).labelMedium,
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context).alternate,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context).primary,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context).error,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context).error,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             style: FlutterFlowTheme.of(context).bodyMedium,
//                             validator: _model.nameControllerValidator
//                                 .asValidator(context),
//                           ),
//                         ),
//                         Align(
//                           alignment: AlignmentDirectional(-1, 0),
//                           child: Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(10, 25, 10, 0),
//                             child: Text(
//                               'Номер операции',
//                               style: FlutterFlowTheme.of(context).bodyMedium,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(8, 10, 8, 0),
//                           child: TextFormField(
//                             controller: _model.operationNumberController,
//                             focusNode: _model.operationNumberFocusNode,
//                             autofocus: true,
//                             obscureText: false,
//                             decoration: InputDecoration(
//                               labelText: 'Ввод',
//                               labelStyle:
//                                   FlutterFlowTheme.of(context).labelMedium,
//                               hintStyle:
//                                   FlutterFlowTheme.of(context).labelMedium,
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context).alternate,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context).primary,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context).error,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context).error,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             style: FlutterFlowTheme.of(context).bodyMedium,
//                             validator: _model.operationNumberControllerValidator
//                                 .asValidator(context),
//                           ),
//                         ),
//                         Align(
//                           alignment: AlignmentDirectional(-1, 0),
//                           child: Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(10, 25, 10, 0),
//                             child: Text(
//                               'Время операции',
//                               style: FlutterFlowTheme.of(context).bodyMedium,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(8, 10, 8, 0),
//                           child: TextFormField(
//                             controller: _model.timeController,
//                             focusNode: _model.timeFocusNode,
//                             autofocus: true,
//                             obscureText: false,
//                             decoration: InputDecoration(
//                               labelText: 'Ввод',
//                               labelStyle:
//                                   FlutterFlowTheme.of(context).labelMedium,
//                               hintStyle:
//                                   FlutterFlowTheme.of(context).labelMedium,
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context).alternate,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context).primary,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context).error,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context).error,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             style: FlutterFlowTheme.of(context).bodyMedium,
//                             validator: _model.timeControllerValidator
//                                 .asValidator(context),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
//                           child: FFButtonWidget(
//                             onPressed: () async {
//                               await actions.updateOrderOperationsFilter(
//                                 widget.order!,
//                               );
//                               _model.newOrder = await actions.orderAdd(
//                                 widget.order!,
//                               );
//                               await OperatorsOperationsTable().insert({
//                                 'region': FFAppState().masterRegionNumber,
//                                 'plan_number': _model.planNumberController.text,
//                                 'operation_name': _model.nameController.text,
//                                 'operation_number': int.tryParse(
//                                     _model.operationNumberController.text),
//                                 'time': _model.timeController.text,
//                                 'equipment_name': widget.equipmentName,
//                                 'company': FFAppState().companyName,
//                                 'order': _model.newOrder,
//                               });
//                               context.safePop();

//                               setState(() {});
//                             },
//                             text: 'Ввод',
//                             options: FFButtonOptions(
//                               height: 40,
//                               padding:
//                                   EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                               iconPadding:
//                                   EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                               color: FlutterFlowTheme.of(context).primary,
//                               textStyle: FlutterFlowTheme.of(context)
//                                   .titleSmall
//                                   .override(
//                                     fontFamily: 'Inter',
//                                     color: Colors.white,
//                                   ),
//                               elevation: 3,
//                               borderSide: BorderSide(
//                                 color: Colors.transparent,
//                                 width: 1,
//                               ),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
