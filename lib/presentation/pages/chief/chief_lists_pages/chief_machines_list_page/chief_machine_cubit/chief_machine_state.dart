part of 'chief_machine_cubit.dart';

final class ChiefMachineState extends Equatable {
  const ChiefMachineState({
    this.machinesList = const [],
    this.areasList = const [],
    this.areasNamesList = const [],
    this.isNeedUpdate = false,
    this.listView = const [],
    this.listControl = const [],
    this.listType = const [],
    this.listShiftSch = const [],
    });

  final List<Machine> machinesList;
  final List<Area> areasList;
  final List<String> areasNamesList;
  final bool isNeedUpdate;
  final List<NameIndex> listView;
  final List<NameIndex> listControl;
  final List<NameIndex> listType;
  final List<NameIndex> listShiftSch;

  ChiefMachineState copyWith({
    List<Machine>? machinesList,
    List<Area>? areasList,
    List<String>? areasNamesList,
    bool isNeedUpdate = false,
    List<NameIndex>? listView,
    List<NameIndex>? listControl,
    List<NameIndex>? listType,
    List<NameIndex>? listShiftSch,
    }){
    return ChiefMachineState(
      machinesList: machinesList ?? this.machinesList,
      areasList: areasList ?? this.areasList,
      areasNamesList: areasNamesList ?? this.areasNamesList,
      isNeedUpdate: isNeedUpdate,
      listView: listView ?? this.listView,
      listControl: listControl ?? this.listControl,
      listType: listType ?? this.listType,
      listShiftSch: listShiftSch ?? this.listShiftSch,
    );
  }

  @override
  List<Object?> get props => [machinesList, areasList, areasNamesList];
}
