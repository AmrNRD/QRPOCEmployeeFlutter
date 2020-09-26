import 'dart:async';
import 'dart:math' as math show sin, pi,sqrt;

import 'package:QRFlutter/bloc/attendance/attendance_bloc.dart';
import 'package:QRFlutter/data/repositories/attendance_repository.dart';
import 'package:QRFlutter/ui/style/app.colors.dart';
import 'package:QRFlutter/ui/style/theme.dart';
import 'package:QRFlutter/utils/app.localization.dart';
import 'package:QRFlutter/utils/core.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with TickerProviderStateMixin{
  AnimationController _controller;
  String _qrCode;
  String status="pending";
  int reqStatus=0;

  AttendanceBloc attendanceBloc;

  @override
  void initState() {
    super.initState();
    attendanceBloc=AttendanceBloc(AttendanceDataRepository());
    _controller = AnimationController(lowerBound: 0.5, duration: Duration(seconds: 3), vsync: this)..repeat()..reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsetsDirectional.only(top: 50,start: 10,end: 10),
        child: BlocProvider<AttendanceBloc>(
          create:(context)=> attendanceBloc,
          child: BlocListener<AttendanceBloc,AttendanceState>(
          listener: (context,state){
            if(state is AttendanceSentSuccessfully){
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(state.message, style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white)),
                backgroundColor: AppColors.successColor,
              ));
              setState(() {
                status=state.attendance.status;
              });
              Vibrate.feedback(FeedbackType.heavy);
              Duration _duration = new Duration(seconds: 3);
              Timer(_duration, goBack);
            }else if(state is AttendancesError){
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(state.message, style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white)),
                backgroundColor: AppColors.failedColor,
              ));
              Duration _duration = new Duration(seconds: 1);
              Timer(_duration, goBack);
            }
          },
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap:() =>  Navigator.pop(context),
                          child: Container(
                            height: 60,
                            width: 60,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child:  SizedBox(height: 30, width: 30, child: Icon(FontAwesomeIcons.times)),
                          ),
                        ),
                      ),
                      Expanded(flex: 9,child: Text(AppLocalizations.of(context).translate("qr_scanning",defaultText: "QR Scanning"),style:Theme.of(context).textTheme.headline1,textAlign: TextAlign.center,)),
                      Flexible(flex:1,child: Container(color: Colors.transparent))
                    ],
                  ),
                  SizedBox(height: screenAwareSize(84, context)),
                  Text(AppLocalizations.of(context).translate("place_the_qr_code_inside_area",defaultText: "Place the QR code inside area"),style:Theme.of(context).textTheme.headline2,textAlign: TextAlign.center),
                  SizedBox(height: screenAwareSize(30, context)),
                  Center(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 246,
                          width: 246,
                          alignment: Alignment.center,
                          child: QRBarScannerCamera(
                            onError: (context, error) => Text(error.toString(),
                                style: TextStyle(color: Colors.red)),
                            qrCodeCallback: (code) => _qrCallback(code),

                          ),
                        ),
                        SvgPicture.asset("assets/images/qr-window.svg"),
                      ],
                    ),
                  ),

                ],
              ),
              AnimatedBuilder(
                  animation: CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
                  builder: (context, child) {
                return Positioned(
                  bottom: 5,
                  right: 0,
                  left: 0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Wave(animationValue: _controller.value,status: status,size: 80),
                      Wave(animationValue: _controller.value,status: status,size: 80),
                      Wave(animationValue: _controller.value,status: status,size:120),
                      Wave(animationValue: _controller.value,status: status,size:160),
                      Wave(animationValue: _controller.value,status: status,size:200),
                      FloatingActionButton(heroTag: "scanButton",onPressed: null,child: Icon(AppTheme.attendanceIcon(status),color: AppColors.white),backgroundColor: AppTheme.attendanceColor(status))
                    ],
                  ),
                );
            }),
            ],
          ),
      ),
        ),
    ),
    );
  }


  _qrCallback(String code) {
    if(reqStatus==0) {
      attendanceBloc.add(SendQR(code));
    setState(() {
      reqStatus=1;
    });
    }
  }

  goBack(){
    Navigator.pop(context);
  }

}


class Wave extends StatelessWidget {
  final String status;
  final double animationValue;
  final double size;
  const Wave({Key key,@required this.status,@required this.animationValue,@required this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color:AppTheme.attendanceColor(status).withOpacity(1 - animationValue)));
  }
}






class CurveWave extends Curve {
  const CurveWave();
  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter(
      this._animation, {
        @required this.color,
      }) : super(repaint: _animation);
  final Color color;
  final Animation<double> _animation;
  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final Color _color = color.withOpacity(opacity);
    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);
    final Paint paint = Paint()..color = _color;
    canvas.drawCircle(rect.center, radius, paint);
  }
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }
  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}