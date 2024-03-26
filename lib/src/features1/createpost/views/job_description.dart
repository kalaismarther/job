// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features1/createpost/post_api.dart';
import 'package:job/src/features1/createpost/views/job_benefit.dart';
import 'package:job/src/features1/createpost/views/steps.dart';

class JobDescription extends StatefulWidget {
  const JobDescription({super.key, required this.job_id});

  final String job_id;

  @override
  State<JobDescription> createState() => _JobDescriptionState();
}

class _JobDescriptionState extends State<JobDescription> {
  final _formKey1 = GlobalKey<FormState>();

  TextEditingController job_description = TextEditingController();
  TextEditingController job_responsibility = TextEditingController();
  TextEditingController details1 = TextEditingController();
  TextEditingController details2 = TextEditingController();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        Nav.back(context, widget.job_id);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: AppTheme.primary,
          title: const Text("Create Post",
              style: TextStyle(color: AppTheme.white, fontSize: 18)),
          leading: IconButton(
              onPressed: () {
                Nav.back(context, widget.job_id);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppTheme.white,
              )),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: _formKey1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Steps(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Job Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLength: 500,
                    maxLines: 5,
                    controller: job_description,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Job description';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Enter Job Description",
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.TextLite)),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            // Border color
                            width: 2.0, // Border width
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Responsibilites",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLength: 500,
                    maxLines: 5,
                    controller: job_responsibility,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter job responsibilites';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Enter Responsibilites",
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.TextLite)),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            // Border color
                            width: 2.0, // Border width
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // const Text(
                  //   "who you are",
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // TextFormField(
                  //   maxLength: 500,
                  //   maxLines: 5,
                  //   controller: details1,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please Enter details';
                  //     }
                  //     return null;
                  //   },
                  //   decoration: InputDecoration(
                  //       hintText: "Enter who you are",
                  //       fillColor: Colors.white,
                  //       enabledBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(color: AppTheme.TextLite)),
                  //       border: const OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           // Border color
                  //           width: 2.0, // Border width
                  //         ),
                  //       )),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // const Text(
                  //   "Nice to haves",
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // TextFormField(
                  //   maxLength: 500,
                  //   maxLines: 5,
                  //   controller: details2,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please Enter details';
                  //     }
                  //     return null;
                  //   },
                  //   decoration: InputDecoration(
                  //       hintText: "Enter Job Nice-to-haves",
                  //       fillColor: Colors.white,
                  //       enabledBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(color: AppTheme.TextLite)),
                  //       border: const OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           width: 5.0, // Border width
                  //         ),
                  //       )),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  SizedBox(
                      width: ScreenWidth,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (isLoading == false) {
                              setState(() {
                                isLoading = true;
                              });
                              if (_formKey1.currentState!.validate()) {
                                var UserResponse =
                                    PrefManager.read("UserResponse");
                                var data = {
                                  "user_id": UserResponse['data']['id'],
                                  "job_description": job_description.text,
                                  "job_responsibility": job_responsibility.text,
                                  "job_additional_details1": details1.text,
                                  "job_additional_details2": details2.text,
                                  "job_id": widget.job_id
                                };
                                print(data);
                                var result = await PostApi.updateJobInfo(
                                    context,
                                    data,
                                    UserResponse['data']['api_token']);
                                print(result);

                                if (result.success) {
                                  if (result.data['status'].toString() == "1") {
                                    Nav.to(
                                        context,
                                        JobBenefit(
                                          user_id: widget.job_id,
                                        ));
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

                            // Nav.to(context, const JobBenefit());
                          },
                          child: !isLoading
                              ? const Text(
                                  "Next Step",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : Loader.common())),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
