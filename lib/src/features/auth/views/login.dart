// ignore_for_file: non_constant_identifier_names, unused_local_variable, use_build_context_synchronously

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/core/utils/validate.dart';
import 'package:job/src/features/auth/auth_api.dart';
import 'package:job/src/features/auth/views/forgotpass.dart';
import 'package:job/src/features/auth/views/signin.dart';
import 'package:job/src/features/dashboard/views/dashboard.dart';
import 'package:job/src/features1/auth/views/provider_signin.dart';
import 'package:job/src/features1/dashboard/views/provider_dashboard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  bool visiable = false;
  bool _sType = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Login",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _sType = false;
                              });
                            },
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: !_sType
                                      ? AppTheme.primary
                                      : AppTheme.TextFormFieldBac,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Text(
                                "Job Seekers",
                                style: TextStyle(
                                    color:
                                        !_sType ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _sType = true;
                              });
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: _sType
                                      ? AppTheme.primary
                                      : AppTheme.TextFormFieldBac,
                                  borderRadius: BorderRadius.circular(5.0)),
                              alignment: Alignment.center,
                              child: Text("Employer",
                                  style: TextStyle(
                                      color: _sType
                                          ? Colors.white
                                          : Colors.black)),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      // maxLength: 10,
                      controller: email,
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return 'Please enter valid email or mobile number';
                        } else {
                          if (value.toString().contains('@')) {
                            if (!emailRegex.hasMatch(value!)) {
                              return 'please enter valid email';
                            } else {
                              return null;
                            }
                          } else {
                            if (!mobileNumberRegex.hasMatch(value!) ||
                                value.length < 10) {
                              return 'please enter valid mobile number';
                            } else {
                              return null;
                            }
                          }
                        }
                      },
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return "Please Enter a Email Address";
                      //   } else {
                      //     return null;
                      //   }
                      // },
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

                        hintText: 'Email Address or mobile number',
                        // labelText: "Mobile Number"
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      // maxLength: 10,
                      controller: password,
                      obscureText: !visiable,
                      // validator: Validate.email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter a Password";
                        } else {
                          return null;
                        }
                      },
                      // keyboardType: TextInputType.phone,
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
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          onPressed: () {
                            Nav.to(
                                context,
                                ForgotPassword(
                                  user_type: !_sType ? "USER" : "COMPANY",
                                ));
                          },
                          child: const Text(
                            "Forgot Password?",
                            // style: TextStyle(color: colors.AppColor1),
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                        width: ScreenWidth,
                        child: ElevatedButton(
                            onPressed: () async {
                              print(email.text.contains('@'));
                              if (_formKey.currentState!.validate()) {
                                print(email.text);
                                // var data = {
                                //   "email": email.text,
                                //   "password": password.text,
                                //   "fcm_token": "fcm_token",
                                //   "device_id": "deviceid",
                                //   "device_type": "IOS"
                                // };

                                if (isLoading == false) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final fcmToken = await FirebaseMessaging
                                      .instance
                                      .getToken();
                                  // if(!_sType){
                                  //   print("User");
                                  // }else{
                                  //   print("Company");
                                  // }

                                  var data = {
                                    "email": email.text,
                                    "password": password.text,
                                    "fcm_token": fcmToken,
                                    "device_id": "",
                                    "device_type":
                                        Platform.isAndroid ? "ANDROID" : "IOS",
                                  };
                                  print(data);

                                  var result = !_sType
                                      ? await AuthApi.login(context, data)
                                      : await AuthApi.CompanyLogin(
                                          context, data);
                                  print(result.data);
                                  if (result.success) {
                                    if (result.data['status'].toString() ==
                                        "1") {
                                      pref.setBool("isLoggin", true);
                                      PrefManager.write(
                                          "UserResponse", result.data);
                                      PrefManager.write("update_profile1",
                                          result.data['data']);
                                      result.data['data']?['user_type'] ==
                                              "COMPANY"
                                          ? Nav.offAll(
                                              context, ProviderDashboard())
                                          : Nav.offAll(
                                              context,
                                              Dashboard(
                                                current_index: 0,
                                              ));

                                      print(result.data);
                                    } else if (result.data['message'] != null) {
                                      Snackbar.show(
                                          result.data['message'], Colors.black);
                                    } else {
                                      Snackbar.show("Some Error", Colors.black);
                                    }
                                  } else {
                                    Snackbar.show("Some Error", Colors.red);
                                  }

                                  setState(() {
                                    isLoading = false;
                                  });
                                }

                                // Nav.offAll(context,  Dashboard());
                                // print(data);
                              }
                              // else {
                              //   if (email.text.isEmpty) {
                              //     Snackbar.show("Please Enter a Email Address", Colors.black);
                              //   } else {
                              //     Snackbar.show("Please Enter a password", Colors.black);
                              //   }
                              // }
                              // Nav.offAll(context, Dashboard());
                            },
                            child: !isLoading
                                ? const Text(
                                    "Login",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : Loader.common())),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: ScreenWidth,
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                  color: AppTheme.TextBoldLite,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500),
                              children: [
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Nav.to(
                                            context,
                                            !_sType
                                                ? SignIn()
                                                : ProviderSignin());
                                      },
                                    text: "Sign Up",
                                    style: TextStyle(
                                        color: AppTheme.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))
                              ])),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Align(
                      child: TextButton(
                          onPressed: () async {
                            var guest_data = {
                              "fcm_token": "",
                              "device_id": "",
                              "device_type": "IOS"
                            };

                            var result = !_sType
                                ? await AuthApi.guestLogin(context, guest_data)
                                : await AuthApi.companyGuestLogin(
                                    context, guest_data);
                            if (result.success) {
                              if (result.data['status'].toString() == "1") {
                                pref.setBool("isLoggin", true);
                                PrefManager.write("guest", "yes");
                                PrefManager.write("UserResponse", result.data);
                                PrefManager.write(
                                    "update_profile1", result.data['data']);
                                result.data['data']?['user_type'] ==
                                        "GUEST_COMPANY"
                                    ? Nav.offAll(context, ProviderDashboard())
                                    : Nav.offAll(
                                        context, Dashboard(current_index: 0));
                              }
                            }
                          },
                          child: Text(
                            "Guest Login",
                            style: TextStyle(color: AppTheme.primary),
                          )),
                    )
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
                    //       Nav.to(context, UpdateProfile2());
                    //     },
                    //     child: const Text("Job Provider"))
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


// user_id:33
// company_name:Smart Tech
// current_designation:HR
// mobile_number:9923423423
// registered_email:smarther@gmail.com
// landline_code:044
// landline_number:3423423
// organisation_type_id:1
// kycdoc_type_id:1

// kyc_document:<file>

// gst_number:sdfsdf
// pan_number:
// adhar_number:
// address1:Perumbakkam
// address2:
// country_id:101
// state_id:
// district_id:
// pincode:
