part of 'chief_staff_cubit.dart';

class ChiefStaffState extends Equatable {
  const ChiefStaffState({
    this.staffList = const [],
    this.areasList = const [],
  });

  final List<AreaModel> areasList;
  final List<StaffModel> staffList;

  ChiefStaffState copyWith({
    List<StaffModel>? staffList,
    List<AreaModel>? areasList,
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
