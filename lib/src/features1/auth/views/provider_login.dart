import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/features1/auth/views/provider_signin.dart';

class ProviderLogin extends StatefulWidget {
  const ProviderLogin({super.key});

  @override
  State<ProviderLogin> createState() => _ProviderLoginState();
}

class _ProviderLoginState extends State<ProviderLogin> {
  bool visiable = false;

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
                // key: _formKey,
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
                    TextFormField(
                      maxLength: 10,
                      // controller: email,
                      // validator: Validate.mobile,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter a Email Address";
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
                            "assets/icons/email.png",
                            height: 20,
                            width: 20,
                          ),
                        ),

                        hintText: 'Email Address',
                        // labelText: "Mobile Number"
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      // maxLength: 10,
                      // controller: password,
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
                            // Nav.to(context, const ForgotPassword());
                          },
                          child: const Text(
                            "Forgot Possword?",
                            // style: TextStyle(color: colors.AppColor1),
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                        width: ScreenWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              // if (_formKey.currentState!.validate()) {
                              //   var data = {
                              //     "email": email.text,
                              //     "password": password.text,
                              //     "fcm_token": "fcm_token",
                              //     "device_id": "deviceid",
                              //     "device_type": "IOS"
                              //   };
                              //   Nav.offAll(context,  Dashboard());
                              //   // print(data);
                              // } else {
                              //   // Form is invalid, do something accordingly
                              //   // print('Form is invalid');
                              //   if (email.text.isEmpty) {
                              //     Snackbar.show("Please Enter a Email Address");
                              //   } else {
                              //     Snackbar.show("Please Enter a password");
                              //   }
                              // }
                              // Nav.offAll(context, Dashboard());
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
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
                                        Nav.to(context, const ProviderSignin());
                                      },
                                    text: "Sign In",
                                    style: TextStyle(
                                        color: AppTheme.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))
                              ])),
                    ),
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
