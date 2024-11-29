import '../model/staff.dart';

class StaffService {
  Staff? staff;

  static final StaffService instance = StaffService._internal();

  StaffService._internal();

  factory StaffService(Staff staff) {
    instance.staff = staff;

    return instance;
  }
}
