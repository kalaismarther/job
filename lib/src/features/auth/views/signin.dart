// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, unused_field, unused_local_variable

import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/common_search_modal.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/core/utils/validate.dart';
import 'package:job/src/features/auth/auth_api.dart';
import 'package:job/src/features/auth/views/terms_conditions.dart';
import 'package:job/src/features/auth/views/verification.dart';

// enum SingingCharacter { lafayette, jefferson }

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  TextEditingController mobileno = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  // TextEditingController city = TextEditingController();
  TextEditingController district = TextEditingController();

  final GlobalKey<FormState> _dropdown1Key = GlobalKey<FormState>();

  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();

  bool visiable = false;
  // SingingCharacter? _character = SingingCharacter.lafayette;
  String selectedGender = '';
  bool isLoading = false;
  bool acceptTerms = false;
  bool stateLoad = false;
  bool cityLoad = false;
  bool check_s = false;
  bool check_c = false;
  var _SCountry = "";
  var _SCountry_code = "";
  var _SState = "";
  var _SCity = "";
  var back_userId = "0";
  var countryId;
  var stateId;
  var districtId;

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
    // initilize();
    super.initState();
  }

  // initilize() async {
  //   var get_countries = await AuthApi.getCountry(context);
  //   var get_states = await AuthApi.getStates(context, {"country_id": 101});
  //   var get_city =
  //       await AuthApi.getStates(context, {"state_id": 4035, "search": ""});

  //   if (get_countries.success) {
  //     setState(() {
  //       Countries.addAll(get_countries.data['data'] ?? "");
  //     });
  //   }

  //   print(get_states);
  //   print(get_countries);
  //   print(get_city);
  // }

  void change(value) {
    State = value;
  }

  String formatDateString(String inputDate) {
    DateTime dateTime = DateFormat("dd-MM-yyyy").parse(inputDate);
    String formattedDate = DateFormat("yyyy-MM-dd").format(dateTime);
    return formattedDate;
  }

  Future<void> districtModal(data, type) async {
    final result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CommonSearchModal(data: data, type: type);
        });

    if (result != null) {
      print(result);
      setState(() {
        _SCity = (result['id'] ?? "").toString();
        district.text = result['district_name'] ?? "";
      });
    }
  }

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
          _SCountry_code = result['phonecode'].toString();
          state.text = "";
          city.text = "";
          districtId = "";
          stateId = "";
          stateLoad = true;
          cityLoad = false;
        } else if (type == "state") {
          state.text = result['state_name'] ?? "";
          stateId = result['id'] ?? "";
          districtId = "";
          city.text = "";
          cityLoad = true;
        } else {
          city.text = result['district_name'] ?? "";
          districtId = result['id'] ?? "";
        }
        // s_Location = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    double ScreenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ScreenWidth,
                height: ScreenHeight * 0.35,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25.0),
                        bottomRight: Radius.circular(25.0))),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // Helper().ExitDialog(context);
                        Nav.back(context);
                      },
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: const EdgeInsets.only(top: 30),
                            height: 40,
                            child: Image.asset("assets/icons/back.png")),
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: Image.asset("assets/images/logo_light.png"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Job Seekers",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppTheme.primary),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
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
                        controller: mobileno,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          // LengthLimitingTextInputFormatter(2),
                          // FilteringTextInputFormatter.deny(RegExp('0')),
                        ],
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
                          // labelText: "Password"
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        // maxLength: 10,
                        controller: password,
                        obscureText: !visiable,
                        validator: Validate.password,
                        // keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          counterText: '',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              "assets/icons/lock.png",
                              height: 20,
                              width: 20,
                            ),
                          ),
                          suffixIcon: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                visiable = !visiable;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                !visiable
                                    ? "assets/icons/hide.png"
                                    : "assets/icons/visible.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ),
                          hintText: 'Password',
                          // labelText: "Password"
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
                              "assets/icons/city.png",
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
                        // maxLength: 10,aa
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
                          if (!stateLoad) {
                            Snackbar.show(
                                "Please Select Country", Colors.black);
                          } else {
                            _SelectModal1([
                              {"country_id": countryId.toString()}
                            ], "state");
                          }
                          // _SelectModal("", countryId.toString(), "state");
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
                        maxLength: 10,
                        readOnly: true,
                        controller: city,
                        onTap: () {
                          if (stateId == null || stateId == "" || !cityLoad) {
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
                          counterText: '',
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
                      // Container(
                      //     // margin: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(10.0),
                      //       // boxShadow: [
                      //       //   BoxShadow(
                      //       //     color: Colors.grey.withOpacity(0.2),
                      //       //     spreadRadius: 2,
                      //       //     blurRadius: 3,
                      //       //     offset: Offset(0, 1), // changes position of shadow
                      //       //   ),
                      //       // ],
                      //     ),
                      //     // height: 50,
                      //     child: DropdownButtonFormField(
                      //       hint: const Text(
                      //         'Country',
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
                      //         prefixIcon: Padding(
                      //           padding: const EdgeInsets.all(12.0),
                      //           child: Image.asset(
                      //             "assets/icons/countries.png",
                      //             height: 20,
                      //             width: 20,
                      //           ),
                      //         ),
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
                      //       validator: (value) {
                      //         if (value == null || value.isEmpty) {
                      //           return 'Please select an option';
                      //         }
                      //         return null;
                      //       },
                      //       onChanged: (value) async {
                      //         print(value?.split("&*"));
                      //         var _v = value?.split("&*");
                      //         var _c_id = _v?[0];
                      //         var _c_code = _v?[1];
                      //         print(value);
                      //         setState(() {
                      //           _SCountry = _c_id!;
                      //           _SCountry_code = _c_code!;
                      //           _SState = "";
                      //           _SCity = "";
                      //           State = [
                      //             {
                      //               "id": "0",
                      //               "state_name": "Please Select Country"
                      //             }
                      //           ];
                      //           Citys = [
                      //             {
                      //               "id": "0",
                      //               "district_name": "Please Select State"
                      //             }
                      //           ];
                      //           stateLoad = true;
                      //         });
                      //         var get_states = await AuthApi.getStates(
                      //             context, {"country_id": _c_id});
                      //         // print(get_states.data);
                      //         setState(() {
                      //           stateLoad = false;
                      //           cityLoad = false;
                      //           //  _dropdown1Key.currentState?.reset();
                      //           // _SState = "";
                      //           // _dropdown1Key.currentState?.reset();
                      //           // change(get_states.data['data']);
                      //           if (get_states.data['data'] != null) {
                      //             State = get_states.data['data'];
                      //           } else {
                      //             State = [
                      //               {"id": "0", "state_name": "No State List"}
                      //             ];
                      //           }
                      //         });
                      //       },
                      //       items:
                      //           Countries.map<DropdownMenuItem<String>>((item) {
                      //         return DropdownMenuItem(
                      //           value: item['id'].toString() +
                      //               "&*" +
                      //               item['phonecode'].toString(),
                      //           child: SizedBox(
                      //             width: ScreenWidth * 0.7,
                      //             child: Text(
                      //               item['name'] ?? "",
                      //               overflow: TextOverflow.ellipsis,
                      //             ),
                      //           ),
                      //         );
                      //       }).toList(),
                      //     )),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Container(
                      //     // margin: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(10.0),
                      //       // boxShadow: [
                      //       //   BoxShadow(
                      //       //     color: Colors.grey.withOpacity(0.2),
                      //       //     spreadRadius: 2,
                      //       //     blurRadius: 3,
                      //       //     offset: Offset(0, 1), // changes position of shadow
                      //       //   ),
                      //       // ],
                      //     ),
                      //     // height: 50,
                      //     child: AbsorbPointer(
                      //       absorbing: false,
                      //       child: DropdownButtonFormField(

                      //           // key: _dropdown1Key,
                      //           validator: (value) {
                      //             if (value == null ||
                      //                 value.isEmpty ||
                      //                 value == "0") {
                      //               return 'Please select an option';
                      //             }
                      //             return null;
                      //           },
                      //           // isDense: true,
                      //           hint: Text(
                      //             stateLoad
                      //                 ? "State list loading ....."
                      //                 : 'State',
                      //             style: TextStyle(fontSize: 14),
                      //           ),
                      //           icon: Padding(
                      //             padding: const EdgeInsets.only(right: 10.0),
                      //             child: Icon(
                      //               Icons.keyboard_arrow_down,
                      //               color: AppTheme.TextBoldLite,
                      //               size: 25,
                      //             ),
                      //           ),
                      //           decoration: InputDecoration(
                      //             prefixIcon: Padding(
                      //               padding: const EdgeInsets.all(12.0),
                      //               child: Image.asset(
                      //                 "assets/icons/state.png",
                      //                 height: 20,
                      //                 width: 20,
                      //               ),
                      //             ),
                      //             enabledBorder: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(10),
                      //                 borderSide: BorderSide.none),
                      //             focusedBorder: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(10),
                      //                 borderSide: BorderSide.none),
                      //             // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                      //             border: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //             //  filled: true,
                      //             //  fillColor: Colors.greenAccent,
                      //           ),
                      //           value: _SState.isNotEmpty ? _SState : null,
                      //           onChanged: (value) async {
                      //             setState(() {
                      //               // cityLoad = true;
                      //               _SState = value!;
                      //             });
                      //             var get_city = await AuthApi.getCity(
                      //                 context, {"state_id": value, "search": ""});
                      //             print(get_city);
                      //             setState(() {
                      //               // stateLoad = false;
                      //               cityLoad = true;

                      //               //  _dropdown1Key.currentState?.reset();
                      //               _SCity = "";
                      //               // _dropdown1Key.currentState?.reset();
                      //               // change(get_states.data['data']);
                      //               if (get_city.data['data'] != null) {
                      //                 Citys = get_city.data['data'];
                      //               } else {
                      //                 Citys = [
                      //                   {
                      //                     "id": "0",
                      //                     "district_name": "No City List"
                      //                   }
                      //                 ];
                      //               }
                      //             });
                      //           },
                      //           items: !stateLoad
                      //               ? State.map<DropdownMenuItem<String>>((item) {
                      //                   return DropdownMenuItem(
                      //                     value: item['id'].toString(),
                      //                     child: SizedBox(
                      //                         width: ScreenWidth * 0.7,
                      //                         child:
                      //                             Text(item['state_name'] ?? "")),
                      //                   );
                      //                 }).toList()
                      //               : ["State list loading..."]
                      //                   .map<DropdownMenuItem<String>>((item) {
                      //                   return DropdownMenuItem(
                      //                     value: item,
                      //                     child: SizedBox(
                      //                         width: ScreenWidth * 0.7,
                      //                         child: Text(item)),
                      //                   );
                      //                 }).toList()),
                      //     )),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // cityLoad
                      //     ? TextFormField(
                      //         // maxLength: 10,
                      //         controller: district,
                      //         readOnly: true,
                      //         onTap: () async {
                      //           districtModal([
                      //             {"id": _SState.toString()}
                      //           ], "district");
                      //         },
                      //         // validator: Validate.email,
                      //         validator: (value) {
                      //           if (value == null || value.isEmpty) {
                      //             return 'Please select district';
                      //           }
                      //           return null;
                      //         },
                      //         // keyboardType: TextInputType.phone,
                      //         decoration: InputDecoration(
                      //           counterText: '',
                      //           prefixIcon: Padding(
                      //             padding: const EdgeInsets.all(12.0),
                      //             child: Image.asset(
                      //               "assets/icons/city.png",
                      //               height: 20,
                      //               width: 20,
                      //             ),
                      //           ),
                      //           suffixIcon: SizedBox(
                      //               width: 15,
                      //               height: 15,
                      //               child: Padding(
                      //                 padding: const EdgeInsets.all(18.0),
                      //                 child: Image.asset(
                      //                   "assets/icons/down.png",
                      //                   fit: BoxFit.contain,
                      //                 ),
                      //               )),
                      //           hintText: 'District',
                      //           // labelText: "Password"
                      //         ),
                      //       )
                      //     : Container(
                      //         // margin: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                      //         decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(10.0),
                      //           // boxShadow: [
                      //           //   BoxShadow(
                      //           //     color: Colors.grey.withOpacity(0.2),
                      //           //     spreadRadius: 2,
                      //           //     blurRadius: 3,
                      //           //     offset: Offset(0, 1), // changes position of shadow
                      //           //   ),
                      //           // ],
                      //         ),
                      //         // height: 50,
                      //         child: AbsorbPointer(
                      //           absorbing: cityLoad,
                      //           child: DropdownButtonFormField(
                      //             hint: Text(
                      //               cityLoad
                      //                   ? "District list loading ..."
                      //                   : 'District',
                      //               style: TextStyle(fontSize: 14),
                      //             ),
                      //             icon: Padding(
                      //               padding: const EdgeInsets.only(right: 10.0),
                      //               child: Icon(
                      //                 Icons.keyboard_arrow_down,
                      //                 color: AppTheme.TextBoldLite,
                      //                 size: 25,
                      //               ),
                      //             ),
                      //             decoration: InputDecoration(
                      //               prefixIcon: Padding(
                      //                 padding: const EdgeInsets.all(12.0),
                      //                 child: Image.asset(
                      //                   "assets/icons/city.png",
                      //                   height: 20,
                      //                   width: 20,
                      //                 ),
                      //               ),
                      //               enabledBorder: OutlineInputBorder(
                      //                   borderRadius: BorderRadius.circular(10),
                      //                   borderSide: BorderSide.none),
                      //               focusedBorder: OutlineInputBorder(
                      //                   borderRadius: BorderRadius.circular(10),
                      //                   borderSide: BorderSide.none),
                      //               // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                      //               border: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(10),
                      //               ),
                      //               //  filled: true,
                      //               //  fillColor: Colors.greenAccent,
                      //             ),
                      //             validator: (value) {
                      //               if (value == null || value.isEmpty) {
                      //                 return 'Please select an option';
                      //               }
                      //               return null;
                      //             },
                      //             value: _SCity.isNotEmpty ? _SCity : null,
                      //             onChanged: (value) {
                      //               setState(() {
                      //                 _SCity = value!;
                      //               });
                      //             },
                      //             items:
                      //                 Citys.map<DropdownMenuItem<String>>((item) {
                      //               return DropdownMenuItem(
                      //                 value: item['id'].toString(),
                      //                 child: SizedBox(
                      //                     width: ScreenWidth * 0.7,
                      //                     child: Text(item['district_name'])),
                      //               );
                      //             }).toList(),
                      //           ),
                      //         )),
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
                        // mainAxisAlignment: MainAxisAlignment.center,
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
                              child: Text('Prefer not to say',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12))),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: acceptTerms,
                            onChanged: (value) {
                              setState(() {
                                acceptTerms = value!;
                              });
                            },
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                // style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                      text: 'I accept the ',
                                      style: TextStyle(
                                          color: AppTheme.TextBoldLite,
                                          fontSize: 14,
                                          height: 1.3)),
                                  TextSpan(
                                    text: 'Terms and Conditions',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                        fontSize: 14),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Nav.to(
                                            context, const TermsConditions());
                                        // Navigate to a new page or perform any action here
                                        // print(
                                        //     'Navigate to Terms and Conditions page');
                                        // Add your navigation logic here
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      SizedBox(
                          width: ScreenWidth,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (isLoading == false) {
                                  if (_formKey.currentState!.validate()) {
                                    // var data = {
                                    //   "email": email.text,
                                    //   "password": mobileno.text,
                                    //   "fcm_token": "fcm_token",
                                    //   "device_id": "deviceid",
                                    //   "device_type": "IOS"
                                    // };

                                    if (selectedGender.isEmpty) {
                                      Snackbar.show(
                                          "Please Select Gender", Colors.black);
                                    } else if (acceptTerms == false) {
                                      Snackbar.show(
                                          "Please Accept Terms and Contidions",
                                          Colors.black);
                                    } else {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      var data = {
                                        "name": name.text,
                                        "email": email.text,
                                        "country_code": _SCountry_code,
                                        "mobile": mobileno.text,
                                        "password": password.text,
                                        "country_id": countryId,
                                        "state_id": stateId,
                                        "district_id": districtId,
                                        // "country_id": _SCountry,
                                        // "state_id": _SState,
                                        // "district_id": _SCity,
                                        "device_type": Platform.isAndroid
                                            ? "ANDROID"
                                            : "IOS",
                                        "device_id": "",
                                        "fcm_token": "",
                                        "gender": selectedGender,
                                        // "dob": _dateController.text,
                                        "dob": formatDateString(
                                            _dateController.text),
                                        "user_id": back_userId
                                      };
                                      print(data);

                                      var result =
                                          await AuthApi.SignUp(context, data);
                                      print(result);
                                      if (result.success) {
                                        if (result.data['status'].toString() ==
                                            "1") {
                                          PrefManager.write(
                                              "UserResponse", result.data);
                                          var bac_user = await Nav.to(
                                              context,
                                              Verification(
                                                type: "signup",
                                                user_id: result.data['data']
                                                        ['id']
                                                    .toString(),
                                                mobileno: mobileno.text,
                                              ));

                                          setState(() {
                                            if (bac_user != null) {
                                              back_userId = bac_user;
                                            }
                                          });
                                          print(result.data);
                                        } else if (result.data['message'] !=
                                            null) {
                                          Snackbar.show(result.data['message'],
                                              Colors.black);
                                        } else {
                                          Snackbar.show(
                                              "Some Error", Colors.black);
                                        }
                                      } else {
                                        Snackbar.show(
                                            "Some Error", Colors.black);
                                      }

                                      setState(() {
                                        isLoading = false;
                                      });
                                      // var result = AuthApi.SignUp(context, data);
                                      // PrefManager.write("UserResponse", data);
                                      // print("***************");
                                      // print(PrefManager.read("UserResponse"));
                                      // print(data);
                                      // Nav.to(context, Verification(type: "signup"));

                                      // var result  = AuthApi(
                                    }
                                  } else {
                                    // Form is invalid, do something accordingly
                                    print('Form is invalid');
                                  }
                                }

                                // Nav.to(
                                //     context,
                                //     const Verification(
                                //       type: 'sign',
                                //     ));
                              },
                              child:
                                  !isLoading ? Text("Next") : Loader.common())),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
