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

class SubscriptionApi {
  static Future<ApiResponse<Map<String, dynamic>>> getCompanyPackages(
      context, user_id, token) async {
    try {
      String get_company_packagesUrl = URI.get_company_packages;

      var response = await http.post(Uri.parse(get_company_packagesUrl),
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

  static Future<ApiResponse<Map<String, dynamic>>> checkPackagePurchase(
      context, data, token) async {
    try {
      String check_company_package_purchaseUrl =
          URI.check_company_package_purchase;

      var response = await http.post(
          Uri.parse(check_company_package_purchaseUrl),
          body: jsonEncode(data),
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

  static Future<ApiResponse<Map<String, dynamic>>> postPackagePurchase(
      context, data, token) async {
    try {
      String post_company_package_purchaseUrl =
          URI.post_company_package_purchase;

      var response = await http.post(
          Uri.parse(post_company_package_purchaseUrl),
          body: jsonEncode(data),
          headers: _setHeaders(token));
      final result = json.decode(response.body);
      print('>>>>>>>> $result');

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

  static Future<ApiResponse<Map<String, dynamic>>> getPackagePurchaseList(
      context, user_id, page_no, token) async {
    try {
      String check_company_package_purchaseUrl =
          URI.get_company_package_purchases;

      var response = await http.post(
          Uri.parse(check_company_package_purchaseUrl),
          body: jsonEncode({"user_id": user_id, "page_no": page_no}),
          headers: _setHeaders(token));
      print({"user_id": user_id, "page_no": page_no});
      print(token);
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

class ExcelApi {
  static Future<ApiResponse<Map<String, dynamic>>> downloadCVsList(
      context, packageId, token) async {
    print(packageId);
    try {
      var response = await http.get(
        Uri.parse(
            'https://jobeasyee.com/backend/package_downloaded_cvs_xls/$packageId'),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        return ApiResponse(data: {"excel_file": response.body}, success: true);
      } else {
        return ApiResponse(data: {}, success: false);
      }
    } catch (error) {
      print(error);
      return ApiResponse(data: {}, success: false);
    }
  }

  static Future<ApiResponse<Map<String, dynamic>>> downloadPostedJobsList(
      context, packageId, token) async {
    try {
      var response = await http.get(
        Uri.parse(
            'https://jobeasyee.com/backend/package_posted_jobs_xls/$packageId'),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        return ApiResponse(data: {"excel_file": response.body}, success: true);
      } else {
        return ApiResponse(data: {}, success: false);
      }
    } catch (error) {
      print(error);
      return ApiResponse(data: {}, success: false);
    }
  }

  static Future<ApiResponse<Map<String, dynamic>>> appliedSeekersList(
      context, jobId, token) async {
    try {
      var response = await http.get(
        Uri.parse('https://jobeasyee.com/backend/applied_seekers_xls/$jobId'),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        return ApiResponse(data: {"excel_file": response.body}, success: true);
      } else {
        return ApiResponse(data: {}, success: false);
      }
    } catch (error) {
      print(error);
      return ApiResponse(data: {}, success: false);
    }
  }
}
