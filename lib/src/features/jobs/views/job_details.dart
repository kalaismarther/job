// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, unnecessary_null_comparison

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/guestAlert.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features/dashboard/user_dashboard_api.dart';
import 'package:job/src/features/jobs/user_job_api.dart';
import 'package:job/src/features/jobs/views/job_apply.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({super.key, required this.job_id});

  final String job_id;

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  List menu = [
    "Description",
    "Company",
    // "Map",
    // "Reviews",
  ];
  int _SIndex = 0;
  bool showFullText = false;
  var Job_Details;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    initilize();
    super.initState();
  }

  initilize() async {
    setState(() {
      isLoading = true;
    });
    var UserResponse = PrefManager.read("UserResponse");

    var get_details = await UserJobApi.getJobDetails(
        context,
        UserResponse['data']['id'],
        widget.job_id,
        UserResponse['data']['api_token']);

    print(get_details.data);

    setState(() {
      if (get_details.success) {
        Job_Details = get_details.data['data']?[0] ?? "";
      }
      isLoading = false;
    });
  }

  String getEmploymentTypes(list) {
    List employmentTypes =
        list.map((item) => item["employmenttype"].toString()).toList();
    return employmentTypes.join(', ');
  }

  void applyBottomModal() async {
    final result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ApplyModal(
            job_id: widget.job_id,
            company_name:
                Job_Details?['company_details']?['company_name'] ?? "",
          );
        });
    if (result != null) {
      setState(() {
        // s_Location = result;
      });
    }
  }

  // void bottomModal() {
  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
  //       ),
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) {
  //           return Container(
  //             padding:
  //                 const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
  //             width: MediaQuery.of(context).size.width,
  //             decoration: const BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(30.0),
  //                     topRight: Radius.circular(30.0))),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 SizedBox(
  //                     width: 100,
  //                     child: Divider(
  //                       thickness: 3,
  //                       color: AppTheme.TextBoldLite,
  //                     )),
  //                 Text(
  //                   "Apply this job to ${Job_Details?['company_details']?['company_name'] ?? ""}",
  //                   style: TextStyle(color: AppTheme.TextBoldLite),
  //                 ),
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 const Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Text(
  //                     "Upload Your Resume/CV",
  //                     style:
  //                         TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   height: 100,
  //                   decoration: const BoxDecoration(
  //                     color: Colors.white,
  //                     // shape: BoxShape.circle,
  //                     image: DecorationImage(
  //                       fit: BoxFit.fill,
  //                       image: AssetImage("assets/images/dot_border.png"),
  //                     ),
  //                   ),
  //                   child: Center(
  //                       child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Image.asset(
  //                         "assets/images/pdf.png",
  //                         height: 40,
  //                       ),
  //                       const SizedBox(
  //                         height: 5,
  //                       ),
  //                       Text(
  //                         "CV-Ganesh-UI/UX Designer.pdf",
  //                         style: TextStyle(
  //                             color: AppTheme.TextBoldLite,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 13),
  //                       ),
  //                     ],
  //                   )),
  //                 ),
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 SizedBox(
  //                   width: MediaQuery.of(context).size.width,
  //                   child: ElevatedButton(
  //                       onPressed: () {
  //                         Nav.to(context, const JobApply());
  //                       },
  //                       child: const Text("Apply Now")),
  //                 )
  //               ],
  //             ),
  //           );
  //         });
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(),
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text("Job Details",
            style: TextStyle(color: AppTheme.white, fontSize: 18)),
        leading: IconButton(
            onPressed: () {
              Nav.back(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme.white,
            )),
      ),
      bottomNavigationBar: !isLoading
          ? Padding(
              padding: Platform.isAndroid
                  ? const EdgeInsets.all(5.0)
                  : const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  Job_Details?['is_saved'].toString() == "0"
                      ? InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            var result = PrefManager.read("guest");
                            if (result == "yes") {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return GuestAlert();
                                },
                              );
                            } else {
                              bool result =
                                  await JobSaved(Job_Details['id'], context);
                              if (result == true) {
                                setState(() {
                                  Job_Details['is_saved'] = 1;
                                });
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2, color: AppTheme.primary),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/bookmark_light.png",
                                  height: 20,
                                  color: AppTheme.primary,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Save",
                                  style: TextStyle(color: AppTheme.primary),
                                ),
                              ],
                            ),
                          ),
                        )
                      : InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            bool result =
                                await JobUnSaved(Job_Details['id'], context);
                            if (result == true) {
                              setState(() {
                                Job_Details['is_saved'] = 0;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2, color: AppTheme.primary),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/bookmark_dark.png",
                                  height: 20,
                                  color: AppTheme.primary,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Save",
                                  style: TextStyle(color: AppTheme.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  Job_Details['is_applied'].toString() == "1"
                      ? Expanded(
                          child: Container(
                              height: 48,
                              padding: const EdgeInsets.all(5.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    Snackbar.show(
                                        "Job Already applied", Colors.black);
                                  },
                                  child: const Text("Already Applied"))))
                      : Expanded(
                          child: Container(
                              height: 48,
                              padding: const EdgeInsets.all(5.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    var result = PrefManager.read("guest");
                                    if (result == "yes") {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return GuestAlert();
                                        },
                                      );
                                    } else {
                                      applyBottomModal();
                                    }
                                  },
                                  child: const Text("Apply Now"))))
                ],
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: !isLoading
            ? SizedBox(
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                    Job_Details?['company_details']
                                        ['is_company_logo'],
                                    fit: BoxFit.fill,
                                    height: 50,
                                    width: 55, errorBuilder:
                                        (BuildContext context, Object exception,
                                            StackTrace? stackTrace) {
                                  // Handle the error here
                                  return const Center(
                                    child: Text('UnSupported Image'),
                                  );
                                }),
                              ),
                              // Image.asset(
                              //   "assets/images/back.png",
                              //   height: 55,
                              // ),
                            ),
                          ),
                          Image.asset(
                            "assets/icons/verify.png",
                            height: 25,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      Text(
                        Job_Details?['job_title'] ?? "",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        "${Job_Details?['company_details']?['company_name'] ?? ""}, ${Job_Details?['company_details']?['address1'] ?? ""}",
                        style:
                            TextStyle(color: AppTheme.TextLite, fontSize: 13),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: screenWidth,
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: const Offset(0.2, 0.2),
                                  blurRadius: 6.0)
                            ]),
                        child: GridView.count(
                          primary: false,
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 5,
                          // mainAxisSpacing: 3,
                          crossAxisCount: 4,
                          children: <Widget>[
                            Container(
                              // padding: const EdgeInsets.all(8),
                              // color: Colors.teal[100],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/employee.png",
                                    height: 25,
                                  ),
                                  Text(
                                    "Employees",
                                    style: TextStyle(
                                        color: AppTheme.TextLite,
                                        fontSize: 12,
                                        height: 1.5),
                                  ),
                                  Text(
                                    Job_Details?['employee_size'] ?? "",
                                    style: const TextStyle(height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // padding: const EdgeInsets.all(8),
                              // color: Colors.teal[200],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/jobtype.png",
                                    height: 25,
                                  ),
                                  Text(
                                    "Job Type",
                                    style: TextStyle(
                                        color: AppTheme.TextLite,
                                        fontSize: 12,
                                        height: 1.5),
                                  ),
                                  Text(
                                    getEmploymentTypes(
                                        Job_Details['is_employment_types'] ??
                                            []),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(height: 1.5),
                                  ),
                                  getEmploymentTypes(Job_Details[
                                                      'is_employment_types'] ??
                                                  [])
                                              .length >
                                          8
                                      ? InkWell(
                                          onTap: () {
                                            _showDialog(
                                                context,
                                                "Job Type",
                                                getEmploymentTypes(Job_Details[
                                                        'is_employment_types'] ??
                                                    []));
                                          },
                                          child: Text(
                                            "Read More",
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: AppTheme.primary),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 0,
                                        )
                                ],
                              ),
                            ),
                            Container(
                              // padding: const EdgeInsets.all(8),
                              // color: Colors.teal[300],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/level.png",
                                    height: 25,
                                  ),
                                  Text(
                                    "Level",
                                    style: TextStyle(
                                        color: AppTheme.TextLite,
                                        fontSize: 12,
                                        height: 1.5),
                                  ),
                                  // const Text(
                                  //   "Junior",
                                  //   style: TextStyle(height: 1.5),
                                  // ),
                                  Text(
                                    Job_Details['is_job_level'] ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(height: 1.5),
                                  ),
                                  // Job_Details['is_job_level']
                                  (Job_Details['is_job_level'] ?? "").length > 8
                                      ? InkWell(
                                          onTap: () {
                                            _showDialog(
                                                context,
                                                "Job Type",
                                                Job_Details['is_job_level'] ??
                                                    "");
                                          },
                                          child: Text(
                                            "Read More",
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: AppTheme.primary),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 0,
                                        )
                                ],
                              ),
                            ),
                            Container(
                              // padding: const EdgeInsets.all(8),
                              // color: Colors.teal[400],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/employee.png",
                                    height: 25,
                                  ),
                                  Text(
                                    "Salaries",
                                    style: TextStyle(
                                        color: AppTheme.TextLite,
                                        fontSize: 12,
                                        height: 1.5),
                                  ),
                                  Job_Details['is_hide_salary'].toString() ==
                                          '1'
                                      ? const SizedBox(height: 0)
                                      : Text(
                                          "${(Job_Details['from_sal'] ?? "").toString()} - ${(Job_Details['to_sal'] ?? "").toString()}",
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(height: 1.5),
                                        ),
                                  InkWell(
                                    onTap: () {
                                      _showDialog(
                                          context,
                                          "Salaries",
                                          Job_Details['is_hide_salary']
                                                      .toString() ==
                                                  '1'
                                              ? "Salary details are hidden"
                                              : "${(Job_Details['from_sal'] ?? "").toString()} - ${(Job_Details['to_sal'] ?? "").toString()}");
                                    },
                                    child: Text(
                                      "Read More",
                                      style: TextStyle(
                                          fontSize: 8, color: AppTheme.primary),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(
                      //   height: 25,
                      // ),
                      // Container(
                      //   width: screenWidth,
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(10.0),
                      //       boxShadow: [
                      //         BoxShadow(
                      //             color: Colors.grey.shade300,
                      //             offset: const Offset(0.2, 0.2),
                      //             blurRadius: 6.0)
                      //       ]),
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Column(
                      //         children: [
                      //           Image.asset(
                      //             "assets/images/employee.png",
                      //             height: 25,
                      //           ),
                      //           Text(
                      //             "Employees",
                      //             style: TextStyle(
                      //                 color: AppTheme.TextLite,
                      //                 fontSize: 12,
                      //                 height: 1.5),
                      //           ),
                      //           Text(
                      //             Job_Details?['employee_size'] ?? "",
                      //             style: const TextStyle(height: 1.5),
                      //           ),
                      //         ],
                      //       ),
                      //       Column(
                      //         children: [
                      //           Image.asset(
                      //             "assets/images/jobtype.png",
                      //             height: 25,
                      //           ),
                      //           Text(
                      //             "Job Type",
                      //             style: TextStyle(
                      //                 color: AppTheme.TextLite,
                      //                 fontSize: 12,
                      //                 height: 1.5),
                      //           ),
                      //           const Text(
                      //             "Part-time",
                      //             style: TextStyle(height: 1.5),
                      //           ),
                      //         ],
                      //       ),
                      //       Column(
                      //         children: [
                      //           Image.asset(
                      //             "assets/images/level.png",
                      //             height: 25,
                      //           ),
                      //           Text(
                      //             "Level",
                      //             style: TextStyle(
                      //                 color: AppTheme.TextLite,
                      //                 fontSize: 12,
                      //                 height: 1.5),
                      //           ),
                      //           const Text(
                      //             "Junior",
                      //             style: TextStyle(height: 1.5),
                      //           ),
                      //         ],
                      //       ),
                      //       Column(
                      //         children: [
                      //           Image.asset(
                      //             "assets/images/employee.png",
                      //             height: 25,
                      //           ),
                      //           Text(
                      //             "Salaries",
                      //             style: TextStyle(
                      //                 color: AppTheme.TextLite,
                      //                 fontSize: 12,
                      //                 height: 1.5),
                      //           ),
                      //           const Text(
                      //             "₹13k-15k",
                      //             style: TextStyle(height: 1.5),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4, childAspectRatio: 2.5),
                          itemCount: menu.length,
                          itemBuilder: (BuildContext context, int index) {
                            final data = menu[index];
                            return InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  _SIndex = index;
                                });
                              },
                              child: Container(
                                // margin: const EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                    color: _SIndex == index
                                        ? AppTheme.primary
                                        : AppTheme.white,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Center(
                                    child: Text(
                                  data,
                                  style: TextStyle(
                                      color: _SIndex == index
                                          ? AppTheme.white
                                          : AppTheme.TextBoldLite,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            );
                          }),

                      _SIndex == 0
                          ? Description()
                          : _SIndex == 1
                              ? Company()
                              : Review()
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // const Align(
                      //     alignment: Alignment.centerLeft,
                      //     child: Text(
                      //       "Job Description",
                      //       style:
                      //           TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      //     )),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      // RichText(
                      //   textAlign: TextAlign.justify,
                      //   text: TextSpan(
                      //     text: showFullText
                      //         ? fullText
                      //         : "${fullText.substring(0, 200)}...",
                      //     style: const TextStyle(
                      //       color: Colors.black,
                      //       fontFamily: 'Poppins',
                      //       fontSize: 16,
                      //     ),
                      //     children: <TextSpan>[
                      //       TextSpan(
                      //           text: 'Read More',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold,
                      //               color: AppTheme.primary)),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // const Align(
                      //     alignment: Alignment.centerLeft,
                      //     child: Text(
                      //       "Skills & Requirements",
                      //       style:
                      //           TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      //     )),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // ListView.builder(
                      //     itemCount: 5,
                      //     shrinkWrap: true,
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     itemBuilder: (context, index) {
                      //       return Row(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Padding(
                      //             padding: const EdgeInsets.only(top: 5.0),
                      //             child: Icon(
                      //               Icons.circle,
                      //               color: AppTheme.TextLite,
                      //               size: 10,
                      //             ),
                      //           ),
                      //           const SizedBox(
                      //             width: 10,
                      //           ),
                      //           const Expanded(
                      //             child: Text(
                      //               "Al least 1-2 years of UI/UX Experience in Digital Environment (E-Commerce, Web apps, Mobile Apps)",
                      //               textAlign: TextAlign.justify,
                      //               style: TextStyle(fontSize: 13),
                      //             ),
                      //           ),
                      //           const SizedBox(
                      //             width: 10,
                      //           ),
                      //         ],
                      //       );
                      //     }),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     const SizedBox(
                      //       width: 120,
                      //       height: 50,
                      //       child: Stack(
                      //         // alignment: Alignment.topLeft,
                      //         // fit: StackFit.expand,
                      //         children: [
                      //           Positioned(
                      //             left: 60, // Adjust the spacing as needed
                      //             child: ProfileImage(
                      //               imageUrl: 'assets/images/back.png',
                      //             ),
                      //           ),
                      //           Positioned(
                      //             left: 30, // Adjust the spacing as needed
                      //             child: ProfileImage(
                      //               imageUrl: 'assets/images/ellipse.png',
                      //             ),
                      //           ),
                      //           Positioned(
                      //             left: 0,
                      //             child: ProfileImage(
                      //               imageUrl: 'assets/images/frame.png',
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Text(
                      //       "54 people applied",
                      //       style: TextStyle(color: AppTheme.TextBoldLite),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                ),
              )
            : ShimmerLoader(type: "details"),
      ),
    );
  }

  Description() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Job Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
        const SizedBox(
          height: 15,
        ),
        Job_Details?['job_description'] != null
            ? RichText(
                textAlign: TextAlign.justify,
                text: Job_Details?['job_description'].length > 201
                    ? TextSpan(
                        text: showFullText
                            ? (Job_Details?['job_description'] ?? "")
                            : "${Job_Details['job_description'].substring(0, 200)}...",
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: showFullText ? "Read less" : 'Read More',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  showFullText = !showFullText;
                                });
                              },
                          ),
                        ],
                      )
                    : TextSpan(
                        text: Job_Details?['job_description'] ?? "",
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                      ),
              )
            : const SizedBox(
                height: 0,
              ),
        const SizedBox(
          height: 20,
        ),
        const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Skills & Requirements",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
        const SizedBox(
          height: 20,
        ),
        Text(
          "${Job_Details?['job_responsibility'] ?? ""}",
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontSize: 16,
          ),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(
          height: 10,
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Skills: ${Job_Details?['skills']}",
            )),
        const SizedBox(
          height: 20,
        ),
        const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Qualification",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
        const SizedBox(
          height: 20,
        ),
        Job_Details?['is_education'] != null &&
                Job_Details?['is_education'] != ""
            ? ListView.builder(
                itemCount: Job_Details?['is_education'].length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final edu_data = Job_Details?['is_education'][index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Icon(
                          Icons.circle,
                          color: AppTheme.TextLite,
                          size: 10,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          edu_data['qualification'],
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  );
                })
            : const Text(""),
        const SizedBox(
          height: 20,
        ),
        Benefit()
      ],
    );
  }

  Benefit() {
    return Column(
      children: [
        const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Benefits",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
        const SizedBox(
          height: 20,
        ),
        Job_Details?['is_job_benefits'] != null &&
                Job_Details?['is_job_benefits'] != ""
            ? GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: Job_Details['is_job_benefits'].length,
                itemBuilder: (BuildContext context, int index) {
                  final data = Job_Details['is_job_benefits'][index];
                  return Container(
                    margin: const EdgeInsets.all(3.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              offset: const Offset(0.2, 0.2),
                              blurRadius: 6.0)
                        ]),
                    // decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     border: Border.all(color: AppTheme.TextLite)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Image.asset(
                            //   "assets/images/logo_dark.png",
                            //   width: 45,
                            // ),
                            Image.network(data['is_benefit_image'],
                                width: 35, fit: BoxFit.fitWidth, errorBuilder:
                                    (BuildContext context, Object exception,
                                        StackTrace? stackTrace) {
                              // Handle the error here
                              return const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              );
                            }),
                            // InkWell(
                            //     splashColor: Colors.transparent,
                            //     highlightColor: Colors.transparent,
                            //     onTap: () {
                            //       setState(() {
                            //         selectedType.removeAt(index);
                            //       });
                            //     },
                            //     child: const Icon(Icons.close))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          data['benefit_name'] ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          data['benefit_description'] ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(color: AppTheme.TextLite),
                        )
                      ],
                    ),
                  );
                })
            : const Text(""),
      ],
    );
  }

  Review() {
    return const SizedBox(
      height: 300,
      child: Center(
        child: Text("No Review"),
      ),
    );
  }

  Company() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            Job_Details?['company_details']?['company_name'] ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppTheme.TextBoldLite,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                Job_Details?['company_details']?['address1'] ?? "",
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.email,
                color: AppTheme.TextBoldLite,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                Job_Details?['company_details']?['registered_email'] ?? "",
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.phone,
                color: AppTheme.TextBoldLite,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                Job_Details?['company_details']?['mobile_number'] ?? "",
              )
            ],
          )
        ],
      ),
    );
  }
}

// class ProfileImage extends StatelessWidget {
//   final String imageUrl;

//   const ProfileImage({
//     super.key,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 45,
//       height: 45,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//         image: DecorationImage(
//           fit: BoxFit.cover,
//           image: AssetImage(imageUrl),
//         ),
//       ),
//     );
//   }
// }

class ApplyModal extends StatefulWidget {
  const ApplyModal(
      {super.key, required this.job_id, required this.company_name});

  final String job_id;
  final String company_name;

  @override
  State<ApplyModal> createState() => _ApplyModalState();
}

class _ApplyModalState extends State<ApplyModal> {
  File? selectedPdf;
  var selectedPdf_str = "";
  var file_name = "";
  bool isLoading = false;
  bool showText = false;
  bool showProfileResume = true;

  Future<void> _pickPDF(context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      // Check the file size before processing the selected file
      // int maxSizeInBytes = 10 * 1024; // Set the maximum file size to 10 KB
      int maxSizeInBytes = 1024 * 1024; // 1 MB
      if (result.files.single.size > maxSizeInBytes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Selected file exceeds the maximum allowed size of 10 KB.'),
          ),
        );
        Navigator.pop(context);
        return;
      }

      setState(() {
        selectedPdf = File(result.files.single.path!);
        selectedPdf_str = result.files.single.path!;
        file_name = result.files.single.name;
        showProfileResume = false;
      });

      // Display the selected file name in a SnackBar.
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Selected PDF file: ${result.files.single.name}'),
      //   ),
      // );
    } else {
      // User canceled the file picker.
      print("File picking canceled.");
    }
  }

  String getPdfName(String url) {
    List<String> parts = url.split('/');
    return parts.last;
  }

  @override
  Widget build(BuildContext context) {
    var profileResume = PrefManager.read('user_resume');

    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 100,
            child: Divider(
              thickness: 3,
              color: AppTheme.TextBoldLite,
            ),
          ),
          Text(
            "Apply this job to ${widget.company_name}",
            style: TextStyle(color: AppTheme.TextBoldLite),
          ),
          const SizedBox(
            height: 20,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Upload Your Resume/CV",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          showProfileResume
              ? profileResume.toString().isNotEmpty && profileResume != null
                  ? Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            // shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage("assets/images/dot_border.png"),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/pdf.png",
                                  height: 40,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  getPdfName(profileResume),
                                  style: TextStyle(
                                      color: AppTheme.TextBoldLite,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    )
                  : const Text('No profile resume found')
              : InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    _pickPDF(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      // shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/dot_border.png"),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/pdf.png",
                            height: 40,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            file_name != null && file_name != ""
                                ? file_name
                                : "Select PDF file",
                            style: TextStyle(
                                color: AppTheme.TextBoldLite,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          file_name.isEmpty || selectedPdf_str.isEmpty
              ? TextButton(
                  onPressed: () {
                    _pickPDF(context);
                  },
                  child: const Text('Select pdf from file'),
                )
              : const SizedBox(
                  height: 0,
                ),
          // InkWell(
          //   splashColor: Colors.transparent,
          //   highlightColor: Colors.transparent,
          //   onTap: () {
          //     _pickPDF(context);
          //   },
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     height: 100,
          //     decoration: const BoxDecoration(
          //       color: Colors.white,
          //       // shape: BoxShape.circle,
          //       image: DecorationImage(
          //         fit: BoxFit.fill,
          //         image: AssetImage("assets/images/dot_border.png"),
          //       ),
          //     ),
          //     child: Center(
          //         child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Image.asset(
          //           "assets/images/pdf.png",
          //           height: 40,
          //         ),
          //         const SizedBox(
          //           height: 5,
          //         ),
          //         Text(
          //           file_name != null && file_name != ""
          //               ? file_name
          //               : "Select PDF file",
          //           style: TextStyle(
          //               color: AppTheme.TextBoldLite,
          //               fontWeight: FontWeight.bold,
          //               fontSize: 13),
          //         ),
          //       ],
          //     )),
          //   ),
          // ),
          showText
              ? const Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "* Please select Resume/CV",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                )
              : const SizedBox(
                  height: 0,
                ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                onPressed: () async {
                  if (isLoading == false) {
                    setState(() {
                      isLoading = true;
                    });
                    var UserResponse = PrefManager.read("UserResponse");
                    if (showProfileResume) {
                      if (profileResume.toString().isEmpty ||
                          profileResume == null) {
                        setState(() {
                          showText = true;
                        });
                      } else {
                        var data = {
                          "user_id": UserResponse['data']['id'],
                          "job_id": widget.job_id,
                          "resume": profileResume.toString()
                        };
                        print(data);
                        var result = await UserJobApi.applyJobwithProfileResume(
                            context, data, UserResponse['data']['api_token']);
                        print(result);
                        print(result.data['message']);
                        if (result.success) {
                          if (result.data['status'].toString() == "1") {
                            if (result.data['message'] != null) {
                              Snackbar.show(
                                  result.data['message'], Colors.green);
                            } else {
                              Snackbar.show("Successfully", Colors.green);
                            }
                            Nav.to(context, JobApply());
                            // print(result.data);
                          } else if (result.data['message'] != null) {
                            Snackbar.show(result.data['message'], Colors.black);
                            Navigator.pop(context);
                          } else {
                            Snackbar.show("Some Error", Colors.red);
                            Navigator.pop(context);
                          }
                        } else {
                          Snackbar.show("Some Error", Colors.red);
                          Navigator.pop(context);
                        }
                      }
                      return;
                    } else {
                      if (selectedPdf_str == null || selectedPdf_str == "") {
                        setState(() {
                          showText = true;
                        });
                        // Snackbar.show("Please Select Resume/cv", Colors.black);
                        // Navigator.pop(context);
                      } else {
                        var data = {
                          "user_id": UserResponse['data']['id'],
                          "job_id": widget.job_id,
                          "resume": selectedPdf_str
                        };

                        var result = await UserJobApi.applyJob(
                            context, data, UserResponse['data']['api_token']);
                        print(result);
                        print(result.data['message']);
                        if (result.success) {
                          if (result.data['status'].toString() == "1") {
                            if (result.data['message'] != null) {
                              Snackbar.show(
                                  result.data['message'], Colors.green);
                            } else {
                              Snackbar.show("Successfully", Colors.green);
                            }
                            Nav.to(context, JobApply());
                            // print(result.data);
                          } else if (result.data['message'] != null) {
                            Snackbar.show(result.data['message'], Colors.black);
                            Navigator.pop(context);
                          } else {
                            Snackbar.show("Some Error", Colors.red);
                            Navigator.pop(context);
                          }
                        } else {
                          Snackbar.show("Some Error", Colors.red);
                          Navigator.pop(context);
                        }
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }

                  // Nav.to(context, const JobApply());
                },
                child: !isLoading ? Text("Apply Now") : Loader.common()),
          )
        ],
      ),
    );
  }
}

// Function to show the dialog
void _showDialog(BuildContext context, title, values) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(10.0),
        content: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Align(
              //     alignment: Alignment.topRight,
              //     child: InkWell(
              //       splashColor: Colors.transparent,
              //       highlightColor: Colors.transparent,
              //       onTap: () {
              //         Nav.back(context);
              //       },
              //       child: const Padding(
              //         padding: EdgeInsets.only(right: 5),
              //         child: Icon(
              //           Icons.cancel,
              //           color: Colors.black,
              //         ),
              //       ),
              //     )),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Nav.back(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.cancel,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   title,
                  //   style: const TextStyle(fontWeight: FontWeight.bold),
                  // ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(values),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

Future<bool> JobSaved(job_id, context) async {
  var UserResponse = PrefManager.read("UserResponse");
  var result = await UserDashboardApi.JobSaved(context,
      UserResponse['data']['id'], job_id, UserResponse['data']['api_token']);
  if (result.success) {
    if (result.data['status'].toString() == "1") {
      if (result.data['message'] != null) {
        Snackbar.show(result.data['message'], Colors.green);
      } else {
        Snackbar.show("Job Saved", Colors.green);
      }
      return true;
    } else if (result.data['message'] != null) {
      Snackbar.show(result.data['message'], Colors.black);
    } else {
      Snackbar.show("Some Error", Colors.black);
    }
  }

  return false;
}

Future<bool> JobUnSaved(job_id, context) async {
  var UserResponse = PrefManager.read("UserResponse");
  var result = await UserDashboardApi.JobUnSaved(context,
      UserResponse['data']['id'], job_id, UserResponse['data']['api_token']);
  if (result.success) {
    if (result.data['status'].toString() == "1") {
      if (result.data['message'] != null) {
        Snackbar.show(result.data['message'], Colors.green);
      } else {
        Snackbar.show("Job Saved", Colors.green);
      }
      return true;
    } else if (result.data['message'] != null) {
      Snackbar.show(result.data['message'], Colors.black);
    } else {
      Snackbar.show("Some Error", Colors.black);
    }
  }

  return false;
}
