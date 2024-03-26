import 'package:job/src/core/utils/api_response.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/logout.dart';
import '../../core/utils/uri.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

_setHeadersWithOutToken() => {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };

// _setHeaders(token) => {
//       'Content-type': 'application/json; charset=UTF-8',
//       'Accept': 'application/json',
//       'Authorization': '$token'
//     };

_setHeaders(token) => {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'x-api-key': '$token'
    };

class AuthApi {
  static Future<ApiResponse<Map<String, dynamic>>> getCountry(
      context, data) async {
    print(data);
    try {
      String getCountryUrl = URI.get_country;

      var response = await http.post(Uri.parse(getCountryUrl),
          body: jsonEncode(data), headers: _setHeadersWithOutToken());
      print(response.statusCode);
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

  static Future<ApiResponse<Map<String, dynamic>>> getStates(
      context, data) async {
    try {
      String getStateUrl = URI.get_state;

      var response = await http.post(Uri.parse(getStateUrl),
          body: jsonEncode(data), headers: _setHeadersWithOutToken());

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

  static Future<ApiResponse<Map<String, dynamic>>> getCity(
      context, data) async {
    print(json.encode(data));
    try {
      String getCityUrl = URI.get_city;

      var response = await http.post(Uri.parse(getCityUrl),
          body: jsonEncode(data), headers: _setHeadersWithOutToken());
      print(response.body);
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

  static Future<ApiResponse<Map<String, dynamic>>> SignUp(context, data) async {
    try {
      String signupUrl = URI.signup;

      var response = await http.post(Uri.parse(signupUrl),
          body: jsonEncode(data), headers: _setHeadersWithOutToken());

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

  static Future<ApiResponse<Map<String, dynamic>>> VerifyOtp(
      context, data) async {
    try {
      String verifyOtpUrl = URI.verifyOtp;

      var response = await http.post(Uri.parse(verifyOtpUrl),
          body: jsonEncode(data), headers: _setHeadersWithOutToken());

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

  static Future<ApiResponse<Map<String, dynamic>>> ResendOtp(
      context, data, token) async {
    try {
      String otpresendOtpUrl = URI.otpresend;

      var response = await http.post(Uri.parse(otpresendOtpUrl),
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

  static Future<ApiResponse<Map<String, dynamic>>> login(context, data) async {
    try {
      String loginUrl = URI.login;

      var response = await http.post(Uri.parse(loginUrl),
          body: jsonEncode(data), headers: _setHeadersWithOutToken());
      print(response.statusCode);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data?['status'] == 3 || data?['status'] == "3") {
          // print("Logout");
          await Logout.logout(context, "session");
        } else {
          print(data?['data']?['is_resume']);
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

  static Future<ApiResponse<Map<String, dynamic>>> guestLogin(
      context, data) async {
    try {
      String guestloginUrl = URI.guestlogin;

      var response = await http.post(Uri.parse(guestloginUrl),
          body: jsonEncode(data), headers: _setHeadersWithOutToken());

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

  static Future<ApiResponse<Map<String, dynamic>>> companyGuestLogin(
      context, data) async {
    try {
      String guestcompanyloginUrl = URI.guestcompanylogin;

      var response = await http.post(Uri.parse(guestcompanyloginUrl),
          body: jsonEncode(data), headers: _setHeadersWithOutToken());

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

  static Future<ApiResponse<Map<String, dynamic>>> ForgotPass(
      context, data) async {
    try {
      String forgot_passwordUrl = URI.forgot_password;

      var response = await http.post(Uri.parse(forgot_passwordUrl),
          body: jsonEncode(data), headers: _setHeadersWithOutToken());

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

  static Future<ApiResponse<Map<String, dynamic>>> ResetPassword(
      context, data, token) async {
    try {
      String reset_passwordUrl = URI.reset_password;

      var response = await http.post(Uri.parse(reset_passwordUrl),
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

  // Company login

  static Future<ApiResponse<Map<String, dynamic>>> CompanyLogin(
      context, data) async {
    try {
      String company_loginUrl = URI.company_login;

      var response = await http.post(Uri.parse(company_loginUrl),
          body: jsonEncode(data), headers: _setHeadersWithOutToken());

      print(data);

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

  static Future<ApiResponse<Map<String, dynamic>>> ProviderSignup(
      context, data) async {
    try {
      String company_signupUrl = URI.company_signup;

      var response = await http.post(Uri.parse(company_signupUrl),
          body: jsonEncode(data), headers: _setHeadersWithOutToken());

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

  static Future<ApiResponse<Map<String, dynamic>>> GetQualification(
      context, data, search, pageNo, token) async {
    try {
      String get_qualificationsUrl = URI.get_qualifications;
      print({"user_id": data, "search": search, "page_no": pageNo});
      print(token);

      var response = await http.post(Uri.parse(get_qualificationsUrl),
          body: jsonEncode(
              {"user_id": data, "search": search, "page_no": pageNo}),
          headers: _setHeaders(token));

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

  static Future<ApiResponse<Map<String, dynamic>>> GetSpecialisations(
      context, data, search, token) async {
    try {
      String get_specialisationsUrl = URI.get_specialisations;

      var response = await http.post(Uri.parse(get_specialisationsUrl),
          body: jsonEncode({"user_id": data, "search": search}),
          headers: _setHeaders(token));

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

  static Future<ApiResponse<Map<String, dynamic>>> GetIndustried(
      context, data, search, pageNo, token) async {
    try {
      String get_industriesUrl = URI.get_industries;

      var response = await http.post(Uri.parse(get_industriesUrl),
          body: jsonEncode(
              {"user_id": data, "search": search, "page_no": pageNo}),
          headers: _setHeaders(token));

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

  static Future<ApiResponse<Map<String, dynamic>>> GetDepartments(
      context, data, search, pageNo, token) async {
    try {
      String get_departmentsUrl = URI.get_departments;

      var response = await http.post(Uri.parse(get_departmentsUrl),
          body: jsonEncode(
              {"user_id": data, "search": search, "page_no": pageNo}),
          headers: _setHeaders(token));

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

  static Future<ApiResponse<Map<String, dynamic>>> GetPreferredRole(
      context, data, search, token) async {
    try {
      String get_preferred_rolesUrl = URI.get_preferred_roles;

      var response = await http.post(Uri.parse(get_preferred_rolesUrl),
          body: jsonEncode({"user_id": data, "search": search}),
          headers: _setHeaders(token));

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

  static Future<ApiResponse<Map<String, dynamic>>> GetYears(
      context, data, token) async {
    try {
      String get_yearsUrl = URI.get_years;

      var response = await http.post(Uri.parse(get_yearsUrl),
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

  static Future<ApiResponse<Map<String, dynamic>>> GetOrganisationType(
      context, data, token) async {
    try {
      String get_organisation_typesUrl = URI.get_organisation_types;

      var response = await http.post(Uri.parse(get_organisation_typesUrl),
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

  static Future<ApiResponse<Map<String, dynamic>>> GetKycDocType(
      context, data, token) async {
    try {
      String get_kycdoc_typesUrl = URI.get_kycdoc_types;

      var response = await http.post(Uri.parse(get_kycdoc_typesUrl),
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

  static Future<ApiResponse<Map<String, dynamic>>> updateUserProfession(
      context, data, token) async {
    try {
      String update_user_professionsUrl = URI.update_user_profession;

      var response = await http.post(Uri.parse(update_user_professionsUrl),
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

  static Future<ApiResponse<Map<String, dynamic>>> updateUserEducation(
      context, data, token) async {
    try {
      String update_user_educationUrl = URI.update_user_education;

      var response = await http.post(Uri.parse(update_user_educationUrl),
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

  static Future<ApiResponse<Map<String, dynamic>>> updateUserPreference(
      context, data, token) async {
    try {
      String update_user_preferenceUrl = URI.update_user_preference;

      var response = await http.post(Uri.parse(update_user_preferenceUrl),
          body: jsonEncode(data), headers: _setHeaders(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data?['status'] == 3 || data?['status'] == "3") {
          // print("Logout");
          await Logout.logout(context, "session");
        } else {
          return ApiResponse(data: data, success: true);
        }
      } else if (response.statusCode == 408) {
        print("timout");
      } else {
        return ApiResponse(data: {}, success: false);
      }
    } catch (error) {
      return ApiResponse(data: {}, success: false);
    }
    return ApiResponse(data: {}, success: false);
  }

  static Future<ApiResponse<Map<String, dynamic>>> GetSkills(
      context, data, search, pageNo, token) async {
    try {
      String get_skillsUrl = URI.get_skills;

      var response = await http.post(Uri.parse(get_skillsUrl),
          body: jsonEncode(
              {"user_id": data, "search": search, "page_no": pageNo}),
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

  static Future<ApiResponse<Map<String, dynamic>>> UpdateUserEmployement(
      context, data, token) async {
    try {
      String update_user_employmentsUrl = URI.update_user_employments;

      var response = await http.post(Uri.parse(update_user_employmentsUrl),
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

  static Future<ApiResponse<Map<String, dynamic>>> updateCompanyProfile(
      context, data, token) async {
    try {
      String update_company_profileUrl = URI.update_company_profile;

      var request =
          http.MultipartRequest('POST', Uri.parse(update_company_profileUrl));

      // Add headers, including the authentication token
      request.headers['x-api-key'] = token;

      request.fields['user_id'] = data['user_id'].toString();
      request.fields['company_name'] = data['company_name'];
      request.fields['current_designation'] = data['current_designation'];
      request.fields['mobile_number'] = data['mobile_number'];
      request.fields['registered_email'] = data['registered_email'];
      request.fields['landline_code'] = data['landline_code'];
      request.fields['landline_number'] = data['landline_number'];
      request.fields['kycdoc_type_id'] = data['kycdoc_type_id'];
      request.fields['organisation_type_id'] = data['organisation_type_id'];
      request.fields['gst_number'] = data['gst_number'];
      request.fields['pan_number'] = data['pan_number'];
      request.fields['adhar_number'] = data['adhar_number'];
      request.fields['employee_size'] = data['employee_size'];

      // Add file to the request
      if (data['kyc_document'] != "" && data['kyc_document'] != null) {
        var file = await http.MultipartFile.fromPath(
            'kyc_document', data['kyc_document']);
        request.files.add(file);
      }
      if (data['company_logo'] != null && data['company_logo'] != "") {
        var file1 = await http.MultipartFile.fromPath(
            'company_logo', data['company_logo']);

        request.files.add(file1);
      }

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

  static Future<ApiResponse<Map<String, dynamic>>> UpdateCompanyAddress(
      context, data, token) async {
    try {
      String update_company_addressUrl = URI.update_company_address;

      var response = await http.post(Uri.parse(update_company_addressUrl),
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

  static Future<ApiResponse<Map<String, dynamic>>> getTermsCondition(
      context, user_id) async {
    try {
      String terms_conditionsUrl = URI.terms_conditions;

      var response = await http.post(Uri.parse(terms_conditionsUrl),
          body: jsonEncode({"user_id": user_id}),
          headers: _setHeadersWithOutToken());

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

  // <kalai>
  static Future<ApiResponse<Map<String, dynamic>>> getCompanyDetails(
      context, user_id, token) async {
    try {
      String get_company_detailsUrl = URI.get_company_details;

      var response = await http.post(Uri.parse(get_company_detailsUrl),
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
  } // </kalai>

  static Future<ApiResponse<Map<String, dynamic>>> getCompanyProfileDetails(
      context, user_id, token) async {
    try {
      String get_company_detailsUrl = URI.get_company_details;

      var response = await http.post(Uri.parse(get_company_detailsUrl),
          body: jsonEncode({"user_id": user_id}), headers: _setHeaders(token));

      print(jsonEncode({"user_id": user_id}));

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

  static Future<ApiResponse<Map<String, dynamic>>> getKeywords(
      context, data, search, pageNo, token) async {
    try {
      String get_keywordsUrl = URI.get_keywords;

      var response = await http.post(Uri.parse(get_keywordsUrl),
          body: jsonEncode(
              {"user_id": data, "search": search, "page_no": pageNo}),
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

// class AuthApi {
//   //   Future<bool> createUser({
//   //   required String name,
//   //   required String job,
//   // }) async {
//   //   bool userCreated = false;
//   //   try {
//   //     final response = await HttpClient.request(
//   //         requestType: Request.POST,
//   //         url: URI.createUser,
//   //         body: {"name": "222"});

//   //     userCreated = response.data["id"] != null;
//   //   } catch (e, s) {
//   //     Log.e(s, e);
//   //   }
//   //   return userCreated;
//   // }

//   // Future<bool> Login({required Map data}) async {
//   //   bool isLogin = false;
//   //   try {} catch (e) {

//   //   }
//   //   return isLogin;
//   // }

//   Future<UserListModel?> getUserList() async {
//     UserListModel? userListModel;
//     try {
//       final response = await http.get(Uri.parse(URI.userList),
//           headers: _setHeadersWithOutToken());

//       if (response.statusCode == 200) {
//         // Parse the response body here
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         userListModel = UserListModel.fromJson(responseData);
//       } else {
//         // Handle the error based on the response status code
//         print('Error: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Log.e(s, e);
//     }
//     return userListModel;
//   }
// }

// Future<UserListModel?> getUserList() async {
//   UserListModel? userListModel;
//   try {
//     final response = await http.get(Uri.parse(URI.userList), headers: _setHeadersWithOutToken());

//     if (response.statusCode == 200) {
//       // Parse the response body here
//       final Map<String, dynamic> responseData = json.decode(response.body);
//       userListModel = UserListModel.fromJson(responseData);
//     } else {
//       // Handle the error based on the response status code
//       print('Error: ${response.statusCode}');
//     }
//   } catch (e, s) {
//     // Log.e(s, e);
//   }
//   return userListModel;
// }

bool sample() {
  return true;
}
