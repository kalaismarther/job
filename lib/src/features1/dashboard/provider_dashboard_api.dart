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

class ProviderDashboardApi {
  static Future<ApiResponse<Map<String, dynamic>>> getProviderHomeContent(
      context, user_id, token) async {
    try {
      String get_company_homecontentsUrl = URI.get_company_homecontents;

      var response = await http.post(Uri.parse(get_company_homecontentsUrl),
          body: jsonEncode({"user_id": user_id}), headers: _setHeaders(token));
      final data = json.decode(response.body);
      print(data);
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

  static Future<ApiResponse<Map<String, dynamic>>> getSearchFilter(
      context, data, token) async {
    try {
      String get_company_filtersUrl = URI.get_company_filters;

      var response = await http.post(Uri.parse(get_company_filtersUrl),
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

  static Future<ApiResponse<Map<String, dynamic>>> providerSearch(
      context, data, token) async {
    try {
      String get_company_searchusersUrl = URI.get_company_searchusers;

      var response = await http.post(Uri.parse(get_company_searchusersUrl),
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

  static Future<ApiResponse<Map<String, dynamic>>> CompanyDownloadCVcheck(
      context, data, token) async {
    try {
      String company_download_applied_profileUrl =
          URI.company_download_applied_profile;

      var response = await http.post(
          Uri.parse(company_download_applied_profileUrl),
          body: jsonEncode(data),
          headers: _setHeaders(token));
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
