part of 'chiefs_list_cubit.dart';

enum ChiefsListStatus { initial, loading, success, failure }

class ChiefsListState extends Equatable {
  const ChiefsListState(
      {this.status = ChiefsListStatus.initial,
      this.unitsList = const [],
      this.areasList = const [],
      this.chiefsList = const []});

  final ChiefsListStatus status;
  final List<PositionStaffModel> chiefsList;
  final List<Unit> unitsList;
  final List<Area> areasList;

  @override
  List<Object> get props => [status, chiefsList, unitsList, areasList];

  ChiefsListState copyWith(
      {ChiefsListStatus? status,
      List<PositionStaffModel>? chiefsList,
      List<Area>? areasList,
      List<Unit>? unitsList}) {
    return ChiefsListState(
        status: status ?? this.status,
        chiefsList: chiefsList ?? this.chiefsList,
        unitsList: unitsList ?? this.unitsList,
        areasList: areasList ?? this.areasList);
  }
}
