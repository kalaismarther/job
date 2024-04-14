// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features1/dashboard/provider_dashboard_api.dart';
import 'package:job/src/features1/request/request_api.dart';
import 'package:job/src/features1/subscription/views/subscription_list.dart';
import 'package:path_provider/path_provider.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails(
      {super.key,
      required this.applied_user_id,
      required this.job_id,
      required this.jobs_applied_id});

  final String applied_user_id;
  final String job_id;
  final String jobs_applied_id;

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  var details;
  bool download_pdf = false;
  bool isLoading = false;

  List status = [
    {"id": "1", "status": "Applied"},
    {"id": "2", "status": "Reviewed"},
    {"id": "3", "status": "HR Interview"},
    {"id": "4", "status": "Interview"},
    {"id": "5", "status": "Sortlisted"},
    {"id": "6", "status": "Rejected"},
  ];
  @override
  void initState() {
    print(widget.applied_user_id);
    print(widget.job_id);
    print(widget.jobs_applied_id);
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
      "applied_user_id": widget.applied_user_id,
      "job_id": widget.job_id
    };
    print(data);
    var get_details = await RequestApi.getAppliedProfiledetails(
        context, data, UserResponse['data']['api_token']);

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

  Future<void> _showModal(data, job_applied_id, status_id) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return UpdateModal(
          data: data,
          job_applied_id: job_applied_id,
          status_id: status_id.toString(),
        );
      },
    );
    print(result);
    setState(() {
      details?['job_details']?['status'] = result ?? "";
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
          style: const TextStyle(color: AppTheme.white, fontSize: 18),
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
                                child: Text('UnSupported Image'),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                // Text(
                                //   "Social Media Assistant",
                                //   style: TextStyle(color: AppTheme.TextBoldLite),
                                // ),
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
                                                color: AppTheme.TextLite,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        details?['email'] ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12),
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
                                                color: AppTheme.TextLite,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "+${details?['country_code'] ?? ""} ${details?['mobile'] ?? ""}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    )
                                  ],
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  "Date of Birth",
                                  style: TextStyle(color: AppTheme.TextLite),
                                ),
                                Text(details?['dob'] ?? "",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
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
                                // Text(
                                //     details?['userprofessiondetails']?[0]
                                //             ?['is_current_location'] ??
                                //         "",
                                //     style:
                                //         TextStyle(fontWeight: FontWeight.bold)),
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
                                //     details?['userprofessiondetails']?[0]
                                //             ?['is_qualification'] ??
                                //         "",
                                //     style:
                                //         TextStyle(fontWeight: FontWeight.bold)),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                                        physics: NeverScrollableScrollPhysics(),
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
                                // ListView.builder(
                                //     shrinkWrap: true,
                                //     itemCount:
                                //         (details?['is_preferred_role_ids'] ??
                                //                 [])
                                //             .length,
                                //     physics: NeverScrollableScrollPhysics(),
                                //     itemBuilder: (context, index) {
                                //       final text_data =
                                //           details?['is_preferred_role_ids']
                                //               [index];
                                //       return Text(text_data['role_name'] ?? "",
                                //           style: TextStyle(
                                //               fontWeight: FontWeight.bold,
                                //               color: AppTheme.primary));
                                //     }),
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
                    SizedBox(
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
                            } else {
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
                                    .CompanyDownloadCVcheck(context, data,
                                        UserResponse['data']['api_token']);
                                print(result);
                                PrefManager.write("job_post_status",
                                    result.data['job_post_status'] ?? 0);
                                PrefManager.write("cv_view_status",
                                    result.data['cv_view_status'] ?? 0);
                                // Snackbar.show("Please wait ....", Colors.black);

                                await createFileOfPdfUrl(details?['job_details']
                                            ?['is_resume'] ??
                                        "")
                                    .then((f) {
                                  Nav.to(
                                      context,
                                      PdfViewer(
                                        pdfUrl: f.path,
                                      ));
                                  // setState(() {
                                  //   remotePDFpath = f.path;
                                  // });
                                });
                                setState(() {
                                  download_pdf = false;
                                });
                              }
                            }
                          },
                          child: !download_pdf
                              ? Text(
                                  "View CV",
                                  style: TextStyle(color: AppTheme.primary),
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
                          onPressed: () {
                            _showModal(status, widget.jobs_applied_id,
                                details?['job_details']?['status'] ?? "");
                          },
                          child: Text("Update Status")),
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

class PdfViewer extends StatefulWidget {
  final String pdfUrl;

  PdfViewer({required this.pdfUrl});

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late int pageNumber = 1;
  late int totalPages = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text(
          "View CV",
          style: const TextStyle(color: AppTheme.white, fontSize: 18),
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
      // appBar: AppBar(
      //   title: Text('PDF Viewer', style: TextStyle(color: Colors.white),),
      // ),
      body: Center(
        child: PDFView(
          filePath: widget.pdfUrl,
          autoSpacing: true,
          pageSnap: true,
          pageFling: true,
          onPageChanged: (page, total) {
            setState(() {
              pageNumber = page!.toInt();
              totalPages = total!.toInt();
            });
          },
          onError: (error) {
            print('PDFView Error: $error');
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Page ${pageNumber + 1} of $totalPages',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class UpdateModal extends StatefulWidget {
  const UpdateModal(
      {super.key,
      required this.data,
      required this.job_applied_id,
      required this.status_id});

  final List data;
  final String job_applied_id;
  final String status_id;
  @override
  State<UpdateModal> createState() => _UpdateModalState();
}

class _UpdateModalState extends State<UpdateModal> {
  String _selectedStatus = "";
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    _selectedStatus = widget.status_id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  var item = widget.data[index];
                  return ListTile(
                    title: Text(item['status']),
                    trailing: Radio(
                      value: item['id'],
                      groupValue: _selectedStatus,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value; // Update the selected value
                        });
                      },
                    ),
                  );
                })),
        SizedBox(
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () async {
                    if (!isLoading) {
                      setState(() {
                        isLoading = true;
                      });
                      var UserResponse = PrefManager.read("UserResponse");

                      var data = {
                        "user_id": UserResponse['data']['id'],
                        "jobs_applied_id": widget.job_applied_id,
                        "status": _selectedStatus
                      };
                      var result = await RequestApi.updateAppliedProfiled(
                          context, data, UserResponse['data']['api_token']);
                      if (result.success) {
                        if (result.data['status'].toString() == "1") {
                          if (result.data['message'] != null) {
                            Snackbar.show(result.data['message'], Colors.green);
                          } else {
                            Snackbar.show("Updated Successfully", Colors.green);
                          }
                        } else {
                          Snackbar.show("Failed", Colors.black);
                        }
                      }
                      Nav.back(context, _selectedStatus);
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: !isLoading ? Text("Update") : Loader.common()),
            )),
        Platform.isIOS
            ? const SizedBox(
                height: 20,
              )
            : const SizedBox(
                height: 0,
              )
      ],
    );
  }
}
