// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/core/utils/validate.dart';
import 'package:job/src/features/auth/auth_api.dart';
import 'package:job/src/features/auth/views/newpass.dart';
import 'package:job/src/features/auth/views/proffesional_details.dart';
import 'package:job/src/features1/auth/views/update_profile1.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class Verification extends StatefulWidget {
  const Verification(
      {super.key,
      required this.type,
      required this.user_id,
      required this.mobileno});

  final String type;
  final String user_id;
  final String mobileno;

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  OtpFieldController otp = OtpFieldController();

  int _remainingSeconds = 60;
  // ignore: unused_field
  late Timer _timer;
  bool isLoading = false;
  // String otp = "";
  var OTP = "";

  @override
  void initState() {
    // initilize();
    startTimer();
    super.initState();
  }

  startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
    // super.initState();
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
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Verification",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: ScreenWidth * 0.9,
                      child: OTPTextField(
                        outlineBorderRadius: 8,
                        length: 4,
                        fieldWidth: 60,
                        controller: otp,
                        contentPadding: const EdgeInsets.all(15.0),
                        style: const TextStyle(fontSize: 17),
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.box,
                        onChanged: (value) {
                          if (OTP.length == 4) {
                            setState(() {
                              OTP = value;
                            });
                          }
                        },
                        onCompleted: (pin) {
                          setState(() {
                            OTP = pin;
                          });
                          // print("Completed: " + pin);
                        },
                        otpFieldStyle: OtpFieldStyle(
                            backgroundColor: AppTheme.TextFormFieldBac),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    widget.type == "signup" || widget.type == "company_signup"
                        ? _remainingSeconds == 0
                            ? SizedBox(
                                width: ScreenWidth,
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      _remainingSeconds = 59;
                                      startTimer();
                                    });

                                    var UserResponse =
                                        PrefManager.read("UserResponse");

                                    var data = {
                                      "user_id": widget.user_id,
                                      "mobile": widget.mobileno
                                    };
                                    var result = await AuthApi.ResendOtp(
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
                                          Snackbar.show("OTP Sent Successfully",
                                              Colors.green);
                                        }
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
                                    // var data = {
                                    //   "user_id": "",
                                    //   "mobile": widget.mobileno,
                                    // };

                                    // var result = await Api.ResendOtp(data);
                                    // if (result.data['status'].toString() == "1") {
                                    //   Snackbar.show(result.data['message'], 'success');
                                    // } else {
                                    //   if (result.data['message'] != null) {
                                    //     Snackbar.show(result.data['message'], '');
                                    //   } else {
                                    //     Snackbar.show("Some Error", '');
                                    //   }
                                    // }
                                  },
                                  child: Text(
                                    "Resend OTP",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: AppTheme.primary),
                                  ),
                                ),
                              )
                            : RichText(
                                text: TextSpan(
                                  text: 'Resend Code in  ',
                                  style: TextStyle(
                                      color: AppTheme.TextBoldLite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                  children: [
                                    TextSpan(
                                        text: "$_remainingSeconds sec",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primary)),
                                    // TextSpan(text: ' sec'),
                                  ],
                                ),
                              )
                        : const SizedBox(
                            height: 0,
                          ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Nav.back(context, widget.user_id);
                      },
                      child: Text(
                        "Change email address?",
                        style: TextStyle(
                          color: AppTheme.TextBoldLite,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
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
                              // if (widget.type == "sign") {
                              //   Nav.offAll(context, Dashboard());
                              // } else {
                              //   Nav.to(context, const NewPassword());
                              // }
                              // Nav.to(context, page)

                              if (OTP.length != 4) {
                                Snackbar.show(
                                    "Please Enter a OTP Number", Colors.black);
                              } else {
                                if (isLoading == false) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  var UserResponse =
                                      PrefManager.read("UserResponse");
                                  print(UserResponse);
                                  var data = {
                                    "user_id": widget.user_id,
                                    "otp": OTP
                                  };
                                  var result =
                                      await AuthApi.VerifyOtp(context, data);
                                  print(result);
                                  if (result.success) {
                                    if (result.data['status'].toString() ==
                                        "1") {
                                      print("=========================");
                                      print(result);
                                      PrefManager.write(
                                          "UserResponse_verify", result.data);
                                      if (widget.type == "forgot") {
                                        Nav.to(
                                            context,
                                            NewPassword(
                                              user_id: widget.user_id,
                                            ));
                                      } else if (widget.type ==
                                          "company_signup") {
                                        pref.setBool("isLoggin", true);
                                        // Nav.to(context, ProviderDashboard());
                                        Nav.to(context, UpdateProfile1());
                                      } else {
                                        pref.setBool("isLoggin", true);
                                        // Nav.offAll(context, Dashboard());
                                        Nav.to(context, ProffesionalDetails());
                                      }

                                      print(result.data);
                                    } else if (result.data['message'] != null) {
                                      Snackbar.show(
                                          result.data['message'], Colors.black);
                                    } else {
                                      Snackbar.show("Some Error", Colors.red);
                                    }
                                  } else {
                                    Snackbar.show("Some Error", Colors.red);
                                  }
                                }

                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: !isLoading
                                ? Text("Verify OTP")
                                : Loader.common())),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
