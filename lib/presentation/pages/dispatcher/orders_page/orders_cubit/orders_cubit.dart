import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/order_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/order_table.dart';
import 'package:master_plan/domain/model/order.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersState());

  final _orderTable = OrderTable();

  Future<void> fetchOrders() async {
    var fetchedOrdersList = await _orderTable.select();
    for (var fetchedOrder in fetchedOrdersList) {
      final orderDto = OrderDTO.fromMap(fetchedOrder);
      final order = Order(id: orderDto.id,
          number: orderDto.number,
          dateReceipt: orderDto.dateReceipt,
          datePlanCompletion: orderDto.datePlanCompletion,
          priority: orderDto.priority);
    }
  }
}
