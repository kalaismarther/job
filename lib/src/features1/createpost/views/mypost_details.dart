// ignore_for_file: non_constant_identifier_names
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/features1/createpost/post_api.dart';
import 'package:job/src/features1/createpost/views/requested_persons.dart';
import 'package:job/src/features1/editpost/views/edit_job_information.dart';

class MypostDetails extends StatefulWidget {
  const MypostDetails({super.key, required this.job_id});

  final String job_id;

  @override
  State<MypostDetails> createState() => _MypostDetailsState();
}

class _MypostDetailsState extends State<MypostDetails> {
  bool m_isLoading = false;
  List menu = [
    "Description",
    "Perk and Benefit",
  ];
  int _SIndex = 0;
  bool showFullText = false;

  var details;

  var value;

  @override
  void initState() {
    initilize();
    // TODO: implement initState

    super.initState();
  }

  initilize() async {
    setState(() {
      m_isLoading = true;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var result = await PostApi.getCompanyJobDetails(
        context,
        UserResponse['data']['id'],
        widget.job_id,
        UserResponse['data']['api_token']);
    print(widget.job_id);
    print(UserResponse['data']['id']);
    print(UserResponse['data']['api_token']);

    if (result.success) {
      setState(() {
        details = result.data['data'];
        // value = result.data['data'];
      });
    }
    setState(() {
      m_isLoading = false;
    });
    print(details);
  }

  String getEmploymentTypes(list) {
    List employmentTypes =
        list.map((item) => item["employmenttype"].toString()).toList();
    return employmentTypes.join(', ');
  }

  String changeDateFormat(String date) {
    DateTime _date = DateFormat("yyyy-MM-dd").parse(date);
    String _formattedDate = DateFormat('dd-MM-yyyy').format(_date);
    return _formattedDate;
  }

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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text("Job details",
            style: TextStyle(color: AppTheme.white, fontSize: 18)),
        leading: IconButton(
            onPressed: () {
              Nav.back(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme.white,
            )),
        actions: [
          PopupMenuButton<String>(
            iconColor: Colors.white,
            onSelected: (String value) {
              // Handle item selection
              print('Selected: $value');
              if (value == "Edit") {
                Nav.to(
                  context,
                  EditJobInformation(
                    editData: details,
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Edit',
                  child: Text('Edit'),
                ),
                // const PopupMenuItem<String>(
                //   value: 'Delete',
                //   child: Text('Delete'),
                // ),
              ];
            },
          ),
        ],
      ),
      body: !m_isLoading
          ? SingleChildScrollView(
              child: SizedBox(
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
                                borderRadius: BorderRadius.circular(15.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                        details?['company_details']
                                            ?['is_company_logo'],
                                        fit: BoxFit.fill,
                                        height: 50,
                                        width: 55, errorBuilder:
                                            (BuildContext context,
                                                Object exception,
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
                        height: 10,
                      ),
                      Text(
                        details?['job_title'] ?? "",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'expires on ${changeDateFormat(details!['display_expire_date'].toString().substring(0, 10))}',
                        style: TextStyle(
                            color: AppTheme.TextLite,
                            fontSize: 12,
                            height: 1.5),
                      ),
                      // Text(
                      //   "Elux Space, Malang(Remote)",
                      //   style: TextStyle(color: AppTheme.TextLite, fontSize: 13),
                      // ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: screenWidth,
                        padding: const EdgeInsets.all(5.0),
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
                                    details?['employee_size'] ?? "",
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
                                        details['is_employment_types'] ?? []),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(height: 1.5),
                                  ),
                                  getEmploymentTypes(details[
                                                      'is_employment_types'] ??
                                                  [])
                                              .length >
                                          8
                                      ? InkWell(
                                          onTap: () {
                                            _showDialog(
                                                context,
                                                "Job Type",
                                                getEmploymentTypes(details[
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
                                      : const SizedBox(
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
                                    details['is_job_level'] ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(height: 1.5),
                                  ),
                                  // Job_Details['is_job_level']
                                  (details['is_job_level'] ?? "").length > 8
                                      ? InkWell(
                                          onTap: () {
                                            _showDialog(context, "Job Level",
                                                details['is_job_level'] ?? "");
                                          },
                                          child: Text(
                                            "Read More",
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: AppTheme.primary),
                                          ),
                                        )
                                      : const SizedBox(
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
                                  details['is_hide_salary'].toString() == '1'
                                      ? const SizedBox(
                                          height: 0,
                                        )
                                      : Text(
                                          "${(details['from_sal'] ?? "").toString()} - ${(details['to_sal'] ?? "").toString()}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(height: 1.5),
                                        ),
                                  // ((details['from_sal'] ?? "") +
                                  //                 (details['from_sal'] ?? ""))
                                  //             .toString()
                                  //             .length >
                                  //         7
                                  //     ?
                                  InkWell(
                                    onTap: () {
                                      _showDialog(
                                          context,
                                          "Salaries",
                                          details['is_hide_salary']
                                                      .toString() ==
                                                  '1'
                                              ? "Salary details are hidden"
                                              : "${(details['from_sal'] ?? "").toString()} - ${(details['to_sal'] ?? "").toString()}");
                                    },
                                    child: Text(
                                      "Read More",
                                      style: TextStyle(
                                          fontSize: 8, color: AppTheme.primary),
                                    ),
                                  )
                                  // : const SizedBox(
                                  //     height: 0,
                                  //   )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                      //             details?['employee_size'] ?? "",
                      //             style: TextStyle(height: 1.5),
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
                      //            Text(
                      //               getEmploymentTypes(
                      //                   details['is_employment_types'] ??
                      //                       []),
                      //               maxLines: 1,
                      //               overflow: TextOverflow.ellipsis,
                      //               style: TextStyle(height: 1.5),
                      //             ),
                      //             getEmploymentTypes(details[
                      //                                 'is_employment_types'] ??
                      //                             [])
                      //                         .length >
                      //                     8
                      //                 ? InkWell(
                      //                     onTap: () {
                      //                       _showDialog(
                      //                           context,
                      //                           "Job Type",
                      //                           getEmploymentTypes(details[
                      //                                   'is_employment_types'] ??
                      //                               []));
                      //                     },
                      //                     child: Text(
                      //                       "Read More",
                      //                       style: TextStyle(
                      //                           fontSize: 8,
                      //                           color: AppTheme.primary),
                      //                     ),
                      //                   )
                      //                 : SizedBox(
                      //                     height: 0,
                      //                   )
                      //           // const Text(
                      //           //   "Part-time",
                      //           //   style: TextStyle(height: 1.5),
                      //           // ),
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
                      //            Text(
                      //               details['is_job_level'] ?? "",
                      //               maxLines: 1,
                      //               overflow: TextOverflow.ellipsis,
                      //               style: TextStyle(height: 1.5),
                      //             ),
                      //             // Job_Details['is_job_level']
                      //             (details['is_job_level'] ?? "").length > 8
                      //                 ? InkWell(
                      //                     onTap: () {
                      //                       _showDialog(
                      //                           context,
                      //                           "Job Type",
                      //                           details['is_job_level'] ??
                      //                               "");
                      //                     },
                      //                     child: Text(
                      //                       "Read More",
                      //                       style: TextStyle(
                      //                           fontSize: 8,
                      //                           color: AppTheme.primary),
                      //                     ),
                      //                   )
                      //                 : SizedBox(
                      //                     height: 0,
                      //                   )
                      //           // const Text(
                      //           //   "Junior",
                      //           //   style: TextStyle(height: 1.5),
                      //           // ),
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
                                  crossAxisCount: 3, childAspectRatio: 3),
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
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Text(
                                          data,
                                          style: TextStyle(
                                              color: _SIndex == index
                                                  ? AppTheme.white
                                                  : AppTheme.TextBoldLite,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold),
                                        ))),
                              ),
                            );
                          }),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      _SIndex == 0 ? Description() : Benefit(),

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
              ),
            )
          : SingleChildScrollView(child: ShimmerLoader(type: "details")),
      bottomNavigationBar: m_isLoading
          ? const SizedBox(
              height: 0,
            )
          : details['applied_count'] == null ||
                  details['applied_count'].toString() == '0'
              ? const SizedBox(
                  height: 0,
                )
              : Container(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      Nav.to(
                        context,
                        RequestedPersons(
                          jobId: details['id'].toString(),
                          jobTitle: details?['job_title'] ?? "",
                        ),
                      );
                    },
                    child: Text(
                        'View ${details['applied_count'] ?? 's'} requests'),
                  ),
                ),
      //  Center(child: CircularProgressIndicator())
    );
  }

  Description() {
    return Column(
      children: [
        Platform.isAndroid
            ? const SizedBox(
                height: 20,
              )
            : const SizedBox(
                height: 0,
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
        details?['job_description'] != null
            ? RichText(
                textAlign: TextAlign.justify,
                text: details?['job_description'].length > 201
                    ? TextSpan(
                        text: showFullText
                            ? (details?['job_description'] ?? "")
                            : "${details['job_description'].substring(0, 200)}...",
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
                        text: details?['job_description'] ?? "",
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
          " " + "${details?['job_responsibility'] ?? ""}",
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
              "Skills: ${details?['skills']}",
            )),
        const SizedBox(
          height: 20,
        ),
        const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Qualifications",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
        const SizedBox(
          height: 20,
        ),
        ListView.builder(
            itemCount: details?['is_education'].length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final edu_data = details?['is_education'][index];
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
            }),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Benefit() {
    return Column(
      children: [
        Platform.isAndroid == "ANDROID"
            ? const SizedBox(
                height: 15,
              )
            : const SizedBox(
                height: 0,
              ),
        GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: details['is_job_benefits'].length,
            itemBuilder: (BuildContext context, int index) {
              final data = details['is_job_benefits'][index];
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
                            child: Text('UnSupported Image'),
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
            }),
      ],
    );
  }
}

class ProfileImage extends StatelessWidget {
  final String imageUrl;

  const ProfileImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(imageUrl),
        ),
      ),
    );
  }
}
