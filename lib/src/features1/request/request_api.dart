import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job/src/core/utils/api_response.dart';
import 'package:job/src/core/utils/logout.dart';
import 'package:job/src/core/utils/uri.dart';

_setHeadersWithOutToken() => {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };

_setHeaders(token) => {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'x-api-key': '$token'
    };

class RequestApi {
  static Future<ApiResponse<Map<String, dynamic>>> getCompanyJobAppliedList(
      context, data, token) async {
    try {
      String company_jobs_appliedUrl = URI.company_jobs_applied;

      var response = await http.post(Uri.parse(company_jobs_appliedUrl),
          body: jsonEncode(data), headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
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

  static Future<ApiResponse<Map<String, dynamic>>> getAppliedProfiledetails(
      context, data, token) async {
    try {
      String company_jobs_applied_profileUrl = URI.company_jobs_applied_profile;

      var response = await http.post(Uri.parse(company_jobs_applied_profileUrl),
          body: jsonEncode(data), headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
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

  static Future<ApiResponse<Map<String, dynamic>>> updateAppliedProfiled(
      context, data, token) async {
    try {
      String company_jobs_applied_updateUrl = URI.company_jobs_applied_update;

      var response = await http.post(Uri.parse(company_jobs_applied_updateUrl),
          body: jsonEncode(data), headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
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

  static Future<ApiResponse<Map<String, dynamic>>> compnayUserPick(
      context, data, token) async {
    try {
      String company_pick_userUrl = URI.company_pick_user;

      var response = await http.post(Uri.parse(company_pick_userUrl),
          body: jsonEncode(data), headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
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
