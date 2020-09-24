
import 'dart:io';

import 'package:QRFlutter/bloc/user/user_bloc.dart';
import 'package:QRFlutter/ui/common/custom_raised_button.dart';
import 'package:QRFlutter/ui/common/form.input.dart';
import 'package:QRFlutter/utils/validators.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../env.dart';
import '../../../../utils/app.localization.dart';
import '../../../../utils/core.util.dart';
import '../../../style/app.colors.dart';
import '../../../style/app.dimens.dart';

class LoginScreen extends StatefulWidget {
  final Function goToForgotPassword;

  const LoginScreen({Key key,@required this.goToForgotPassword}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String platform;
  FirebaseMessaging firebaseMessaging;
  String firebaseToken;


  bool _obscureTextLogin = true;

  final GlobalKey<FormState> _formKey = GlobalKey();


  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;

  int reqStatus=0;

  Map<String, String> _authData = {'email': '', 'password': ''};

  @override
  void initState() {
    platform = Platform.isIOS ? "IOS" : "Android";
    firebaseToken = "";
    firebaseMessaging = new FirebaseMessaging();
    firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      firebaseToken = token;
    });

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) async {
        if (state is UserLoading) {
          setState(() {reqStatus = 1;});
        } else if (state is UserLoaded) {
          setState(() {reqStatus= 2;});
          Navigator.of(context).pushReplacementNamed(Env.homePage);
        } else if (state is UserError) {
          setState(() {reqStatus = 0;});
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(state.message, style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),),
            backgroundColor: AppColors.accentColor1,
          ));
        }
      },
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.marginEdgeCase24),
          margin: EdgeInsets.only(top: AppDimens.paddingEdgeCase40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 138),
                  child: Hero(tag: "Logo", child: SvgPicture.asset("assets/images/logo.svg",height: screenAwareSize(48, context),width: screenAwareWidth(48, context))),
                ),

                SizedBox(height: AppDimens.marginDefault12),

                Text(AppLocalizations.of(context).translate("welcome"), style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 25, fontWeight: FontWeight.bold)),

                Padding(
                  padding: const EdgeInsets.only(top: AppDimens.marginDefault4),
                  child: Text(AppLocalizations.of(context).translate("please_sign_in_to_continue"), style: Theme.of(context).textTheme.subtitle1),
                ),

                SizedBox(height: AppDimens.marginEdgeCase24),

                //email
                FormInputField(title: "email", focusNode: _emailFocusNode, onSave: (value) => _authData['email'] = value,validator:(value)=>Validator(context).isEmail(value) ,nextFocusNode: _passwordFocusNode, prefixIcon: PrefixIcon(iconData: FontAwesomeIcons.user)),

                //password
                FormInputField(
                  title: "password",
                  focusNode: _passwordFocusNode,
                  onSave: (value) => _authData['password'] = value,
                  isRequired: true,
                  obscureText: _obscureTextLogin,
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() {_obscureTextLogin = !_obscureTextLogin;}),
                    child: Icon(_obscureTextLogin ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye, size: 15.0, color: Colors.grey)
                  ),
                  prefixIcon: PrefixIcon(iconData: FontAwesomeIcons.unlock)
                ),
                SizedBox(height: AppDimens.marginEdgeCase32),
                Center(child: CustomRaisedButton(label: AppLocalizations.of(context).translate("sign_in"), onPress: onLogin, isLoading: reqStatus == 1)),
                Center(child: FlatButton(onPressed: widget.goToForgotPassword, child: Text(AppLocalizations.of(context).translate("forget"), style: Theme.of(context).textTheme.subtitle1))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onLogin() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      BlocProvider.of<UserBloc>(context)..add(LoginUser(_authData['email'], _authData['password'], firebaseToken, platform));
    }
  }

  void onSkip(){
    Navigator.pushReplacementNamed(context, Env.homePage);
  }



}

class PrefixIcon extends StatelessWidget {
  const PrefixIcon({
    Key key,
    @required this.iconData,
  }) : super(key: key);
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColorDark,
        borderRadius: BorderRadius.circular(12),
      ),
      height: screenAwareSize(48, context),
      width: screenAwareSize(38, context),
      child: Icon(iconData,color: AppColors.white),
    );
  }
}
