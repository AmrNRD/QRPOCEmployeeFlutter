import 'package:QRFlutter/ui/style/app.colors.dart';
import 'package:QRFlutter/ui/style/app.dimens.dart';
import 'package:QRFlutter/utils/app.localization.dart';
import 'package:QRFlutter/utils/core.util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class ProgressCard extends StatefulWidget {
  final int checked;
  final int missed;
  final int absence;

  const ProgressCard({Key key,@required this.checked,@required this.missed,@required this.absence}) : super(key: key);
  @override
  _ProgressCardState createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  int touchedIndex;

  List<PieChartSectionData> sections;
  @override
  Widget build(BuildContext context) {
    sections = getSections( widget.checked??0, widget.missed??0,widget.absence??0);
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 200,
        child: Row(
          children: <Widget>[
            Flexible(
              child: PieChart(
                PieChartData(
                    pieTouchData: PieTouchData(
                        touchCallback: (pieTouchResponse) {
                          setState(() {
                            if (pieTouchResponse.touchInput is FlLongPressEnd || pieTouchResponse.touchInput is FlPanEnd) {
                              touchedIndex = -1;
                            } else {
                              touchedIndex = pieTouchResponse.touchedSectionIndex;
                            }
                          });
                        },
                    ),
                    borderData: FlBorderData(show: false,),

                    sectionsSpace: 0,

                    centerSpaceRadius: 20,
                    sections: sections),

              ),
            ),
            SizedBox(width: AppDimens.marginDefault20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Text(AppLocalizations.of(context).translate("monthly_progress",defaultText: "Monthly progress"),style: Theme.of(context).textTheme.headline2),
                SizedBox(height: AppDimens.marginDefault14),
              ProgressColorCard(color: AppColors.successColor,title: "days_checked",count: widget.checked),
              ProgressColorCard(color: AppColors.warningColor,title: "days_check_missed",count: widget.missed),
              ProgressColorCard(color: AppColors.failedColor,title: "days_absence",count: widget.absence),
              ],
            ),
            SizedBox(width: AppDimens.marginEdgeCase32),

          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> getSections(int daysChecked,int daysMissedChecked, int daysAbsence) {
    int total = daysChecked + daysMissedChecked+daysAbsence;
    double daysCheckedPercentage = ((daysChecked / total) * 100);
    double daysMissedCheckedPercentage = ((daysMissedChecked / total) * 100);
    double daysAbsencePercentage = ((daysAbsence / total) * 100);

    List<PieChartSectionData> list = [];
    final isDaysCheckedTouched = 0 == touchedIndex;
    final double fontDaysCheckedSize = isDaysCheckedTouched ? 25 : 16;
    final double daysCheckedRadius = isDaysCheckedTouched ? 60 : 50;

    final isDaysMissedCheckedTouched = 1 == touchedIndex;
    final double daysMissedCheckedFontSize = isDaysMissedCheckedTouched ? 25 : 16;
    final double daysMissedCheckedRadius = isDaysMissedCheckedTouched ? 60 : 50;

    final isDaysAbsenceTouched = 2 == touchedIndex;
    final double daysAbsenceTouchedFontSize = isDaysAbsenceTouched ? 25 : 16;
    final double daysAbsenceTouchedRadius = isDaysAbsenceTouched ? 60 : 50;

    list.add(PieChartSectionData(
      color: AppColors.successColor,
      value: daysCheckedPercentage,
      title: '${daysCheckedPercentage.toStringAsFixed(2)}%',
      radius: daysCheckedRadius,
      showTitle: false,
    ));
    list.add(PieChartSectionData(
      color: AppColors.warningColor,
      value: daysMissedCheckedPercentage,
      title: '${daysMissedCheckedPercentage.toStringAsFixed(2)}%',
      radius: daysMissedCheckedRadius,
      showTitle: false,
    ));
    list.add(PieChartSectionData(
      color: AppColors.failedColor,
      value: daysAbsencePercentage,
      title: '${daysAbsencePercentage.toStringAsFixed(2)}%',
      radius: daysAbsenceTouchedRadius,
      showTitle: false,
    ));
    return list;
  }
}






class ProgressColorCard extends StatelessWidget {
  const ProgressColorCard({
    Key key,@required this.title,@required this.color,@required this.count,

  }) : super(key: key);

  final String title;
  final Color color;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: color,
          ),
          width: screenAwareWidth(15, context),
          height: screenAwareSize(10,context),
          margin: EdgeInsetsDirectional.only(end: 10),
        ),
        Text(count.toString()+" "+AppLocalizations.of(context).translate(title,defaultText: title),style: Theme.of(context).textTheme.headline4,),
      ],
    );
  }
}
