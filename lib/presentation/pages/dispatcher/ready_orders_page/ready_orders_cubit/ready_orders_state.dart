part of 'ready_orders_cubit.dart';

@immutable
sealed class ReadyOrdersState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ReadyOrdersInitial extends ReadyOrdersState {}

final class ReadyOrdersLoading extends ReadyOrdersState {}

final class ReadyOrdersSuccess extends ReadyOrdersState {

  ReadyOrdersSuccess ({required this.ordersList});

  final List<Order> ordersList;

  @override
  List<Object?> get props => [ordersList];
}
