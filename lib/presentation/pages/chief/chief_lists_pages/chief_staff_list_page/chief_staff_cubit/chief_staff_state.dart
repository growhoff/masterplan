part of 'chief_staff_cubit.dart';

enum ChiefStaffStatus { initial, loading, success }

class ChiefStaffState extends Equatable {
  const ChiefStaffState({
    this.positionStaffList = const [],
    this.areasList = const [],
    this.areasNamesList = const [],
    this.status = ChiefStaffStatus.initial,
  });

  final List<PositionStaffModel> positionStaffList;
  final List<Area> areasList;

  final List<String> areasNamesList;

  final ChiefStaffStatus status;

  ChiefStaffState copyWith({
    List<Area>? areasList,
    List<String>? areasNamesList,
    List<PositionStaffModel>? positionStaffList,
    ChiefStaffStatus? status,
  }) {
    return ChiefStaffState(
        areasList: areasList ?? this.areasList,
        areasNamesList: areasNamesList ?? this.areasNamesList,
        status: status ?? this.status,
        positionStaffList: positionStaffList ?? this.positionStaffList);
  }

  @override
  List<Object?> get props =>
      [areasList, areasNamesList, status, positionStaffList];
}
