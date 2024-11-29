// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class CompanyDTO extends Dto {
  final int id;
  final String name;
  final String code;
  final bool? isPaid;
  final String? dateOfPayment;
  final String? paymentEndDate;
  final bool? isTestPeriod;
  final int? numberOfSupportStaff;

  CompanyDTO(
      {required this.id,
      required this.name,
      required this.code,
      this.isPaid,
      this.dateOfPayment,
      this.isTestPeriod,
      this.numberOfSupportStaff,
      this.paymentEndDate});

  CompanyDTO.init(
      {this.id = 0,
      this.name = '0',
      this.code = '0',
      this.isPaid = true,
      this.numberOfSupportStaff = 0,
      this.paymentEndDate = '',
      this.isTestPeriod = false,
      this.dateOfPayment = ''});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
    };
  }

  factory CompanyDTO.fromMap(Map<String, dynamic> map) {
    return CompanyDTO(
        id: map['id'] as int,
        name: map['name'] as String,
        code: map['code'] as String,
        isPaid: map['is_paid'],
        dateOfPayment: map['date_of_payment'],
        paymentEndDate: map['payment_end_date'],
        isTestPeriod: map['is_test_period'],
        numberOfSupportStaff: map['number_of_support_staff']);
  }

  String toJson() => json.encode(toMap());

  factory CompanyDTO.fromJson(String source) =>
      CompanyDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
