import 'package:QRFlutter/ui/style/app.dimens.dart';
import 'package:QRFlutter/utils/core.util.dart';
import 'package:QRFlutter/utils/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';

class DateEggShapeWidget extends StatelessWidget {
  final defaultDateFormat = 'dd';
  final defaultMonthFormat = 'MMM';
  final defaultWeekDayFormat = 'EEE';

  final DateTime date;
  final TextStyle monthTextStyle;
  final TextStyle selectedMonthTextStyle;
  final String monthFormat;
  final TextStyle dateTextStyle;
  final TextStyle selectedDateTextStyle;
  final String dateFormat;
  final TextStyle weekDayTextStyle;
  final TextStyle selectedWeekDayTextStyle;
  final String weekDayFormat;
  final VoidCallback onTap;
  final VoidCallback onLongTap;
  final Decoration defaultDecoration;
  final Decoration selectedDecoration;
  final Decoration disabledDecoration;
  final bool isSelected;
  final bool isDisabled;
  final EdgeInsetsGeometry padding;
  final List<LabelType> labelOrder;
  final bool isLabelUppercase;
  final IconData iconData;
  final Color iconColor;
  final Color eggColor;
  final Color selectedEggColor;
  final Color circleColor;

  const DateEggShapeWidget({
    Key key,
    @required this.date,
    this.onTap,
    this.onLongTap,
    this.isSelected = false,
    this.isDisabled = false,
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
    this.selectedDecoration = const BoxDecoration(color: Colors.cyan),
    this.disabledDecoration = const BoxDecoration(color: Colors.grey),
    this.padding,
    this.labelOrder,
    this.isLabelUppercase = false, this.iconData, this.iconColor,
    this.eggColor,
    this.selectedEggColor, this.circleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6;
    final subTitleStyle = Theme.of(context).textTheme.subtitle2;

    final monthStyle = isSelected
        ? selectedMonthTextStyle ?? monthTextStyle ?? subTitleStyle
        : monthTextStyle ?? subTitleStyle;
    final dateStyle = isSelected
        ? selectedDateTextStyle ?? dateTextStyle ?? titleStyle
        : dateTextStyle ?? titleStyle;
    final dayStyle = isSelected
        ? selectedWeekDayTextStyle ?? weekDayTextStyle ?? subTitleStyle
        : weekDayTextStyle ?? subTitleStyle;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      onLongPress: isDisabled ? null : onLongTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.5),
        ),
        color: isSelected?selectedEggColor:eggColor,
        child: Column(
          children: <Widget>[
            Container(
              width: screenAwareWidth(60, context),
              decoration: isSelected
                  ? selectedDecoration
                  : isDisabled ? disabledDecoration : defaultDecoration,
              padding: EdgeInsets.all(15),
              margin: padding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ...labelOrder.map((type) {
                    Text text;
                    switch (type) {
                      case LabelType.month:
                        text = Text(
                          isLabelUppercase
                              ? _monthLabel().toUpperCase()
                              : _monthLabel(),
                          style: monthStyle,
                        );
                        break;
                      case LabelType.date:
                        text = Text(
                          DateFormat(dateFormat ?? defaultDateFormat,Root.locale.languageCode).format(date),
                          style: dateStyle,
                        );
                        break;
                      case LabelType.weekday:

                        break;
                    }
                    return text;
                  }).toList()
                ],
              ),
            ),
            Container(
              width: screenAwareWidth(60, context),
              alignment: Alignment.center,
              child: Text(
              isLabelUppercase
                  ? _weekDayLabel().toUpperCase()
                  : _weekDayLabel(),
              style: dayStyle,
            ),
            ),
           Container(
             margin: EdgeInsets.only(top: AppDimens.marginDefault8),
             child: Icon(iconData,color: iconColor,size: 16),
           ),
            SizedBox(height: AppDimens.marginDefault16,)
          ],
        ),
      ),
    );
  }

  String _monthLabel() {
    return DateFormat(monthFormat ?? defaultMonthFormat,Root.locale.languageCode).format(date);
  }

  String _weekDayLabel() {
    return DateFormat(weekDayFormat ?? defaultWeekDayFormat,Root.locale.languageCode).format(date);
  }
}
