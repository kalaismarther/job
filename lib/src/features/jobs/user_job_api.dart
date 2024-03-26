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

class UserJobApi {
  static Future<ApiResponse<Map<String, dynamic>>> getJobDetails(
      context, user_id, job_id, token) async {
    try {
      String get_user_job_detailsUrl = URI.get_user_job_details;

      var response = await http.post(Uri.parse(get_user_job_detailsUrl),
          body: jsonEncode(({"user_id": user_id, "job_id": job_id})),
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

  static Future<ApiResponse<Map<String, dynamic>>> getAllJobs(
      context, data, token) async {
    try {
      String get_user_searchjobsUrl = URI.get_user_searchjobs;

      var response = await http.post(Uri.parse(get_user_searchjobsUrl),
          body: jsonEncode(data), headers: _setHeaders(token));

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

  static Future<ApiResponse<Map<String, dynamic>>> getUserFilter(
      context, data, token) async {
    try {
      String get_user_filtersUrl = URI.get_user_filters;

      var response = await http.post(Uri.parse(get_user_filtersUrl),
          body: jsonEncode(data), headers: _setHeaders(token));

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

  static Future<ApiResponse<Map<String, dynamic>>> applyJob(
      context, data, token) async {
    try {
      String user_job_applyUrl = URI.user_job_apply;

      var request = http.MultipartRequest('POST', Uri.parse(user_job_applyUrl));

      // Add headers, including the authentication token
      request.headers['x-api-key'] = token;

      request.fields['user_id'] = data['user_id'].toString();
      request.fields['job_id'] = data['job_id'];
      // Add file to the request
      var file = await http.MultipartFile.fromPath('resume', data['resume']);
      request.files.add(file);
      print("=============**********");

      print("${request}, =================================");

      // Send the request
      var response = await request.send();
      print(response);
      final responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseMap = jsonDecode(responseBody);

      print(responseBody);
      print(responseMap);

      if (response.statusCode == 200) {
        print("success");
        final data = json.decode(responseBody);
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

  static Future<ApiResponse<Map<String, dynamic>>> applyJobwithProfileResume(
      context, data, token) async {
    try {
      var pdfUrl = await http.get(Uri.parse(data['resume']));
      var pdfBytes = pdfUrl.bodyBytes;
      String user_job_applyUrl = URI.user_job_apply;

      var request = http.MultipartRequest('POST', Uri.parse(user_job_applyUrl));

      // Add headers, including the authentication token
      request.headers['x-api-key'] = token;

      request.fields['user_id'] = data['user_id'].toString();
      request.fields['job_id'] = data['job_id'];
      // Add file to the request
      var file = http.MultipartFile.fromBytes('resume', pdfBytes,
          filename: "resume.pdf");
      request.files.add(file);
      print("=============**********");

      print("${request}, =================================");

      // Send the request
      var response = await request.send();
      print(response);
      final responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseMap = jsonDecode(responseBody);

      print(responseBody);
      print(responseMap);

      if (response.statusCode == 200) {
        print("success");
        final data = json.decode(responseBody);
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

  static Future<ApiResponse<Map<String, dynamic>>> GetSavaedJobList(
      context, user_id, page_no, token) async {
    try {
      String user_jobs_savedUrl = URI.user_jobs_saved;

      var response = await http.post(Uri.parse(user_jobs_savedUrl),
          body: jsonEncode({"user_id": user_id, "page_no": page_no}),
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

  static Future<ApiResponse<Map<String, dynamic>>> GetJobAppiledList(
      context, user_id, page_no, token) async {
    try {
      String user_job_appliedUrl = URI.user_job_applied;

      var response = await http.post(Uri.parse(user_job_appliedUrl),
          body: jsonEncode({"user_id": user_id, "page_no": page_no}),
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
