// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/name_index.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/model/distrib_item.dart';

class StateDistributionDetails extends Equatable {
  final List<DistribItem> pathListOper;
  final bool isLoading;
  final List<AreaMachine> listAreaMachine;
  final int activeArea;
  final List<NameIndex> listItemArea;
  const StateDistributionDetails({
    this.pathListOper = const [],
    this.isLoading = false,
    this.listAreaMachine = const [],
    this.activeArea = 0,
    this.listItemArea = const [],
  });

  @override
  List<Object> get props => [pathListOper, isLoading, listAreaMachine, activeArea, listItemArea];

  StateDistributionDetails copyWith({
    List<DistribItem>? pathListOper,
    bool? isLoading,
    int? activeArea,
    List<AreaMachine>? listAreaMachine,
    List<NameIndex>? listItemArea,
  }) {
    return StateDistributionDetails(
      pathListOper: pathListOper ?? this.pathListOper,
      isLoading:  isLoading ?? this.isLoading,
      activeArea: activeArea ?? this.activeArea,
      listAreaMachine: listAreaMachine ?? this.listAreaMachine,
      listItemArea: listItemArea ?? this.listItemArea,
    );
  }

  @override
  bool get stringify => true;
}
