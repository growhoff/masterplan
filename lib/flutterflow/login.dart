// import '/backend/schema/structs/index.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '/custom_code/actions/index.dart' as actions;
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import 'login_page_model.dart';
// export 'login_page_model.dart';

// class LoginPageWidget extends StatefulWidget {
//   const LoginPageWidget({super.key});

//   @override
//   State<LoginPageWidget> createState() => _LoginPageWidgetState();
// }

// class _LoginPageWidgetState extends State<LoginPageWidget> {
//   late LoginPageModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => LoginPageModel());

//     _model.numberController ??= TextEditingController();
//     _model.numberFocusNode ??= FocusNode();

//     _model.passwordController ??= TextEditingController();
//     _model.passwordFocusNode ??= FocusNode();

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
//           title: Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 'MasterPlan',
//                 style: FlutterFlowTheme.of(context).headlineMedium.override(
//                       fontFamily: 'Readex Pro',
//                       color: Colors.white,
//                       fontSize: 22,
//                     ),
//               ),
//               Text(
//                 FFAppState().version,
//                 style: FlutterFlowTheme.of(context).bodyMedium,
//               ),
//             ],
//           ),
//           actions: [],
//           centerTitle: false,
//           elevation: 2,
//         ),
//         body: SafeArea(
//           top: true,
//           child: Padding(
//             padding: EdgeInsetsDirectional.fromSTEB(0, 130, 0, 0),
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Align(
//                   alignment: AlignmentDirectional(-1, 0),
//                   child: Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
//                     child: Text(
//                       'Табельный номер',
//                       textAlign: TextAlign.start,
//                       style: FlutterFlowTheme.of(context).titleLarge.override(
//                             fontFamily: 'Readex Pro',
//                             fontWeight: FontWeight.bold,
//                           ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
//                   child: TextFormField(
//                     controller: _model.numberController,
//                     focusNode: _model.numberFocusNode,
//                     autofocus: true,
//                     obscureText: false,
//                     decoration: InputDecoration(
//                       labelText: 'Ввод',
//                       labelStyle: FlutterFlowTheme.of(context).labelMedium,
//                       hintStyle: FlutterFlowTheme.of(context).labelMedium,
                      
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: FlutterFlowTheme.of(context).primary,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: FlutterFlowTheme.of(context).error,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: FlutterFlowTheme.of(context).error,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     style: FlutterFlowTheme.of(context).bodyMedium,
//                     validator:
//                         _model.numberControllerValidator.asValidator(context),
//                   ),
//                 ),
//                 Align(
//                   alignment: AlignmentDirectional(-1, 0),
//                   child: Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(8, 20, 0, 0),
//                     child: Text(
//                       'Пароль',
//                       textAlign: TextAlign.start,
//                       style: FlutterFlowTheme.of(context).titleLarge.override(
//                             fontFamily: 'Readex Pro',
//                             fontWeight: FontWeight.bold,
//                           ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
//                   child: TextFormField(
//                     controller: _model.passwordController,
//                     focusNode: _model.passwordFocusNode,
//                     autofocus: true,
//                     obscureText: false,
//                     decoration: InputDecoration(
//                       labelText: 'Ввод',
//                       labelStyle: FlutterFlowTheme.of(context).labelMedium,
//                       hintStyle: FlutterFlowTheme.of(context).labelMedium,
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: FlutterFlowTheme.of(context).alternate,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: FlutterFlowTheme.of(context).primary,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: FlutterFlowTheme.of(context).error,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: FlutterFlowTheme.of(context).error,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     style: FlutterFlowTheme.of(context).bodyMedium,
//                     validator:
//                         _model.passwordControllerValidator.asValidator(context),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
//                   child: FFButtonWidget(
//                     onPressed: () async {
//                       await actions.logInAction(
//                         _model.numberController.text,
//                         _model.passwordController.text,
//                         () async {
//                           await showDialog(
//                             context: context,
//                             builder: (alertDialogContext) {
//                               return AlertDialog(
//                                 title: Text('ошибка'),
//                                 content: Text('Неверный номер или пароль'),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () =>
//                                         Navigator.pop(alertDialogContext),
//                                     child: Text('Ok'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                         () async {
//                           _model.regionNumber = await actions.fetchRegionNumber(
//                             FFAppState().userInfo.region,
//                           );
//                           setState(() {
//                             FFAppState().updateUserInfoStruct(
//                               (e) => e..regionNumber = _model.regionNumber,
//                             );
//                           });

//                           context.pushNamed('MasterListChange');
//                         },
//                         () async {
//                           _model.regionNumber2 =
//                               await actions.fetchRegionNumber(
//                             FFAppState().userInfo.region,
//                           );
//                           setState(() {
//                             FFAppState().updateUserInfoStruct(
//                               (e) => e..regionNumber = _model.regionNumber2,
//                             );
//                           });

//                           context.pushNamed('StartShiftPage');
//                         },
//                         () async {
//                           await actions.fetchOperatorsOperationsList();
//                         },
//                         () async {
//                           context.pushNamed('chiefMainPage');
//                         },
//                       );

//                       setState(() {});
//                     },
//                     text: 'Войти',
//                     options: FFButtonOptions(
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
//                 ),
//               ].divide(SizedBox(height: 5)),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
