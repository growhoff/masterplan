// ignore_for_file: public_member_api_docs, sort_constructors_first

class Company {
  final int id;
  final String name;
  final String code;
  final bool? isPaid;
  Company({
    required this.id,
    required this.name,
    required this.code,
    this.isPaid
  });

  
  static final empty = Company(id: 0, name: '', code: '');
}
