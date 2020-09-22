import 'package:QRFlutter/bloc/attendance/attendance_bloc.dart';
import 'package:QRFlutter/ui/style/app.colors.dart';
import 'package:QRFlutter/ui/style/app.dimens.dart';
import 'package:QRFlutter/utils/app.localization.dart';
import 'package:QRFlutter/utils/date_helper.dart';
import 'package:QRFlutter/utils/delayed_animation.dart';
import 'package:QRFlutter/utils/is_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator_view/loading_indicator_view.dart';

import '../../../main.dart';
import 'components/gridview.card.component.dart';
import 'components/horizontal_calendar.component.dart';
import 'components/progress.card.component.dart';


class HomeTabPage extends StatefulWidget {
  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  int numberOfCheckedOutDays=0;
  int numberOfMissedOutDays=0;
  int numberOfNotCompletedDays=0;
  int numberOfAbsenceOutDays=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsetsDirectional.only(top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(margin:EdgeInsetsDirectional.only(start: AppDimens.marginEdgeCase24),child: Text(AppLocalizations.of(context).translate("hello")+"!",style: Theme.of(context).textTheme.headline1,textAlign: TextAlign.start)),
                Container(margin:EdgeInsetsDirectional.only(start: AppDimens.marginEdgeCase24,top: AppDimens.marginDefault4),child: Text(Root.user?.name??"",style: Theme.of(context).textTheme.headline4,textAlign: TextAlign.start)),
                BlocListener<AttendanceBloc,AttendanceState>(
                  listener: (context,state){
                    if(state is AttendanceSentSuccessfully){
                      BlocProvider.of<AttendanceBloc>(context).add(GetAllAttendances());
                    }else if(state is AttendancesLoaded){
                      setState(() {
                        numberOfCheckedOutDays=state.numberOfCheckedOutDays;
                        numberOfMissedOutDays=state.numberOfMissedOutDays;
                        numberOfAbsenceOutDays=state.numberOfAbsenceOutDays;
                        numberOfNotCompletedDays=state.numberOfNotCompletedDays;
                      });
                    }
                  },
                 child: BlocBuilder<AttendanceBloc,AttendanceState>(
                   builder: (context,state){
                     if(state is AttendancesLoading){
                       return Container(margin: EdgeInsets.all(30),alignment: Alignment.center,child: SemiCircleSpinIndicator(color: Theme.of(context).accentColor),);
                     } else if(state is AttendancesLoaded){
                       DateTime today;
                       if(DateTime.now().month==state.attendances[0].date.month)
                         today=DateTime.now();
                         else
                         today=state.attendances.last.date;

                       return  HorizontalCalendar(
                         firstDate: startOfTheMonth(state.attendances[0].date.month,state.attendances[0].date.year),lastDate: endOfTheMonth(state.attendances[0].date.month,state.attendances[0].date.year),
                         selectedDecoration: BoxDecoration(shape: BoxShape.circle,color: Theme.of(context).canvasColor),
                         labelOrder: 	[LabelType.date,LabelType.month],
                         monthTextStyle: Theme.of(context).textTheme.headline6.copyWith(fontSize: 9),
                         padding:EdgeInsets.all(AppDimens.marginSeparator8),
                         defaultDecoration:BoxDecoration(shape: BoxShape.circle,color: Theme.of(context).canvasColor),
                         spacingBetweenDates: 16,weekDayFormat: "EEEE",
                         selectedEggColor: AppColors.primaryColor,
                         eggColor: Theme.of(context).cardColor,
                         weekDayTextStyle: Theme.of(context).textTheme.headline5.copyWith(fontSize: 12),
                         selectedWeekDayTextStyle: Theme.of(context).textTheme.headline5.copyWith(fontSize: 12,color: Colors.white),
                         initialSelectedDates: [today],
                         attendanceList: state.attendances,
                       );
                     }
                     return Container();
                   },
                 ),
               ),
                SizedBox(height: AppDimens.marginSeparator16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: <Widget>[
                    ProgressCard(checked: 20,missed: 5,absence: 5),
                    GridView(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10, childAspectRatio: 0.9),
                      shrinkWrap: true,
                      primary: false,
                      children: <Widget>[
                        DelayedAnimation(child: GridViewCard(title: "checked",color: AppColors.successColor,icon: FontAwesomeIcons.solidCheckCircle,days: numberOfCheckedOutDays),delay: 200),
                        DelayedAnimation(child: GridViewCard(title: "missed",color: AppColors.simpleWarningColor,icon: FontAwesomeIcons.solidCheckCircle,days: numberOfMissedOutDays),delay:400),
                        DelayedAnimation(child: GridViewCard(title: "notCompleted",color: AppColors.warningColor,icon: FontAwesomeIcons.exclamationCircle,days: numberOfAbsenceOutDays),delay: 600),
                        DelayedAnimation(child: GridViewCard(title: "absence",color: AppColors.failedColor,icon: FontAwesomeIcons.solidTimesCircle,days: numberOfAbsenceOutDays),delay: 600),
                      ],
                    ),
                      SizedBox(height: AppDimens.marginEdgeCase32),
                    ],
                  ),

                ),
              ],
            ),
          ),
        ));
  }


}
