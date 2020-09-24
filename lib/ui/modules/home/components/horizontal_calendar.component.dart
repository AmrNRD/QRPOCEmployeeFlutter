
import 'package:QRFlutter/data/models/attendance_model.dart';
import 'package:QRFlutter/ui/style/app.colors.dart';
import 'package:QRFlutter/ui/style/theme.dart';
import 'package:QRFlutter/utils/core.util.dart';
import 'package:QRFlutter/utils/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'date_egg.component.dart';

typedef DateBuilder = bool Function(DateTime dateTime);

typedef DateSelectionCallBack = void Function(DateTime dateTime);

class HorizontalCalendar extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final double height;
  final TextStyle monthTextStyle;
  final TextStyle selectedMonthTextStyle;
  final String monthFormat;
  final TextStyle dateTextStyle;
  final TextStyle selectedDateTextStyle;
  final String dateFormat;
  final TextStyle weekDayTextStyle;
  final TextStyle selectedWeekDayTextStyle;
  final String weekDayFormat;
  final DateSelectionCallBack onDateSelected;
  final DateSelectionCallBack onDateLongTap;
  final DateSelectionCallBack onDateUnSelected;
  final VoidCallback onMaxDateSelectionReached;
  final Decoration defaultDecoration;
  final Decoration selectedDecoration;
  final Decoration disabledDecoration;
  final DateBuilder isDateDisabled;
  final List<DateTime> initialSelectedDates;
  final ScrollController scrollController;
  final double spacingBetweenDates;
  final EdgeInsetsGeometry padding;
  final List<LabelType> labelOrder;
  final int minSelectedDateCount;
  final int maxSelectedDateCount;
  final bool isLabelUppercase;
  final Color circleColor;
  final Color eggColor;
  final Color selectedEggColor;
  final List<Attendance>attendanceList;

  HorizontalCalendar({
    Key key,
    this.height = 146,
    @required this.firstDate,
    @required this.lastDate,
    this.scrollController,
    this.onDateSelected,
    this.onDateLongTap,
    this.onDateUnSelected,
    this.onMaxDateSelectionReached,
    this.minSelectedDateCount = 0,
    this.maxSelectedDateCount = 1,
    this.monthTextStyle,
    this.selectedMonthTextStyle,
    this.monthFormat,
    this.dateTextStyle,
    this.selectedDateTextStyle,
    this.dateFormat,
    this.weekDayTextStyle,
    this.selectedWeekDayTextStyle,
    this.weekDayFormat,
    this.defaultDecoration,
    this.selectedDecoration,
    this.disabledDecoration,
    this.isDateDisabled,
    this.initialSelectedDates = const [],
    this.spacingBetweenDates = 8.0,
    this.padding = const EdgeInsets.all(8.0),
    this.attendanceList,
    this.labelOrder = const [
      LabelType.month,
      LabelType.date,
      LabelType.weekday,
    ],
    this.isLabelUppercase = false, this.eggColor, this.selectedEggColor, this.circleColor,
  })  : assert(firstDate != null),
        assert(lastDate != null),
        assert(
          toDateMonthYear(lastDate) == toDateMonthYear(firstDate) ||
              toDateMonthYear(lastDate).isAfter(toDateMonthYear(firstDate)),
        ),
        assert(labelOrder != null && labelOrder.isNotEmpty,
            'Label Order should not be empty'),
        assert(minSelectedDateCount <= maxSelectedDateCount),
        assert(minSelectedDateCount <= initialSelectedDates.length,
            "You must provide at least $minSelectedDateCount initialSelectedDates"),
        assert(maxSelectedDateCount >= initialSelectedDates.length,
            "You can't provide more than $maxSelectedDateCount initialSelectedDates"),
        super(key: key);

  @override
  _HorizontalCalendarState createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  final List<DateTime> allDates = [];
  final List<DateTime> selectedDates = [];

  @override
  void initState() {
    super.initState();
    allDates.addAll(getDateList(widget.firstDate, widget.lastDate));
    selectedDates.addAll(widget.initialSelectedDates.map((toDateMonthYear)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:screenAwareSize(170, context),
      child: Center(
        child: ListView.builder(
          controller: widget.scrollController ?? ScrollController(),
          scrollDirection: Axis.horizontal,
          itemCount: allDates.length,
          itemBuilder: (context, index) {
            final date = allDates[index];
            bool set=false;
            Color iconColor=AppColors.customGreyLevels[100].withOpacity(0.6);
            IconData iconData=FontAwesomeIcons.solidCheckCircle;


            //todo:improve the algorithm when you have time (N^2)!
            for(Attendance attendance in widget.attendanceList){
              if(attendance.date.day==date.day)
                {
                  set=true;
                  iconColor=AppTheme.attendanceColor(attendance.status);
                  iconData=AppTheme.attendanceCircleIcon(attendance.status);
                  break;
                }
            }

            if(date.isBefore(DateTime.now())&&!set&&date.weekday!=6&&date.weekday!=5){
              iconColor=AppColors.failedColor;
              iconData=FontAwesomeIcons.solidTimesCircle;
            }


            return Row(
              children: <Widget>[
                DateEggShapeWidget(
                  key: Key(date.toIso8601String()),
                  padding: widget.padding,
                  isSelected: selectedDates.contains(date),
                  isDisabled: widget.isDateDisabled != null
                      ? widget.isDateDisabled(date)
                      : false,
                  date: date,
                  monthTextStyle: widget.monthTextStyle,
                  selectedMonthTextStyle: widget.selectedMonthTextStyle,
                  monthFormat: widget.monthFormat,
                  dateTextStyle: widget.dateTextStyle,
                  selectedDateTextStyle: widget.selectedDateTextStyle,
                  dateFormat: widget.dateFormat,
                  weekDayTextStyle: widget.weekDayTextStyle,
                  selectedWeekDayTextStyle: widget.selectedWeekDayTextStyle,
                  weekDayFormat: widget.weekDayFormat,
                  defaultDecoration: widget.defaultDecoration,
                  selectedDecoration: widget.selectedDecoration,
                  disabledDecoration: widget.disabledDecoration,
                  labelOrder: widget.labelOrder,
                  iconData: iconData,
                  circleColor:widget.circleColor,
                  iconColor: iconColor,
                  isLabelUppercase: widget.isLabelUppercase ?? false,
                  selectedEggColor: widget.selectedEggColor,
                  eggColor: widget.eggColor,
                  onTap: () {
                  },
                  onLongTap: () => widget.onDateLongTap != null
                      ? widget.onDateLongTap(date)
                      : null,
                ),
                SizedBox(width: widget.spacingBetweenDates),
              ],
            );
          },
        ),
      ),
    );
  }




}
