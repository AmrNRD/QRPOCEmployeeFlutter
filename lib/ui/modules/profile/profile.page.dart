import 'package:QRFlutter/ui/modules/profile/components/profile.settings.button.component.dart';
import 'package:QRFlutter/ui/modules/profile/components/profile.tag.component.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsetsDirectional.only(top: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ProfileTagComponent(user: Root.user),
              Divider(thickness: 1),
              SettingsButtonComponent(),
            ],
          ),
        ),
      ),
    );
  }
}
