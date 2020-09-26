import 'dart:async';

import 'package:QRFlutter/data/models/attendance_model.dart';
import 'package:QRFlutter/data/repositories/attendance_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository attendanceRepository;
  AttendanceBloc(this.attendanceRepository) : super(AttendanceInitial());

  @override
  Stream<AttendanceState> mapEventToState(AttendanceEvent event) async* {
    try{
      if(event is GetAllAttendances){
          Map<String, dynamic> res=await attendanceRepository.fetchMonthAttendancesRecords();

          yield AttendancesLoaded(attendances:res['attendances'],numberOfCheckedOutDays: res['numberOfCheckedOutDays'],numberOfMissedOutDays: res['numberOfMissedOutDays'],numberOfAbsenceOutDays: res['numberOfAbsenceOutDays'],numberOfNotCompletedDays: res['numberOfNotCompletedDays']);
      }else if(event is SendQR){
        Map<String, dynamic> res=await attendanceRepository.sendQR(event.qrCode);
        yield AttendanceSentSuccessfully(attendance: res['attendance'],message: res['message']);
      }
    }catch(error){
      debugPrint("Error happened in AttendanceBloc of type ${error.runtimeType} with output ' ${error.toString()} '");
       yield AttendancesError(error.toString());
    }
  }
}
