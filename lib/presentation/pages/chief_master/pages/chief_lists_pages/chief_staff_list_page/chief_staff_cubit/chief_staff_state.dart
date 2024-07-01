part of 'chief_staff_cubit.dart';


enum ChiefStaffStatus {initial, loading, success}

class ChiefStaffState extends Equatable {
  const ChiefStaffState({
    this.staffList = const [],
    this.positionStaffList = const [],
    this.areasList = const [],
    this.unitsList = const [],
    this.areasNamesList = const [],
    this.status = ChiefStaffStatus.initial,

  });
  final List<PositionStaffModel> positionStaffList;
  final List<Area> areasList;
  final List<Staff> staffList;
  final List<String> areasNamesList;
  final List<Unit> unitsList;

  final ChiefStaffStatus status;


  ChiefStaffState copyWith({
    List<Staff>? staffList,
    List<PositionStaffModel>? positionStaffList,
    List<Area>? areasList,
    List<String>? areasNamesList,
    List<Unit>? unitsList,
    ChiefStaffStatus? status,

  }) {
    return ChiefStaffState(
        staffList: staffList ?? this.staffList,
        areasList: areasList ?? this.areasList,
        areasNamesList: areasNamesList ?? this.areasNamesList,
      positionStaffList: positionStaffList ?? this.positionStaffList,
      unitsList: unitsList ?? this.unitsList,
      status: status ?? this.status,
       );
  }

  @override
  List<Object?> get props => [staffList, areasList, areasNamesList, status, positionStaffList, unitsList];
}

