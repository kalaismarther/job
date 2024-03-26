// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unused_field, unused_local_variable

import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

class ProviderSignin extends StatefulWidget {
  const ProviderSignin({super.key});

  @override
  State<ProviderSignin> createState() => _ProviderSigninState();
}

class _ProviderSigninState extends State<ProviderSignin> {
  final _formKey = GlobalKey<FormState>();

  bool visiable = false;
  bool acceptTerms = false;
  bool isLoading = false;

  List Countries = [];
  var _SCountry = "";
  var _SCountry_code = "";
  var back_userId = "0";
  var countryId;

  TextEditingController mobileno = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();

  TextEditingController country = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    // initilize();
    super.initState();
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
        }
        // s_Location = result;
      });
    }
  }

  // initilize() async {
  //   var get_countries = await AuthApi.getCountry(context);

  //   if (get_countries.success) {
  //     setState(() {
  //       Countries.addAll(get_countries.data['data'] ?? "");
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    double ScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                          // margin: const EdgeInsets.only(top: 30),
                          margin: const EdgeInsets.only(top: 52, left: 22),
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
              // Center(
              //   child: SizedBox(
              //     child: Image.asset("assets/images/logo_light.png"),
              //   ),
              // ),
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
                      "Employer",
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                    //         });
                    //         // var get_states = await AuthApi.getStates(
                    //         //     context, {"country_id": _c_id});
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
                                      Nav.to(context, TermsConditions());
                                      // Nav.to(context, const TermsConditions());
                                      // Navigate to a new page or perform any action here
                                      // print(
                                      //     'Navigate to Terms and Conditions page');
                                      // Add your navigation logic here
                                    },
                                ),
                                // TextSpan(
                                //     text:
                                //         ' Lorem ipsum dolor sit amet, consectetuer adipiscing elit.',
                                //     style: TextStyle(
                                //         color: AppTheme.TextBoldLite,
                                //         fontSize: 14,
                                //         height: 1.3)),
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
                              if (_formKey.currentState!.validate()) {
                                if (acceptTerms == false) {
                                  Snackbar.show(
                                      "Please Accept Terms and Contidions",
                                      Colors.black);
                                } else {
                                  if (isLoading == false) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    var data = {
                                      "name": name.text,
                                      "email": email.text,
                                      "country_code": _SCountry_code,
                                      "mobile": mobileno.text,
                                      "password": password.text,
                                      "device_type": Platform.isAndroid
                                          ? "ANDROID"
                                          : "IOS",
                                      "device_id": "",
                                      "fcm_token": "",
                                      "user_id": back_userId
                                    };
                                    // print(data);
                                    var result = await AuthApi.ProviderSignup(
                                        context, data);
                                    print(result);
                                    if (result.success) {
                                      if (result.data['status'].toString() ==
                                          "1") {
                                        PrefManager.write(
                                            "UserResponse", result.data);
                                        var data = {
                                          "mobileno": mobileno.text,
                                          "emailId": email.text
                                        };
                                        PrefManager.write("c_signup", data);
                                        PrefManager.write("update_profile1",
                                            result.data['data']);
                                        var bac_user = await Nav.to(
                                            context,
                                            Verification(
                                              type: "company_signup",
                                              user_id: result.data['data']['id']
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
                                        Snackbar.show("Some Error", Colors.red);
                                      }
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              } else {
                                // Form is invalid, do something accordingly
                                print('Form is invalid');
                              }
                              // Nav.to(
                              //     context,
                              //     const UpdateProfile1());
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
    );
  }
}
