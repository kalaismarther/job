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

class PostApi {
  static Future<ApiResponse<Map<String, dynamic>>> getEmploymentType(
      context, user_id, token) async {
    try {
      String get_employment_typeUrl = URI.get_employment_type;

      var response = await http.post(Uri.parse(get_employment_typeUrl),
          body: jsonEncode({"user_id": user_id}), headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data?['status'] == 3 || data?['status'] == "3") {
          // Logout.logout(context, "session");
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

  static Future<ApiResponse<Map<String, dynamic>>> getCurrency(
      context, user_id, search, pageNo, token) async {
    try {
      String get_currenciesUrl = URI.get_currencies;

      var response = await http.post(Uri.parse(get_currenciesUrl),
          body: jsonEncode(
              {"user_id": user_id, "search": search, "page_no": pageNo}),
          headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data?['status'] == 3 || data?['status'] == "3") {
          // Logout.logout(context, "session");
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

  static Future<ApiResponse<Map<String, dynamic>>> createJob(
      context, data, token) async {
    try {
      String create_jobUrl = URI.create_job;

      var response = await http.post(Uri.parse(create_jobUrl),
          body: jsonEncode(data), headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data?['status'] == 3 || data?['status'] == "3") {
          // Logout.logout(context, "session");
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

  static Future<ApiResponse<Map<String, dynamic>>> updateJobInfo(
      context, data, token) async {
    try {
      String update_job_infoUrl = URI.update_job_info;

      var response = await http.post(Uri.parse(update_job_infoUrl),
          body: jsonEncode(data), headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data?['status'] == 3 || data?['status'] == "3") {
          // Logout.logout(context, "session");
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

  static Future<ApiResponse<Map<String, dynamic>>> updateJobBenefit(
      context, data, token) async {
    try {
      String update_job_benefitsUrl = URI.update_job_benefits;

      var response = await http.post(Uri.parse(update_job_benefitsUrl),
          body: jsonEncode(data), headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data?['status'] == 3 || data?['status'] == "3") {
          // Logout.logout(context, "session");
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

  static Future<ApiResponse<Map<String, dynamic>>> getMypostJob(
      context, user_id, page_no, token) async {
    try {
      String company_jobsUrl = URI.company_jobs;

      var response = await http.post(Uri.parse(company_jobsUrl),
          body: jsonEncode({"user_id": user_id, "page_no": page_no}),
          headers: _setHeaders(token));
      final data = json.decode(response.body);
      print(data);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data?['status'] == 3 || data?['status'] == "3") {
          // Logout.logout(context, "session");
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

  static Future<ApiResponse<Map<String, dynamic>>> getCompanyJobDetails(
      context, user_id, job_id, token) async {
    try {
      String company_job_detailsUrl = URI.company_job_details;

      var response = await http.post(Uri.parse(company_job_detailsUrl),
          body: jsonEncode({"user_id": user_id, "job_id": job_id}),
          headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data?['status'] == 3 || data?['status'] == "3") {
          // Logout.logout(context, "session");
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

  static Future<ApiResponse<Map<String, dynamic>>> getCompnybenefits(
      context, user_id, token) async {
    try {
      String get_company_benefitsUrl = URI.get_company_benefits;

      var response = await http.post(Uri.parse(get_company_benefitsUrl),
          body: jsonEncode({"user_id": user_id}), headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data?['status'] == 3 || data?['status'] == "3") {
          // Logout.logout(context, "session");
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

  static Future<ApiResponse<Map<String, dynamic>>> getJobLevel(
      context, user_id, token) async {
    try {
      String get_job_levelsUrl = URI.get_job_levels;

      var response = await http.post(Uri.parse(get_job_levelsUrl),
          body: jsonEncode({"user_id": user_id}), headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data?['status'] == 3 || data?['status'] == "3") {
          // Logout.logout(context, "session");
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
