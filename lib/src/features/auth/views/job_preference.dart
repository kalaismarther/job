// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/common_multiselect.dart';
import 'package:job/src/core/utils/common_search_modal.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features/auth/auth_api.dart';
import 'package:job/src/features/auth/views/employement_details.dart';

class JobPreference extends StatefulWidget {
  const JobPreference({super.key});

  @override
  State<JobPreference> createState() => _JobPreferenceState();
}

class _JobPreferenceState extends State<JobPreference> {
  final _formKey1 = GlobalKey<FormState>();
  TextEditingController country = TextEditingController();

  List skills = [
    "Design",
    "Account Management",
    "Design",
  ];
  bool isloading = false;
  List keySkills = [];
  List s_keySkills = [];
  List Industry = [];
  List s_Industry = [];
  List Depart = [];
  List S_Depart = [];
  List PreRole = [];
  List s_PreRole = [];
  List Location = [];
  List s_Location = [];

  List countries = [];

  var countryId;

  bool anyCountry = true;

  // void _searchModal() async {
  //   final result = await showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Locationsearch(location: [], s_Location: s_Location, type: "");
  //       });
  //   if (result != null) {
  //     setState(() {
  //       s_Location = result;
  //     });
  //   }
  // }
  void _SelectModal1(data, type) async {
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
        }
        // s_Location = result;
      });
    }
  }

  merge(values, name) {
    return values.map((value) => value[name]).join(',');
  }

  // void _showModal(mv, sv, type) async {
  //   final result = await showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CommonModal(
  //         districts: mv,
  //         selectedDistricts: sv,
  //         type: type,
  //       );
  //     },
  //   );

  //   if (result != null) {
  //     setState(() {
  //       if (type == "industry") {
  //         s_Industry = result;
  //       } else if (type == "depart") {
  //         S_Depart = result;
  //       } else if (type == "preffered") {
  //         s_PreRole = result;
  //       } else {
  //         s_keySkills = result;
  //       }
  //     });
  //   }
  //   _formKey1.currentState!.validate();
  // }

  void _showModal1(data, sv, type) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CommonMultiSelect(data: data, type: type, s_list: sv);
      },
    );

    if (result != null) {
      setState(() {
        if (type == "industry") {
          s_Industry = result;
        } else if (type == "depart") {
          S_Depart = result;
        } else if (type == "preffered") {
          s_PreRole = result;
        } else if (type == "p_location") {
          s_Location = result;
        } else if (type == "p_country") {
          countries = result;
        } else {
          s_keySkills = result;
        }
      });
    }
    // _formKey1.currentState!.validate();
  }

  @override
  void initState() {
    // TODO: implement initState
    // initilize();
    super.initState();
  }

  // initilize() async {
  //   var UserResponse = PrefManager.read("UserResponse");
  //   print(UserResponse);

  //   var get_skills = await AuthApi.GetSkills(
  //       context, UserResponse['data']['id'], "", UserResponse['data']['api_token']);
  //   var get_industries = await AuthApi.GetIndustried(
  //       context, UserResponse['data']['id'], "",UserResponse['data']['api_token']);
  //   var get_departments = await AuthApi.GetDepartments(
  //       context, UserResponse['data']['id'],"", UserResponse['data']['api_token']);
  //   var get_preferred_roles = await AuthApi.GetPreferredRole(
  //       context, UserResponse['data']['id'],"", UserResponse['data']['api_token']);

  //   if (get_skills.success) {
  //     setState(() {
  //       keySkills = get_skills.data['data'];
  //     });
  //   }

  //   if (get_industries.success) {
  //     setState(() {
  //       Industry = get_industries.data['data'];
  //     });
  //   }
  //   if (get_departments.success) {
  //     setState(() {
  //       Depart = get_departments.data['data'];
  //     });
  //   }
  //   if (get_preferred_roles.success) {
  //     setState(() {
  //       PreRole = get_preferred_roles.data['data'];
  //     });
  //   }
  // }

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
            key: _formKey1,
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
                            "Job Preference",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          InkWell(
                            onTap: () {
                              Nav.to(context, EmployementDetails());
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
                        "Key Skills",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.TextBoldLite),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLength: 10,
                        onTap: () {
                          // _showModal(keySkills, s_keySkills, "");
                          _showModal1([], s_keySkills, "");
                        },
                        validator: (value) {
                          if (s_keySkills.length != 0) {
                            return null;
                          } else {
                            return "Please add key skills";
                          }
                        },
                        readOnly: true,
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
                          hintText: 'Add Maximum Key Skills',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        spacing: 3.0,
                        runSpacing: 2.0,
                        children: s_keySkills
                            .asMap()
                            .entries
                            .map(
                              (entry) => GestureDetector(
                                onTap: () {
                                  // Remove the skill when the close icon is clicked
                                  setState(() {
                                    s_keySkills.removeAt(entry.key);
                                  });
                                },
                                child: Chip(
                                  labelStyle:
                                      TextStyle(color: AppTheme.primary),
                                  side: BorderSide(color: AppTheme.primary),
                                  padding: EdgeInsets.all(0.0),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        entry.value['skill_name'] ?? "",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Icon(
                                        Icons.close,
                                        size: 15,
                                        color: AppTheme.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),

                      // Wrap(
                      //   spacing: 3.0, // Adjust the spacing between skills
                      //   runSpacing: 2.0, // Adjust the spacing between lines
                      //   children: s_keySkills
                      //       .map(
                      //         (skill) => Chip(
                      //           labelStyle: TextStyle(color: AppTheme.primary),
                      //           side: BorderSide(color: AppTheme.primary),
                      //           padding: EdgeInsets.all(0.0),
                      //           materialTapTargetSize:
                      //               MaterialTapTargetSize.shrinkWrap,
                      //           label: Row(
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: [
                      //               Text(
                      //                 skill['skill_name'] ?? "",
                      //                 style: TextStyle(fontSize: 10),
                      //               ),
                      //               Icon(
                      //                 Icons.close,
                      //                 size: 15,
                      //                 color: AppTheme.primary,
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       )
                      //       .toList(),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Industry",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.TextBoldLite),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        maxLength: 10,
                        onTap: () {
                          // _showModal(Industry, s_Industry, "industry");
                          _showModal1([], s_Industry, "industry");
                        },
                        validator: (value) {
                          if (s_Industry.length != 0) {
                            return null;
                          } else {
                            return "Please add Industry";
                          }
                        },
                        readOnly: true,
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
                          hintText: 'Minimum 1 industries can be selected',
                        ),
                      ),
                      // Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     child: DropdownButtonFormField(
                      //       hint: const Text(
                      //         'Maximum 2 industries can be selected',
                      //         style: TextStyle(fontSize: 14),
                      //       ),
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
                      //       onChanged: (value) {},
                      //       items: Industry
                      //           .map<DropdownMenuItem<String>>((item) {
                      //         return DropdownMenuItem(
                      //           value: item['id'].toString(),
                      //           child: Text(item['industry_name']),
                      //         );
                      //       }).toList(),
                      //     )),
                      const SizedBox(
                        height: 10,
                      ),
                      // Wrap(
                      //   spacing: 3.0, // Adjust the spacing between skills
                      //   runSpacing: 2.0, // Adjust the spacing between lines
                      //   children: skills
                      //       .map(
                      //         (skill) => Chip(
                      //           labelStyle: TextStyle(color: AppTheme.primary),
                      //           side: BorderSide(color: AppTheme.primary),
                      //           padding: EdgeInsets.all(0.0),
                      //           materialTapTargetSize:
                      //               MaterialTapTargetSize.shrinkWrap,
                      //           label: Row(
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: [
                      //               Text(
                      //                 skill,
                      //                 style: TextStyle(fontSize: 10),
                      //               ),
                      //               Icon(
                      //                 Icons.close,
                      //                 size: 15,
                      //                 color: AppTheme.primary,
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       )
                      //       .toList(),
                      // ),

                      Wrap(
                        spacing: 3.0,
                        runSpacing: 2.0,
                        children: s_Industry
                            .asMap()
                            .entries
                            .map(
                              (entry) => GestureDetector(
                                onTap: () {
                                  // Remove the skill when the close icon is clicked
                                  setState(() {
                                    s_Industry.removeAt(entry.key);
                                  });
                                },
                                child: Chip(
                                  labelStyle:
                                      TextStyle(color: AppTheme.primary),
                                  side: BorderSide(color: AppTheme.primary),
                                  padding: EdgeInsets.all(0.0),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        entry.value['industry_name'] ?? "",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Icon(
                                        Icons.close,
                                        size: 15,
                                        color: AppTheme.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Department / Function",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.TextBoldLite),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLength: 10,
                        onTap: () {
                          // _showModal(Depart, S_Depart, "depart");
                          _showModal1([], S_Depart, "depart");
                        },
                        validator: (value) {
                          if (S_Depart.length != 0) {
                            return null;
                          } else {
                            return "Please add Department/Function";
                          }
                        },
                        readOnly: true,
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
                          hintText: 'Minimum 1 department can be selected',
                        ),
                      ),
                      // Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     child: DropdownButtonFormField(
                      //       hint: const Text(
                      //         'Maximum 2 industries can be selected',
                      //         style: TextStyle(fontSize: 14),
                      //       ),
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
                      //       onChanged: (value) {},
                      //       items: ['Salem', 'Chennai', 'Perumpakkam']
                      //           .map<DropdownMenuItem<String>>((item) {
                      //         return DropdownMenuItem(
                      //           value: item,
                      //           child: Text(item),
                      //         );
                      //       }).toList(),
                      //     )),
                      const SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        spacing: 3.0,
                        runSpacing: 2.0,
                        children: S_Depart.asMap()
                            .entries
                            .map(
                              (entry) => GestureDetector(
                                onTap: () {
                                  // Remove the skill when the close icon is clicked
                                  setState(() {
                                    S_Depart.removeAt(entry.key);
                                  });
                                },
                                child: Chip(
                                  labelStyle:
                                      TextStyle(color: AppTheme.primary),
                                  side: BorderSide(color: AppTheme.primary),
                                  padding: EdgeInsets.all(0.0),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        entry.value['department_name'] ?? "",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Icon(
                                        Icons.close,
                                        size: 15,
                                        color: AppTheme.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Preferred Role",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.TextBoldLite),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        // maxLength: 10,
                        readOnly: true,
                        onTap: () {
                          // _showModal(PreRole, s_PreRole, "preffered");
                          _showModal1([], s_PreRole, "preffered");
                        },
                        validator: (value) {
                          if (s_PreRole.length != 0) {
                            return null;
                          } else {
                            return "Please add Preffered Role";
                          }
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
                          hintText: 'Minimum 1 preferred role can be selected',
                        ),
                      ),
                      // Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     child: DropdownButtonFormField(
                      //       hint: const Text(
                      //         'Maximum 2 Roles can be selected',
                      //         style: TextStyle(fontSize: 14),
                      //       ),
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
                      //       onChanged: (value) {},
                      //       items: ['Salem', 'Chennai', 'Perumpakkam']
                      //           .map<DropdownMenuItem<String>>((item) {
                      //         return DropdownMenuItem(
                      //           value: item,
                      //           child: Text(item),
                      //         );
                      //       }).toList(),
                      //     )),
                      const SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        spacing: 3.0,
                        runSpacing: 2.0,
                        children: s_PreRole
                            .asMap()
                            .entries
                            .map(
                              (entry) => GestureDetector(
                                onTap: () {
                                  // Remove the skill when the close icon is clicked
                                  setState(() {
                                    s_PreRole.removeAt(entry.key);
                                  });
                                },
                                child: Chip(
                                  labelStyle:
                                      TextStyle(color: AppTheme.primary),
                                  side: BorderSide(color: AppTheme.primary),
                                  padding: EdgeInsets.all(0.0),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        entry.value['role_name'] ?? "",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Icon(
                                        Icons.close,
                                        size: 15,
                                        color: AppTheme.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Preferred Country",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.TextBoldLite),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CheckboxListTile(
                        title: const Text('All countries'),
                        contentPadding: EdgeInsets.all(0),
                        value: anyCountry,
                        onChanged: (value) {
                          setState(() {
                            anyCountry = !anyCountry;
                          });
                          countries.clear();
                          s_Location.clear();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        // maxLength: 10,aa
                        enabled: anyCountry ? false : true,
                        readOnly: true,
                        controller: country,
                        onTap: () async {
                          print("Success");
                          // final result = _SelectModal("", "", "country");
                          // final result = _SelectModal1([], "country");
                          _showModal1([], countries, "p_country");
                        },
                        validator: (value) {
                          if (anyCountry) {
                            return null;
                          } else {
                            if (countries.isEmpty) {
                              return 'Please Select Country';
                            }
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Image.asset(
                          //     "assets/icons/countries.png",
                          //     height: 20,
                          //     width: 20,
                          //   ),
                          // ),
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
                        height: 10,
                      ),
                      Wrap(
                        spacing: 3.0,
                        runSpacing: 2.0,
                        children: countries
                            .asMap()
                            .entries
                            .map(
                              (entry) => GestureDetector(
                                onTap: () {
                                  // Remove the skill when the close icon is clicked
                                  setState(() {
                                    countries.removeAt(entry.key);
                                  });
                                },
                                child: Chip(
                                  labelStyle:
                                      TextStyle(color: AppTheme.primary),
                                  side: BorderSide(color: AppTheme.primary),
                                  padding: EdgeInsets.all(0.0),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        entry.value['name'] ?? "",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Icon(
                                        Icons.close,
                                        size: 15,
                                        color: AppTheme.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Preferred Location",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.TextBoldLite),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        enabled: anyCountry ? false : true,
                        maxLength: 10,
                        onTap: () async {
                          // _showModal(PreRole, s_PreRole, "preffered");
                          // _searchModal();
                          _showModal1(countries.map((e) => e['id']).toList(),
                              s_Location, "p_location");
                        },
                        validator: (value) {
                          if (s_Location.length != 0) {
                            return null;
                          } else {
                            return "Please add Preferred location";
                          }
                        },
                        readOnly: true,
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
                          hintText: 'Minimum 1 location can be selected',
                        ),
                      ),

                      // Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     child: DropdownButtonFormField(
                      //       hint: SizedBox(
                      //         width: ScreenWidth * 0.75,
                      //         child: const Text(
                      //           'Add Location (s) you want to work from home',
                      //           style: TextStyle(fontSize: 14),
                      //           overflow: TextOverflow.ellipsis,
                      //         ),
                      //       ),
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
                      //       onChanged: (value) {},
                      //       items: ['Salem', 'Chennai', 'Perumpakkam']
                      //           .map<DropdownMenuItem<String>>((item) {
                      //         return DropdownMenuItem(
                      //           value: item,
                      //           child: Text(item),
                      //         );
                      //       }).toList(),
                      //     )),
                      // const SizedBox(
                      //   height: 30,
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        spacing: 3.0,
                        runSpacing: 2.0,
                        children: s_Location
                            .asMap()
                            .entries
                            .map(
                              (entry) => GestureDetector(
                                onTap: () {
                                  // Remove the skill when the close icon is clicked
                                  setState(() {
                                    s_Location.removeAt(entry.key);
                                  });
                                },
                                child: Chip(
                                  labelStyle:
                                      TextStyle(color: AppTheme.primary),
                                  side: BorderSide(color: AppTheme.primary),
                                  padding: EdgeInsets.all(0.0),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        entry.value['district_name'] ?? "",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Icon(
                                        Icons.close,
                                        size: 15,
                                        color: AppTheme.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                          width: ScreenWidth,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey1.currentState!.validate()) {
                                  if (isloading == false) {
                                    setState(() {
                                      isloading = true;
                                    });
                                    var UserResponse =
                                        PrefManager.read("UserResponse");
                                    var data = {
                                      "user_id": UserResponse['data']['id'],
                                      "skills":
                                          merge(s_keySkills, "skill_name"),
                                      "industry_ids": merge(s_Industry, "id"),
                                      "department_ids": merge(S_Depart, "id"),
                                      "preferred_role_ids":
                                          merge(s_PreRole, "id"),
                                      "preferred_location_ids": anyCountry
                                          ? 0
                                          : merge(s_Location, "id"),
                                      "country_id": anyCountry
                                          ? 0
                                          : merge(countries, "id"),
                                    };
                                    print(data);

                                    var result =
                                        await AuthApi.updateUserPreference(
                                            context,
                                            data,
                                            UserResponse['data']['api_token']);

                                    if (result.success) {
                                      if (result.data['status'].toString() ==
                                          "1") {
                                        print("=========================");
                                        print(result);
                                        Snackbar.show(
                                            "Successfully", Colors.green);
                                        Nav.to(context, EmployementDetails());
                                        // Nav.offAll(
                                        //     context,
                                        //     Dashboard(
                                        //       current_index: 0,
                                        //     ));
                                      } else if (result.data['message'] !=
                                          null) {
                                        Snackbar.show(result.data['message'],
                                            Colors.black);
                                      } else {
                                        Snackbar.show("Some Error", Colors.red);
                                      }
                                    } else {
                                      Snackbar.show("Some Error", Colors.red);
                                    }
                                  }

                                  setState(() {
                                    isloading = false;
                                  });
                                }

                                // Nav.to(context, const JobPreference());
                              },
                              child: !isloading
                                  ? Text("Submit")
                                  : Loader.common())),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
