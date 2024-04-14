import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features1/account/profile_details.dart';
import 'package:job/src/features1/createpost/post_api.dart';
import 'package:job/src/features1/subscription/subscription_api.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class RequestedPersons extends StatefulWidget {
  const RequestedPersons(
      {super.key, required this.jobId, required this.jobTitle});

  final String jobId;
  final String jobTitle;

  @override
  State<RequestedPersons> createState() => _RequestedPersonsState();
}

class _RequestedPersonsState extends State<RequestedPersons> {
  bool permission = false;
  bool dowloading = false;
  bool isLoading = true;

  String fileName = '';
  late String filePath;

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

  excelDownload(link) async {
    var storePath = await getPath();
    var filePaths = '$storePath/$fileName';
    try {
      await Dio().download(link, filePaths);

      OpenFile.open(filePath);
    } catch (e) {
      print(e);
      setState(() {
        dowloading = false;
      });
    }
  }

  List requestedSeekers = [];

  Map? selectedFilter;

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
    initilize('');
    super.initState();
  }

  initilize(String type) async {
    setState(() {
      isLoading = true;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var result = await PostApi.getCompanyJobDetails(
        context,
        UserResponse['data']['id'],
        widget.jobId,
        UserResponse['data']['api_token']);

    if (result.success) {
      if (type == 'filter') {
        setState(() {
          requestedSeekers = result.data['data']['applied_seekers']
              .where((element) =>
                  element['status'].toString() == selectedFilter!['id'])
              .toList();

          // value = result.data['data'];
        });
      } else {
        setState(() {
          requestedSeekers = result.data['data']['applied_seekers'];
          // value = result.data['data'];
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Nav.back(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          widget.jobTitle,
          style: const TextStyle(color: AppTheme.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    for (final type in status)
                      ListTile(
                        tileColor: selectedFilter?['id'] == type['id']
                            ? Colors.grey.shade200
                            : Colors.transparent,
                        onTap: () {
                          setState(() {
                            // selectedRepeatType = type;
                            selectedFilter = type;
                            // requestedSeekers = requestedSeekers
                            //     .where((element) =>
                            //         element['status'].toString() == type['id'])
                            //     .toList();
                          });
                          Nav.back(context);
                          initilize('filter');
                        },
                        title: Text(
                          '${type['status']} seekers only',
                          style: const TextStyle(fontSize: 12),
                        ),
                        // trailing: const Icon(
                        //   Icons.arrow_forward_ios,
                        //   color: Colors.black87,
                        //   size: 15,
                        // ),
                      ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            selectedFilter = null;
                          });
                          Nav.back(context);
                          initilize('');
                        },
                        child: const Text(
                          'Clear Filters',
                          style: TextStyle(color: Colors.red),
                        )),
                  ],
                ),
              );
            },
            icon: selectedFilter == null
                ? Image.asset(
                    'assets/icons/fliter.png',
                    color: Colors.white,
                    height: 25,
                  )
                : Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Image.asset(
                      'assets/icons/fliter.png',
                      color: Colors.black,
                      height: 20,
                    ),
                  ),
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : selectedFilter != null && requestedSeekers.isEmpty
              ? const Center(
                  child: Text('No requests found for selected filter'),
                )
              : requestedSeekers.isEmpty
                  ? const Center(
                      child: Text('No requests'),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Requested Seekers',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () async {
                                  var UserResponse =
                                      PrefManager.read("UserResponse");
                                  // if (Platform.isAndroid) {
                                  //   download(widget.package['is_invoice']);
                                  // } else {
                                  //   download(widget.package['is_invoice']);
                                  // }

                                  try {
                                    setState(() {
                                      dowloading = true;
                                    });
                                    var result =
                                        await ExcelApi.appliedSeekersList(
                                            context,
                                            widget.jobId,
                                            UserResponse['data']['api_token']);

                                    if (result.success) {
                                      setState(() {
                                        fileName = '${widget.jobTitle}.xlsx';
                                      });
                                      await checkFileExists();
                                      excelDownload(
                                          'https://jobeasyee.com/backend/applied_seekers_xls/${widget.jobId}.xlsx');
                                      setState(() {
                                        dowloading = false;
                                      });
                                    } else {
                                      setState(() {
                                        dowloading = false;
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
                                      dowloading = false;
                                    });
                                    print(e);
                                  }
                                },
                                icon: dowloading
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(),
                                      )
                                    : Image.asset(
                                        'assets/images/excel.png',
                                        height: 20,
                                      ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: requestedSeekers.length,
                              itemBuilder: (context, index) => Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade300,
                                              offset: const Offset(0.2, 0.2),
                                              blurRadius: 6.0)
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                child: Image.network(
                                                    requestedSeekers[index]
                                                        ['is_profile_image'],
                                                    fit: BoxFit.fill,
                                                    height: 40,
                                                    width: 40, errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                  // Handle the error here
                                                  return const Center(
                                                    child: Text(
                                                        'UnSupported Image'),
                                                  );
                                                }),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  requestedSeekers[index]
                                                          ?['name'] ??
                                                      "",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Status : ${requestedSeekers[index]?['display_status'] ?? ""}',
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            await Nav.to(
                                              context,
                                              ProfileDetails(
                                                applied_user_id:
                                                    requestedSeekers[index]
                                                            ['id']
                                                        .toString(),
                                                job_id: widget.jobId,
                                                jobs_applied_id:
                                                    requestedSeekers[index]
                                                            ['jobs_applied_id']
                                                        .toString(),
                                              ),
                                            );
                                            setState(() {
                                              requestedSeekers.clear();
                                            });
                                            if (selectedFilter != null) {
                                              initilize('filter');
                                            } else {
                                              initilize('');
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                top: 5.0,
                                                bottom: 5.0,
                                                left: 10.0,
                                                right: 10.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppTheme.primary),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Text(
                                              "See Application",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: AppTheme.primary),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                        ],
                      ),
                    ),
    );
  }
}
