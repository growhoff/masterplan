// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import '../model/distrib_item.dart';

class StateDistributionDetailsChMas extends Equatable {
  final List<DistribItem> pathListOper;
  final bool isLoading;
  final int activeArea;
  final List<AreaMachine> listAreaMachine;
  const StateDistributionDetailsChMas({
    this.pathListOper = const [],
    this.isLoading = false,
    this.activeArea = 0,
    this.listAreaMachine = const [],
  });

  @override
  List<Object> get props => [pathListOper, isLoading, activeArea, listAreaMachine];

  StateDistributionDetailsChMas copyWith({
    List<DistribItem>? pathListOper,
    bool? isLoading,
    int? activeArea,
    List<AreaMachine>? listAreaMachine,
  }) {
    return StateDistributionDetailsChMas(
      pathListOper: pathListOper ?? this.pathListOper,
      isLoading:  isLoading ?? this.isLoading,
      activeArea: activeArea ?? this.activeArea,
      listAreaMachine: listAreaMachine ?? this.listAreaMachine,
    );
  }

  @override
  bool get stringify => true;
}
