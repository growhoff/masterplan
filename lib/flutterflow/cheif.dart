// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import 'chief_main_page_model.dart';
// export 'chief_main_page_model.dart';

// class ChiefMainPageWidget extends StatefulWidget {
//   const ChiefMainPageWidget({super.key});

//   @override
//   State<ChiefMainPageWidget> createState() => _ChiefMainPageWidgetState();
// }

// class _ChiefMainPageWidgetState extends State<ChiefMainPageWidget> {
//   late ChiefMainPageModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => ChiefMainPageModel());

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
//                     '${FFAppState().userInfo.number} ${FFAppState().userInfo.fio} ${FFAppState().userInfo.position}',
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
//                   'Списки',
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
//           child: Align(
//             alignment: AlignmentDirectional(0, 0),
//             child: Padding(
//               padding: EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Align(
//                     alignment: AlignmentDirectional(0, -1),
//                     child: FFButtonWidget(
//                       onPressed: () async {
//                         context.pushNamed('EquipmentListPage');
//                       },
//                       text: 'Список оборудования',
//                       options: FFButtonOptions(
//                         height: 40,
//                         padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                         iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                         color: FlutterFlowTheme.of(context).primary,
//                         textStyle:
//                             FlutterFlowTheme.of(context).titleSmall.override(
//                                   fontFamily: 'Inter',
//                                   color: Colors.white,
//                                 ),
//                         elevation: 3,
//                         borderSide: BorderSide(
//                           color: Colors.transparent,
//                           width: 1,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: AlignmentDirectional(0, -1),
//                     child: Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
//                       child: FFButtonWidget(
//                         onPressed: () async {
//                           context.pushNamed('StaffListPage');
//                         },
//                         text: 'Список персонала',
//                         options: FFButtonOptions(
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
//                   ),
//                   Align(
//                     alignment: AlignmentDirectional(0, -1),
//                     child: Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
//                       child: FFButtonWidget(
//                         onPressed: () async {
//                           context.pushNamed('RegionsListPage');
//                         },
//                         text: 'Список участков',
//                         options: FFButtonOptions(
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
