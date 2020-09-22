import 'package:QRFlutter/ui/style/app.dimens.dart';
import 'package:QRFlutter/utils/app.localization.dart';
import 'package:QRFlutter/utils/core.util.dart';
import 'package:flutter/material.dart';

class GridViewCard extends StatelessWidget {
  final String title;
  final int days;
  final IconData icon;
  final Color color;

  const GridViewCard({Key key,@required this.title,@required this.days,@required this.icon,@required this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: screenAwareWidth(156, context),
        padding: EdgeInsets.all(AppDimens.marginEdgeCase24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(child: Text(AppLocalizations.of(context).translate(title,defaultText: title),style: Theme.of(context).textTheme.headline2,)),
            SizedBox(width: AppDimens.marginDefault6),
            Text(days.toString()+" "+AppLocalizations.of(context).translate("days",defaultText: "days"),style: Theme.of(context).textTheme.subtitle1,),
            Container(
              margin: EdgeInsetsDirectional.only(top: AppDimens.marginEdgeCase24),
              child: Stack(
                children: <Widget>[
                  Container(decoration: BoxDecoration(color: color.withOpacity(.25),borderRadius: BorderRadius.circular(6)),height: 32,width: 32,margin: EdgeInsets.all(8)),
                  Positioned(right: 0,child: Icon(icon,color: color,size: 24)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
