part of 'chief_areas_cubit.dart';

@immutable
abstract class ChiefAreasState extends Equatable {}

class ChiefRegionsInitial extends ChiefAreasState {
  @override
  List<Object?> get props => [];
}

class ChiefRegionsSuccess extends ChiefAreasState {
  ChiefRegionsSuccess({required this.regions});

  final List<ZArea> regions;

  @override
  List<Object?> get props => [regions];
}

class ChiefRegionsFailure extends ChiefAreasState {
  @override
  List<Object?> get props => [];
}
