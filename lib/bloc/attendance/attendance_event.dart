part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceEvent {}

class GetAllAttendances extends AttendanceEvent{
  GetAllAttendances();
}

class SendQR extends AttendanceEvent{
  final String qrCode;
  SendQR(this.qrCode);
}
