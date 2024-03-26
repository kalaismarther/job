// ignore_for_file: non_constant_identifier_names, unused_field, use_build_context_synchronously, prefer_typing_uninitialized_variables, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/common_search_modal.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features/auth/auth_api.dart';
import 'package:job/src/features1/dashboard/views/provider_dashboard.dart';

class UpdateProfile2 extends StatefulWidget {
  const UpdateProfile2({super.key});

  @override
  State<UpdateProfile2> createState() => _UpdateProfile2State();
}

class _UpdateProfile2State extends State<UpdateProfile2> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController zipcode = TextEditingController();

  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();

  bool acceptTerms = false;

  var _SCountry = "";
  var _SCountry_code = "";
  var _SState = "";
  var _SCity = "";
  bool cityLoad = false;
  bool stateLoad = false;
  bool isLoading = false;
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
  //   if (get_countries.success) {
  //     setState(() {
  //       Countries.addAll(get_countries.data['data'] ?? "");
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
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Update Profile",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                            InkWell(
                          onTap: (){
                           Nav.offAll(
                                            context, ProviderDashboard());
                          },
                           child: Container(
                            padding: EdgeInsets.only(top: 2,bottom: 2,right: 6,left: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: AppTheme.primary
                            ),
                            child: Text("Skip",style: TextStyle(color: Colors.white, fontSize: 12),),
                           ),
                         )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Company Address",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Address 1"),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        // maxLength: 10,
                        controller: address1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Address';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Image.asset(
                          //     "assets/icons/email.png",
                          //     height: 20,
                          //     width: 20,
                          //   ),
                          // ),
                          hintText: 'Enter Address',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Address 2"),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: address2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Address';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Image.asset(
                          //     "assets/icons/email.png",
                          //     height: 20,
                          //     width: 20,
                          //   ),
                          // ),
                          hintText: 'Enter Address',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Country"),
                      const SizedBox(
                        height: 10,
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
                      const Text("State"),
                      const SizedBox(
                        height: 10,
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
                      const Text("City"),
                      const SizedBox(
                        height: 10,
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
                      //           return 'Please select country';
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
                      // const Text("State"),
                      // const SizedBox(
                      //   height: 10,
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
                      //       absorbing: stateLoad,
                      //       child: DropdownButtonFormField(

                      //           // key: _dropdown1Key,
                      //           validator: (value) {
                      //             if (value == null ||
                      //                 value.isEmpty ||
                      //                 value == "0") {
                      //               return 'Please select state';
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
                      //               cityLoad = true;
                      //               _SState = value!;
                      //             });
                      //             var get_city = await AuthApi.getCity(context,
                      //                 {"state_id": value, "search": ""});
                      //             print(get_city);
                      //             setState(() {
                      //               // stateLoad = false;
                      //               cityLoad = false;

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
                      //               ? State.map<DropdownMenuItem<String>>(
                      //                   (item) {
                      //                   return DropdownMenuItem(
                      //                     value: item['id'].toString(),
                      //                     child: SizedBox(
                      //                         width: ScreenWidth * 0.7,
                      //                         child: Text(
                      //                             item['state_name'] ?? "")),
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
                      // const Text("City"),
                      // const SizedBox(
                      //   height: 10,
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
                      //       absorbing: cityLoad,
                      //       child: DropdownButtonFormField(
                      //         hint: Text(
                      //           cityLoad
                      //               ? "District list loading ..."
                      //               : 'District',
                      //           style: TextStyle(fontSize: 14),
                      //         ),
                      //         icon: Padding(
                      //           padding: const EdgeInsets.only(right: 10.0),
                      //           child: Icon(
                      //             Icons.keyboard_arrow_down,
                      //             color: AppTheme.TextBoldLite,
                      //             size: 25,
                      //           ),
                      //         ),
                      //         decoration: InputDecoration(
                      //           prefixIcon: Padding(
                      //             padding: const EdgeInsets.all(12.0),
                      //             child: Image.asset(
                      //               "assets/icons/city.png",
                      //               height: 20,
                      //               width: 20,
                      //             ),
                      //           ),
                      //           enabledBorder: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(10),
                      //               borderSide: BorderSide.none),
                      //           focusedBorder: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(10),
                      //               borderSide: BorderSide.none),
                      //           // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                      //           border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //           //  filled: true,
                      //           //  fillColor: Colors.greenAccent,
                      //         ),
                      //         validator: (value) {
                      //           if (value == null || value.isEmpty) {
                      //             return 'Please select district';
                      //           }
                      //           return null;
                      //         },
                      //         value: _SCity.isNotEmpty ? _SCity : null,
                      //         onChanged: (value) {
                      //           setState(() {
                      //             _SCity = value!;
                      //           });
                      //         },
                      //         items:
                      //             Citys.map<DropdownMenuItem<String>>((item) {
                      //           return DropdownMenuItem(
                      //             value: item['id'].toString(),
                      //             child: SizedBox(
                      //                 width: ScreenWidth * 0.7,
                      //                 child: Text(item['district_name'])),
                      //           );
                      //         }).toList(),
                      //       ),
                      //     )),
                      // const Text("Country"),
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
                      //         'Enter Country',
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
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // const Text("State"),
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
                      //         'Enter State',
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
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // const Text("City"),
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
                      //         'Enter City',
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
                        height: 20,
                      ),
                      const Text("Zip Code"),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLength: 10,
                        controller: zipcode,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          // LengthLimitingTextInputFormatter(2),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter zip code';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          counterText: '',
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Image.asset(
                          //     "assets/icons/email.png",
                          //     height: 20,
                          //     width: 20,
                          //   ),
                          // ),
                          hintText: 'Enter Zip Code',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Row(
                      //   children: [
                      //     Checkbox(
                      //       value: acceptTerms,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           acceptTerms = value!;
                      //         });
                      //       },
                      //     ),
                      // Expanded(
                      //   child: RichText(
                      //     text: TextSpan(
                      //       // style: DefaultTextStyle.of(context).style,
                      //       children: [
                      //         TextSpan(
                      //           text: 'Terms and Conditions',
                      //           style: const TextStyle(
                      //               fontWeight: FontWeight.bold,
                      //               color: Colors.blue,
                      //               fontSize: 14),
                      //           recognizer: TapGestureRecognizer()
                      //             ..onTap = () {
                      //               // Nav.to(context, const TermsConditions());
                      //               // Navigate to a new page or perform any action here
                      //               // print(
                      //               //     'Navigate to Terms and Conditions page');
                      //               // Add your navigation logic here
                      //             },
                      //         ),
                      //         TextSpan(
                      //             text:
                      //                 ' Lorem ipsum dolor sit amet, consectetuer adipiscing elit.',
                      //             style: TextStyle(
                      //                 color: AppTheme.TextBoldLite,
                      //                 fontSize: 14,
                      //                 height: 1.3)),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: ScreenWidth,
                          child: ElevatedButton(
                              onPressed: () async {
                                // if (_formKey.currentState!.validate()) {
                                //   var data = {
                                //     "email": email.text,
                                //     "password": mobileno.text,
                                //     "fcm_token": "fcm_token",
                                //     "device_id": "deviceid",
                                //     "device_type": "IOS"
                                //   };
                                //   print(data);
                                // } else {
                                //   // Form is invalid, do something accordingly
                                //   print('Form is invalid');
                                // }
                                // Nav.to(context, ProviderDashboard());

                                if (isLoading == false) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (_formKey.currentState!.validate()) {
                                    // if (acceptTerms == false) {
                                    //   Snackbar.show(
                                    //       "Please Accept Terms and Contidions",
                                    //       Colors.black);
                                    // } else {
                                    var UserResponse =
                                        PrefManager.read("UserResponse");
                                    var data = {
                                      "user_id": UserResponse['data']['id'],
                                      "address1": address1.text,
                                      "address2": address2.text,
                                      "country_id": countryId,
                                      "state_id": stateId,
                                      "district_id": districtId,
                                      // "country_id": _SCountry,
                                      // "state_id": _SState,
                                      // "district_id": _SCity,
                                      "pincode": zipcode.text
                                    };
                                    print(data);

                                    var result =
                                        await AuthApi.UpdateCompanyAddress(
                                            context,
                                            data,
                                            UserResponse['data']['api_token']);

                                    if (result.success) {
                                      if (result.data['status'].toString() ==
                                          "1") {
                                        if (result.data['message'] != null) {
                                          Snackbar.show(result.data['message'],
                                              Colors.green);
                                        } else {
                                          Snackbar.show(
                                              "Successfully", Colors.green);
                                        }
                                        Nav.offAll(
                                            context, ProviderDashboard());
                                        print(result.data);
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
                                    // }
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                              child: !isLoading
                                  ? const Text("Submit")
                                  : Loader.common())),
                      const SizedBox(
                        height: 20,
                      ),
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
