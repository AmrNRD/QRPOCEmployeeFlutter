import "dart:async";
import "dart:convert";
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../env.dart';
import 'app.exceptions.dart';



class APICaller {
  static  Map<String, String> get headers {
    return {"Content-Type": "application/json", "Accept": "application/json"};
  }

 static Future<Map<String, String>> authorizedHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": token,
    };
  }

  static Future<dynamic> getData(String urlExtension, {bool authorizedHeader = false}) async {
    Map<String, String> headers;
    if (authorizedHeader) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": token,
      };
    } else {
      headers = APICaller.headers;
    }
    try {


      final res = await http.get(Env.baseUrl + urlExtension, headers: headers).timeout(const Duration(seconds: 10), onTimeout: () {
        throw RequestTimeOutException("Poor internet or no internet connectivity");
      });
      var dataRetrived = returnResponse(res);
      return dataRetrived;
    } on SocketException {
      return [];
    }
  }

  static Future<dynamic> postData(String urlExtension, {Map body, bool authorizedHeader = false}) async {
    Map<String, String> headers;
    if (authorizedHeader) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": token,
      };
    } else {
      headers = APICaller.headers;
    }

    if (body == null) {
      body = {};
    }

    final res = await http.post(Env.baseUrl + urlExtension, headers: headers, body: json.encode(body));
    var dataRetrived = returnResponse(res);
    return dataRetrived;
  }

  static Future<dynamic> putData(String urlExtension, {Map body, bool authorizedHeader = false}) async {
    Map<String, String> headers;
    if (authorizedHeader) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": token,
      };
    } else {
      headers = APICaller.headers;
    }
    if (body == null) {
      body = {};
    }

    final res = await http
        .put(Env.baseUrl + urlExtension, headers: headers, body: json.encode(body))
        .timeout(const Duration(seconds: 10), onTimeout: () {
      throw RequestTimeOutException("Poor internet or no internet connectivity, Please try again.");
    });
    var dataRetrived = returnResponse(res);
    return dataRetrived;
  }

  static Future<dynamic> deleteData(String urlExtension, {bool authorizedHeader = false}) async {
    Map<String, String> headers;
    if (authorizedHeader) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": token,
      };
    } else {
      headers = APICaller.headers;
    }


    final res = await http.delete(Env.baseUrl + urlExtension, headers: headers).timeout(const Duration(seconds: 10), onTimeout: () {throw RequestTimeOutException("Poor internet or no internet connectivity, Please try again.");});
    var dataRetrived = returnResponse(res);

    return dataRetrived;
  }

  static returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        Map responseBody = json.decode(response.body);
        return responseBody;
        break;
      case 400:
        throw BadRequestException("Error please try again later.");
        break;
      case 401:
        Map responseBody = json.decode(response.body);
//        if(App.context!=null) {
//          BlocProvider.of<UserBloc>(App.context)..add(LogoutUser());
//          BlocProvider.of<HomeBloc>(App.context)..add(ChangePage(0));
//          HomeDataRepository.totalUnFinishedActivity=0;
//          HomeDataRepository.totalActivity=0;
//          HomeDataRepository.activitiesStatisticsPerElement=[];
//        }
        throw UnauthorisedException(responseBody.containsKey("message") ? responseBody["message"] : "Unauthorized");
        break;
      case 403:
        throw UnauthorisedException(response.body.toString());
        break;
      case 404:
        throw BadRequestException("Internal server error, please try again later.");
        break;
      case 409:
      case 422:
        Map responseBody = json.decode(response.body);
        throw HttpException(responseBody['message']);
        break;
      case 500:
        debugPrint("Server error: "+response.body);
        throw ServerErrorException("Server error, please try again later.");
        break;
      case 503:
        debugPrint("Server error: "+response.body);
        break;
      default:
        throw FetchDataException('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
