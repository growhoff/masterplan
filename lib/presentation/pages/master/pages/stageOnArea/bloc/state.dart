// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
// import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/batches_page/batch_model.dart';
import 'package:master_plan/presentation/pages/master/pages/stageOnArea/model/view_content.dart';

class StateStageOnArea extends Equatable {
  final List<StageModel> stagesList;
  final List<ViewContent> listRes;

  const StateStageOnArea({
    this.stagesList = const [],
    this.listRes = const [],
  });

  @override
  List<Object> get props => [stagesList, listRes];

  StateStageOnArea copyWith({
    List<StageModel>? stagesList,
    List<ViewContent>? listRes,
  }) {
    return StateStageOnArea(
      stagesList: stagesList ?? this.stagesList,
      listRes: listRes ?? this.listRes,
    );
  }

  @override
  bool get stringify => true;
}
