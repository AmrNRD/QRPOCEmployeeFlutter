import 'package:flutter/material.dart';

import 'app.localization.dart';

class Validator {

  static const _emailRegEx =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  var _password;
  var _email;
  var field;

  final BuildContext context;

  Validator(this.context) {
    if (AppLocalizations.of(context).currentLanguage == "ar") {
      //todo:translate
      field = AppLocalizations.of(context).translate("field");
    } else {
      field = "";
    }
  }


  String isEmail(String value) {
    bool check = RegExp(_emailRegEx).hasMatch(value);
    if (check) {
      _email = value;
      return null;
    } else {
      //todo:translate
      return AppLocalizations.of(context).translate("log_in_error_email",defaultText: "Please enter valid email");
    }
  }

  bool isEmailBoolCheck(String value) {
    bool check = RegExp(_emailRegEx).hasMatch(value);
    return check;
  }

  isReEmail(String value) {
    if (value == null || value.length == 0) {
      //todo:translate
      return AppLocalizations.of(context).translate("register_re_email_error");
    } else {
      if (_email == value) {
        return null;
      } else {
        //todo:translate
        return AppLocalizations.of(context)
            .translate("register_re_email_mismatch");
      }
    }
  }

  isValidPassword(value) {
    if (value == null || value.length == 0) {
      //todo:translate
      return AppLocalizations.of(context).translate("password_error_empty",defaultText: "Please fill the password");
    } else {
      _password = value;
      return null;
    }
  }

  isValidRePassword(value) {
    if (value == null || value.length == 0) {
      //todo:translate
      return AppLocalizations.of(context).translate("re_password_error_empty");
    } else {
      if (_password == value) {
        return null;
      } else {
        //todo:translate
        return AppLocalizations.of(context).translate("re_password_mismatch",defaultText: "Password dose not match");
      }
    }
  }

  isEmpty(String value, String type) {
    if (value == null || value.length == 0) {
      //todo:translate
      return "$field $type ${AppLocalizations.of(context).translate("missing_data")}";
    }
    return null;
  }


}
