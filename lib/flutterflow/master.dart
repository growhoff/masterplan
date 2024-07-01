

// class MasterListChangeWidget extends StatefulWidget {
//   const MasterListChangeWidget({super.key});

//   @override
//   State<MasterListChangeWidget> createState() => _MasterListChangeWidgetState();
// }

// class _MasterListChangeWidgetState extends State<MasterListChangeWidget> {
//   late MasterListChangeModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => MasterListChangeModel());

//     // On page load action.
//     SchedulerBinding.instance.addPostFrameCallback((_) async {
//       await actions.fetchEquipmentList();
//       await actions.fetchStafList();
//       await actions.fetchShiftsDistribution(
//         _model.calendarSelectedDay!.start,
//       );
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
//           title: Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Список смен',
//                 style: FlutterFlowTheme.of(context).headlineMedium.override(
//                       fontFamily: 'Readex Pro',
//                       color: Colors.white,
//                       fontSize: 22,
//                     ),
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   AlignedTooltip(
//                     content: Padding(
//                         padding: EdgeInsets.all(4),
//                         child: Text(
//                           'Закрепить все',
//                           style: FlutterFlowTheme.of(context).bodyLarge,
//                         )),
//                     offset: 4,
//                     preferredDirection: AxisDirection.down,
//                     borderRadius: BorderRadius.circular(8),
//                     backgroundColor:
//                         FlutterFlowTheme.of(context).secondaryBackground,
//                     elevation: 4,
//                     tailBaseWidth: 24,
//                     tailLength: 12,
//                     waitDuration: Duration(milliseconds: 100),
//                     showDuration: Duration(milliseconds: 1500),
//                     triggerMode: TooltipTriggerMode.tap,
//                     child: Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
//                       child: FlutterFlowIconButton(
//                         borderColor: FlutterFlowTheme.of(context).primary,
//                         borderRadius: 20,
//                         borderWidth: 1,
//                         buttonSize: 42,
//                         fillColor: FlutterFlowTheme.of(context).accent1,
//                         icon: Icon(
//                           Icons.auto_fix_high,
//                           color: FlutterFlowTheme.of(context).primaryBackground,
//                           size: 24,
//                         ),
//                         onPressed: () async {
//                           await actions.updateEquipmentCustomReset();
//                           await actions.updateEquipmentCustom();
//                         },
//                       ),
//                     ),
//                   ),
//                   AlignedTooltip(
//                     content: Padding(
//                         padding: EdgeInsets.all(4),
//                         child: Text(
//                           'Открепить все',
//                           style: FlutterFlowTheme.of(context).bodyLarge,
//                         )),
//                     offset: 4,
//                     preferredDirection: AxisDirection.down,
//                     borderRadius: BorderRadius.circular(8),
//                     backgroundColor:
//                         FlutterFlowTheme.of(context).secondaryBackground,
//                     elevation: 4,
//                     tailBaseWidth: 24,
//                     tailLength: 12,
//                     waitDuration: Duration(milliseconds: 100),
//                     showDuration: Duration(milliseconds: 1500),
//                     triggerMode: TooltipTriggerMode.tap,
//                     child: Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
//                       child: FlutterFlowIconButton(
//                         borderColor: FlutterFlowTheme.of(context).primary,
//                         borderRadius: 20,
//                         borderWidth: 1,
//                         buttonSize: 42,
//                         fillColor: FlutterFlowTheme.of(context).accent1,
//                         icon: Icon(
//                           Icons.auto_fix_off,
//                           color: FlutterFlowTheme.of(context).alternate,
//                           size: 24,
//                         ),
//                         onPressed: () async {
//                           await actions.updateEquipmentCustomReset();
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
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
//                 padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Card(
//                         clipBehavior: Clip.antiAliasWithSaveLayer,
//                         color: FlutterFlowTheme.of(context).accent2,
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
//                           child: SingleChildScrollView(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.max,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsetsDirectional.fromSTEB(
//                                       0, 0, 0, 20),
//                                   child: FlutterFlowCalendar(
//                                     color: FlutterFlowTheme.of(context).primary,
//                                     iconColor: FlutterFlowTheme.of(context)
//                                         .secondaryText,
//                                     weekFormat: true,
//                                     weekStartsMonday: true,
//                                     rowHeight: 64,
//                                     onChange:
//                                         (DateTimeRange? newSelectedDate) async {
//                                       if (_model.calendarSelectedDay ==
//                                           newSelectedDate) {
//                                         return;
//                                       }
//                                       _model.calendarSelectedDay =
//                                           newSelectedDate;
//                                       await actions.fetchShiftsDistribution(
//                                         _model.calendarSelectedDay!.start,
//                                       );
//                                       setState(() {});
//                                       setState(() {});
//                                     },
//                                     titleStyle: FlutterFlowTheme.of(context)
//                                         .headlineSmall,
//                                     dayOfWeekStyle:
//                                         FlutterFlowTheme.of(context).labelLarge,
//                                     dateStyle:
//                                         FlutterFlowTheme.of(context).bodyMedium,
//                                     selectedDateStyle:
//                                         FlutterFlowTheme.of(context).titleSmall,
//                                     inactiveDateStyle:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium,
//                                   ),
//                                 ),
//                                 Align(
//                                   alignment: AlignmentDirectional(-1, 0),
//                                   child: Padding(
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         0, 0, 0, 20),
//                                     child: Text(
//                                       'Распределение на станки',
//                                       style: FlutterFlowTheme.of(context)
//                                           .titleLarge,
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsetsDirectional.fromSTEB(
//                                       0, 0, 0, 10),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.max,
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Padding(
//                                           padding:
//                                               EdgeInsetsDirectional.fromSTEB(
//                                                   0, 0, 5, 0),
//                                           child: FFButtonWidget(
//                                             onPressed: FFAppState().isShiftValut
//                                                 ? null
//                                                 : () async {
//                                                     FFAppState().isShiftValut =
//                                                         true;
//                                                     await actions
//                                                         .fetchShiftsDistribution(
//                                                       _model
//                                                           .calendarSelectedDay!
//                                                           .start,
//                                                     );
//                                                     setState(() {});
//                                                   },
//                                             text: '1 смена',
//                                             icon: Icon(
//                                               Icons.wb_sunny_rounded,
//                                               size: 15,
//                                             ),
//                                             options: FFButtonOptions(
//                                               height: 35,
//                                               padding: EdgeInsetsDirectional
//                                                   .fromSTEB(12, 0, 12, 0),
//                                               iconPadding: EdgeInsetsDirectional
//                                                   .fromSTEB(0, 0, 0, 0),
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .alternate,
//                                               textStyle:
//                                                   FlutterFlowTheme.of(context)
//                                                       .titleSmall
//                                                       .override(
//                                                         fontFamily: 'Inter',
//                                                         color: Colors.white,
//                                                       ),
//                                               elevation: 3,
//                                               borderSide: BorderSide(
//                                                 color: Colors.transparent,
//                                                 width: 1,
//                                               ),
//                                               borderRadius:
//                                                   BorderRadius.circular(50),
//                                               disabledColor:
//                                                   FlutterFlowTheme.of(context)
//                                                       .secondary,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 1,
//                                         child: Padding(
//                                           padding:
//                                               EdgeInsetsDirectional.fromSTEB(
//                                                   5, 0, 0, 0),
//                                           child: FFButtonWidget(
//                                             onPressed: !FFAppState()
//                                                     .isShiftValut
//                                                 ? null
//                                                 : () async {
//                                                     FFAppState().isShiftValut =
//                                                         false;
//                                                     await actions
//                                                         .fetchShiftsDistribution(
//                                                       _model
//                                                           .calendarSelectedDay!
//                                                           .start,
//                                                     );
//                                                     setState(() {});
//                                                   },
//                                             text: '2 смена',
//                                             icon: Icon(
//                                               Icons.mode_night,
//                                               size: 15,
//                                             ),
//                                             options: FFButtonOptions(
//                                               height: 35,
//                                               padding: EdgeInsetsDirectional
//                                                   .fromSTEB(12, 0, 12, 0),
//                                               iconPadding: EdgeInsetsDirectional
//                                                   .fromSTEB(0, 0, 0, 0),
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .alternate,
//                                               textStyle:
//                                                   FlutterFlowTheme.of(context)
//                                                       .titleSmall
//                                                       .override(
//                                                         fontFamily: 'Inter',
//                                                         color: Colors.white,
//                                                         fontSize: 16,
//                                                       ),
//                                               elevation: 3,
//                                               borderSide: BorderSide(
//                                                 color: Colors.transparent,
//                                                 width: 1,
//                                               ),
//                                               borderRadius:
//                                                   BorderRadius.circular(50),
//                                               disabledColor:
//                                                   FlutterFlowTheme.of(context)
//                                                       .secondary,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsetsDirectional.fromSTEB(
//                                       0, 12, 0, 0),
//                                   child: Builder(
//                                     builder: (context) {
//                                       final shiftList = FFAppState()
//                                           .shiftsDistributionList
//                                           .toList();
//                                       return ListView.builder(
//                                         padding: EdgeInsets.zero,
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.vertical,
//                                         itemCount: shiftList.length,
//                                         itemBuilder: (context, shiftListIndex) {
//                                           final shiftListItem =
//                                               shiftList[shiftListIndex];
//                                           return Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     0, 0, 0, 12),
//                                             child: Column(
//                                               mainAxisSize: MainAxisSize.max,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Padding(
//                                                   padding: EdgeInsetsDirectional
//                                                       .fromSTEB(0, 0, 0, 6),
//                                                   child: Text(
//                                                     shiftListItem.equipment,
//                                                     textAlign: TextAlign.center,
//                                                     style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 18,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 if (!functions
//                                                     .isVisibleCloseShifts(functions
//                                                         .getShiftFIOelseValue(
//                                                             FFAppState()
//                                                                 .isShiftValut,
//                                                             shiftListItem
//                                                                 .changeOneFio,
//                                                             shiftListItem
//                                                                 .changeTwoFio)))
//                                                   Slidable(
//                                                     endActionPane: ActionPane(
//                                                       motion:
//                                                           const ScrollMotion(),
//                                                       extentRatio: 0.25,
//                                                       children: [
//                                                         SlidableAction(
//                                                           label: 'Добавить',
//                                                           backgroundColor:
//                                                               FlutterFlowTheme.of(
//                                                                       context)
//                                                                   .success,
//                                                           icon: Icons.add,
//                                                           onPressed: (_) async {
//                                                             context.pushNamed(
//                                                               'ShiftEditUserName',
//                                                               queryParameters: {
//                                                                 'equipment':
//                                                                     serializeParam(
//                                                                   shiftListItem
//                                                                       .equipment,
//                                                                   ParamType
//                                                                       .String,
//                                                                 ),
//                                                                 'data':
//                                                                     serializeParam(
//                                                                   _model
//                                                                       .calendarSelectedDay
//                                                                       ?.start,
//                                                                   ParamType
//                                                                       .DateTime,
//                                                                 ),
//                                                                 'change':
//                                                                     serializeParam(
//                                                                   functions
//                                                                       .getShiftBoolForInt(
//                                                                           FFAppState()
//                                                                               .isShiftValut)
//                                                                       .toString(),
//                                                                   ParamType
//                                                                       .String,
//                                                                 ),
//                                                                 'isAdd':
//                                                                     serializeParam(
//                                                                   true,
//                                                                   ParamType
//                                                                       .bool,
//                                                                 ),
//                                                               }.withoutNulls,
//                                                             );
//                                                           },
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     child: ListTile(
//                                                       title: Text(
//                                                         functions.getShiftFIOelseValue(
//                                                             FFAppState()
//                                                                 .isShiftValut,
//                                                             shiftListItem
//                                                                 .changeOneFio,
//                                                             shiftListItem
//                                                                 .changeTwoFio),
//                                                         style:
//                                                             FlutterFlowTheme.of(
//                                                                     context)
//                                                                 .labelSmall,
//                                                       ),
//                                                       tileColor:
//                                                           FlutterFlowTheme.of(
//                                                                   context)
//                                                               .alternate,
//                                                       dense: false,
//                                                     ),
//                                                   ),
//                                                 if (functions.isVisibleCloseShifts(
//                                                     functions
//                                                         .getShiftFIOelseValue(
//                                                             FFAppState()
//                                                                 .isShiftValut,
//                                                             shiftListItem
//                                                                 .changeOneFio,
//                                                             shiftListItem
//                                                                 .changeTwoFio)))
//                                                   Slidable(
//                                                     endActionPane: ActionPane(
//                                                       motion:
//                                                           const ScrollMotion(),
//                                                       extentRatio: 0.5,
//                                                       children: [
//                                                         SlidableAction(
//                                                           label: 'Изменить',
//                                                           backgroundColor:
//                                                               FlutterFlowTheme.of(
//                                                                       context)
//                                                                   .success,
//                                                           icon: Icons.create,
//                                                           onPressed: (_) async {
//                                                             FFAppState()
//                                                                     .activeFioOperator =
//                                                                 functions.getShiftFIOelseValue(
//                                                                     FFAppState()
//                                                                         .isShiftValut,
//                                                                     shiftListItem
//                                                                         .changeOneFio,
//                                                                     shiftListItem
//                                                                         .changeTwoFio);

//                                                             context.pushNamed(
//                                                               'ShiftEditUserName',
//                                                               queryParameters: {
//                                                                 'equipment':
//                                                                     serializeParam(
//                                                                   shiftListItem
//                                                                       .equipment,
//                                                                   ParamType
//                                                                       .String,
//                                                                 ),
//                                                                 'data':
//                                                                     serializeParam(
//                                                                   _model
//                                                                       .calendarSelectedDay
//                                                                       ?.start,
//                                                                   ParamType
//                                                                       .DateTime,
//                                                                 ),
//                                                                 'change':
//                                                                     serializeParam(
//                                                                   functions
//                                                                       .getShiftBoolForInt(
//                                                                           FFAppState()
//                                                                               .isShiftValut)
//                                                                       .toString(),
//                                                                   ParamType
//                                                                       .String,
//                                                                 ),
//                                                                 'isAdd':
//                                                                     serializeParam(
//                                                                   false,
//                                                                   ParamType
//                                                                       .bool,
//                                                                 ),
//                                                               }.withoutNulls,
//                                                             );
//                                                           },
//                                                         ),
//                                                         SlidableAction(
//                                                           label: 'Удалить',
//                                                           backgroundColor:
//                                                               FlutterFlowTheme.of(
//                                                                       context)
//                                                                   .error,
//                                                           icon: Icons
//                                                               .delete_forever,
//                                                           onPressed: (_) async {
//                                                             await ShiftsDistributionTable()
//                                                                 .delete(
//                                                               matchingRows:
//                                                                   (rows) => rows
//                                                                       .eq(
//                                                                         'user',
//                                                                         shiftListItem
//                                                                             .changeOneFio,
//                                                                       )
//                                                                       .eq(
//                                                                         'region',
//                                                                         FFAppState()
//                                                                             .masterRegionNumber,
//                                                                       )
//                                                                       .eq(
//                                                                         'company',
//                                                                         FFAppState()
//                                                                             .companyName,
//                                                                       )
//                                                                       .eq(
//                                                                         'data',
//                                                                         supaSerialize<DateTime>(_model
//                                                                             .calendarSelectedDay
//                                                                             ?.start),
//                                                                       )
//                                                                       .eq(
//                                                                         'equipment_name',
//                                                                         shiftListItem
//                                                                             .equipment,
//                                                                       )
//                                                                       .eq(
//                                                                         'change',
//                                                                         functions
//                                                                             .getShiftBoolForInt(FFAppState().isShiftValut)
//                                                                             .toString(),
//                                                                       ),
//                                                             );
//                                                             await actions
//                                                                 .fetchShiftsDistribution(
//                                                               _model
//                                                                   .calendarSelectedDay!
//                                                                   .start,
//                                                             );
//                                                             setState(() {});
//                                                           },
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     child: ListTile(
//                                                       title: Text(
//                                                         functions.getShiftFIOelseValue(
//                                                             FFAppState()
//                                                                 .isShiftValut,
//                                                             shiftListItem
//                                                                 .changeOneFio,
//                                                             shiftListItem
//                                                                 .changeTwoFio),
//                                                         style:
//                                                             FlutterFlowTheme.of(
//                                                                     context)
//                                                                 .labelSmall,
//                                                       ),
//                                                       tileColor:
//                                                           FlutterFlowTheme.of(
//                                                                   context)
//                                                               .alternate,
//                                                       dense: false,
//                                                     ),
//                                                   ),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
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
