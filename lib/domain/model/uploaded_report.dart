import 'package:master_plan/data/repositories/supabase/dto/position_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/uploaded_report_dto.dart';
import 'package:master_plan/domain/model/staff.dart';

class UploadedReport {
  UploadedReport(
      {required this.number, this.staffId, this.staff, this.reportTypeId});

  final int number;
  final int? staffId;
  final Staff? staff;
  final int? reportTypeId;

  factory UploadedReport.fromDto(UploadedReportDTO dto) {
    return UploadedReport(
        number: dto.number,
        staffId: dto.staffId,
        reportTypeId: dto.reportTypeId,
        staff: Staff.fromDTO(dto.staff ??
            StaffDTO(
                id: 0,
                login: '',
                password: '',
                fio: '',
                positionId: 0,
                position: PositionDTO(id: 0, name: ''))));
  }
}
