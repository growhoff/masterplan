import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:master_plan/data/repositories/supabase/dto/order_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/order_table.dart';
import 'package:master_plan/domain/model/order.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(const OrdersState());

  final _orderTable = OrderTable();
  final numberController = TextEditingController();
  DateTime receiptDate = DateTime.now();

  DateTime planCompletionDate = DateTime.now();

  final List<int> prioritiesList = [1, 2, 3, 4];

  int selectedPriority = 1;

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
            priority: orderDto.priority,
            statusId: orderDto.statusId,
            status: OrderStatus(
                id: orderDto.status?.id ?? 0,
                name: orderDto.status?.name ?? ''));

        print(order.status?.name);
        ordersList.add(order);
      }

      emit(
          state.copyWith(status: OrdersStatus.success, ordersList: ordersList));
    } catch (e) {
      emit(state.copyWith(status: OrdersStatus.failure));
    }
  }

  Future<void> createOrder() async {
    await _orderTable.insert(OrderDTO(
        id: 0,
        number: numberController.text,
        dateReceipt: receiptDate.toString(),
        datePlanCompletion: planCompletionDate.toString(),
        priority: selectedPriority,
        statusId: 1));
  }

  Future deleteOrder(int id) async {
    await _orderTable.delete(id);
  }
}
