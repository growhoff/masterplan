part of 'monitoring_cubit.dart';


class MonitoringState extends Equatable {
  final List<ElementBarModel>? listBar;
  const MonitoringState({
    this.listBar = const[],
  });

  @override
  List<Object> get props => [listBar ?? []];

  MonitoringState copyWith({
    List<ElementBarModel>? listBar,
  }) {
    return MonitoringState(
      listBar: listBar ?? this.listBar,
    );
  }

  @override
  bool get stringify => true;
}
