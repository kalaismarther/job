// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/core/utils/validate.dart';
import 'package:job/src/features/auth/auth_api.dart';
import 'package:job/src/features/auth/views/login.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key, required this.user_id});

  final String user_id;

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController newpass = TextEditingController();
  TextEditingController confirm = TextEditingController();

  bool visiable = false;
  bool visiable1 = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    double ScreenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: ()async{
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
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "New Password",
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        maxLength: 10,
                        obscureText: !visiable,
                        controller: newpass,
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
                          hintText: 'Enter New Password',
                          // labelText: "Mobile Number"
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        // maxLength: 10,
                        controller: confirm,
                        obscureText: !visiable1,
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
                                visiable1 = !visiable1;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                !visiable1
                                    ? "assets/icons/hide.png"
                                    : "assets/icons/visible.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ),
                          hintText: 'Confirm Password',
                          // labelText: "Password"
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                          width: ScreenWidth,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (newpass.text != confirm.text) {
                                    Snackbar.show(
                                        "Password Mismatch Please Check",
                                        Colors.black);
                                  } else {
                                    if (isLoading == false) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      var data = {
                                        "user_id": widget.user_id,
                                        "newpassword": newpass.text
                                      };
      
                                      var UserResponse =
                                          PrefManager.read("UserResponse_verify");
                                      var result = await AuthApi.ResetPassword(
                                          context,
                                          data,
                                          UserResponse['data']['api_token']);
      
                                      if (result.success) {
                                        if (result.data['status'].toString() ==
                                            "1") {
                                          Nav.offAll(context, const Login());
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
                                        Snackbar.show("Some Error", Colors.red);
                                      }
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                } else {
                                  // Form is invalid, do something accordingly
                                  print('Form is invalid');
                                }
                                // Nav.offAll(context, Dashboard());
                                // Nav.to(context, const ProffesionalDetails());
                              },
                              child: !isLoading
                                  ? const Text("Submit")
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
