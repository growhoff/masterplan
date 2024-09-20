// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:master_plan/domain/model/status.dart';

import 'batch_archive.dart';
import 'order.dart';

class Batch {
  final int id;
  final String numberRS;
  final String name;
  final int count;
  final String? number;
  final String code;
  final String technology;
  final Order? order;

  final int? batchStatusId;
  final int? orderId;
  final BatchArchive? batchArchive;
  final Status? status;
  final int? batchArchiveId;

  Batch({
    required this.id,
    required this.numberRS,
    this.number,
    required this.name,
    required this.count,
    required this.code,
    required this.technology,
    this.status,
    this.batchStatusId,
    this.order,
    this.batchArchive,

    required this.orderId,
    this.batchArchiveId,
  });

  static final empty = Batch(
      id: 0,
      numberRS: '',
      name: '',
      number: '',
      count: 0,
      code: '',
      technology: '',
      order: Order(id: 0, number: '', priority: 0, statusId: 0),

      orderId: 0);


}
