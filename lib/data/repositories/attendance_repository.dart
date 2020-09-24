
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

    Map<String, dynamic> result={};
    result['attendances']=loadedAttendance;
    result['numberOfCheckedOutDays']=extractedData['number_of_checked_out_days'];
    result['numberOfMissedOutDays']=extractedData['number_of_missed_days'];
    result['numberOfAbsenceOutDays']=extractedData['number_of_absented_days'];
    result['numberOfNotCompletedDays']=extractedData['number_of_work_hours_not_completed_days'];

    return result;
  }

  @override
  Future<Attendance> sendQR(String qrCode) async{
    String filteredQrCode=qrCode.substring(0,qrCode.length-6);
    final extractedData = await APICaller.postData("/register-attendance/qr",body: {"qr_code":filteredQrCode}, authorizedHeader: true);
    Attendance attendance=Attendance.fromJson(extractedData);
    return attendance;
  }
}