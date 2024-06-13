// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/model/distrib_item.dart';

class StateDistributionDetailsChMas extends Equatable {
  final List<DistribItem> pathListOper;
  final bool isLoading;
  const StateDistributionDetailsChMas({
    this.pathListOper = const [],
    this.isLoading = false
  });

  @override
  List<Object> get props => [pathListOper, isLoading];

  StateDistributionDetailsChMas copyWith({
    List<DistribItem>? operList,
    bool? isLoading,
  }) {
    return StateDistributionDetailsChMas(
      pathListOper: operList ?? this.pathListOper,
      isLoading:  isLoading ?? this.isLoading,
    );
  }

  @override
  bool get stringify => true;
}
