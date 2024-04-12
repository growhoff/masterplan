part of 'chief_staff_cubit.dart';

class ChiefStaffState extends Equatable {
  const ChiefStaffState({
    this.staffList = const [],
    this.areasList = const [],
  });

  final List<Area> areasList;
  final List<Staff> staffList;

  ChiefStaffState copyWith({
    List<Staff>? staffList,
    List<Area>? areasList,
  }) {
    return ChiefStaffState(
      staffList: staffList ?? this.staffList,
      areasList: areasList ?? this.areasList,
    );
  }

  @override
  List<Object?> get props => [staffList];
}

class ChiefStaffAddPageState extends ChiefStaffState {
  const ChiefStaffAddPageState(
      {required this.positionsNamesList, required this.areasNamesList});

  final List<String> areasNamesList;
  final List<String> positionsNamesList;
}
