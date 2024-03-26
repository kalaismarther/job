// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:job/src/core/utils/api_response.dart';
import 'package:job/src/core/utils/local_storage.dart';
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

class UserProfileApi {
  static Future<ApiResponse<Map<String, dynamic>>> updateUserProfile(
      context, data, token) async {
    try {
      String update_profileimageUrl = URI.update_profileimage;

      var request =
          http.MultipartRequest('POST', Uri.parse(update_profileimageUrl));

      // Add headers, including the authentication token
      request.headers['x-api-key'] = token;

      request.fields['user_id'] = data['user_id'].toString();

      // Add file to the request
      var file = await http.MultipartFile.fromPath(
          'profile_image', data['profile_image']);

      request.files.add(file);

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

  static Future<ApiResponse<Map<String, dynamic>>> uploadUserCv(
      context, data, token) async {
    try {
      String update_resumeUrl = URI.update_resume;

      var request = http.MultipartRequest('POST', Uri.parse(update_resumeUrl));

      // Add headers, including the authentication token
      request.headers['x-api-key'] = token;

      request.fields['user_id'] = data['user_id'].toString();

      // Add file to the request
      var file = await http.MultipartFile.fromPath('resume', data['resume']);

      request.files.add(file);

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
          // Logout.logout(context, "session");
          await Logout.logout(context, "session");
        } else {
          PrefManager.write('user_resume', data?['data']?['is_resume'] ?? '');
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

  static Future<ApiResponse<Map<String, dynamic>>> deleteUserCv(
      context, data, token) async {
    try {
      String delete_resumeUrl = URI.delete_resume;

      var response = await http.post(Uri.parse(delete_resumeUrl),
          body: jsonEncode({"user_id": data}), headers: _setHeaders(token));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data?['status'] == 3 || data?['status'] == "3") {
          // print("Logout");
          await Logout.logout(context, "session");
        } else {
          PrefManager.remove('user_resume');
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

  static Future<ApiResponse<Map<String, dynamic>>> GetUserProfileDetails(
      context, data, token) async {
    try {
      String get_user_detailsUrl = URI.get_user_details;

      var response = await http.post(Uri.parse(get_user_detailsUrl),
          body: jsonEncode({"user_id": data}), headers: _setHeaders(token));

      if (response.statusCode == 200 || response.statusCode == 201) {
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

  static Future<ApiResponse<Map<String, dynamic>>> UpdateUserProfile(
      context, data, token) async {
    try {
      String update_user_profileUrl = URI.update_user_profile;

      var response = await http.post(Uri.parse(update_user_profileUrl),
          body: jsonEncode(data), headers: _setHeaders(token));

      if (response.statusCode == 200 || response.statusCode == 201) {
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

  static Future<ApiResponse<Map<String, dynamic>>> GetEducationalDetails(
      context, data, token) async {
    try {
      String list_user_educationUrl = URI.list_user_education;

      var response = await http.post(Uri.parse(list_user_educationUrl),
          body: jsonEncode({"user_id": data}), headers: _setHeaders(token));

      if (response.statusCode == 200 || response.statusCode == 201) {
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

  static Future<ApiResponse<Map<String, dynamic>>> GetJobPreferenceDetails(
      context, data, token) async {
    print(data);
    print(token);
    try {
      String get_user_preferenceUrl = URI.get_user_preference;

      var response = await http.post(Uri.parse(get_user_preferenceUrl),
          body: jsonEncode({"user_id": data}), headers: _setHeaders(token));

      if (response.statusCode == 200 || response.statusCode == 201) {
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

  static Future<ApiResponse<Map<String, dynamic>>> GetJobProfessionDetails(
      context, data, token) async {
    try {
      String get_user_professionUrl = URI.get_user_profession;

      var response = await http.post(Uri.parse(get_user_professionUrl),
          body: jsonEncode({"user_id": data}), headers: _setHeaders(token));

      if (response.statusCode == 200 || response.statusCode == 201) {
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

  static Future<ApiResponse<Map<String, dynamic>>> GetUserEmployeDetails(
      context, user_id, token) async {
    try {
      String list_user_employmentsUrl = URI.list_user_employments;

      var response = await http.post(Uri.parse(list_user_employmentsUrl),
          body: jsonEncode({"user_id": user_id}), headers: _setHeaders(token));

      if (response.statusCode == 200 || response.statusCode == 201) {
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
