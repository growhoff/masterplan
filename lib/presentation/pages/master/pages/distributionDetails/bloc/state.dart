// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/model/distrib_item.dart';

class StateDistributionDetails extends Equatable {
  final List<DistribItem> operList;
  const StateDistributionDetails({
    this.operList = const [],
  });

  @override
  List<Object> get props => [operList];

  StateDistributionDetails copyWith({
    List<DistribItem>? operList,
  }) {
    return StateDistributionDetails(
      operList: operList ?? this.operList,
    );
  }

  @override
  bool get stringify => true;
}
