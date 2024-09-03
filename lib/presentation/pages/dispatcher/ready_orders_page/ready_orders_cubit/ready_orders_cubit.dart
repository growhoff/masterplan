import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/order_table.dart';
import 'package:meta/meta.dart';

import '../../../../../data/repositories/supabase/dto/order_dto.dart';
import '../../../../../domain/model/order.dart';

part 'ready_orders_state.dart';

class ReadyOrdersCubit extends Cubit<ReadyOrdersState> {
  ReadyOrdersCubit() : super(ReadyOrdersInitial());

  final _distributionStageTable = DistributionStageTable();
  final _orderTable = OrderTable();

  Future fetchReadyOrders() async {
    final List<Order> ordersList = [];

    var fetchedOrdersList = await _orderTable.selectReadyOrders();

    try {
      for (var fetchedOrder in fetchedOrdersList) {
        final orderDto = OrderDTO.fromMap(fetchedOrder);

        final order = Order(
            id: orderDto.id,
            number: orderDto.number,
            dateReceipt: orderDto.dateReceipt,
            requiredCompletionDate: orderDto.requiredCompletionDate,
            calculatedCompletionDate: orderDto.calculatedCompletionDate,
            actualCompletionDate: orderDto.actualCompletionDate,
            customer: orderDto.customer,
            priority: orderDto.priority,
            statusId: orderDto.statusId,
            status: OrderStatus(
                id: orderDto.status?.id ?? 0,
                name: orderDto.status?.name ?? ''));

        ordersList.add(order);
      }



      emit(ReadyOrdersSuccess(ordersList: ordersList));
    } catch (e) {}
  }
}
