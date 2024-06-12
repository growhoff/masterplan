part of 'chief_staff_cubit.dart';


enum ChiefStaffStatus {initial, loading, success}

class ChiefStaffState extends Equatable {
  const ChiefStaffState({
    this.staffList = const [],
    this.areasList = const [],
    this.areasNamesList = const [],
    this.status = ChiefStaffStatus.initial,

  });

  final List<Area> areasList;
  final List<Staff> staffList;
  final List<String> areasNamesList;

  final ChiefStaffStatus status;


  ChiefStaffState copyWith({
    List<Staff>? staffList,
    List<Area>? areasList,
    List<String>? areasNamesList,
    ChiefStaffStatus? status,

  }) {
    return ChiefStaffState(
        staffList: staffList ?? this.staffList,
        areasList: areasList ?? this.areasList,
        areasNamesList: areasNamesList ?? this.areasNamesList,
      status: status ?? this.status,
       );
  }

  @override
  List<Object?> get props => [staffList, areasList, areasNamesList, status];
}

