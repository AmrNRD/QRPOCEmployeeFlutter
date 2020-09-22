import 'package:QRFlutter/bloc/attendance/attendance_bloc.dart';
import 'package:QRFlutter/data/repositories/attendance_repository.dart';
import 'package:QRFlutter/data/repositories/settings_repositoy.dart';
import 'package:QRFlutter/ui/style/app.fonts.dart';
import 'package:QRFlutter/ui/style/theme.dart';
import 'package:QRFlutter/utils/app.localization.dart';
import 'package:QRFlutter/utils/core.util.dart';
import 'package:QRFlutter/utils/route_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app.dart';
import 'bloc/settings/settings_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'data/models/user_model.dart';
import 'data/repositories/user_repository.dart';
import 'env.dart';

void main() => runApp(Root());

class Root extends StatefulWidget {
  // This widget is the root of your application.
  static String fontFamily;
  static Locale locale;
  static ThemeMode themeMode=ThemeMode.system;
  static User user;


  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  bool localeLoaded = false;
  SettingsBloc settingsBloc;

  @override
  void initState() {
    super.initState();
    settingsBloc=SettingsBloc(SettingsDataRepository());
    settingsBloc.add(LoadSettings());
    Root.fontFamily = AppFonts.fontSF;

  }

  changeFont(Locale locale){
    if(locale.languageCode=="ar")
      setState(() {
        Root.fontFamily = AppFonts.fontTajawal;
      });
    else
      setState(() {
        Root.fontFamily = AppFonts.fontSF;
      });
  }




  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (BuildContext context) => UserBloc(UserDataRepository())),
        BlocProvider<SettingsBloc>(create: (BuildContext context) => settingsBloc),
        BlocProvider<AttendanceBloc>(create: (BuildContext context) => AttendanceBloc(AttendanceDataRepository())),
      ],
      child: BlocListener<SettingsBloc,SettingsState>(
        listener: (context,state){
          if (state is SettingsLoaded) {
            setState(() {
              Root.themeMode=state.themeMode;
              Root.locale=state.locale;
              changeFont(Root.locale);
            });
          }else if (state is LocalLoaded) {
            setState(() {
              Root.locale=state.locale;
              changeFont(Root.locale);
            });
          }else if (state is ThemeModeLoaded) {
            setState(() {
              Root.themeMode=state.themeMode;
            });
          }
        },
        child: MaterialApp(
          title: Env.appName,
          supportedLocales: application.supportedLocales(),
          builder: (context, child) {
            return ScrollConfiguration(behavior: CustomScrollBehavior(), child: child);
          },
          theme: AppTheme(Root.fontFamily).lightModeTheme,
          darkTheme: AppTheme(Root.fontFamily).darkModeTheme,
          localizationsDelegates: [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode && supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          locale: Root.locale,
          debugShowCheckedModeBanner: false,
          themeMode: Root.themeMode,
          onGenerateRoute: RouteGenerator().generateRoute,
        ),
      ),
    );
  }
}
