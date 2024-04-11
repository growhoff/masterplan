part of 'chief_check_cubit.dart';

class ChiefCheckState extends Equatable{

  ChiefCheckState({this.stagesList = const []});

  final List<StageModel> stagesList;

  @override
  List<Object?> get props => [stagesList];

}