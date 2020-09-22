
import 'package:QRFlutter/data/models/attendance_model.dart';
import 'package:QRFlutter/data/sources/remote/base/api_caller.dart';

abstract class AttendanceRepository{
  Future<Map<String,dynamic>> fetchMonthAttendancesRecords();
  Future<Attendance> sendQR(String qrCode);
}

class AttendanceDataRepository extends AttendanceRepository{
  @override
  Future<Map<String, dynamic>> fetchMonthAttendancesRecords() async{
    final extractedData = await APICaller.getData("/attendances-month-records", authorizedHeader: true);

    List<Attendance> loadedAttendance = [];
    for (int i = 0; i < extractedData['attendances'].length; i++) {
      var attendanceData = extractedData['attendances'][i];
      loadedAttendance.add(Attendance.fromJson(attendanceData));
    }

    Map result={};
    result['attendances']=loadedAttendance;
    result['numberOfCheckedOutDays']=extractedData['number_of_checked_out_days'];
    result['numberOfMissedOutDays']=extractedData['number_of_missed_out_days'];
    result['numberOfAbsenceOutDays']=extractedData['number_of_absence_out_days'];
    result['numberOfNotCompletedDays']=extractedData['number_of_not_completed_days'];

    return result;
  }

  @override
  Future<Attendance> sendQR(String qrCode) async{
    final extractedData = await APICaller.postData("/register-attendance/qr",body: {"qr_code":qrCode}, authorizedHeader: true);
    Attendance attendance=Attendance.fromJson(extractedData);
    return attendance;
  }
}