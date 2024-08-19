// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/dto/batch_archive_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/order_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class BatchDTO extends Dto {
  final int id;
  final String numberRS;
  final String number;
  final String name;
  final int count;
  final String code;
  final String technology;
  final OrderDTO? order;
  final bool isready;
  final int? orderId;
  final int? companyId;

  final int? batchStatusId;
  final StatusDTO? status;
  final String? description;

  BatchDTO({
    required this.id,
    required this.numberRS,
    required this.number,
    required this.name,
    required this.count,
    required this.code,
    required this.technology,
    required this.isready,
    this.description,
    this.status,

    this.batchStatusId,
    this.order,

    this.orderId,
    this.companyId,
  });

  static final empty = BatchDTO(
    id: 0,
    numberRS: '',
    name: '',
    number: '',
    count: 0,
    code: '',
    order: OrderDTO(id: 0, number: '', priority: 0, statusId: 0),
    technology: '',
    isready: false,
    orderId: 0,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': numberRS,
      'name': name,
      'count': count,
      'code': code,
      'technology': technology,
      'isready': isready,
      'order_id': orderId,
    };
  }

  factory BatchDTO.fromMap(Map<String, dynamic> map) {
    return BatchDTO(
        id: map['id'] as int,
        numberRS: map['rs_number'] as String,
        number: map['number'],
        name: map['name'] as String,
        count: map['count'] as int,
        status: map['z_batch_status'] != null
            ? StatusDTO.fromMap(map['z_batch_status'])
            : null,
        code: map['code'] as String,
        order: map['z_order'] != null ? OrderDTO.fromMap(map['z_order']) : null,
        technology: map['technology'] as String,
        isready: map['isready'] as bool,
        orderId: map['order_id'] != null ? map['order_id'] as int : null,
        companyId: map['company_id'],

        description: map['description'],
        batchStatusId: map['batch_status_id'],
       );
  }

  String toJson() => json.encode(toMap());

  factory BatchDTO.fromJson(String source) =>
      BatchDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
