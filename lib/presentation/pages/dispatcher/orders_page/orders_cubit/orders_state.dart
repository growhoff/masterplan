part of 'orders_cubit.dart';

enum OrdersStatus { initial, loading, success, failure }

final class OrdersState extends Equatable {
  const OrdersState(
      {this.ordersList = const [], this.status = OrdersStatus.initial});

  final List<Order> ordersList;
  final OrdersStatus status;

  OrdersState copyWith({List<Order>? ordersList, OrdersStatus? status}) {
    return OrdersState(
        ordersList: ordersList ?? this.ordersList,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [ordersList, status];
}
