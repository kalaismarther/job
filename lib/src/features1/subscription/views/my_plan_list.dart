import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/file_storage.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features1/createpost/views/mypost_details.dart';
import 'package:job/src/features1/dashboard/views/provider_dashboard.dart';
import 'package:job/src/features1/subscription/subscription_api.dart';
import 'package:job/src/features1/subscription/views/viewed_cv_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;

class MyPlanList extends StatefulWidget {
  const MyPlanList({super.key});

  @override
  State<MyPlanList> createState() => _MyPlanListState();
}

class _MyPlanListState extends State<MyPlanList> {
  final controller = ScrollController();

  bool isLoading = false;
  bool page_loading = false;
  List list = [];
  var page_no;
  @override
  void initState() {
    // TODO: implement initState
    initilize("");
    scrollEvent();
    super.initState();
  }

  initilize(type) async {
    setState(() {
      // isLoading = true;
      type == "scroll" ? page_loading = true : isLoading = true;
      page_no = list.length;
    });
    var UserResponse = PrefManager.read("UserResponse");

    var get_list = await SubscriptionApi.getPackagePurchaseList(context,
        UserResponse['data']['id'], page_no, UserResponse['data']['api_token']);
    print(get_list.data);

    if (get_list.success) {
      if (get_list.data['status'].toString() == "1") {
        setState(() {
          list.addAll(get_list.data['data'] ?? []);
        });
        print(list);
      }
    }
    setState(() {
      type == "scroll" ? page_loading = false : isLoading = false;
    });
  }

  void scrollEvent() {
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        if (page_no != null && page_no != list.length) {
          // Latest();
          initilize("scroll");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: AppTheme.primary,
      //   title: const Text("Packages",
      //       style: TextStyle(
      //         color: AppTheme.white,
      //       )),
      //   leading: IconButton(
      //       onPressed: () {
      //         Nav.back(context);
      //       },
      //       icon: const Icon(
      //         Icons.arrow_back_ios_new,
      //         color: AppTheme.white,
      //       )),
      // ),
      body: !isLoading
          ? list.isNotEmpty
              ? SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          // final data = list[index];

                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              print(list[index]['downloaded_cvs']);
                            },
                            child: Subt(
                              package: list[index],
                              index: index,
                            ),
                          );
                        },
                      ),
                      page_loading
                          ? const Padding(
                              padding: EdgeInsets.all(5),
                              child: SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: CircularProgressIndicator()))
                          : const SizedBox(
                              height: 0,
                            )
                    ],
                  ),
                )
              : const Center(child: Text("No list"))
          : SingleChildScrollView(child: ShimmerLoader(type: "")),
    );
  }
}

// class SubscriptionCard extends StatelessWidget {
//   final Map package;
//   final int index;

//   const SubscriptionCard({Key? key, required this.package, required this.index})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Future downloadFile() async {
//       final appStorage = await getApplicationDocumentsDirectory();

//       final file = File('${appStorage.path}/invoice.pdf');

//       try {
//         final response = await Dio().get(package['is_invoice'],
//             options: Options(
//                 responseType: ResponseType.bytes,
//                 followRedirects: false,
//                 receiveTimeout: Duration.zero));

//         final raf = file.openSync(mode: FileMode.write);
//         raf.writeFromSync(response.data);
//         await raf.close();
//         return file;
//       } catch (e) {
//         print(e);
//       }
//     }

//     List<Color> colors = [
//       // Colors.blue,
//       AppTheme.primary_light,
//       AppTheme.primary_light,
//       AppTheme.primary_light,
//       // Colors.green,
//       // Colors.deepOrange,
//     ];

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Card(
//         child: Container(
//           // margin: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: colors[index % colors.length].withOpacity(0.15),
//             // Transparent background with different colors
//             borderRadius: BorderRadius.circular(10),
//             border: Border(
//               left: BorderSide(
//                 color:
//                     colors[index % colors.length], // Set desired border color
//                 width: 10.0, // Set desired border width
//               ),
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         package['package_title'] ?? "",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       package['payment_date'] ?? "",
//                       style: const TextStyle(fontSize: 10),
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "₹ ${(package['total_amount'] ?? "").toString()}",
//                       style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.green,
//                           fontWeight: FontWeight.bold),
//                     ),

//                     // Text(
//                     //   package['status'] ?? "",
//                     //   style: TextStyle(
//                     //       fontWeight: FontWeight.bold,
//                     //       color: (package['status'] ?? "") == "ACTIVE"
//                     //           ? Colors.green
//                     //           : Colors.red),
//                     // )
//                   ],
//                 ),
//                 // Text(
//                 //   package['package_title'] ?? "",
//                 //   style: TextStyle(fontSize: 16, color: AppTheme.TextLite),
//                 // ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "Invoice No: ${package['invoice_no'] ?? ""}",
//                   style: const TextStyle(fontSize: 12),
//                 ),

//                 const SizedBox(height: 10),
//                 // Text(
//                 //   package['short_description'] ?? "",
//                 //   style: const TextStyle(fontSize: 16),
//                 // ),
//                 package['job_qty'] > 0
//                     ? Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 "Job Posting Status",
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                               Text(
//                                 "${package['status'] ?? ""}",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: (package['status'] ?? "") == "ACTIVE"
//                                         ? Colors.green
//                                         : Colors.red),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                         ],
//                       )
//                     : const SizedBox(
//                         height: 0,
//                       ),
//                 package['total_cv_qty'] > 0
//                     ? Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 "CV Status",
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                               Text(
//                                 "${package['cv_download_status'] ?? ""}",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color:
//                                         (package['cv_download_status'] ?? "") ==
//                                                 "ACTIVE"
//                                             ? Colors.green
//                                             : Colors.red),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                         ],
//                       )
//                     : const SizedBox(
//                         height: 0,
//                       ),

//                 // package['company_package_id'].toString() == "3"
//                 //     ?
//                 package['total_cv_qty'] > 0 && package['job_qty'] > 0
//                     ? Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Job Qty: ${(package['job_qty'] ?? "").toString()}",
//                                 style: const TextStyle(fontSize: 12),
//                               ),
//                               Text(
//                                 "CV Qty: ${(package['total_cv_qty'] ?? "").toString()}",
//                                 style: const TextStyle(fontSize: 12),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Posted Jobs: ${package['posted_jobs'] ?? ""}",
//                                 style: const TextStyle(fontSize: 12),
//                               ),
//                               Text(
//                                 "Viewed CV: ${package['downloaded_cv_qty'] ?? ""}",
//                                 style: const TextStyle(fontSize: 12),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Pending Jobs: ${package['pending_jobs'] ?? ""}",
//                                 style: const TextStyle(fontSize: 12),
//                               ),
//                               Text(
//                                 "Pending CV: ${package['pending_cv_qty'] ?? ""}",
//                                 style: const TextStyle(fontSize: 12),
//                               ),
//                               // Text(
//                               //   package['status'] ?? "",
//                               //   style: TextStyle(
//                               //       fontWeight: FontWeight.bold,
//                               //       color: (package['status'] ?? "") == "ACTIVE"
//                               //           ? Colors.green
//                               //           : Colors.red),
//                               // )
//                             ],
//                           )
//                         ],
//                       )
//                     : Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             child: package['job_qty'] > 0
//                                 ? Text(
//                                     "Job Qty: ${(package['job_qty'] ?? "").toString()}",
//                                     style: const TextStyle(fontSize: 12),
//                                   )
//                                 : Text(
//                                     "CV Qty: ${(package['total_cv_qty'] ?? "").toString()}",
//                                     style: const TextStyle(fontSize: 12),
//                                   ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Container(
//                             child: package['job_qty'] > 0
//                                 ? Text(
//                                     "Posted Jobs: ${package['posted_jobs'] ?? ""}",
//                                     style: const TextStyle(fontSize: 12),
//                                   )
//                                 : Text(
//                                     "Viewed CV: ${package['downloaded_cv_qty'] ?? ""}",
//                                     style: const TextStyle(fontSize: 12),
//                                   ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Container(
//                             child: package['job_qty'] > 0
//                                 ? Text(
//                                     "Pending Jobs: ${package['pending_jobs'] ?? ""}",
//                                     style: const TextStyle(fontSize: 12),
//                                   )
//                                 : Text(
//                                     "Pending CV: ${package['pending_cv_qty'] ?? ""}",
//                                     style: const TextStyle(fontSize: 12),
//                                   ),
//                           ),
//                         ],
//                       ),
//                 // : Column(
//                 //     crossAxisAlignment: CrossAxisAlignment.start,
//                 //     children: [
//                 //       package['company_package_id'].toString() == "1"
//                 //           ? Text(
//                 //               "Jobs Qty: ${package['job_qty'] ?? ""}",
//                 //               style: const TextStyle(fontSize: 12),
//                 //             )
//                 //           : Text(
//                 //               "CV Qty: ${package['total_cv_qty'] ?? ""}",
//                 //               style: const TextStyle(fontSize: 12),
//                 //             ),
//                 //       const SizedBox(height: 10),
//                 //       package['company_package_id'].toString() == "1"
//                 //           ? Text(
//                 //               "Posted Jobs: ${package['posted_jobs'] ?? ""}",
//                 //               style: const TextStyle(fontSize: 12),
//                 //             )
//                 //           : Text(
//                 //               "Viewed CV: ${package['downloaded_cv_qty'] ?? ""}",
//                 //               style: const TextStyle(fontSize: 12),
//                 //             ),
//                 //       const SizedBox(height: 10),
//                 //       package['company_package_id'].toString() == "1"
//                 //           ? Text(
//                 //               "Pending Jobs: ${package['pending_jobs'] ?? ""}",
//                 //               style: const TextStyle(fontSize: 12),
//                 //             )
//                 //           : Text(
//                 //               "Pending CV: ${package['pending_cv_qty'] ?? ""}",
//                 //               style: const TextStyle(fontSize: 12),
//                 //             ),
//                 //       const SizedBox(height: 10),
//                 //     ],
//                 //   )
//                 //  package?['package_title'] == "Job Posting" ?
//                 //  ,

//                 // ElevatedButton(
//                 //   onPressed: () {
//                 //     // Implement subscription action
//                 //   },
//                 //   child: Text('Subscribe'),
//                 // ),
//                 const SizedBox(height: 10),
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton.icon(
//                     style: OutlinedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       side: BorderSide(
//                         color: AppTheme.primary,
//                       ),
//                     ),
//                     onPressed: () async {
//                       // try {
//                       //   final directory = await getExternalStorageDirectory();
//                       //   final savedDir = directory!.path;

//                       //   final taskId = await FlutterDownloader.enqueue(
//                       //     url: package['is_invoice'],
//                       //     savedDir: savedDir,
//                       //     fileName: 'invoice.pdf',
//                       //     showNotification: true,
//                       //     openFileFromNotification: true,
//                       //   );
//                       // } catch (e) {
//                       //   print(e);
//                       // }

//                       final dFile = await downloadFile();
//                       print(dFile.path);
//                       if (dFile == null) {
//                         return;
//                       }
//                       try {
//                         OpenFile.open(dFile.path);
//                       } catch (e) {
//                         print(e);
//                       }
//                     },
//                     icon: const Icon(Icons.download),
//                     label: const Text('Download Invoice'),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class Subt extends StatefulWidget {
  final Map package;
  final int index;

  const Subt({Key? key, required this.package, required this.index})
      : super(key: key);
  @override
  State<Subt> createState() => _SubtState();
}

class _SubtState extends State<Subt> {
  bool permission = false;
  bool dowloading = false;
  bool cvExcelLoading = false;
  bool postedJobsExcelLoading = false;

  String fileName = '';
  late String filePath;

  // Future<File?> downloadFile(String url) async {
  //   final appStorage = await getApplicationDocumentsDirectory();

  //   final file = File('${appStorage.path}/invoice.pdf');

  //   try {
  //     final response = await Dio().get(url,
  //         options: Options(
  //             responseType: ResponseType.bytes,
  //             followRedirects: false,
  //             receiveTimeout: 0));

  //     final raf = file.openSync(mode: FileMode.write);
  //     raf.writeFromSync(response.data);
  //     await raf.close();
  //     return file;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  // Future<void> checkPermission() async {
  //   var isStorage = await Permission.manageExternalStorage.request();

  //   if (!isStorage.isGranted) {
  //     await Permission.storage.request();
  //     if (!isStorage.isGranted) {
  //       setState(() {
  //         permission = false;
  //       });
  //     } else {
  //       setState(() {
  //         permission = true;
  //       });
  //       download();
  //     }
  //   } else {
  //     setState(() {
  //       permission = true;
  //     });
  //     download();
  //   }
  // }

  getPath() async {
    if (Platform.isAndroid) {
      final Directory? tempDir = await getExternalStorageDirectory();
      final filePath = Directory("${tempDir!.path}/files");
      if (await filePath.exists()) {
        return filePath.path;
      } else {
        await filePath.create(recursive: true);
        return filePath.path;
      }
    } else {
      try {
        final Directory? tempDir = await getApplicationDocumentsDirectory();
        final filePath = Directory("${tempDir!.path}/files");

        if (await filePath.exists()) {
          return filePath.path;
        } else {
          await filePath.create(recursive: true);
          return filePath.path;
        }
      } catch (e) {
        return ''; // Handle error accordingly
      }
    }
  }

  checkFileExists() async {
    var storePath = await getPath();
    filePath = '$storePath/$fileName';
  }

  download(fileLink) async {
    if (fileLink == '') {
      return;
    }
    setState(() {
      dowloading = true;
    });
    var storePath = await getPath();
    var filePaths = '$storePath/$fileName';
    try {
      await Dio().download(fileLink, filePaths);
      setState(() {
        dowloading = false;
      });
      OpenFile.open(filePath);
    } catch (e) {
      setState(() {
        dowloading = false;
      });
    }
  }

  excelDownload(link) async {
    var storePath = await getPath();
    var filePaths = '$storePath/$fileName';
    try {
      final result = await Dio().download(link, filePaths);
      if (result.statusCode == 200) {
        OpenFile.open(filePath);
      } else {
        setState(() {
          dowloading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        dowloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      // Colors.blue,
      AppTheme.primary_light,
      AppTheme.primary_light,
      AppTheme.primary_light,
      // Colors.green,
      // Colors.deepOrange,
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          // margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colors[widget.index % colors.length].withOpacity(0.15),
            // Transparent background with different colors
            borderRadius: BorderRadius.circular(10),
            border: Border(
              left: BorderSide(
                color: colors[
                    widget.index % colors.length], // Set desired border color
                width: 10.0, // Set desired border width
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.package['package_title'] ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${widget.package['package_start_date'] ?? ""} to ${widget.package['package_end_date'] ?? ""}',
                  style: const TextStyle(fontSize: 10),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹ ${(widget.package['total_amount'] ?? "").toString()}",
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),

                    // Text(
                    //   package['status'] ?? "",
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       color: (package['status'] ?? "") == "ACTIVE"
                    //           ? Colors.green
                    //           : Colors.red),
                    // )
                  ],
                ),
                // Text(
                //   package['package_title'] ?? "",
                //   style: TextStyle(fontSize: 16, color: AppTheme.TextLite),
                // ),
                const SizedBox(height: 10),
                Text(
                  "Invoice No: ${widget.package['invoice_no'] ?? ""}",
                  style: const TextStyle(fontSize: 12),
                ),

                const SizedBox(height: 10),
                // Text(
                //   package['short_description'] ?? "",
                //   style: const TextStyle(fontSize: 16),
                // ),
                widget.package['job_qty'] > 0
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Job Posting Status",
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                "${widget.package['status'] ?? ""}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: (widget.package['status'] ?? "") ==
                                            "ACTIVE"
                                        ? Colors.green
                                        : Colors.red),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                widget.package['total_cv_qty'] > 0
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "CV Status",
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                "${widget.package['cv_download_status'] ?? ""}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        (widget.package['cv_download_status'] ??
                                                    "") ==
                                                "ACTIVE"
                                            ? Colors.green
                                            : Colors.red),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      )
                    : const SizedBox(
                        height: 0,
                      ),

                // package['company_package_id'].toString() == "3"
                //     ?
                widget.package['total_cv_qty'] > 0 &&
                        widget.package['job_qty'] > 0
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Job Qty: ${(widget.package['job_qty'] ?? "").toString()}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                "CV Qty: ${(widget.package['total_cv_qty'] ?? "").toString()}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Posted Jobs: ${widget.package['posted_jobs']?.length ?? ""}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Nav.to(
                                          context,
                                          ViewedCvScreen(
                                            packageInfo: widget.package,
                                          ));
                                    },
                                    child: Icon(
                                      Icons.visibility,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Viewed CV: ${widget.package['downloaded_cv_qty'] ?? ""}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Pending Jobs: ${widget.package['pending_jobs'] ?? ""}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                "Pending CV: ${widget.package['pending_cv_qty'] ?? ""}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              // Text(
                              //   package['status'] ?? "",
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.bold,
                              //       color: (package['status'] ?? "") == "ACTIVE"
                              //           ? Colors.green
                              //           : Colors.red),
                              // )
                            ],
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: widget.package['job_qty'] > 0
                                ? Text(
                                    "Job Qty: ${(widget.package['job_qty'] ?? "").toString()}",
                                    style: const TextStyle(fontSize: 12),
                                  )
                                : Text(
                                    "CV Qty: ${(widget.package['total_cv_qty'] ?? "").toString()}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: widget.package['job_qty'] > 0
                                ? Text(
                                    "Posted Jobs: ${widget.package['posted_jobs']?.length ?? ""}",
                                    style: const TextStyle(fontSize: 12),
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        "Viewed CV: ${widget.package['downloaded_cv_qty'] ?? ""}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {
                                          Nav.to(
                                              context,
                                              ViewedCvScreen(
                                                packageInfo: widget.package,
                                              ));
                                        },
                                        icon: Icon(
                                          Icons.visibility,
                                          color: AppTheme.primary,
                                        ),
                                        iconSize: 20,
                                      )
                                    ],
                                  ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: widget.package['job_qty'] > 0
                                ? Text(
                                    "Pending Jobs: ${widget.package['pending_jobs'] ?? ""}",
                                    style: const TextStyle(fontSize: 12),
                                  )
                                : Text(
                                    "Pending CV: ${widget.package['pending_cv_qty'] ?? ""}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                          ),
                        ],
                      ),
                // if (widget.package['posted_jobs'] != null &&
                //     widget.package['posted_jobs'].isNotEmpty) ...[
                //   const SizedBox(height: 10),
                //   const Text(
                //     'Posted Jobs :',
                //     style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                //   ),
                //   const SizedBox(height: 10),
                //   for (final postedJob in widget.package['posted_jobs'])
                //     InkWell(
                //       splashColor: Colors.transparent,
                //       highlightColor: Colors.transparent,
                //       onTap: () {
                //         Nav.to(
                //           context,
                //           MypostDetails(
                //             job_id: postedJob['id'].toString(),
                //           ),
                //         );
                //       },
                //       child: Container(
                //         padding: const EdgeInsets.symmetric(
                //             vertical: 12, horizontal: 8),
                //         margin: EdgeInsets.only(bottom: 4),
                //         decoration: BoxDecoration(
                //             color: Colors.grey.shade200,
                //             borderRadius: BorderRadius.circular(8)),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               postedJob['job_title'] ?? '',
                //               style: const TextStyle(fontSize: 12),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.only(right: 15),
                //               child: Text(
                //                 '${postedJob['applied_count'] ?? ''}',
                //                 style: const TextStyle(fontSize: 12),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                // ],
                // : Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       package['company_package_id'].toString() == "1"
                //           ? Text(
                //               "Jobs Qty: ${package['job_qty'] ?? ""}",
                //               style: const TextStyle(fontSize: 12),
                //             )
                //           : Text(
                //               "CV Qty: ${package['total_cv_qty'] ?? ""}",
                //               style: const TextStyle(fontSize: 12),
                //             ),
                //       const SizedBox(height: 10),
                //       package['company_package_id'].toString() == "1"
                //           ? Text(
                //               "Posted Jobs: ${package['posted_jobs'] ?? ""}",
                //               style: const TextStyle(fontSize: 12),
                //             )
                //           : Text(
                //               "Viewed CV: ${package['downloaded_cv_qty'] ?? ""}",
                //               style: const TextStyle(fontSize: 12),
                //             ),
                //       const SizedBox(height: 10),
                //       package['company_package_id'].toString() == "1"
                //           ? Text(
                //               "Pending Jobs: ${package['pending_jobs'] ?? ""}",
                //               style: const TextStyle(fontSize: 12),
                //             )
                //           : Text(
                //               "Pending CV: ${package['pending_cv_qty'] ?? ""}",
                //               style: const TextStyle(fontSize: 12),
                //             ),
                //       const SizedBox(height: 10),
                //     ],
                //   )
                //  package?['package_title'] == "Job Posting" ?
                //  ,

                // ElevatedButton(
                //   onPressed: () {
                //     // Implement subscription action
                //   },
                //   child: Text('Subscribe'),
                // ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      style:
                          TextButton.styleFrom(padding: const EdgeInsets.all(0)
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(5),
                              // ),
                              // side: BorderSide(
                              //   color: AppTheme.primary,
                              // ),
                              ),
                      onPressed: dowloading
                          ? () {}
                          : widget.package['is_invoice'].toString().isEmpty ||
                                  widget.package['is_invoice'] == null
                              ? () {}
                              : () async {
                                  setState(() {
                                    fileName = path
                                        .basename(widget.package['is_invoice']);
                                  });
                                  await checkFileExists();
                                  download(widget.package['is_invoice'] ?? '');
                                },
                      icon: dowloading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator())
                          : const Icon(
                              Icons.sim_card_download_outlined,
                              size: 18,
                            ),
                      label: const Text(
                        'Invoice',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    widget.package['pending_jobs'] != null &&
                            widget.package['pending_jobs'] > 0
                        ? TextButton(
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(0)),
                            onPressed: () {
                              Nav.to(
                                  context,
                                  ProviderDashboard(
                                    tabNo: 2,
                                  ));
                            },
                            child: const Text(
                              'Add post',
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        : const SizedBox(
                            height: 0,
                          )
                  ],
                ),
                if (widget.package['posted_jobs'] != null &&
                    widget.package['posted_jobs'].isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Text(
                    'Posted Jobs :',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  for (final postedJob in widget.package['posted_jobs'])
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Nav.to(
                          context,
                          MypostDetails(
                            job_id: postedJob['id'].toString(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        margin: EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Job Title ',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'No of requests ',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const Column(
                              children: [
                                Text(
                                  ' : ',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  ' : ',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' ${postedJob['job_title'] ?? ''}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  ' ${postedJob['applied_count'] ?? ''}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
                widget.package['total_cv_qty'] > 0
                    ? SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          onPressed: () async {
                            var UserResponse = PrefManager.read("UserResponse");
                            // if (Platform.isAndroid) {
                            //   download(widget.package['is_invoice']);
                            // } else {
                            //   download(widget.package['is_invoice']);
                            // }

                            try {
                              setState(() {
                                cvExcelLoading = true;
                              });
                              var result = await ExcelApi.downloadCVsList(
                                  context,
                                  widget.package['id'],
                                  UserResponse['data']['api_token']);

                              if (result.success) {
                                setState(() {
                                  fileName =
                                      'Package${widget.package['id']}.xlsx';
                                });
                                await checkFileExists();
                                excelDownload(
                                    'https://jobeasyee.com/backend/package_downloaded_cvs_xls/${widget.package['id']}.xls');
                                setState(() {
                                  cvExcelLoading = false;
                                });
                              } else {
                                setState(() {
                                  cvExcelLoading = false;
                                });
                                Snackbar.show('Cv list is empty', Colors.black);
                              }
                              // setState(() {
                              //   fileName = '${widget.package['id']}.xls';
                              // });
                              // await checkFileExists();
                              // excelDownload(
                              //     'https://jobeasyee.com/backend/package_downloaded_cvs_xls/${widget.package['id']}.xls');
                            } catch (e) {
                              setState(() {
                                cvExcelLoading = false;
                              });
                              print(e);
                            }
                          },
                          icon: cvExcelLoading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/excel.png',
                                  height: 20,
                                ),
                          label: const Text(
                            'Downloaded CVs List',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                widget.package['job_qty'] > 0
                    ? SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          onPressed: () async {
                            var UserResponse = PrefManager.read("UserResponse");
                            // if (Platform.isAndroid) {
                            //   download(widget.package['is_invoice']);
                            // } else {
                            //   download(widget.package['is_invoice']);
                            // }

                            try {
                              setState(() {
                                postedJobsExcelLoading = true;
                              });
                              var result =
                                  await ExcelApi.downloadPostedJobsList(
                                      context,
                                      widget.package['id'],
                                      UserResponse['data']['api_token']);

                              if (result.success) {
                                setState(() {
                                  fileName =
                                      'Package${widget.package['id']}.xlsx';
                                });
                                await checkFileExists();
                                excelDownload(
                                    'https://jobeasyee.com/backend/package_posted_jobs_xls/${widget.package['id']}.xlsx');
                                setState(() {
                                  postedJobsExcelLoading = false;
                                });
                              } else {
                                setState(() {
                                  postedJobsExcelLoading = false;
                                });
                                Snackbar.show(
                                    'No posted Jobs found', Colors.black);
                              }
                              // setState(() {
                              //   fileName = '${widget.package['id']}.xls';
                              // });
                              // await checkFileExists();
                              // excelDownload(
                              //     'https://jobeasyee.com/backend/package_downloaded_cvs_xls/${widget.package['id']}.xls');
                            } catch (e) {
                              setState(() {
                                postedJobsExcelLoading = false;
                              });
                              print(e);
                            }
                          },
                          icon: postedJobsExcelLoading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/excel.png',
                                  height: 20,
                                ),
                          label: const Text(
                            'Posted Jobs List',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
