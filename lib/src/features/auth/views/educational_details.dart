// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/common_search_modal.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features/auth/auth_api.dart';
import 'package:job/src/features/auth/views/job_preference.dart';

class EducationalDetails extends StatefulWidget {
  const EducationalDetails({super.key});

  @override
  State<EducationalDetails> createState() => _EducationalDetailsState();
}

class _EducationalDetailsState extends State<EducationalDetails> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController qulification = TextEditingController();
  TextEditingController specialization = TextEditingController();
  TextEditingController university = TextEditingController();
  TextEditingController year = TextEditingController();

  String EducationType = '';
  bool isLoading = false;
  var s_qulId = "";
  var s_specId = "";
  var s_uniName = "";
  var s_yr = "";

  List Qualification = [];
  List Specialisations = [];
  List University = [];
  List years = [];

  @override
  void initState() {
    // TODO: implement initState
    // initilize();
    super.initState();
  }

  // initilize() async {
  // var UserResponse = PrefManager.read("UserResponse");
  // var qul_result = await AuthApi.GetQualification(
  //     context, UserResponse['data']['id'], "", UserResponse['data']['api_token']);
  // var spl_result = await AuthApi.GetSpecialisations(
  //     context, UserResponse['data']['id'],"", UserResponse['data']['api_token']);
  // var uni_result = await AuthApi.GetIndustried(
  //     context, UserResponse['data']['id'], UserResponse['data']['api_token']);
  // var yr_result = await AuthApi.GetYears(
  //     context, UserResponse['data']['id'], UserResponse['data']['api_token']);

  // if (qul_result.success) {
  //   setState(() {
  //     Qualification = qul_result.data['data'];
  //   });
  // }

  // if (spl_result.success) {
  //   setState(() {
  //     Specialisations = spl_result.data['data'];
  //   });
  // }
  // if (uni_result.success) {
  //   setState(() {
  //     University = uni_result.data['data'];
  //   });
  // }
  // if (yr_result.success) {
  //   setState(() {
  //     years = yr_result.data['data'];
  //   });
  // }
  // }

  void _modal(data, type) async {
    final result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CommonSearchModal(data: data, type: type);
        });
    if (result != null) {
      setState(() {
        if (type == "qul") {
          qulification.text = result['qualification'] ?? "";
          s_qulId = result['id'].toString();
        }
        if (type == "specification") {
          specialization.text = result['specialise_name'] ?? "";
          s_specId = result['id'].toString();
        }
        if (type == "year") {
          year.text = (result['year'] ?? "").toString();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    double ScreenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: ScreenWidth,
                  height: ScreenHeight * 0.3,
                  // padding: const EdgeInsets.all(30.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0))),
                  child: Center(
                    child: SizedBox(
                      child: Image.asset("assets/images/logo_light.png"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Update Profile",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Educational Details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          InkWell(
                            onTap: () {
                              Nav.to(context, JobPreference());
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 2, bottom: 2, right: 6, left: 6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: AppTheme.primary),
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Highest Qualification",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.TextBoldLite),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: qulification,
                        onTap: () async {
                          print("success");
                          _modal([], "qul");
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Select Qualification';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          counterText: '',
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
                          hintText: 'Highest Qualification',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Specialization/Major",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.TextBoldLite),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: specialization,
                        onTap: () async {
                          _modal([], "specification");
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Select Specialization';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          counterText: '',
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
                          hintText: 'Specialization',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "University/Institute",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.TextBoldLite),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        // readOnly: true,
                        controller: university,
                        onTap: () async {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter a University/Institute';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          // suffixIcon: SizedBox(
                          //     width: 15,
                          //     height: 15,
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(17.0),
                          //       child: Image.asset(
                          //         "assets/icons/down.png",
                          //         fit: BoxFit.contain,
                          //       ),
                          //     )),
                          hintText: 'University/Institute',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Years of Graduation",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.TextBoldLite),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: year,
                        onTap: () async {
                          _modal([], "year");
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Select Year';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          counterText: '',
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
                          hintText: 'Year',
                        ),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     child: DropdownButtonFormField(
                      //       hint: const Text(
                      //         'Qualification',
                      //         style: TextStyle(fontSize: 14),
                      //       ),
                      //       validator: (value) {
                      //         if (value == null || value.isEmpty) {
                      //           return 'Please select Qualification ';
                      //         }
                      //         return null;
                      //       },
                      //       icon: Padding(
                      //         padding: const EdgeInsets.only(right: 10.0),
                      //         child: Icon(
                      //           Icons.keyboard_arrow_down,
                      //           color: AppTheme.TextBoldLite,
                      //           size: 25,
                      //         ),
                      //       ),
                      //       decoration: InputDecoration(
                      //         enabledBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //             borderSide: BorderSide.none),
                      //         focusedBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //             borderSide: BorderSide.none),
                      //         // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //         //  filled: true,
                      //         //  fillColor: Colors.greenAccent,
                      //       ),
                      //       onChanged: (value) {
                      //         setState(() {
                      //           s_qulId = value.toString();
                      //         });
                      //       },
                      //       items: Qualification.map<DropdownMenuItem<String>>(
                      //           (item) {
                      //         return DropdownMenuItem(
                      //           value: item['id'].toString(),
                      //           child: Text(item['qualification']),
                      //         );
                      //       }).toList(),
                      //     )),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Text(
                      //   "Specialization/Major",
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       color: AppTheme.TextBoldLite),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     child: DropdownButtonFormField(
                      //       hint: const Text(
                      //         'Specialization',
                      //         style: TextStyle(fontSize: 14),
                      //       ),
                      //       validator: (value) {
                      //         if (value == null || value.isEmpty) {
                      //           return 'Please select Specialization ';
                      //         }
                      //         return null;
                      //       },
                      //       icon: Padding(
                      //         padding: const EdgeInsets.only(right: 10.0),
                      //         child: Icon(
                      //           Icons.keyboard_arrow_down,
                      //           color: AppTheme.TextBoldLite,
                      //           size: 25,
                      //         ),
                      //       ),
                      //       decoration: InputDecoration(
                      //         enabledBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //             borderSide: BorderSide.none),
                      //         focusedBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //             borderSide: BorderSide.none),
                      //         // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //         //  filled: true,
                      //         //  fillColor: Colors.greenAccent,
                      //       ),
                      //       onChanged: (value) {
                      //         setState(() {
                      //           s_specId = value.toString();
                      //         });
                      //       },
                      //       items: Specialisations.map<DropdownMenuItem<String>>(
                      //           (item) {
                      //         return DropdownMenuItem(
                      //           value: item['id'].toString(),
                      //           child: Text(item['specialise_name']),
                      //         );
                      //       }).toList(),
                      //     )),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Text(
                      //   "University/Institute",
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       color: AppTheme.TextBoldLite),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     child: DropdownButtonFormField(
                      //       hint: const Text(
                      //         'University/Institute',
                      //         style: TextStyle(fontSize: 14),
                      //       ),
                      //       validator: (value) {
                      //         if (value == null || value.isEmpty) {
                      //           return 'Please select University/Institute ';
                      //         }
                      //         return null;
                      //       },
                      //       icon: Padding(
                      //         padding: const EdgeInsets.only(right: 10.0),
                      //         child: Icon(
                      //           Icons.keyboard_arrow_down,
                      //           color: AppTheme.TextBoldLite,
                      //           size: 25,
                      //         ),
                      //       ),
                      //       decoration: InputDecoration(
                      //         enabledBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //             borderSide: BorderSide.none),
                      //         focusedBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //             borderSide: BorderSide.none),
                      //         // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //         //  filled: true,
                      //         //  fillColor: Colors.greenAccent,
                      //       ),
                      //       onChanged: (value) {
                      //         setState(() {
                      //           s_uniName = value.toString();
                      //         });
                      //       },
                      //       items:
                      //           University.map<DropdownMenuItem<String>>((item) {
                      //         return DropdownMenuItem(
                      //           value: item['industry_name'].toString(),
                      //           child: Text(item['industry_name']),
                      //         );
                      //       }).toList(),
                      //     )),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Text(
                      //   "Years of Graduation",
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       color: AppTheme.TextBoldLite),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     child: DropdownButtonFormField(
                      //       hint: const Text(
                      //         'Year',
                      //         style: TextStyle(fontSize: 14),
                      //       ),
                      //       validator: (value) {
                      //         if (value == null || value.isEmpty) {
                      //           return 'Please select Year ';
                      //         }
                      //         return null;
                      //       },
                      //       icon: Padding(
                      //         padding: const EdgeInsets.only(right: 10.0),
                      //         child: Icon(
                      //           Icons.keyboard_arrow_down,
                      //           color: AppTheme.TextBoldLite,
                      //           size: 25,
                      //         ),
                      //       ),
                      //       decoration: InputDecoration(
                      //         enabledBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //             borderSide: BorderSide.none),
                      //         focusedBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //             borderSide: BorderSide.none),
                      //         // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //         //  filled: true,
                      //         //  fillColor: Colors.greenAccent,
                      //       ),
                      //       onChanged: (value) {
                      //         s_yr = value.toString();
                      //       },
                      //       items: years.map<DropdownMenuItem<String>>((item) {
                      //         return DropdownMenuItem(
                      //           value: item['year'].toString(),
                      //           child: Text(item['year'].toString()),
                      //         );
                      //       }).toList(),
                      //     )),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Education Type",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.TextBoldLite),
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio(
                            value: '1',
                            groupValue: EducationType,
                            onChanged: (value) {
                              setState(() {
                                EducationType = value.toString();
                              });
                            },
                          ),
                          const Text(
                            'Full Time',
                            style: TextStyle(fontSize: 12),
                          ),
                          Radio(
                            value: '2',
                            groupValue: EducationType,
                            onChanged: (value) {
                              setState(() {
                                EducationType = value.toString();
                              });
                            },
                          ),
                          const Text('Part Time',
                              style: TextStyle(fontSize: 12)),
                          Radio(
                            value: '3',
                            groupValue: EducationType,
                            onChanged: (value) {
                              setState(() {
                                EducationType = value.toString();
                              });
                            },
                          ),
                          const Flexible(
                              child: Text('Correspondence',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12))),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                          width: ScreenWidth,
                          child: ElevatedButton(
                              onPressed: () async {
                                var UserResponse =
                                    PrefManager.read("UserResponse");
                                if (isLoading == false) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (_formKey.currentState!.validate()) {
                                    if (EducationType == "") {
                                      Snackbar.show(
                                          "Please Select Education Type",
                                          Colors.black);
                                    } else {
                                      var data = {
                                        "user_id": UserResponse['data']['id'],
                                        "qualification_id": s_qulId,
                                        "specialisation_id": s_specId,
                                        "institute_name": university.text,
                                        "year_of_graduation": year.text,
                                        "education_type": EducationType
                                      };
                                      var result =
                                          await AuthApi.updateUserEducation(
                                              context,
                                              data,
                                              UserResponse['data']
                                                  ['api_token']);
                                      if (result.success) {
                                        if (result.data['status'].toString() ==
                                            "1") {
                                          Snackbar.show("Update Successfully",
                                              Colors.green);
                                          Nav.to(context, JobPreference());
                                        } else if (result.data['message'] !=
                                            null) {
                                          Snackbar.show(result.data['message'],
                                              Colors.black);
                                        } else {
                                          Snackbar.show(
                                              "Some Error", Colors.black);
                                        }
                                      } else {
                                        Snackbar.show("Some Error", Colors.red);
                                      }
                                      print(data);
                                    }
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                }

                                // Nav.to(context, const JobPreference());
                              },
                              child: !isLoading
                                  ? Text("Continue")
                                  : Loader.common())),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
