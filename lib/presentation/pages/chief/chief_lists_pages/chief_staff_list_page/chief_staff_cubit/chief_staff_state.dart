part of 'chief_staff_cubit.dart';

class ChiefStaffState extends Equatable {
  const ChiefStaffState({
    this.staffList = const [],
    this.areasList = const [],
    this.areasNamesList = const [],
    this.positionsNamesList = const [],
  });

  final List<ZArea> areasList;
  final List<StaffModel> staffList;
  final List<String> areasNamesList;
  final List<String> positionsNamesList;

  ChiefStaffState copyWith({
    List<StaffModel>? staffList,
    List<ZArea>? areasList,
    List<String>? areasNamesList,
    List<String>? positionsNamesList,
  }) {
    return ChiefStaffState(
        staffList: staffList ?? this.staffList,
        areasList: areasList ?? this.areasList,
        areasNamesList: areasNamesList ?? this.areasNamesList,
        positionsNamesList: positionsNamesList ?? this.positionsNamesList);
  }

  @override
  List<Object?> get props => [staffList, areasList, areasNamesList, positionsNamesList];
}

class ChiefStaffAddPageState extends ChiefStaffState {
  const ChiefStaffAddPageState(
      {required this.positionsNamesList, required this.areasNamesList});

  final List<String> areasNamesList;
  final List<String> positionsNamesList;
}
