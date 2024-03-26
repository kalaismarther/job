import 'dart:convert';

import 'package:job/src/core/utils/api_response.dart';
import 'package:job/src/core/utils/logout.dart';
import 'package:job/src/core/utils/uri.dart';

import 'package:http/http.dart' as http;

_setHeadersWithOutToken() => {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };

_setHeaders(token) => {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'x-api-key': '$token'
    };

class UserDashboardApi {
  static Future<ApiResponse<Map<String, dynamic>>> getuserHomeContent(
      context, user_id, token) async {
    try {
      String get_user_homecontentsUrl = URI.get_user_homecontents;

      var response = await http.post(Uri.parse(get_user_homecontentsUrl),
          body: jsonEncode({"user_id": user_id}), headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data?['status'] == 3 || data?['status'] == "3") {
          // print("Logout");
           await Logout.logout(context, "session");
        } else {
          return ApiResponse(data: data, success: true);
        }
      } else {
        return ApiResponse(data: {}, success: false);
      }
    } catch (error) {
      return ApiResponse(data: {}, success: false);
    }
    return ApiResponse(data: {}, success: false);
  }

  static Future<ApiResponse<Map<String, dynamic>>> getNotificationlist(
      context, user_id, page_no, token) async {
    try {
      String getnotificationsUrl = URI.getnotifications;

      var response = await http.post(Uri.parse(getnotificationsUrl),
          body: jsonEncode({"user_id": user_id, "page_no": page_no}), headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data?['status'] == 3 || data?['status'] == "3") {
          // print("Logout");
           await Logout.logout(context, "session");
        } else {
          return ApiResponse(data: data, success: true);
        }
      } else {
        return ApiResponse(data: {}, success: false);
      }
    } catch (error) {
      return ApiResponse(data: {}, success: false);
    }
    return ApiResponse(data: {}, success: false);
  }

  static Future<ApiResponse<Map<String, dynamic>>> notifyCount(
      context, user_id, token) async {
    try {
      String notifyUrl = URI.notify;

      var response = await http.post(Uri.parse(notifyUrl),
          body: jsonEncode({"user_id": user_id}), headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data?['status'] == 3 || data?['status'] == "3") {
          // print("Logout");
           await Logout.logout(context, "session");
        } else {
          return ApiResponse(data: data, success: true);
        }
      } else {
        return ApiResponse(data: {}, success: false);
      }
    } catch (error) {
      return ApiResponse(data: {}, success: false);
    }
    return ApiResponse(data: {}, success: false);
  }

  static Future<ApiResponse<Map<String, dynamic>>> JobSaved(
      context, user_id, job_id, token) async {
    try {
      String user_job_saveUrl = URI.user_job_save;

      var response = await http.post(Uri.parse(user_job_saveUrl),
          body: jsonEncode({"user_id": user_id, "job_id": job_id}),
          headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data?['status'] == 3 || data?['status'] == "3") {
          // print("Logout");
           await Logout.logout(context, "session");
        } else {
          return ApiResponse(data: data, success: true);
        }
      } else {
        return ApiResponse(data: {}, success: false);
      }
    } catch (error) {
      return ApiResponse(data: {}, success: false);
    }
    return ApiResponse(data: {}, success: false);
  }

  static Future<ApiResponse<Map<String, dynamic>>> JobUnSaved(
      context, user_id, job_id, token) async {
    try {
      String user_job_unsaveUrl = URI.user_job_unsave;

      var response = await http.post(Uri.parse(user_job_unsaveUrl),
          body: jsonEncode({"user_id": user_id, "job_id": job_id}),
          headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data?['status'] == 3 || data?['status'] == "3") {
          // print("Logout");
           await Logout.logout(context, "session");
        } else {
          return ApiResponse(data: data, success: true);
        }
      } else {
        return ApiResponse(data: {}, success: false);
      }
    } catch (error) {
      return ApiResponse(data: {}, success: false);
    }
    return ApiResponse(data: {}, success: false);
  }
}
