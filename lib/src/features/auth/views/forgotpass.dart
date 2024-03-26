// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/core/utils/validate.dart';
import 'package:job/src/features/auth/auth_api.dart';
import 'package:job/src/features/auth/views/verification.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key, required this.user_type});

  final String user_type;

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    double ScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
                          // padding: EdgeInsets.only(left: 22,t),
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
              
              //  Center(
              //   child: SizedBox(
              //     child: Image.asset("assets/images/logo_light.png"),
              //   ),
              // ),
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
                      "Forgot Password",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text("Change Password from "),
                        Text(
                          widget.user_type == "USER"
                              ? "Job Seekers"
                              : "Employer",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary),
                        )
                      ],
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
                        hintText: 'Enter Email Address',
                        // labelText: "Mobile Number"
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                        width: ScreenWidth,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (isLoading == false) {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  var data = {
                                    "email": email.text,
                                    "user_type": widget.user_type
                                  };

                                  // {"email":"smarthersm38u@gmail.com", "user_type":"USER/COMPANY"}
                                  var result =
                                      await AuthApi.ForgotPass(context, data);
                                  print(result);
                                  if (result.success) {
                                    if (result.data['status'].toString() ==
                                        "1") {
                                      Nav.to(
                                          context,
                                          Verification(
                                            type: 'forgot',
                                            user_id: result.data['userid']
                                                .toString(), mobileno: '',
                                          ));
                                      print(result.data);
                                    } else if (result.data['message'] != null) {
                                      Snackbar.show(result.data['message'], Colors.black);
                                    } else {
                                      Snackbar.show("Some Error", Colors.black);
                                    }
                                  } else {
                                    Snackbar.show("Some Error",Colors.black);
                                  }

                                  setState(() {
                                    isLoading = false;
                                  });

                                  print(data);
                                } else {
                                  // Form is invalid, do something accordingly
                                  print('Form is invalid');
                                }
                              }

                              // Nav.to(context, Verification(type: 'forgot'));
                            },
                            child:
                                !isLoading ? Text("Send") : Loader.common())),
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
