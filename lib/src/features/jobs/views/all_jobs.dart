import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/guestAlert.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features/dashboard/user_dashboard_api.dart';
import 'package:job/src/features/jobs/user_job_api.dart';
import 'package:job/src/features/jobs/views/job_details.dart';

class AllJobs extends StatefulWidget {
  const AllJobs({super.key, required this.type});

  final int type;

  @override
  State<AllJobs> createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> with TickerProviderStateMixin {
  final controller = ScrollController();
  // ignore: non_constant_identifier_names
  final rec_controller = ScrollController();

  List latest = [];
  List recommeded = [];
  bool isLoading = false;
  bool load_check = false;
  bool lat_loading = false;
  bool recommed_loading = false;

  var lat_page_no;
  var rec_page_no;

  // @override
  // void initState() {
  //   // TODO: implement initState

  //   initlize();
  //   super.initState();

  // }

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, length: 2, initialIndex: widget.type);
    _tabController.addListener(_handleTabChange);
    scrollEvent();
    initlize();
  }

  void scrollEvent() {
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        if (lat_page_no != null && lat_page_no != latest.length) {
          Latest();
        }
      }
    });
    rec_controller.addListener(() {
      if (rec_controller.position.maxScrollExtent == rec_controller.offset) {
        if (rec_page_no != null && rec_page_no != recommeded.length) {
          Recommeded_api();
        }
      }
    });
  }

  initlize() async {
    setState(() {
      isLoading = true;
    });
    await Latest();
    await Recommeded_api();
    setState(() {
      isLoading = false;
    });
    // var UserResponse = PrefManager.read("UserResponse");
    // var data = {
    //   "user_id": UserResponse['data']['id'],
    //   "page_no": 0,
    //   "mode": widget.type,
    //   "search": ""
    // };
  }

  Latest() async {
    setState(() {
      lat_loading = true;
      lat_page_no = latest.length;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var data = {
      "user_id": UserResponse['data']['id'],
      "page_no": latest.length,
      "mode": 1,
      "search": ""
    };
    var lat_result = await UserJobApi.getAllJobs(
        context, data, UserResponse['data']['api_token']);
    print(lat_result);
    setState(() {
      if (lat_result.success) {
        if (lat_result.data['status']?.toString() == "1") {
          // latest = lat_result.data['data'];

          latest.addAll(lat_result.data['data'] ?? []);
        }
      }
      lat_loading = false;
    });

    // print(lat_result);
  }

  Recommeded_api() async {
    setState(() {
      recommed_loading = true;
      rec_page_no = recommeded.length;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var data = {
      "user_id": UserResponse['data']['id'],
      "page_no": recommeded.length,
      "mode": widget.type,
      "search": ""
    };

    var recom_result = await UserJobApi.getAllJobs(
        context, data, UserResponse['data']['api_token']);
    print(recom_result);
    setState(() {
      if (recom_result.success) {
        if (recom_result.data['status']?.toString() == "1") {
          // recommeded = recom_result.data['data'];
          recommeded.addAll(recom_result.data['data']);
        }
      }
      recommed_loading = false;
    });

    print(recommeded);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Future<void> _handleTabChange(int newIndex) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   // Do something when the tab changes
  //   if (newIndex == 1) {
  //     // print("recomed");

  //     await Recommeded_api();
  //   } else {
  //     await Latest();
  //     // print("lates");
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  //   // print("Tab changed to index $newIndex");
  // }

  Future<void> _handleTabChange() async {
    if (load_check) {
      setState(() {
        isLoading = true;
        load_check = false;
      });

      if (_tabController.index == 1) {
        await Recommeded_api();
      } else {
        await Latest();
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.type,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
              kToolbarHeight - 5.0), // Adjust the height as needed
          child: AppBar(
            backgroundColor: Colors.white,
            bottom: TabBar(
              controller: _tabController,
              dividerColor: AppTheme.TextLite,
              indicatorWeight: 3,
              indicatorColor: AppTheme.primary,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(
                  child: Text(
                    "Latest",
                  ),
                ),
                Tab(
                  child: Text("Recommended"),
                ),
              ],
              onTap: (value) {
                _handleTabChange();
              },
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Icon(Icons.directions_car),
            latestUi(),
            _recommed()
            // Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }

  latestUi() {
    return !isLoading
        ? latest.length != 0
            ? ListView.builder(
                controller: controller,
                // shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                itemCount: latest.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index < latest.length) {
                    final re_data = latest[index];
                    return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Nav.to(
                              context,
                              JobDetails(
                                job_id: re_data['id'].toString(),
                              ));
                        },
                        child: Recommeded(
                          recommed_data: re_data,
                          onTap: () {
                            setState(() {
                              load_check = true;
                            });
                          },
                        ));
                  } else {
                    return lat_loading
                        ? Center(
                            child: SingleChildScrollView(
                                child: ShimmerLoader(type: "")),
                          )
                        : Container(
                            height: lat_page_no != latest.length ? 100 : 0,
                          );
                  }
                },
              )
            : const Center(
                child: Text("No Job List"),
              )
        : SingleChildScrollView(child: ShimmerLoader(type: ""));
  }

  _recommed() {
    return !isLoading
        ? recommeded.length != 0
            ? ListView.builder(
                controller: rec_controller,
                // shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                itemCount: recommeded.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index < recommeded.length) {
                    final re_data = recommeded[index];
                    return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Nav.to(
                              context,
                              JobDetails(
                                job_id: re_data['id'].toString(),
                              ));
                        },
                        child: Recommeded(
                          recommed_data: re_data,
                          onTap: () {
                            setState(() {
                              load_check = true;
                            });
                          },
                        ));
                  } else {
                    return recommed_loading
                        ? Center(
                            child: SingleChildScrollView(
                                child: ShimmerLoader(type: "")),
                          )
                        : Container(
                            height: rec_page_no != recommeded.length ? 100 : 0,
                          );
                  }
                },
              )
            : const Center(
                child: Text("No Job List"),
              )
        : SingleChildScrollView(child: ShimmerLoader(type: ""));
  }
}

class Recommeded extends StatefulWidget {
  const Recommeded(
      {super.key, required this.recommed_data, required this.onTap});

  final Map<String, dynamic> recommed_data;
  final Function onTap;

  @override
  State<Recommeded> createState() => _RecommededState();
}

class _RecommededState extends State<Recommeded> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8.0),
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
        // height: 50,
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // Image.asset(
                      //   "assets/images/back.png",
                      //   height: 50,
                      // ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                            widget.recommed_data['company_details']
                                ['is_company_logo'],
                            fit: BoxFit.fill,
                            height: 50,
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
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.recommed_data['job_title'] ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Text(
                                widget.recommed_data['job_description'] ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: AppTheme.TextLite, fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                widget.recommed_data['is_saved'] == 0
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
                            bool result = await JobSaved(
                                widget.recommed_data['id'], context);
                            if (result == true) {
                              setState(() {
                                widget.recommed_data['is_saved'] = 1;
                              });
                              widget.onTap();
                            }
                          }
                        },
                        child: Image.asset(
                          "assets/icons/bookmark_light.png",
                          height: 25,
                        ),
                      )
                    : InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          bool result = await JobUnSaved(
                              widget.recommed_data['id'], context);
                          if (result == true) {
                            setState(() {
                              widget.recommed_data['is_saved'] = 0;
                            });
                            widget.onTap();
                          }
                        },
                        child: Image.asset(
                          "assets/icons/bookmark_dark.png",
                          height: 25,
                        ),
                      )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 25,
              child: ListView.builder(
                  itemCount: widget.recommed_data['is_employment_types'].length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final job_type =
                        widget.recommed_data['is_employment_types'][index];
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: AppTheme.primary_light),
                      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Center(
                        child: Text(
                          job_type['employmenttype'],
                          style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            // const SizedBox(
            //   height: 15,
            // ),
            // Row(
            //   children: [
            //     ClipOval(
            //       child: Image.asset(
            //         "assets/images/ellipse.png",
            //         height: 35,
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     Text(
            //       "Your Profile match this job",
            //       style: TextStyle(
            //           color: AppTheme.primary,
            //           fontWeight: FontWeight.w600,
            //           fontSize: 12),
            //     )
            //   ],
            // ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/time.png",
                      height: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.recommed_data['is_ago'] ?? "",
                      style:
                          TextStyle(color: AppTheme.TextBoldLite, fontSize: 11),
                    )
                  ],
                ),
                // Text(
                //   "₹12k - 20k/years",
                //   style: TextStyle(color: AppTheme.success),
                // ),
                Text(
                    "${widget.recommed_data['from_currency'] ?? ""} ${widget.recommed_data['from_sal'] ?? ""} - ${widget.recommed_data['to_sal'] ?? ""}",
                    style: TextStyle(color: AppTheme.success)),
                Container(
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: const Text(
                    "Apply Now",
                    style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ));
  }
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
