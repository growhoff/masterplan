part of 'chief_areas_cubit.dart';

@immutable
abstract class ChiefAreasState extends Equatable {}

class ChiefRegionsInitial extends ChiefAreasState {
  @override
  List<Object?> get props => [];
}

class ChiefRegionsSuccess extends ChiefAreasState {
  ChiefRegionsSuccess({required this.areas});

  final List<Area> areas;

  @override
  List<Object?> get props => [areas];
}

class ChiefRegionsFailure extends ChiefAreasState {
  @override
  List<Object?> get props => [];
}
