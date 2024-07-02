part of 'units_cubit.dart';

enum UnitsStatus { initial, loading, success, failure }

final class UnitsState extends Equatable {
  const UnitsState(
      {this.unitsList = const [],
      this.status = UnitsStatus.initial,
      this.chiefsList = const []});

  final List<UnitModel> unitsList;
  final UnitsStatus status;
  final List<Staff> chiefsList;

  UnitsState copyWith({
    UnitsStatus? status,
    List<UnitModel>? unitsList,
    List<Staff>? chiefsList,
  }) {
    return UnitsState(
        chiefsList: chiefsList ?? this.chiefsList,
        unitsList: unitsList ?? this.unitsList,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [unitsList, status, chiefsList];
}
