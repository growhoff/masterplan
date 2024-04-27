part of 'chief_machine_cubit.dart';

final class ChiefMachineState extends Equatable {
  const ChiefMachineState(
      {this.machinesList = const [],
      this.areasList = const [],
      this.areasNamesList = const [],
      this.isNeedUpdate = false});

  final List<Machine> machinesList;
  final List<Area> areasList;
  final List<String> areasNamesList;
  final bool isNeedUpdate;

  ChiefMachineState copyWith(
      {List<Machine>? machinesList,
      List<Area>? areasList,
      List<String>? areasNamesList,
      bool isNeedUpdate = false}) {
    return ChiefMachineState(
      machinesList: machinesList ?? this.machinesList,
      areasList: areasList ?? this.areasList,
      areasNamesList: areasNamesList ?? this.areasNamesList,
      isNeedUpdate: isNeedUpdate
    );
  }

  @override
  List<Object?> get props => [machinesList, areasList, areasNamesList];
}
