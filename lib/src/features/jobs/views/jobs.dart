// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/features/jobs/user_job_api.dart';
import 'package:job/src/features/jobs/views/job_details.dart';
import 'package:job/src/features/jobs/views/job_status.dart';

class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  final applied_controller = ScrollController();

  int select = 0;
  List joblist = [];
  List appliedList = [];
  List applicationCount = [];

  bool applied_loading = false;
  bool job_loading = false;
  bool _mLoading = false;

  var apply_page_no;
  var saved_page_no;

  @override
  void initState() {
    // TODO: implement initState
    initilize();
    super.initState();
  }

  initilize() async {
    setState(() {
      _mLoading = true;
    });
    scrollEvent();
    await AppliedList();
    await JobSavedList();
    setState(() {
      _mLoading = false;
    });
  }

  void scrollEvent() {
    applied_controller.addListener(() {
      if (applied_controller.position.maxScrollExtent ==
          applied_controller.offset) {
        if (apply_page_no != null && apply_page_no != appliedList.length) {
          // Latest();
          AppliedList();
        }

        if (saved_page_no != null && saved_page_no != joblist.length) {
          JobSavedList();
        }
      }
    });
  }

  // JobSavedList(page_no) async {
  //   setState(() {
  //     job_loading = true;
  //   });
  //   var UserResponse = PrefManager.read("UserResponse");

  //   var get_savedJob = await UserJobApi.GetSavaedJobList(context,
  //       UserResponse['data']['id'], 0, UserResponse['data']['api_token']);

  //   print(get_savedJob);

  //   if (get_savedJob.success) {
  //     if (get_savedJob.data['status'].toString() == "1") {
  //       setState(() {
  //         joblist.addAll(get_savedJob.data['data']);
  //       });
  //     }
  //   }
  //   setState(() {
  //     job_loading = false;
  //   });
  // }
  JobSavedList() async {
    setState(() {
      job_loading = true;
      saved_page_no = joblist.length;
    });
    var UserResponse = PrefManager.read("UserResponse");

    var get_savedJob = await UserJobApi.GetSavaedJobList(
        context,
        UserResponse['data']['id'],
        joblist.length,
        UserResponse['data']['api_token']);

    print(get_savedJob);

    if (get_savedJob.success) {
      if (get_savedJob.data['status'].toString() == "1") {
        setState(() {
          joblist.addAll(get_savedJob.data['data']);
        });
      }
    }
    setState(() {
      job_loading = false;
    });
  }

  AppliedList() async {
    setState(() {
      applied_loading = true;
      apply_page_no = appliedList.length;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var result = await UserJobApi.GetJobAppiledList(
        context,
        UserResponse['data']['id'],
        appliedList.length,
        UserResponse['data']['api_token']);

    print(UserResponse['data']['id']);
    print(UserResponse['data']['api_token']);
    print(result);
    if (result.success) {
      if (result.data['status'].toString() == "1") {
        setState(() {
          appliedList.addAll(result.data['data'] ?? []);
          applicationCount.addAll(result.data['jobs_status_count'] ?? []);
        });
      }
    }
    setState(() {
      applied_loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
        controller: applied_controller,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Application Status",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                height: 90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          offset: const Offset(0.2, 0.2),
                          blurRadius: 6.0)
                    ]),
                child: ListView.builder(
                    itemCount: applicationCount.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final data = applicationCount[index];
                      return Row(
                        children: [
                          SizedBox(
                            width: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  data['count'].toString(),
                                  style: TextStyle(
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(data['count_status'].toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: AppTheme.TextBoldLite,
                                        fontSize: 12))
                              ],
                            ),
                          ),
                          SizedBox(
                              height: 50,
                              // width: 10,
                              child: VerticalDivider(
                                thickness: 1,
                                color: AppTheme.TextLite,
                              )),
                        ],
                      );
                    }),
              ),
              // Container(
              //   padding: const EdgeInsets.all(12.0),
              //   height: 90,
              //   decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(10.0),
              //       boxShadow: [
              //         BoxShadow(
              //             color: Colors.grey.shade300,
              //             offset: const Offset(0.2, 0.2),
              //             blurRadius: 6.0)
              //       ]),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       SizedBox(
              //         width: 70,
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //           children: [
              //             Text(
              //               "5",
              //               style: TextStyle(
              //                   color: AppTheme.primary,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //             Text("Applied",
              //                 style: TextStyle(
              //                     color: AppTheme.TextBoldLite, fontSize: 12))
              //           ],
              //         ),
              //       ),
              //       SizedBox(
              //           height: 50,
              //           // width: 10,
              //           child: VerticalDivider(
              //             thickness: 1,
              //             color: AppTheme.TextLite,
              //           )),
              //       SizedBox(
              //         width: 70,
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //           children: [
              //             const Text(
              //               "1",
              //               style: TextStyle(
              //                   color: AppTheme.amber,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //             Text("Reviewed",
              //                 style: TextStyle(
              //                     color: AppTheme.TextBoldLite, fontSize: 12))
              //           ],
              //         ),
              //       ),
              //       SizedBox(
              //           height: 50,
              //           // width: 10,
              //           child: VerticalDivider(
              //             thickness: 1,
              //             color: AppTheme.TextLite,
              //           )),
              //       SizedBox(
              //         width: 70,
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //           children: [
              //             Text(
              //               "1",
              //               style: TextStyle(
              //                   color: AppTheme.success,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //             Text("Accepted",
              //                 style: TextStyle(
              //                     color: AppTheme.TextBoldLite, fontSize: 12))
              //           ],
              //         ),
              //       ),
              //       SizedBox(
              //           height: 50,
              //           // width: 10,
              //           child: VerticalDivider(
              //             thickness: 1,
              //             color: AppTheme.TextLite,
              //           )),
              //       SizedBox(
              //         width: 70,
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //           children: [
              //             const Text(
              //               "3",
              //               style: TextStyle(
              //                   color: AppTheme.red,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //             Text(
              //               "Rejected",
              //               style: TextStyle(
              //                   color: AppTheme.TextBoldLite, fontSize: 12),
              //             )
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          select = 0;
                        });
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 2,
                                      color: select == 0
                                          ? AppTheme.primary
                                          : AppTheme.white))),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              "Applied",
                              style: TextStyle(
                                  color: select == 0
                                      ? AppTheme.primary
                                      : AppTheme.TextBoldLite,
                                  fontWeight: select == 0
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ))),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          select = 1;
                        });
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 2,
                                      color: select != 0
                                          ? AppTheme.primary
                                          : AppTheme.white))),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text("Bookmarked",
                                style: TextStyle(
                                    color: select != 0
                                        ? AppTheme.primary
                                        : AppTheme.TextBoldLite,
                                    fontWeight: select != 0
                                        ? FontWeight.bold
                                        : FontWeight.normal)),
                          )))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              select == 0
                  ? !_mLoading
                      ? appliedList.length > 0
                          ? ListView.builder(
                              // controller: applied_controller,
                              itemCount: appliedList.length + 1,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (index < appliedList.length) {
                                  final data = appliedList[index];
                                  final track_data = appliedList[index]
                                                  ['status_track']
                                              .length >
                                          0
                                      ? appliedList[index]['status_track'][0]
                                      : null;
                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Nav.to(
                                          context,
                                          JobStatus(
                                            data: data,
                                          ));
                                    },
                                    child: Container(
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
                                      padding: const EdgeInsets.all(10.0),
                                      margin: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Row(
                                        children: [
                                          // ClipRRect(
                                          //   borderRadius: BorderRadius.circular(15.0),
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.all(4.0),
                                          //     child: Image.asset(
                                          //       "assets/images/back.png",
                                          //       height: 55,
                                          //     ),
                                          //   ),
                                          // ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                                data['company_details']
                                                    ['is_company_logo'],
                                                fit: BoxFit.fill,
                                                height: 55,
                                                width: 55, errorBuilder:
                                                    (BuildContext context,
                                                        Object exception,
                                                        StackTrace?
                                                            stackTrace) {
                                              // Handle the error here
                                              return const Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey,
                                              );
                                            }),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: SizedBox(
                                            // height: 53,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Nav.to(
                                                        context,
                                                        JobStatus(
                                                          data: data,
                                                        ));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        data['job_title'] ?? "",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                      Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5.0,
                                                                  right: 5.0,
                                                                  top: 1.0,
                                                                  bottom: 1.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: track_data?[
                                                                        'display_status'] ==
                                                                    "Accepted"
                                                                ? AppTheme
                                                                    .success_light
                                                                : track_data?[
                                                                            'display_status'] ==
                                                                        "Rejected"
                                                                    ? AppTheme
                                                                        .danger_light
                                                                    : AppTheme
                                                                        .app_yellow_lite,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                          child: Text(
                                                            track_data?[
                                                                    'display_status'] ??
                                                                "",
                                                            style: TextStyle(
                                                                color: track_data?[
                                                                            'display_status'] ==
                                                                        "Accepted"
                                                                    ? AppTheme
                                                                        .success
                                                                    : track_data?['display_status'] ==
                                                                            "Rejected"
                                                                        ? AppTheme
                                                                            .danger
                                                                        : AppTheme
                                                                            .app_yellow,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                          // (index % 2) == 0
                                                          //     ? Text(
                                                          //         "Accepted",
                                                          //         style: TextStyle(
                                                          //             color: AppTheme
                                                          //                 .success,
                                                          //             fontSize:
                                                          //                 12,
                                                          //             fontWeight:
                                                          //                 FontWeight
                                                          //                     .bold),
                                                          //       )
                                                          //     : Text(
                                                          //         "Rejected",
                                                          //         style: TextStyle(
                                                          //             color: AppTheme
                                                          //                 .danger,
                                                          //             fontSize:
                                                          //                 12,
                                                          //             fontWeight:
                                                          //                 FontWeight
                                                          //                     .bold),
                                                          //       ),
                                                          )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/icons/verify.png",
                                                      height: 20,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      data['company_details']?[
                                                              'company_name'] ??
                                                          "",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .TextBoldLite,
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "${data['from_currency'] ?? ""} ${data['from_sal'].toString()} - ${data['to_sal'].toString()}",
                                                  style: TextStyle(
                                                      color: AppTheme.success),
                                                )
                                                // Row(
                                                //   children: [
                                                //     Image.asset(
                                                //       "assets/icons/calender.png",
                                                //       height: 15,
                                                //     ),
                                                //     const SizedBox(
                                                //       width: 5,
                                                //     ),
                                                //     Text(
                                                //       "20 Dec 23",
                                                //       maxLines: 1,
                                                //       overflow: TextOverflow.ellipsis,
                                                //       style: TextStyle(
                                                //           color: AppTheme.TextBoldLite,
                                                //           fontSize: 11),
                                                //     ),
                                                //     const SizedBox(
                                                //       width: 5,
                                                //     ),
                                                //     Text(
                                                //       "10.30 WIB",
                                                //       maxLines: 1,
                                                //       overflow: TextOverflow.ellipsis,
                                                //       style: TextStyle(
                                                //           color: AppTheme.TextBoldLite,
                                                //           fontSize: 11),
                                                //     ),
                                                //   ],
                                                // ),
                                              ],
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return applied_loading
                                      ? Center(
                                          child: SingleChildScrollView(
                                              child: ShimmerLoader(type: "")),
                                        )
                                      : Container(
                                          height: apply_page_no !=
                                                  appliedList.length
                                              ? 100
                                              : 0,
                                        );
                                }
                              })
                          : SizedBox(
                              height: screenHeight * 0.5,
                              child: const Center(
                                child: Text("No Jobs List"),
                              ))
                      : ShimmerLoader(type: "")
                  : !_mLoading
                      ? joblist.length > 0
                          ? ListView.builder(
                              itemCount: joblist.length + 1,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (index < joblist.length) {
                                  final job_data = joblist[index];

                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      // Nav.to(context, const JobStatus());
                                      Nav.to(
                                          context,
                                          JobDetails(
                                            job_id: job_data['id'].toString(),
                                          ));
                                    },
                                    child: Container(
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
                                      padding: const EdgeInsets.all(10.0),
                                      margin: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                                job_data['company_details']
                                                    ['is_company_logo'],
                                                fit: BoxFit.fill,
                                                height: 55,
                                                width: 55, errorBuilder:
                                                    (BuildContext context,
                                                        Object exception,
                                                        StackTrace?
                                                            stackTrace) {
                                              // Handle the error here
                                              return const Center(
                                                child:
                                                    Text('UnSupported Image'),
                                              );
                                            }),
                                          ),
                                          // ClipRRect(
                                          //   borderRadius: BorderRadius.circular(15.0),
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.all(4.0),
                                          //     child: Image.asset(
                                          //       "assets/images/back.png",
                                          //       height: 55,
                                          //     ),
                                          //   ),
                                          // ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: SizedBox(
                                            // height: 53,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Nav.to(
                                                        context,
                                                        JobStatus(
                                                          data: job_data,
                                                        ));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        job_data['job_title'] ??
                                                            "",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                      // Container(
                                                      //   padding: const EdgeInsets.only(
                                                      //       left: 5.0,
                                                      //       right: 5.0,
                                                      //       top: 1.0,
                                                      //       bottom: 1.0),
                                                      //   decoration: BoxDecoration(
                                                      //     color: (index % 2) == 0
                                                      //         ? AppTheme.success_light
                                                      //         : AppTheme.danger_light,
                                                      //     borderRadius:
                                                      //         BorderRadius.circular(5.0),
                                                      //   ),
                                                      //   child: (index % 2) == 0
                                                      //       ? Text(
                                                      //           "Accepted",
                                                      //           style: TextStyle(
                                                      //               color: AppTheme.success,
                                                      //               fontSize: 12,
                                                      //               fontWeight:
                                                      //                   FontWeight.bold),
                                                      //         )
                                                      //       : Text(
                                                      //           "Rejected",
                                                      //           style: TextStyle(
                                                      //               color: AppTheme.danger,
                                                      //               fontSize: 12,
                                                      //               fontWeight:
                                                      //                   FontWeight.bold),
                                                      //         ),
                                                      // )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/icons/verify.png",
                                                      height: 20,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      job_data['company_details']
                                                              ?[
                                                              'company_name'] ??
                                                          "",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .TextBoldLite,
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "${job_data['from_currency'] ?? ""} ${job_data['from_sal'].toString()} - ${job_data['to_sal'].toString()}",
                                                  style: TextStyle(
                                                      color: AppTheme.success),
                                                )
                                                // Row(
                                                //   children: [
                                                //     Image.asset(
                                                //       "assets/icons/calender.png",
                                                //       height: 15,
                                                //     ),
                                                //     const SizedBox(
                                                //       width: 5,
                                                //     ),
                                                //     Text(
                                                //       "20 Dec 23",
                                                //       maxLines: 1,
                                                //       overflow: TextOverflow.ellipsis,
                                                //       style: TextStyle(
                                                //           color: AppTheme.TextBoldLite,
                                                //           fontSize: 11),
                                                //     ),
                                                //     const SizedBox(
                                                //       width: 5,
                                                //     ),
                                                //     Text(
                                                //       "10.30 WIB from_sal to_sal",
                                                //       maxLines: 1,
                                                //       overflow: TextOverflow.ellipsis,
                                                //       style: TextStyle(
                                                //           color: AppTheme.TextBoldLite,
                                                //           fontSize: 11),
                                                //     ),

                                                //   ],
                                                // ),
                                              ],
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return job_loading
                                      ? Center(
                                          child: SingleChildScrollView(
                                              child: ShimmerLoader(type: "")),
                                        )
                                      : Container(
                                          height: apply_page_no !=
                                                  appliedList.length
                                              ? 100
                                              : 0,
                                        );
                                }
                              })
                          : SizedBox(
                              height: screenHeight * 0.5,
                              child: const Center(
                                child: Text("No Jobs List"),
                              ))
                      : ShimmerLoader(type: "")
            ],
          ),
        ));
  }
}


/// 
