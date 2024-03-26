// ignore_for_file: non_constant_identifier_names, unused_local_variable, unused_field, use_build_context_synchronously, prefer_final_fields, prefer_typing_uninitialized_variables, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/common_search_modal.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/core/utils/validate.dart';
import 'package:job/src/features/account/user_profile_api.dart';
import 'package:job/src/features/account/views/edit_jobProfession.dart';
import 'package:job/src/features/account/views/edit_jobpreference.dart';
import 'package:job/src/features/account/views/educational_list.dart';
import 'package:job/src/features/account/views/employment_list.dart';
import 'package:job/src/features/auth/views/job_preference.dart';
import 'package:job/src/features/auth/views/proffesional_details.dart';
import 'package:permission_handler/permission_handler.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  TextEditingController mobileno = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();

  bool visiable = false;
  bool isLoading = false;
  bool _imageLoading = false;
  File? _image;
  var _image1;
  var _image_sr;
  var _userResponse;
  String selectedGender = '';
  bool stateLoad = false;
  bool cityLoad = false;
  bool check_s = false;
  bool check_c = false;
  var _SCountry = "";
  var _SCountry_code = "";
  var _SState = "";
  var _SCity = "";
  var countryId;
  var stateId;
  var districtId;
  var country_code;

  List Countries = [];
  List State = [
    {"id": "0", "state_name": "Please Select Country"}
  ];
  List Citys = [
    {"id": "0", "district_name": "Please Select State"}
  ];

  @override
  void initState() {
    // TODO: implement initState
    // print("profile");
    initilize();
    _getUserDetails();
    super.initState();
  }

  initilize() async {
    var UserResponse = PrefManager.read("UserResponse");
    print(UserResponse);
    setState(() {
      _image1 = UserResponse?['data']?['is_profile_image'];
      _userResponse = UserResponse?['data'];
    });
    stateUpdate();
  }

  _getUserDetails() async {
    var get_userDetails = await UserProfileApi.GetUserProfileDetails(
        context, _userResponse['id'], _userResponse['api_token']);
    print(get_userDetails);
    if (get_userDetails.success) {
      if (get_userDetails.data['status'].toString() == "1") {
        PrefManager.write("UserProfile", get_userDetails.data);
        stateUpdate();
      }
    }
  }

  stateUpdate() {
    var get_user_details = PrefManager.read("UserResponse");
    setState(() {
      mobileno.text = get_user_details['data']?['mobile'] ?? "";
      name.text = get_user_details['data']?['name'] ?? "";
      email.text = get_user_details['data']?['email'] ?? "";
      _dateController.text =
          formatDateString1(get_user_details['data']?['dob']);
      countryId = get_user_details['data']?['country_id'];
      stateId = get_user_details['data']?['state_id'];
      districtId = get_user_details['data']?['district_id'];
      city.text = get_user_details['data']?['is_district_name'] ?? "";
      state.text = get_user_details['data']?['is_state_name'] ?? "";
      country.text = get_user_details['data']?['is_country_name'] ?? "";
      selectedGender = get_user_details['data']?['gender'] ?? "";
    });
  }

  void _SelectModal1(data, type) async {
    print(data);
    print(type);
    final result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CommonSearchModal(data: data, type: type);
        });
    if (result != null) {
      setState(() {
        if (type == "country") {
          country.text = result['name'] ?? "";
          countryId = result['id'] ?? "";
          _SCountry_code = result['phonecode'].toString();
          state.text = "";
          city.text = "";
          districtId = "";
          stateId = "";
        } else if (type == "state") {
          state.text = result['state_name'] ?? "";
          stateId = result['id'] ?? "";
          districtId = "";
          city.text = "";
        } else {
          city.text = result['district_name'] ?? "";
          districtId = result['id'] ?? "";
        }
        // s_Location = result;
      });
    }
  }

  void _SelectModal(sId, cId, type) async {
    final result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SelectModal(
            StateId: sId,
            countryId: cId,
            type: type,
          );
        });
    if (result != null) {
      setState(() {
        if (type == "country") {
          country.text = result['name'] ?? "";
          countryId = result['id'] ?? "";
          state.text = "";
          city.text = "";
          districtId = "";
          stateId = "";
        } else if (type == "state") {
          state.text = result['state_name'] ?? "";
          stateId = result['id'] ?? "";
          districtId = "";
          city.text = "";
        } else {
          city.text = result['district_name'] ?? "";
          districtId = result['id'] ?? "";
        }
        // s_Location = result;
      });
    }
  }

  Future<bool> _requestGalleryPermission() async {
    var status = await Permission.photos.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      // You can show a dialog or snackbar to inform the user about the required permission
      await Permission.photos.request();
      return (await Permission.photos.status).isGranted;
    } else {
      // The user has previously denied the permission
      // You can open the app settings page to let the user grant the permission manually
      openAppSettings();
      return false;
    }
  }

  Future _getImage() async {
    // final galleryPermissionGranted = await _requestGalleryPermission();

    // if (galleryPermissionGranted) {
    setState(() {
      _imageLoading = true;
    });
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _image_sr = pickedFile.path;
      });
      print(_image_sr);
      print(_userResponse);
      var data = {"user_id": _userResponse['id'], "profile_image": _image_sr};
      print(_userResponse);

      var result = await UserProfileApi.updateUserProfile(
          context, data, _userResponse['api_token']);
      print(result);
      if (result.success) {
        if (result.data['status'].toString() == "1") {
          print(result);
          await PrefManager.write("UserResponse", result.data);
          initilize();
        }
      }

      // var result = await Api.uploadImage(context, _image!,
      //     UserResponse['id'].toString(), UserResponse['api_token']);
      // if (result.success) {
      //   print(result.data);
      // } else {
      //   Snackbar.show("Faild", "logout");
      // }
    }
    setState(() {
      _imageLoading = false;
    });
  }

  String formatDateString(String inputDate) {
    DateTime dateTime = DateFormat("dd-MM-yyyy").parse(inputDate);
    String formattedDate = DateFormat("yyyy-MM-dd").format(dateTime);
    return formattedDate;
  }

  String formatDateString1(String inputDate) {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(inputDate);
    String formattedDate = DateFormat("dd-MM-yyyy").format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    double ScreenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // print("click");
                  // Navigator.push(
                  //     context,
                  //     (MaterialPageRoute(
                  //         builder: (context) => EditProfile())));
                },
                child: Stack(
                  children: [
                    Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        child:
                            // !_imageLoading ?
                            //  Padding(
                            //    padding: const EdgeInsets.all(30.0),
                            //    child: CircularProgressIndicator(
                            //      strokeWidth: 3,
                            //      color: AppTheme.primary,
                            //    ),
                            //  )
                            //  :
                            _image1 != null
                                ? ClipOval(
                                    child: _imageLoading
                                        ? CircularProgressIndicator() // Show loader when _isLoading is true
                                        : FadeInImage(
                                            placeholder: const AssetImage(
                                                'assets/icons/Profile.png'),
                                            image: NetworkImage(_image1),
                                            fit: BoxFit.cover,
                                            width: 100.0,
                                            height: 100.0,
                                          ), // Show image when _isLoading is false
                                  )
                                // ClipOval(
                                //     child: FadeInImage(
                                //       placeholder: const AssetImage(
                                //           'assets/icons/Profile.png'),
                                //       image: NetworkImage(_image1),
                                //       fit: BoxFit.cover,
                                //       width: 100.0,
                                //       height: 100.0,
                                //     ),
                                //   )
                                // CircleAvatar(
                                //     backgroundColor: Colors.white,
                                //     radius: 60,
                                //     backgroundImage: NetworkImage(_image1),
                                //   )
                                : const CircleAvatar(
                                    radius: 60,
                                    backgroundImage:
                                        AssetImage("assets/icons/Profile.png'"),
                                  )),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            _getImage();
                          },
                          child: SizedBox(
                            height: 40,
                            child: Image.asset("assets/icons/edit_dark.png"),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    // maxLength: 10,
                    controller: name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter a Name';
                      }
                      return null;
                    },
                    // keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      counterText: '',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          "assets/icons/person.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      hintText: 'Name',
                      // labelText: "Mobile Number"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLength: 10,
                    readOnly: true,
                    controller: mobileno,
                    validator: Validate.mobile,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      counterText: '',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          "assets/icons/phone.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      hintText: 'Mobile Number',
                      // labelText: "Password"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    // maxLength: 10,
                    readOnly: true,
                    controller: email,
                    validator: Validate.email,
                    // keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      counterText: '',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          "assets/icons/email.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      hintText: 'Email Address',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    // maxLength: 10,
                    controller: _dateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1800),
                        lastDate: DateTime.now(),
                      );

                      // if (pickedDate != null) {
                      //   String formattedDate =
                      //       DateFormat('yyyy-MM-dd').format(pickedDate);
                      //   _dateController.text = formattedDate;
                      // }
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                        _dateController.text = formattedDate;
                      }
                    },
                    // validator: Validate.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select D.O.B';
                      }
                      return null;
                    },
                    // keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      counterText: '',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          "assets/icons/calender.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      hintText: 'D.O.B',
                      // labelText: "Password"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    // maxLength: 10,
                    readOnly: true,
                    controller: country,
                    onTap: () async {
                      print("Success");
                      // final result = _SelectModal("", "", "country");
                      final result = _SelectModal1([], "country");
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Select Country';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          "assets/icons/countries.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      suffixIcon: SizedBox(
                          width: 15,
                          height: 15,
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Image.asset(
                              "assets/icons/down.png",
                              fit: BoxFit.contain,
                            ),
                          )),
                      hintText: 'Country',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLength: 10,
                    readOnly: true,
                    controller: state,
                    onTap: () {
                      // _SelectModal("", countryId.toString(), "state");
                      _SelectModal1([
                        {"country_id": countryId.toString()}
                      ], "state");
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Selet State';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          "assets/icons/state.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      suffixIcon: SizedBox(
                          width: 15,
                          height: 15,
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Image.asset(
                              "assets/icons/down.png",
                              fit: BoxFit.contain,
                            ),
                          )),
                      hintText: 'State',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    // maxLength: 10,
                    readOnly: true,
                    controller: city,
                    onTap: () {
                      if (stateId != null && stateId == "") {
                        Snackbar.show("Please Select State", Colors.black);
                      } else {
                        // _SelectModal(stateId.toString(), "", "city");
                        _SelectModal1([
                          {"id": stateId.toString()}
                        ], "district_edit");
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Select City';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      // counterText: '',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          "assets/icons/city.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      suffixIcon: SizedBox(
                          width: 15,
                          height: 15,
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Image.asset(
                              "assets/icons/down.png",
                              fit: BoxFit.contain,
                            ),
                          )),
                      hintText: 'City',
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Gender",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'male',
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value.toString();
                          });
                        },
                      ),
                      const Text(
                        'Male',
                        style: TextStyle(fontSize: 12),
                      ),
                      Radio(
                        value: 'female',
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value.toString();
                          });
                        },
                      ),
                      const Text(
                        'Female',
                        style: TextStyle(fontSize: 12),
                      ),
                      Radio(
                        value: 'other',
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value.toString();
                          });
                        },
                      ),
                      const Flexible(
                          child: Text(
                        'Prefer not to say',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Nav.to(context, EditJobProfession());
                    },
                    child: Container(
                      width: ScreenWidth,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppTheme.primary_light,
                          borderRadius: BorderRadius.circular(05)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Job Profession ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          // IconButton(
                          //     onPressed: () {
                          //       Nav.to(context, EditJobProfession());
                          //     },
                          //     icon: Icon(
                          //       Icons.edit,
                          //       color: AppTheme.primary,
                          //     ))
                        ],
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // Container(
                  //   width: ScreenWidth,
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //       color: AppTheme.primary_light,
                  //       borderRadius: BorderRadius.circular(05)),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       const Padding(
                  //         padding: EdgeInsets.only(left: 8.0),
                  //         child: Text(
                  //           "Employement Details ",
                  //           style: TextStyle(fontWeight: FontWeight.w600),
                  //         ),
                  //       ),
                  //       IconButton(
                  //           onPressed: () {},
                  //           icon: Icon(
                  //             Icons.edit,
                  //             color: AppTheme.primary,
                  //           ))
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Nav.to(context, const EducationalList());
                    },
                    child: Container(
                      width: ScreenWidth,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppTheme.primary_light,
                          borderRadius: BorderRadius.circular(05)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Educational Details ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          // IconButton(
                          //     onPressed: () {
                          //       // Nav.to(context, EditEducationalDetails());
                          //       Nav.to(context, const EducationalList());
                          //     },
                          //     icon: Icon(
                          //       Icons.edit,
                          //       color: AppTheme.primary,
                          //     ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Nav.to(context, EditJobPreference());
                    },
                    child: Container(
                      width: ScreenWidth,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppTheme.primary_light,
                          borderRadius: BorderRadius.circular(05)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Job Preference ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          // IconButton(
                          //     onPressed: () {
                          //       Nav.to(context, EditJobPreference());
                          //     },
                          //     icon: Icon(
                          //       Icons.edit,
                          //       color: AppTheme.primary,
                          //     ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Nav.to(context, const EmploymentList());
                    },
                    child: Container(
                      width: ScreenWidth,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppTheme.primary_light,
                          borderRadius: BorderRadius.circular(05)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Employement Details",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          // IconButton(
                          //     onPressed: () {
                          //       // Nav.to(context, EditEmploymentDetails());
                          //       Nav.to(context, const EmploymentList());
                          //     },
                          //     icon: Icon(
                          //       Icons.edit,
                          //       color: AppTheme.primary,
                          //     ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  SizedBox(
                      width: ScreenWidth,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (isLoading == false) {
                              setState(() {
                                isLoading = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                var data = {
                                  "user_id": _userResponse['id'],
                                  "name": name.text,
                                  "email": email.text,
                                  "country_code": _SCountry_code,
                                  "mobile": mobileno.text,
                                  "password": "",
                                  "gender": selectedGender,
                                  // "dob": _dateController.text,
                                  "dob": formatDateString(_dateController.text),
                                  "country_id": countryId,
                                  "state_id": stateId,
                                  "district_id": districtId,
                                  "address": "",
                                  "latitude": "",
                                  "longitude": "",
                                  "is_notify": 0
                                };
                                print(data);
                                var result =
                                    await UserProfileApi.UpdateUserProfile(
                                        context,
                                        data,
                                        _userResponse['api_token']);
                                print(result);
                                if (result.success) {
                                  if (result.data['status'].toString() == "1") {
                                    print(result);
                                    PrefManager.write(
                                        "UserResponse", result.data);
                                    if (result.data['message'] != null) {
                                      Snackbar.show(
                                          result.data['message'], Colors.green);
                                    } else {
                                      Snackbar.show(
                                          "Update Successfully", Colors.green);
                                    }

                                    print(result.data);
                                  } else if (result.data['message'] != null) {
                                    Snackbar.show(
                                        result.data['message'], Colors.black);
                                  } else {
                                    Snackbar.show("Some Error", Colors.black);
                                  }
                                }
                              } else {
                                // Form is invalid, do something accordingly
                                print('Form is invalid');
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: !isLoading
                              ? Text("Update Profile")
                              : Loader.common())),
                  const SizedBox(
                    height: 20,
                  ),
                  // TextFormField(
                  //   // controller: mobileno,
                  //   // enabled: false,
                  //   readOnly: true,
                  //   decoration: InputDecoration(
                  //       suffixIcon: IconButton(
                  //           onPressed: () async {
                  //             await Logout.logout(context, "logout");
                  //           },
                  //           icon: const Icon(
                  //             Icons.logout,
                  //             color: Colors.red,
                  //           )),
                  //       counterText: '',
                  //       hintText: 'Logout',
                  //       hintStyle: const TextStyle(color: Colors.red)),
                  // ),
                  // InkWell(
                  //     splashColor: Colors.transparent,
                  //     highlightColor: Colors.transparent,
                  //     onTap: () {
                  //       // Nav.to(
                  //       //     context,
                  //       //     const Verification(
                  //       //       type: 'signup',
                  //       //       user_id: '',
                  //       //       mobileno: '',
                  //       //     ));
                  //       Nav.to(context, ProffesionalDetails());
                  //       // Nav.to(
                  //       //     context,
                  //       //     const Verification(
                  //       //       type: 'signup',
                  //       //       user_id: '',
                  //       //       mobileno: '',
                  //       //     ));
                  //     },
                  //     child: const Text("Job Provider"))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SelectModal extends StatefulWidget {
  const SelectModal(
      {super.key,
      required this.countryId,
      required this.StateId,
      required this.type});

  final String countryId;
  final String StateId;
  final String type;

  @override
  State<SelectModal> createState() => _SelectModalState();
}

class _SelectModalState extends State<SelectModal> {
  List list = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    // initilize();
    super.initState();
  }

  // initilize() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   if (widget.type == "country") {
  //     var get_countries = await AuthApi.getCountry(context);
  //     if (get_countries.success) {
  //       setState(() {
  //         list.addAll(get_countries.data['data'] ?? "");
  //       });
  //     }
  //   } else if (widget.type == "state") {
  //     var get_states =
  //         await AuthApi.getStates(context, {"country_id": widget.countryId});
  //     if (get_states.success) {
  //       setState(() {
  //         list.addAll(get_states.data['data'] ?? "");
  //       });
  //     }
  //   } else {
  //     var get_city = await AuthApi.getCity(
  //         context, {"state_id": widget.StateId, "search": ""});
  //     if (get_city.success) {
  //       setState(() {
  //         list.addAll(get_city.data['data'] ?? "");
  //       });
  //     }
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final data = list[index];
                        return InkWell(
                          // highlightColor: Colors.red,
                          onTap: () {
                            Nav.back(context, data);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: widget.type == "country"
                                ? Text(data['name'])
                                : widget.type == "state"
                                    ? Text(data['state_name'])
                                    : Text(data['district_name']),
                          ),
                        );
                      }),
                )
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
