
import 'dart:convert';

import 'package:QRFlutter/data/models/user_model.dart';
import 'package:QRFlutter/data/sources/remote/base/api_caller.dart';
import 'package:QRFlutter/data/sources/remote/base/app.exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';


abstract class UserRepository {

  Future<User> login(String email, String password,String platform,String firebaseToken);

  Future<User> update(User user);

  Future<User> updateProfilePicture(String photo,String name);

  Future<String> forgetPassword(String email);

  Future<String> resetPassword(String email,String token,String newPassword);

  Future<User> fetchUserData();

  Future<User> loadUserData(String firebaseToken);

  logout();
}

class UserDataRepository implements UserRepository {
  @override
  Future<User> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      throw UnauthorisedException('no user logged in');
    }
    User user = User.fromJson(json.decode(prefs.get('userData')));
    final expiryDate = DateTime.parse(prefs.get('expiryDate'));
    if (expiryDate.isBefore(DateTime.now())) {
      throw UnauthorisedException('Expired');
    }
    return user;
  }

  @override
  Future<String> forgetPassword(String email) async {
    final responseData = await APICaller.postData("/password/create", body: {"email": email},authorizedHeader: true);
    return responseData['message'];
  }


  @override
  Future<User> login(String email, String password,  String platform,String firebaseToken) async {
    final responseData = await APICaller.postData("/auth/login", body: {"email":email, "password":password,"firebase_token":firebaseToken, "platform":platform});
    User user = User.fromJson(responseData['user']);
    DateTime _expiryDate = DateTime.parse(responseData['expires_at']);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', json.encode(user));
    prefs.setString('token', 'Bearer ' + responseData['access_token']);
    prefs.setString('expiryDate', _expiryDate.toIso8601String());
    prefs.setBool('loggedIn', true);
    return user;
  }

  @override
  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String theme = preferences.getString("theme");
    preferences.clear();
    preferences.setBool('boarded', true);
    preferences.setString('theme', theme);
  }


  @override
  Future<String> resetPassword(String email, String token, String newPassword) async {
    final responseData = await APICaller.postData("/password/reset", body: {
      "email": email,
      "token": token,
    },authorizedHeader: true);
    return responseData;
  }

  @override
  Future<User> update(User updatedUser) async {
    final prefs = await SharedPreferences.getInstance();
    final responseData = await APICaller.postData("/update-user-data", body: updatedUser.toUpdateJson(),authorizedHeader: true);
    User user = User.fromJson(responseData['user']);
    prefs.setString('userData', json.encode(user));
    return user;
  }

  @override
  Future<User> updateProfilePicture(String photo, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final responseData = await APICaller.postData("/update-user-profile-picture", body: {"photo": photo, "name": name,},authorizedHeader: true);
    User user = User.fromJson(responseData['user']);
    prefs.setString('userData', json.encode(user));
    return user;
  }

  @override
  Future<User> loadUserData(String firebaseToken) async {
    final prefs = await SharedPreferences.getInstance();
    final responseData = await APICaller.postData("/auth/user",body: {'firebase_token':firebaseToken}, authorizedHeader: true);
    User user = User.fromJson(responseData['user']);
    prefs.setString('userData', json.encode(user));
    return user;
  }



}
