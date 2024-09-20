// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/distrib_item_details.dart';
import 'package:master_plan/domain/model/name_index.dart';
// import 'package:master_plan/presentation/pages/master/pages/distributionDetails/model/distrib_item.dart';

class StateDistributionDetails extends Equatable {
  final List<DistribItemDetails> pathListOper;
  final List<DistribItemDetails> filterListOper;
  final bool isLoading;
  final List<AreaMachine> listAreaMachine;
  final int activeArea;
  final List<NameIndex> listItemArea;
  final int timeWork;

  const StateDistributionDetails({
    this.pathListOper = const [],
    this.filterListOper = const [],
    this.isLoading = false,
    this.listAreaMachine = const [],
    this.activeArea = 0,
    this.listItemArea = const [],
    this.timeWork = 0,
  });

  @override
  List<Object> get props => [pathListOper, isLoading, listAreaMachine, activeArea, listItemArea, timeWork, filterListOper];

  StateDistributionDetails copyWith({
    List<DistribItemDetails>? pathListOper,
    List<DistribItemDetails>? filterListOper,
    bool? isLoading,
    int? activeArea,
    List<AreaMachine>? listAreaMachine,
    List<NameIndex>? listItemArea,
    int? timeWork,
  }) {
    return StateDistributionDetails(
      pathListOper: pathListOper ?? this.pathListOper,
      filterListOper: filterListOper ?? this.filterListOper,
      isLoading:  isLoading ?? this.isLoading,
      activeArea: activeArea ?? this.activeArea,
      listAreaMachine: listAreaMachine ?? this.listAreaMachine,
      listItemArea: listItemArea ?? this.listItemArea,
      timeWork: timeWork ?? this.timeWork,
    );
  }

  @override
  bool get stringify => true;
}
