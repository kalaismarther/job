// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/core/utils/uri.dart';
import 'package:http/http.dart' as http;
import 'package:job/src/core/utils/validate.dart';
import 'package:job/src/features/auth/views/splash.dart';

_setHeadersWithOutToken() => {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };

class Logout {
  static Future logout(context, type) async {
    try {
      String logoutUrl = URI.logout;

      var UserResponse = PrefManager.read("UserResponse");
      String id = UserResponse['data']['id'].toString();
      String fcm_token = "";
      String device_id = "";
      String device_type = UserResponse['data']['user_source_from'];

      var response = await http.post(Uri.parse(logoutUrl),
          body: jsonEncode({
            "user_id": id,
            "fcm_token": fcm_token,
            "device_id": device_id,
            "device_type": device_type
          }),
          headers: _setHeadersWithOutToken());

      if (response.statusCode == 200) {
        pref.setBool("isLoggin", false);
        PrefManager.clearAll();
        if(type != "guest"){
 type == "logout"
            ? Snackbar.show("Logout Successfully", Colors.green)
            : 
            Snackbar.show("Session Expired", Colors.red);
        }
       
        Nav.offAll(context, Splash());
      } else {
        // Snackbar.show("Some error", Colors.red);
      }
    } catch (error) {
      // Snackbar.show("catch error", Colors.red);
    }
  }
}
