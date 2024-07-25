// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'batch_archive.dart';
import 'order.dart';

class Batch {
  final int id;
  final String number;
  final String name;
  final int count;
  final String code;
  final String technology;
  final Order? order;
  final bool isready;
  final int? batchStatusId;
  final int? orderId;
  final BatchArchive? batchArchive;
  final String? batchStatusName;
  final int? batchArchiveId;

  Batch({
    required this.id,
    required this.number,
    required this.name,
    required this.count,
    required this.code,
    required this.technology,
    this.batchStatusName,
    this.batchStatusId,
    this.order,
    this.batchArchive,
    required this.isready,
    required this.orderId,
    this.batchArchiveId,
  });

  static final empty = Batch(
      id: 0,
      number: '',
      name: '',
      count: 0,
      code: '',
      technology: '',
      order: Order(id: 0, number: '', priority: 0, statusId: 0),
      isready: false,
      orderId: 0);


}
