// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/model/distrib_item.dart';

class StateDistributionDetails extends Equatable {
  final List<DistribItem> pathListOper;
  final bool isLoading;
  const StateDistributionDetails({
    this.pathListOper = const [],
    this.isLoading = false
  });

  @override
  List<Object> get props => [pathListOper, isLoading];

  StateDistributionDetails copyWith({
    List<DistribItem>? operList,
    bool? isLoading,
  }) {
    return StateDistributionDetails(
      pathListOper: operList ?? this.pathListOper,
      isLoading:  isLoading ?? this.isLoading,
    );
  }

  @override
  bool get stringify => true;
}
