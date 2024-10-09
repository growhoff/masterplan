import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/order_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';

import 'package:master_plan/data/repositories/supabase/service/order_table.dart';

import 'package:master_plan/domain/model/order.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(const OrdersState()) {
    _orderTable.stream().listen((list) {
      fetchOrders(list);
    });
  }

  final _orderTable = OrderTable();

  final numberController = TextEditingController();
  final customerController = TextEditingController();
  DateTime receiptDate = DateTime.now();

  DateTime requiredCompletionDate = DateTime.now();

  final List<int> prioritiesList = [1, 2, 3, 4];

  int selectedPriority = 1;

  Future<void> fetchOrders(List<Map<String, dynamic>> fetchedOrdersList) async {
    print('фетч');
    emit(state.copyWith(status: OrdersStatus.loading, ordersList: []));
    final List<Order> ordersList = [];

    try {
      for (var fetchedOrder in fetchedOrdersList) {
        final orderDto = OrderDTO.fromMap(fetchedOrder);

        if (orderDto.statusId != 5) {
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
                  name: statusNameFromId(orderDto.statusId)));

          ordersList.add(order);
        }
      }

      emit(
          state.copyWith(status: OrdersStatus.success, ordersList: ordersList));
    } catch (e) {
      emit(state.copyWith(status: OrdersStatus.failure));
    }
  }

  Future<bool> createOrder() async {
    final fetchedOrder =
        await _orderTable.selectByNumber(numberController.text);

    if (fetchedOrder.isEmpty) {
      await _orderTable.insert(OrderDTO(
          id: 0,
          number: numberController.text,
          dateReceipt: receiptDate.toString(),
          customer: customerController.text,
          requiredCompletionDate: requiredCompletionDate.toString(),
          priority: selectedPriority,
          statusId: 1));
      return true;
    }
    return false;
  }

  Future<bool> editOrder(Order order) async {
    bool isHaveSameNumber = false;

    if (numberController.text != order.number) {
      final fetchedOrder =
      await _orderTable.selectByNumber(numberController.text);
      if (fetchedOrder.isNotEmpty) {
        isHaveSameNumber = true;
      }
    }

    if (!isHaveSameNumber) {
      await _orderTable.updateOrder(OrderDTO(
          id: order.id,
          number: numberController.text,
          dateReceipt: receiptDate.toString(),
          customer: customerController.text,
          requiredCompletionDate: requiredCompletionDate.toString(),
          priority: selectedPriority,
          statusId: 1));

      return true;
    } else {
      emit(state.copyWith(status: OrdersStatus.success));
      return false;
    }
  }

  Future initEditOrderPage(Order order) async {
    numberController.text = order.number;

    DateFormat format = DateFormat("yyyy-MM-dd");

    if (order.dateReceipt != null) {
      receiptDate = format.parse(order.dateReceipt ?? '');
    }

    if (order.requiredCompletionDate != null) {
      requiredCompletionDate = format.parse(order.requiredCompletionDate ?? '');
    }

    customerController.text = order.customer ?? '';

    selectedPriority = order.priority;
  }

  Future deleteOrder(int id) async {
    final batchTable = BatchTable();
    final chiefBatchTable = ChiefBatchTable();
    final distributionStageTable = DistributionStageTable();

    var fetchedBatchesList = await batchTable.selectByOrderId(id);

    List<int> batchesIdsList = [];
    for (var batch in fetchedBatchesList) {
      final batchDto = BatchDTO.fromMap(batch);

      batchesIdsList.add(batchDto.id);
    }

    var fetchedDistributionStagesList =
        await distributionStageTable.selectByBatchesIdsList(batchesIdsList);

    List<int> distributionStagesIdsList = [];

    for (var distributionStage in fetchedDistributionStagesList) {
      final distributionStageDto =
          DistributionStageDto.fromMap(distributionStage);
      distributionStagesIdsList.add(distributionStageDto.id);
    }

    print(distributionStagesIdsList);

    var halfList = distributionStagesIdsList
        .skip((distributionStagesIdsList.length / 2).round());

    //удаляется вторая половина всех этапов
    await distributionStageTable.bulkDeleteByIdsList(halfList.toList());

    var lastList = distributionStagesIdsList.getRange(0, halfList.length);

    //удаляется оставшаяся часть этапов
    await distributionStageTable.bulkDeleteByIdsList(lastList.toList());

    await chiefBatchTable.bulkDeleteByBatchesIdsList(batchesIdsList);

    await batchTable.deleteByIdsList(batchesIdsList);

    await _orderTable.delete(id);
  }

  String statusNameFromId(statusId) {
    String statusName = '';
    switch (statusId) {
      case 1:
        statusName = 'формируется';
      case 2:
        statusName = 'сформирован';
      case 3:
        statusName = 'выполняется';
      case 4:
        statusName = 'срыв срока';
      case 5:
        statusName = 'готов';
      case 6:
        statusName = 'отменен';
    }
    return statusName;
  }
}
