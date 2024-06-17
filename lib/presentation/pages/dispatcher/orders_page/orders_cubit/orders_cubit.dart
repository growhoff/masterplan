import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/order_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/order_table.dart';
import 'package:master_plan/domain/model/order.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(const OrdersState());

  final _orderTable = OrderTable();

  Future<void> fetchOrders() async {
    final List<Order> ordersList = [];

    try {
      var fetchedOrdersList = await _orderTable.select();
      for (var fetchedOrder in fetchedOrdersList) {
        final orderDto = OrderDTO.fromMap(fetchedOrder);
        final order = Order(
            id: orderDto.id,
            number: orderDto.number,
            dateReceipt: orderDto.dateReceipt,
            datePlanCompletion: orderDto.datePlanCompletion,
            priority: orderDto.priority);
        ordersList.add(order);
      }

      emit(
          state.copyWith(status: OrdersStatus.success, ordersList: ordersList));
    } catch (e) {
      emit(state.copyWith(status: OrdersStatus.failure));
    }
  }
}
