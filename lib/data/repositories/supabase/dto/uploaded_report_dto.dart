import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class UploadedReportDTO extends Dto {
  UploadedReportDTO(
      {required this.number, this.staffId, this.staff, this.reportTypeId});

  final int number;
  final int? staffId;
  final StaffDTO? staff;
  final int? reportTypeId;


  factory UploadedReportDTO.fromMap(Map<String, dynamic> map) {
    return UploadedReportDTO(
        number: map['number'],
        staffId: map['staff_id'],
      staff: map['z_staff'] != null ? StaffDTO.fromMap(map['z_staff']) : null,
      reportTypeId: map['report_type_id']
    );
  }


}
