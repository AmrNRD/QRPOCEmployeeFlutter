

import 'package:flutter/material.dart';

class Attendance {
  final int id;
  final String status;
  final DateTime date;
  final String checkIn;
  final String checkOut;

  Attendance({
    @required this.id,
    @required this.status,
    @required this.date,
    @required this.checkIn,
    @required this.checkOut,
  });

  factory Attendance.fromJson(Map<String, dynamic> data) {
    return Attendance(
        //This will be used to convert JSON objects that
        //are coming from querying the database and converting
        //it into a Attendance object
        id:data['id'],
        status: data['status'],
        date: DateTime.tryParse(data['date']),
        checkIn: data['check_in'],
        checkOut: data['check_out']
      );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'date': date,
    'check_in':checkIn,
    'check_out':checkOut,
      
  };


}
