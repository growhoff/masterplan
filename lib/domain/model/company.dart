// ignore_for_file: public_member_api_docs, sort_constructors_first

class Company {
  final int id;
  final String name;
  final String code;
  final bool? isPaid;
  final String? dateOfPayment;
  final String? paymentEndDate;
  final bool? isTestPeriod;
  final int? numberOfSupportStaff;
  Company({
    required this.id,
    required this.name,
    required this.code,
    this.isPaid,
    this.dateOfPayment,
    this.isTestPeriod,
    this.numberOfSupportStaff,
    this.paymentEndDate
  });

  
  static final empty = Company(id: 0, name: '', code: '');
}
