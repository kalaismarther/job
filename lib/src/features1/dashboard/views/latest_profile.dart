import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/guestAlert.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features1/account/profile_details.dart';
import 'package:job/src/features1/dashboard/provider_dashboard_api.dart';
import 'package:job/src/features1/request/request_api.dart';
import 'package:job/src/features1/subscription/views/subscription_list.dart';
import 'package:path_provider/path_provider.dart';

class LatestProfile extends StatefulWidget {
  const LatestProfile({super.key, required this.user_id});
  final String user_id;

  @override
  State<LatestProfile> createState() => _LatestProfileState();
}

class _LatestProfileState extends State<LatestProfile> {
  bool isLoading = false;
  bool btn_loading = false;
  bool download_pdf = false;
  bool alreadyInterestGiven = false;

  var details;

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
    var data = {
      "user_id": UserResponse['data']['id'],
      "applied_user_id": widget.user_id,
      // "job_id": widget.job_id
    };
    print(data);
    var get_details = await RequestApi.getAppliedProfiledetails(
        context, data, UserResponse['data']['api_token']);
    // var get_details = await UserProfileApi.GetUserProfileDetails(
    //     context, widget.user_id, UserResponse['data']['api_token']);
    print(get_details);

    if (get_details.success) {
      if (get_details.data['status'].toString() == "1") {
        setState(() {
          details = get_details.data['data'];
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text(
          "Profile Details",
          style: TextStyle(color: AppTheme.white, fontSize: 18),
        ),
        leading: IconButton(
            onPressed: () {
              Nav.back(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme.white,
            )),
      ),
      body: SingleChildScrollView(
        child: !isLoading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: const Offset(0.2, 0.2),
                                blurRadius: 6.0)
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ClipOval(
                          //   child: Image.asset(
                          //     "assets/images/ellipse.png",
                          //     width: ScreenWidth * 0.17,
                          //   ),
                          // ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: Image.network(details['is_profile_image'],
                                fit: BoxFit.cover,
                                height: 60,
                                width: 60, errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                              // Handle the error here
                              return const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: ScreenWidth * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  details?['name'] ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                // Text(
                                //   "Social Media Assistant",
                                //   style: TextStyle(color: AppTheme.TextBoldLite),
                                // ),
                                const SizedBox(
                                  height: 10,
                                ),
                                alreadyInterestGiven ||
                                        details?['is_company_interested']
                                                .toString() ==
                                            '1'
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/icons/email.png",
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Email",
                                                      style: TextStyle(
                                                          color:
                                                              AppTheme.TextLite,
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  details?['email'] ?? "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/icons/phone.png",
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Contact",
                                                      style: TextStyle(
                                                          color:
                                                              AppTheme.TextLite,
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "+${details?['country_code'] ?? ""} ${details?['mobile'] ?? ""}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    : const Text(
                                        'Tap Interest to see contact details',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.grey),
                                      ),
                                // const SizedBox(
                                //   height: 10,
                                // ),
                                // Row(
                                //   children: [
                                //     SizedBox(
                                //       width: 100,
                                //       child: Row(
                                //         children: [
                                //           Image.asset(
                                //             "assets/icons/website.png",
                                //             height: 20,
                                //             width: 20,
                                //           ),
                                //           const SizedBox(
                                //             width: 10,
                                //           ),
                                //           Text(
                                //             "Website",
                                //             style: TextStyle(
                                //                 color: AppTheme.TextLite,
                                //                 fontSize: 12),
                                //           )
                                //         ],
                                //       ),
                                //     ),
                                //     const Expanded(
                                //       child: Text(
                                //         "www.jeromebell.com",
                                //         overflow: TextOverflow.ellipsis,
                                //         style: TextStyle(fontSize: 12),
                                //       ),
                                //     )
                                //   ],
                                // )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Personal Info",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: ScreenWidth * 0.47,
                            // color: Colors.red,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Full Name",
                                  style: TextStyle(color: AppTheme.TextLite),
                                ),
                                Text(
                                  details?['name'] ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  "Date of Birth",
                                  style: TextStyle(color: AppTheme.TextLite),
                                ),
                                Text(details?['dob'] ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  "Gender",
                                  style: TextStyle(color: AppTheme.TextLite),
                                ),
                                Text(details?['gender'] ?? "",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                // const SizedBox(
                                //   height: 25,
                                // ),
                                // Text(
                                //   "Address",
                                //   style: TextStyle(color: AppTheme.TextLite),
                                // ),
                                // const Text(
                                //     "4517 Washington Ave, Macheskar, kentucky 39495",
                                //     style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  "Location",
                                  style: TextStyle(color: AppTheme.TextLite),
                                ),
                                Text(
                                  details?['userprofessiondetails']
                                              ?.isNotEmpty ==
                                          true
                                      ? (details['userprofessiondetails'][0]
                                              ?['is_current_location'] ??
                                          "")
                                      : "",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                // Text(
                                //     details?['userprofessiondetails']?[0]
                                //             ?['is_current_location'] ??
                                //         "",
                                //     style:
                                //         TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 25,
                                ),
                                // Text(
                                //   "Current Jovb",
                                //   style: TextStyle(color: AppTheme.TextLite),
                                // ),
                                // const Text("Product Designer",
                                //     style: TextStyle(fontWeight: FontWeight.bold)),
                                // const SizedBox(
                                //   height: 25,
                                // ),
                                // Text(
                                //   "Highest Qualification Held",
                                //   style: TextStyle(color: AppTheme.TextLite),
                                // ),
                                // const Text("Bachelors in Engineering",
                                //     style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  "High Qualification",
                                  style: TextStyle(color: AppTheme.TextLite),
                                ),
                                // Text(
                                //   details?['userprofessiondetails']?[0]
                                //               ?['is_qualification']
                                //           ?['qualification'] is String
                                //       ? (details['userprofessiondetails']?[0]
                                //                   ?['is_qualification']
                                //               ?['qualification'] ??
                                //           "")
                                //       : "",
                                //   style: TextStyle(fontWeight: FontWeight.bold),
                                // ),
                                // Text(
                                //   (details?['userprofessiondetails']?[0]
                                //               ?['is_qualification']
                                //           ?['qualification'] is String)
                                //       ? details['userprofessiondetails'][0]
                                //           ['is_qualification']['qualification']
                                //       : "",
                                //   style: TextStyle(fontWeight: FontWeight.bold),
                                // ),
                                Text(
                                  (details?['userprofessiondetails'] != null &&
                                          details['userprofessiondetails']
                                              is List &&
                                          details['userprofessiondetails']
                                              .isNotEmpty &&
                                          details['userprofessiondetails'][0] !=
                                              null &&
                                          details['userprofessiondetails'][0]
                                                  ['is_qualification'] !=
                                              null &&
                                          details['userprofessiondetails'][0]
                                                  ['is_qualification']
                                              ['qualification'] is String)
                                      ? details['userprofessiondetails'][0]
                                          ['is_qualification']['qualification']
                                      : "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),

                                // Text(
                                //     details?['userprofessiondetails']?[0]
                                //             ?['is_qualification'] ??
                                //         "",
                                //     style:
                                //         TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Container(
                            // color: Colors.amber,
                            width: ScreenWidth * 0.48,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   "Gender",
                                //   style: TextStyle(color: AppTheme.TextLite),
                                // ),
                                // Text(details?['gender'] ?? "",
                                //     style:
                                //         TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  "Profession Type",
                                  style: TextStyle(color: AppTheme.TextLite),
                                ),
                                // Text(
                                //     details?['userprofessiondetails']?[0]
                                //             ?['is_profession_type'] ??
                                //         "",
                                //     style:
                                //         TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  (details?['userprofessiondetails'] != null &&
                                          details['userprofessiondetails']
                                              is List &&
                                          details['userprofessiondetails']
                                              .isNotEmpty &&
                                          details['userprofessiondetails'][0] !=
                                              null &&
                                          details['userprofessiondetails'][0]
                                              ['is_profession_type'] is String)
                                      ? details['userprofessiondetails'][0]
                                          ['is_profession_type']
                                      : "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(
                                  height: 25,
                                ),
                                // Text(
                                //   "Language",
                                //   style: TextStyle(color: AppTheme.TextLite),
                                // ),
                                // const Text("English, French, Bahasa",
                                //     style: TextStyle(fontWeight: FontWeight.bold)),
                                // const SizedBox(
                                //   height: 25,
                                // ),
                                // Text(
                                //   "Experience in Years",
                                //   style: TextStyle(color: AppTheme.TextLite),
                                // ),
                                // const Text("4 Years",
                                //     style:
                                //         TextStyle(fontWeight: FontWeight.bold)),
                                // const SizedBox(
                                //   height: 25,
                                // ),
                                Text(
                                  "Skill set",
                                  style: TextStyle(color: AppTheme.TextLite),
                                ),
                                Text(
                                    (details?['userjobpreferences']
                                                ?.isNotEmpty ??
                                            false)
                                        ? (details['userjobpreferences'][0]
                                                    ?['skills'] ??
                                                "")
                                            .toString()
                                        : "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primary)),
                                // Text(
                                //     details?['userjobpreferences']?[0]
                                //             ?['skills'] ??
                                //         "",
                                //     style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         color: AppTheme.primary)),
                                const SizedBox(
                                  height: 25,
                                ),
                                //                             var isPreferredRoleIds = get_details?.data?['data']?['userjobpreferences']?.isNotEmpty ?? false
                                // ? (get_details.data['data']['userjobpreferences'][0] as Map<String, dynamic>?)?['is_preferred_role_ids']
                                // : null;

// print('is_preferred_role_ids: $isPreferredRoleIds');

                                Text(
                                  "Preferred Role",
                                  style: TextStyle(color: AppTheme.TextLite),
                                ),
                                details['userjobpreferences']?.isNotEmpty ??
                                        false
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: (details?[
                                                        'userjobpreferences']?[0]
                                                    ?[
                                                    'is_preferred_role_ids'] ??
                                                [])
                                            .length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final text_data =
                                              details?['userjobpreferences']?[0]
                                                      ?['is_preferred_role_ids']
                                                  [index];
                                          return Text(
                                              text_data['role_name'] ?? "",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.primary));
                                        })
                                    : const SizedBox(
                                        height: 0,
                                      ),
                                // Text(
                                //     details?['userjobpreferences']?[0]?['skills'] ??
                                //         "",
                                //     style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         color: AppTheme.primary)),
                                const SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // SizedBox(
                    //   width: ScreenWidth,
                    //   child: ElevatedButton(
                    //       style: ButtonStyle(
                    //           backgroundColor:
                    //               MaterialStatePropertyAll(Colors.white),
                    //           side: MaterialStatePropertyAll(BorderSide(
                    //               width: 2, color: AppTheme.primary))),
                    //       onPressed: () {
                    //         if (!download_pdf) {
                    //           setState(() {
                    //             download_pdf = true;
                    //           });
                    //           createFileOfPdfUrl(details?['job_details']
                    //                       ?['is_resume'] ??
                    //                   "")
                    //               .then((f) {
                    //             Nav.to(
                    //                 context,
                    //                 PdfViewer(
                    //                   pdfUrl: f.path,
                    //                 ));
                    //             // setState(() {
                    //             //   remotePDFpath = f.path;
                    //             // });
                    //           });
                    //           setState(() {
                    //             download_pdf = false;
                    //           });
                    //         }
                    //       },
                    //       child: Text(
                    //         "View CV",
                    //         style: TextStyle(color: AppTheme.primary),
                    //       )),
                    // ),
                    // (details?['is_resume']) != null &&
                    //         (details?['is_resume']) != ""
                    //     ? SizedBox(
                    //         width: ScreenWidth,
                    //         child: ElevatedButton(
                    //             style: ButtonStyle(
                    //                 backgroundColor:
                    //                     MaterialStatePropertyAll(Colors.white),
                    //                 side: MaterialStatePropertyAll(BorderSide(
                    //                     width: 2, color: AppTheme.primary))),
                    //             onPressed: () async {
                    //               if (!download_pdf) {
                    //                 setState(() {
                    //                   download_pdf = true;
                    //                 });
                    //                 // Snackbar.show("Please wait ....", Colors.black);
                    //                 await createFileOfPdfUrl(
                    //                         details?['is_resume'] ?? "")
                    //                     .then((f) {
                    //                   Nav.to(
                    //                       context,
                    //                       PdfViewer(
                    //                         pdfUrl: f.path,
                    //                       ));
                    //                   // setState(() {
                    //                   //   remotePDFpath = f.path;
                    //                   // });
                    //                 });
                    //                 setState(() {
                    //                   download_pdf = false;
                    //                 });
                    //               }
                    //             },
                    //             child: !download_pdf
                    //                 ? Text(
                    //                     "View CV",
                    //                     style:
                    //                         TextStyle(color: AppTheme.primary),
                    //                   )
                    //                 : SizedBox(
                    //                     height: 30,
                    //                     width: 30,
                    //                     child: CircularProgressIndicator(
                    //                       strokeWidth: 3,
                    //                       color: AppTheme.primary,
                    //                     ),
                    //                   )),
                    //       )
                    //     : const SizedBox(
                    //         height: 0,
                    //       ),
                    details['is_resume'] == null ||
                            details['is_resume'].toString().isEmpty
                        ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.white),
                                  side: MaterialStatePropertyAll(BorderSide(
                                      width: 2, color: AppTheme.primary))),
                              onPressed: () {},
                              child: Text(
                                '${details?['name'] ?? ""} hasn\'t uploaded CV',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: AppTheme.primary),
                              ),
                            ),
                          )
                        : SizedBox(
                            width: ScreenWidth,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.white),
                                    side: MaterialStatePropertyAll(BorderSide(
                                        width: 2, color: AppTheme.primary))),
                                onPressed: () async {
                                  var cv_view_status =
                                      PrefManager.read("cv_view_status");
                                  if (cv_view_status.toString() == "0") {
                                    Nav.to(context, const SubscriptionList());
                                  } else if (alreadyInterestGiven ||
                                      details?['is_company_interested']
                                              .toString() ==
                                          '1') {
                                    if (!download_pdf) {
                                      setState(() {
                                        download_pdf = true;
                                      });
                                      var UserResponse =
                                          PrefManager.read("UserResponse");
                                      var data = {
                                        "user_id": UserResponse['data']['id'],
                                        "applied_user_id": details['id']
                                      };
                                      var result = await ProviderDashboardApi
                                          .CompanyDownloadCVcheck(
                                              context,
                                              data,
                                              UserResponse['data']
                                                  ['api_token']);
                                      print(result);
                                      PrefManager.write("job_post_status",
                                          result.data['job_post_status'] ?? 0);
                                      PrefManager.write("cv_view_status",
                                          result.data['cv_view_status'] ?? 0);
                                      // Snackbar.show("Please wait ....", Colors.black);

                                      await createFileOfPdfUrl(
                                              details?['is_resume'] ?? "")
                                          .then((f) {
                                        Nav.to(
                                          context,
                                          PdfViewer(
                                            pdfUrl: f.path,
                                          ),
                                        );
                                        // setState(() {
                                        //   remotePDFpath = f.path;
                                        // });
                                      });
                                      setState(() {
                                        download_pdf = false;
                                      });
                                    }
                                  } else {
                                    Snackbar.show('Give interest to view CV',
                                        Colors.black);
                                  }
                                },
                                child: !download_pdf
                                    ? Text(
                                        "View CV",
                                        style:
                                            TextStyle(color: AppTheme.primary),
                                      )
                                    : SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: AppTheme.primary,
                                        ),
                                      )),
                          ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: ScreenWidth,
                      child: ElevatedButton(
                        onPressed: () async {
                          // _showModal(status, widget.jobs_applied_id,
                          //     details?['job_details']?['status'] ?? "");
                          var result = PrefManager.read("guest");

                          if (result == "yes") {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return GuestAlert();
                              },
                            );
                          } else {
                            var cv_view_status =
                                PrefManager.read("cv_view_status");
                            print(cv_view_status);
                            if (cv_view_status.toString() == "0") {
                              Nav.to(context, const SubscriptionList());
                            } else if (alreadyInterestGiven ||
                                details?['is_company_interested'].toString() ==
                                    '1') {
                              Snackbar.show(
                                  'Already Interest given', Colors.black);
                            } else {
                              if (btn_loading == false) {
                                setState(() {
                                  btn_loading = true;
                                });
                                var UserResponse =
                                    PrefManager.read("UserResponse");
                                // var data1 = {
                                //   "user_id": UserResponse['data']['id'],
                                //   "applied_user_id": details['id']
                                // };
                                // print(data1);
                                // var result = await ProviderDashboardApi
                                //     .CompanyDownloadCVcheck(context, data1,
                                //         UserResponse['data']['api_token']);
                                //         print(result);

                                var data = {
                                  "user_id": UserResponse['data']['id'],
                                  "pick_user_id": details['id']
                                };
                                var pic_user =
                                    // ignore: use_build_context_synchronously
                                    await RequestApi.compnayUserPick(
                                        context,
                                        data,
                                        UserResponse['data']['api_token']);

                                if (pic_user.success) {
                                  if (pic_user.data['status'].toString() ==
                                      "1") {
                                    setState(() {
                                      alreadyInterestGiven = true;
                                    });
                                    PrefManager.write("job_post_status",
                                        pic_user.data['job_post_status'] ?? 0);
                                    PrefManager.write("cv_view_status",
                                        pic_user.data['cv_view_status'] ?? 0);
                                    if (pic_user.data['message'] != null) {
                                      Snackbar.show(pic_user.data['message'],
                                          Colors.green);
                                    } else {
                                      Snackbar.show(
                                          "Successfully", Colors.green);
                                    }
                                  } else if (pic_user.data['message'] != null) {
                                    Snackbar.show(
                                        pic_user.data['message'], Colors.black);
                                  } else {
                                    Snackbar.show("Some Error", Colors.red);
                                  }
                                }
                                setState(() {
                                  btn_loading = false;
                                });
                              }
                            }
                          }
                        },
                        child: !btn_loading
                            ? Text(alreadyInterestGiven ||
                                    details?['is_company_interested']
                                            .toString() ==
                                        '1'
                                ? 'Interest Given'
                                : 'Interest')
                            : Loader.common(),
                      ),
                    )
                  ],
                ),
              )
            : ShimmerLoader(type: ""),
      ),
    );
  }
}

Future<File> createFileOfPdfUrl(url_str) async {
  Completer<File> completer = Completer();
  print("Start download file from internet!");
  try {
    final url = url_str;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    var dir = await getApplicationDocumentsDirectory();
    print("Download files");
    print("${dir.path}/$filename");
    File file = File("${dir.path}/$filename");

    await file.writeAsBytes(bytes, flush: true);
    completer.complete(file);
  } catch (e) {
    throw Exception('Error parsing asset file!');
  }

  return completer.future;
}
