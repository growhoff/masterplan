// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/model/distrib_item.dart';

class StateDistributionDetails extends Equatable {
  final List<DistribItem> operList;
  final bool isLoading;
  const StateDistributionDetails({
    this.operList = const [],
    this.isLoading = false
  });

  @override
  List<Object> get props => [operList, isLoading];

  StateDistributionDetails copyWith({
    List<DistribItem>? operList,
    bool? isLoading,
  }) {
    return StateDistributionDetails(
      operList: operList ?? this.operList,
      isLoading:  isLoading ?? this.isLoading,
    );
  }

  @override
  bool get stringify => true;
}
