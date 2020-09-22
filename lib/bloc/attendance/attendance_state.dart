part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendancesLoading extends AttendanceState {}


class AttendanceSentSuccessfully extends AttendanceState {
  final Attendance attendance;
  AttendanceSentSuccessfully(this.attendance);
}

class AttendancesLoaded extends AttendanceState {
  final List<Attendance> attendances;
  final int numberOfCheckedOutDays;
  final int numberOfMissedOutDays;
  final int numberOfNotCompletedDays;
  final int numberOfAbsenceOutDays;
  AttendancesLoaded({ @required this.attendances, @required this.numberOfCheckedOutDays, @required this.numberOfMissedOutDays, @required this.numberOfAbsenceOutDays, @required this.numberOfNotCompletedDays});
}

class AttendancesError extends AttendanceState {
  final String message;
  AttendancesError(this.message);
}
