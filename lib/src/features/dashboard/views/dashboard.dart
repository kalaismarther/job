// // ignore_for_file: non_constant_identifier_names

// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/guestAlert.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/logout.dart';
import 'package:job/src/core/utils/logoutAlert.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features/account/views/edit_jobpreference.dart';
import 'package:job/src/features/account/views/profile.dart';
import 'package:job/src/features/auth/views/proffesional_details.dart';
import 'package:job/src/features/chat/views/chat.dart';
import 'package:job/src/features/dashboard/user_dashboard_api.dart';
import 'package:job/src/features/dashboard/views/bottombar.dart';
import 'package:job/src/features/dashboard/views/notifications.dart';
import 'package:job/src/features/dashboard/views/user_search_filter.dart';
import 'package:job/src/features/jobs/views/all_jobs.dart';
import 'package:job/src/features/jobs/views/job_details.dart';
import 'package:job/src/features/jobs/views/jobs.dart';

class Dashboard extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Dashboard({super.key, required this.current_index});

  final int current_index;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  int s_type = 0;
  // int _perviousIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    intilize();
    super.initState();
  }

  intilize() async {
    setState(() {
      _currentIndex = widget.current_index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex == 0) {
          bool shouldPop = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                // title: Text('Confirmation'),
                content: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Are you sure you want to exit?'),
                ),
                actions: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              // If "Cancel" is pressed, do not pop the route
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('Cancel'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              // If "OK" is pressed, pop the route
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('OK'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
          return shouldPop;
        } else {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
      },
      child: Scaffold(
          key: widget.scaffoldKey,
          // drawer: _currentIndex == 0 ? Drawer() : null,
          appBar: _currentIndex != 0
              ? AppBar(
                  centerTitle: true,
                  title: Text(
                    _currentIndex == 1
                        ? "Jobs"
                        : _currentIndex == 2
                            ? "My Application"
                            : "Profile",
                    style: const TextStyle(color: AppTheme.white, fontSize: 18),
                  ),
                  leading: IconButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                  // actions: [
                  //   IconButton(
                  //       onPressed: () async {
                  //         await Logout.logout(context, "logout");
                  //       },
                  //       icon: const Icon(
                  //         Icons.logout,
                  //         color: Colors.white,
                  //       ))
                  // ],
                  actions: [
                    _currentIndex == 3
                        ? IconButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return LogoutAlert();
                                },
                              );
                              // await Logout.logout(context, "logout");
                            },
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ))
                        : const SizedBox(
                            height: 0,
                          )
                  ],
                )
              : PreferredSize(
                  preferredSize: const Size.fromHeight(0.0), child: AppBar()),
          // drawer: Drawer(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 40),
          //     child: Column(
          //       children: [
          // ListTile(
          //   onTap: () {
          //     Navigator.pop(context);
          //     Nav.to(context, Chat());
          //   },
          //   leading: Icon(Icons.chat),
          //   title: Text('Help & Support'),
          // ),
          //         ListTile(
          //           onTap: () {
          //             // Navigator.pop(context);
          //             // Nav.to(context, Chat());
          //             Navigator.pop(context);
          //             showDialog(
          //               context: context,
          //               builder: (BuildContext context) {
          //                 return LogoutAlert();
          //               },
          //             );
          //             // await Logout.logout(context, "logout");
          //           },
          //           leading: Icon(Icons.logout),
          //           title: Text('Logout'),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          bottomNavigationBar: BottomBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                var result = PrefManager.read("guest");
                if (result == "yes") {
                  if (index == 2 || index == 3) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return GuestAlert();
                      },
                    );
                  } else {
                    setState(() {
                      // _perviousIndex = _currentIndex;

                      _currentIndex = index;
                    });
                  }
                } else {
                  setState(() {
                    // _perviousIndex = _currentIndex;
                    _currentIndex = index;
                  });
                }
              }),
          // body: _currentIndex == 0
          //     ? Home(
          //         onTap: () {
          //           // Scaffold.of(context).openDrawer();
          //         },
          //       )
          //     : _currentIndex == 1
          //         ? const Jobs()
          //         : _currentIndex == 2
          //             ? const ChatList()
          //             : const Profile()),
          body: _currentIndex == 0
              ? Home(onTap: (value, index) {
                  setState(() {
                    s_type = value;
                    _currentIndex = index;
                  });
                  // Scaffold.of(context).openDrawer();
                }, clickMenu: () {
                  widget.scaffoldKey.currentState!.openDrawer();
                })
              : _currentIndex == 1
                  ? AllJobs(
                      type: s_type,
                    )
                  : _currentIndex == 2
                      ? const Jobs()
                      : const Profile()),
    );
  }
}

class Home extends StatefulWidget {
  final Function onTap;
  final Function clickMenu;

  const Home({super.key, required this.onTap, required this.clickMenu});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List menu = [
    "All",
    "Developer",
    "UI/UX",
    "Marketing",
    "Data Analatics",
    "SEO",
    "Manager"
  ];
  List menu_skills = [];
  int _SIndex = 0;
  bool isLoading = false;
  var latest_job;
  var recommeded;
  var _User_Response;
  var notifiCount = "0";
  var preCountry;
  @override
  void initState() {
    // TODO: implement initState
    initilize();
    super.initState();
    // initilize();
  }

  initilize() async {
    setState(() {
      isLoading = true;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var get_Home = await UserDashboardApi.getuserHomeContent(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);
    print(get_Home);
    setState(() {
      if (get_Home.success) {
        if (get_Home.data['data']['profession_status'].toString() == "0" &&
            UserResponse['data']?['user_type'] != "GUEST_USER" &&
            UserResponse['data']?['user_type'] != "GUEST_COMPANY") {
          Nav.offAll(context, ProffesionalDetails());
        } else {
          latest_job = get_Home.data['data']?['latest_jobs'];
          recommeded = get_Home.data['data']?['recommended'];
          preCountry = get_Home.data['data']?['preferred_country_name'] ?? "";
          if (get_Home.data['skills'] != null &&
              get_Home.data['skills'].length > 0) {
            menu_skills.addAll(get_Home.data['skills']);
          }
        }
      }
      _User_Response = UserResponse['data'];
      isLoading = false;
    });
    getNotify();
  }

  getNotify() async {
    var UserResponse = PrefManager.read("UserResponse");
    var get_count = await UserDashboardApi.notifyCount(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);

    if (get_count.success) {
      if (get_count.data['status'].toString() == "1") {
        setState(() {
          notifiCount = (get_count.data['data'] ?? "0").toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0))),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _User_Response?['is_profile_image'] != null
                              ? InkWell(
                                  onTap: () {
                                    var result = PrefManager.read("guest");
                                    if (result == "yes") {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return GuestAlert();
                                        },
                                      );
                                    } else {
                                      widget.onTap(0, 3);
                                    }
                                    // Nav.to(context, )
                                  },
                                  child: ClipOval(
                                    child: FadeInImage(
                                      placeholder: const AssetImage(
                                          'assets/icons/Profile.png'),
                                      image: NetworkImage(
                                          _User_Response?['is_profile_image'] ??
                                              ""),
                                      fit: BoxFit.cover,
                                      // width: 100.0,
                                      height: 65,
                                      width: 65,
                                    ),
                                  ),
                                )
                              : Image.asset(
                                  "assets/icons/Profile.png",
                                  height: 65,
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Hi ${_User_Response?['name'] ?? ""}!",
                            style: const TextStyle(
                                color: AppTheme.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      // const Icon(
                      //   Icons.notifications,
                      //   color: Colors.white,
                      // )
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Nav.to(context, Chat());
                            },
                            icon: const Icon(
                              Icons.chat,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
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
                                await Nav.to(context, const Notifications());
                                getNotify();
                              }
                              // Nav.to(context, const Notifications());
                              // Dashboard? dashboard = context
                              //     .findAncestorWidgetOfExactType<Dashboard>();
                              // dashboard?.scaffoldKey.currentState?.openDrawer();
                              // widget.onTap();
                            },
                            child: SizedBox(
                              width: 30,
                              // height: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    SizedBox(
                                        height: 50,
                                        // width: 25,
                                        child: Image.asset(
                                            "assets/icons/notification.png")),
                                    notifiCount != "0"
                                        ? Positioned(
                                            top: 0,
                                            right: notifiCount.length > 2
                                                ? -2.5
                                                : 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: const BoxDecoration(
                                                color: Colors
                                                    .red, // You can customize the color
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                notifiCount,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      notifiCount.length > 2
                                                          ? 6.5
                                                          : 9,
                                                  fontWeight: FontWeight.bold,
                                                ),
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

                            // SizedBox(
                            //   width: 30,
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(right: 10.0),
                            //     child: Image.asset("assets/icons/notification.png"),
                            //   ),
                            // ),
                          ),
                          // IconButton(
                          //   onPressed: () {
                          //     widget.clickMenu();
                          //   },
                          //   icon: Icon(
                          //     Icons.menu,
                          //     color: Colors.white,
                          //   ),
                          // )
                        ],
                      ),
                      // SizedBox(width: 5,)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // const Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       "Let's Find Your Dream Job!",
                  //       style: TextStyle(
                  //           color: AppTheme.white,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 16),
                  //     )),
                  PrefManager.read("guest") != "yes"
                      ? InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Nav.to(context, const EditJobPreference());
                          },
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                preCountry ?? "",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.white,
                              )
                            ],
                          ),
                        )
                      : const SizedBox(
                          height: 0,
                        ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      readOnly: true,
                      onTap: () {
                        Nav.to(
                            context,
                            const UserSearchFilter(
                              getskill: "",
                            ));
                      },
                      decoration: InputDecoration(
                        hintText: "Search Company, jobs, location",
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            "assets/icons/search.png",
                            height: 20,
                            width: 20,
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            "assets/icons/fliter.png",
                            height: 20,
                            width: 20,
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            menu_skills.length > 0
                ? SizedBox(
                    height: 60,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: menu_skills.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final data = menu_skills[index];
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              Nav.to(context,
                                  UserSearchFilter(getskill: data.toString()));
                              setState(() {
                                // _SIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  color: _SIndex == index
                                      ? AppTheme.primary
                                      : AppTheme.TextFormFieldBac,
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
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ))),
                            ),
                          );
                        }),
                  )
                : const SizedBox(
                    height: 0,
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Latest Vacancies",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Nav.to(context, AllJobs(type: 0));
                    },
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        widget.onTap(0, 1);
                      },
                      child: Text(
                        "See all",
                        style: TextStyle(color: AppTheme.primary, fontSize: 12),
                      ),
                    ),
                  )
                ],
              ),
            ),
            !isLoading
                ? latest_job != null && latest_job != ""
                    ? latest_job.length != 0
                        ? SizedBox(
                            height: 190,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(8.0),
                              itemCount: latest_job.length,
                              itemBuilder: (BuildContext context, int index) {
                                final Latest_data = latest_job[index];
                                return InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Nav.to(
                                          context,
                                          JobDetails(
                                            job_id:
                                                Latest_data['id'].toString(),
                                          ));
                                    },
                                    child: Latest(
                                      onTap: (value) {
                                        // print(value);
                                      },
                                      data: Latest_data,
                                    ));
                              },
                            ),
                          )
                        : const Text("No Jobs Job")
                    : const Text("No JobsJob")
                : ShimmerLoader(
                    type: 'latest',
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recommended for you",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      widget.onTap(1, 1);
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(color: AppTheme.primary, fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
            !isLoading
                ? recommeded != null && recommeded != ""
                    ? recommeded.length != 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8.0),
                            itemCount: recommeded.length,
                            itemBuilder: (BuildContext context, int index) {
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
                                    onTap: (value) {},
                                    recommed_data: re_data,
                                  ));
                            },
                          )
                        : const SizedBox(
                            height: 150,
                            child: Center(child: Text("No Recommeded List")))
                    : const Text("No Recommeded List")
                : ShimmerLoader(type: "")
          ],
        ),
      ),
    );
  }
}

class Latest extends StatefulWidget {
  const Latest({super.key, required this.data, required this.onTap});

  final Map<String, dynamic> data;
  final Function onTap;

  @override
  State<Latest> createState() => _LatestState();
}

class _LatestState extends State<Latest> {
  @override
  void initState() {
    print('---^^^&&&---- ${widget.data}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        width: screenWidth * 0.75,
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
                      //   "assets/images/frame.png",
                      //   height: 45,
                      // ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                            widget.data['company_details']['is_company_logo'],
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
                                widget.data['job_title'] ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Text(
                                widget.data['job_description'] ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: AppTheme.TextLite, fontSize: 12),
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
                widget.data['is_saved'] == 0
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
                                await JobSaved(widget.data['id'], context);
                            if (result == true) {
                              setState(() {
                                widget.data['is_saved'] = 1;
                              });
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
                          bool result =
                              await JobUnSaved(widget.data['id'], context);
                          if (result == true) {
                            setState(() {
                              widget.data['is_saved'] = 0;
                            });
                          }
                        },
                        child: Image.asset(
                          "assets/icons/bookmark_dark.png",
                          height: 25,
                        ),
                      )
              ],
            ),
            SizedBox(
              height: 25,
              child: ListView.builder(
                  itemCount: widget.data['is_employment_types'].length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final em_type = widget.data['is_employment_types'][index];
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: AppTheme.primary_light),
                        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Center(
                          child: Text(
                            em_type['employmenttype'],
                            style: TextStyle(
                                color: AppTheme.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    );
                  }),
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
                      widget.data['is_ago'] ?? "",
                      style:
                          TextStyle(color: AppTheme.TextBoldLite, fontSize: 11),
                    )
                  ],
                ),
                // Text(
                //   "₹12k - 20k/years",
                //   style: TextStyle(color: AppTheme.success),
                // )
                widget.data['is_hide_salary'].toString() == '1'
                    ? const SizedBox(
                        height: 0,
                      )
                    : Text(
                        "${widget.data['from_currency'] ?? ""} ${widget.data['from_sal'] ?? ""} - ${widget.data['to_sal'] ?? ""}",
                        style: TextStyle(color: AppTheme.success))
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
  void initState() {
    // TODO: implement initState
    initilize();
    super.initState();
  }

  initilize() {
    print(widget.recommed_data);
  }

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
                              ),
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
              },
            ),
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
              //
              // Text(
              //   "₹12k - 20k/years",
              //   style: TextStyle(color: AppTheme.success),
              // ),
              widget.recommed_data['is_hide_salary'].toString() == '1'
                  ? const SizedBox(
                      height: 0,
                    )
                  : Text(
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
      ),
    );
  }
}

// Latest Vacancies Helper Widget
// class Latest extends StatelessWidget {
//   const Latest({super.key, required this.data, required this.onTap});

//   final Map<String, dynamic> data;
//   final Function onTap;

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Container(
//         width: screenWidth * 0.75,
//         margin: const EdgeInsets.all(8.0),
//         padding: const EdgeInsets.all(12.0),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10.0),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.grey.shade300,
//                   offset: const Offset(0.2, 0.2),
//                   blurRadius: 6.0)
//             ]),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Row(
//                     children: [
//                       Image.asset(
//                         "assets/images/frame.png",
//                         height: 45,
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       Expanded(
//                         child: SizedBox(
//                           height: 45,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 data['job_title'] ?? "",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 data['job_description'] ?? "",
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                     color: AppTheme.TextLite, fontSize: 12),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 data ['is_saved'] == 0 ?
//                 InkWell(
//                   splashColor: Colors.transparent,
//                   highlightColor: Colors.transparent,
//                   onTap: (){
//                     onTap(data);
//                   },
//                   child: Image.asset(
//                     "assets/icons/bookmark_light.png",
//                     height: 25,
//                   ),
//                 )
//                 :
//                  Image.asset(
//                   "assets/icons/bookmark_dark.png",
//                   height: 25,
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 25,
//               child: ListView.builder(
//                   itemCount: data['is_employment_types'].length,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     final em_type = data['is_employment_types'][index];
//                     return InkWell(
//                       onTap: () {},
//                       child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5.0),
//                             color: AppTheme.primary_light),
//                         margin: const EdgeInsets.only(left: 5.0, right: 5.0),
//                         padding: const EdgeInsets.only(left: 5, right: 5),
//                         child: Center(
//                           child: Text(
//                             em_type['employmenttype'],
//                             style: TextStyle(
//                                 color: AppTheme.primary,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Image.asset(
//                       "assets/icons/time.png",
//                       height: 20,
//                     ),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     Text(
//                       "1 hr ago",
//                       style:
//                           TextStyle(color: AppTheme.TextBoldLite, fontSize: 11),
//                     )
//                   ],
//                 ),
//                 // Text(
//                 //   "₹12k - 20k/years",
//                 //   style: TextStyle(color: AppTheme.success),
//                 // )
//                 Text(
//                     "${data['from_currency'] ?? ""} ${data['from_sal'] ?? ""} - ${data['to_sal'] ?? ""}",
//                     style: TextStyle(color: AppTheme.success))
//               ],
//             )
//           ],
//         ));
//   }
// }

// Recommended for you Helper Widget

// class Recommeded extends StatelessWidget {
//   const Recommeded({super.key, required this.recommed_data});

//   final Map<String, dynamic> recommed_data;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         margin: const EdgeInsets.all(8.0),
//         padding: const EdgeInsets.all(12.0),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10.0),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.grey.shade300,
//                   offset: const Offset(0.2, 0.2),
//                   blurRadius: 6.0)
//             ]),
//         // height: 50,
//         // color: Colors.red,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Row(
//                     children: [
//                       Image.asset(
//                         "assets/images/back.png",
//                         height: 50,
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       Expanded(
//                         child: SizedBox(
//                           height: 45,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 recommed_data['job_title'] ?? "",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 recommed_data['job_description'] ?? "",
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                     color: AppTheme.TextLite, fontSize: 13),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Image.asset(
//                   "assets/icons/bookmark_light.png",
//                   height: 25,
//                 )
//               ],
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             SizedBox(
//               height: 25,
//               child: ListView.builder(
//                   itemCount: recommed_data['is_employment_types'].length,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     final job_type =
//                         recommed_data['is_employment_types'][index];
//                     return Container(
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5.0),
//                           color: AppTheme.primary_light),
//                       margin: const EdgeInsets.only(left: 5.0, right: 5.0),
//                       padding: const EdgeInsets.only(left: 5, right: 5),
//                       child: Center(
//                         child: Text(
//                           job_type['employmenttype'],
//                           style: TextStyle(
//                               color: AppTheme.primary,
//                               fontSize: 10,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     );
//                   }),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Row(
//               children: [
//                 ClipOval(
//                   child: Image.asset(
//                     "assets/images/ellipse.png",
//                     height: 35,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Text(
//                   "Your Profile match this job",
//                   style: TextStyle(
//                       color: AppTheme.primary,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 12),
//                 )
//               ],
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Image.asset(
//                       "assets/icons/time.png",
//                       height: 20,
//                     ),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     Text(
//                       "1 hr ago",
//                       style:
//                           TextStyle(color: AppTheme.TextBoldLite, fontSize: 11),
//                     )
//                   ],
//                 ),
//                 // Text(
//                 //   "₹12k - 20k/years",
//                 //   style: TextStyle(color: AppTheme.success),
//                 // ),
//                 Text(
//                     "${recommed_data['from_currency'] ?? ""} ${recommed_data['from_sal'] ?? ""} - ${recommed_data['to_sal'] ?? ""}",
//                     style: TextStyle(color: AppTheme.success)),
//                 Container(
//                   padding: const EdgeInsets.all(7.0),
//                   decoration: BoxDecoration(
//                       color: AppTheme.primary,
//                       borderRadius: BorderRadius.circular(5.0)),
//                   child: const Text(
//                     "Apply Now",
//                     style: TextStyle(
//                         color: AppTheme.white,
//                         fontSize: 9,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ));
//   }
// }

// ignore_for_file: non_constant_identifier_names

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:job/src/core/utils/app_theme.dart';
// import 'package:job/src/core/utils/local_storage.dart';
// import 'package:job/src/core/utils/navigation.dart';
// import 'package:job/src/features/account/views/profile.dart';
// import 'package:job/src/features/chat/views/chat_list.dart';
// import 'package:job/src/features/dashboard/user_dashboard_api.dart';
// import 'package:job/src/features/dashboard/views/bottombar.dart';
// import 'package:job/src/features/dashboard/views/notifications.dart';
// import 'package:job/src/features/jobs/views/job_details.dart';
// import 'package:job/src/features/jobs/views/jobs.dart';

// class Dashboard extends StatefulWidget {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//   Dashboard({super.key});

//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   int _currentIndex = 0;
//   // int _perviousIndex = 0;

//   final screens = [
//     Home(
//       onTap: () {},
//     ),
//     Jobs(),
//     ChatList(),
//     Profile()
//   ];

//   // var latest_job;
//   // var recommeded;

//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   initilize();
//   //   super.initState();
//   // }

//   // initilize() async {
//   //   var UserResponse = PrefManager.read("UserResponse");
//   //   var get_Home = await UserDashboardApi.getuserHomeContent(
//   //       context, UserResponse['data']['id'], UserResponse['data']['api_token']);
//   //   setState(() {
//   //     if (get_Home.success) {
//   //       latest_job = get_Home.data['dada']?['latest_jddobs'];
//   //       recommeded = get_Home.data['dada']?['recommended'];
//   //     }
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         bool shouldPop = await showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               // title: Text('Confirmation'),
//               content: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text('Are you sure you want to exit?'),
//               ),
//               actions: <Widget>[
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: SizedBox(
//                         height: 40,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // If "Cancel" is pressed, do not pop the route
//                             Navigator.of(context).pop(false);
//                           },
//                           child: const Text('Cancel'),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: SizedBox(
//                         height: 40,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // If "OK" is pressed, pop the route
//                             Navigator.of(context).pop(true);
//                           },
//                           child: const Text('OK'),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         );
//         return shouldPop;
//       },
//       child: Scaffold(
//         key: widget.scaffoldKey,
//         // drawer: _currentIndex == 0 ? Drawer() : null,
//         appBar: _currentIndex != 0
//             ? AppBar(
//                 centerTitle: true,
//                 title: Text(
//                   _currentIndex == 1
//                       ? "My Application"
//                       : _currentIndex == 2
//                           ? "Chat"
//                           : "Profile",
//                   style: const TextStyle(color: AppTheme.white, fontSize: 18),
//                 ),
//                 leading: IconButton(
//                     onPressed: () {
//                       setState(() {
//                         _currentIndex = 0;
//                       });
//                     },
//                     icon: const Icon(
//                       Icons.arrow_back_ios,
//                       color: Colors.white,
//                     )),
//               )
//             : PreferredSize(
//                 preferredSize: Size.fromHeight(0.0), child: AppBar()),
//         bottomNavigationBar: BottomBar(
//             currentIndex: _currentIndex,
//             onTap: (index) {
//               setState(() {
//                 // _perviousIndex = _currentIndex;
//                 _currentIndex = index;
//               });
//             }),
//         // body: _currentIndex == 0
//         //     ? Home(
//         //         onTap: () {
//         //           // Scaffold.of(context).openDrawer();
//         //         },
//         //       )
//         //     : _currentIndex == 1
//         //         ? const Jobs()
//         //         : _currentIndex == 2
//         //             ? const ChatList()
//         //             : const Profile()
//         body: IndexedStack(
//           index: _currentIndex,
//           children: screens,
//         ),
//       ),
//     );
//   }
// }

// class Home extends StatefulWidget {
//   final Function onTap;

//   const Home({super.key, required this.onTap});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   List menu = [
//     "All",
//     "Developer",
//     "UI/UX",
//     "Marketing",
//     "Data Analatics",
//     "SEO",
//     "Manager"
//   ];
//   int _SIndex = 0;

//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   print("success");
//   //   super.initState();
//   // }

//   var latest_job;
//   var recommeded;

//   @override
//   void initState() {
//     // TODO: implement initState
//     initilize();
//     super.initState();
//     initilize();
//   }

//   initilize() async {
//     var UserResponse = PrefManager.read("UserResponse");
//     var get_Home = await UserDashboardApi.getuserHomeContent(
//         context, UserResponse['data']['id'], UserResponse['data']['api_token']);
//     setState(() {
//       if (get_Home.success) {
//         latest_job = get_Home.data['dada']?['latest_jddobs'];
//         recommeded = get_Home.data['dada']?['recommended'];
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion(
//       value: SystemUiOverlayStyle(
//         // statusBarColor: Color(_primary),
//         statusBarColor: HexColor("#565BDB"),
//         statusBarIconBrightness: Brightness.light,
//         statusBarBrightness: Brightness.light,
//       ),
//       child: SafeArea(
//         child: Container(
//           color: HexColor("#565BDB"),
//           child: SingleChildScrollView(
//             physics: const ClampingScrollPhysics(),
//             child: Container(
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                         color: AppTheme.primary,
//                         borderRadius: const BorderRadius.only(
//                             bottomLeft: Radius.circular(25.0),
//                             bottomRight: Radius.circular(25.0))),
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 ClipOval(
//                                   child: Image.asset(
//                                     "assets/images/ellipse.png",
//                                     height: 65,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 const Text(
//                                   "Hi Welcome!",
//                                   style: TextStyle(
//                                       color: AppTheme.white,
//                                       fontWeight: FontWeight.bold),
//                                 )
//                               ],
//                             ),
//                             // const Icon(
//                             //   Icons.notifications,
//                             //   color: Colors.white,
//                             // )
//                             InkWell(
//                               splashColor: Colors.transparent,
//                               highlightColor: Colors.transparent,
//                               onTap: () {
//                                 Nav.to(context, const Notifications());
//                                 // Dashboard? dashboard = context
//                                 //     .findAncestorWidgetOfExactType<Dashboard>();
//                                 // dashboard?.scaffoldKey.currentState?.openDrawer();
//                                 // widget.onTap();
//                               },
//                               child: SizedBox(
//                                 width: 30,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(right: 10.0),
//                                   child: Image.asset(
//                                       "assets/icons/notification.png"),
//                                 ),
//                               ),
//                             ),
//                             // SizedBox(width: 5,)
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         const Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               "Let's Find Your Dream Job!",
//                               style: TextStyle(
//                                   color: AppTheme.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16),
//                             )),
//                         const SizedBox(
//                           height: 15,
//                         ),
//                         TextFormField(
//                             decoration: InputDecoration(
//                           hintText: "Search Company, jobs, location",
//                           fillColor: Colors.white,
//                           filled: true,
//                           prefixIcon: Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Image.asset(
//                               "assets/icons/search.png",
//                               height: 20,
//                               width: 20,
//                             ),
//                           ),
//                           suffixIcon: Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Image.asset(
//                               "assets/icons/fliter.png",
//                               height: 20,
//                               width: 20,
//                             ),
//                           ),
//                         )),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   SizedBox(
//                     height: 60,
//                     child: ListView.builder(
//                         padding: const EdgeInsets.all(8.0),
//                         itemCount: menu.length,
//                         scrollDirection: Axis.horizontal,
//                         itemBuilder: (context, index) {
//                           final data = menu[index];
//                           return InkWell(
//                             splashColor: Colors.transparent,
//                             highlightColor: Colors.transparent,
//                             onTap: () {
//                               setState(() {
//                                 _SIndex = index;
//                               });
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.all(5.0),
//                               decoration: BoxDecoration(
//                                   color: _SIndex == index
//                                       ? AppTheme.primary
//                                       : AppTheme.TextFormFieldBac,
//                                   borderRadius: BorderRadius.circular(10.0)),
//                               child: Center(
//                                   child: Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 10, right: 10),
//                                       child: Text(
//                                         data,
//                                         style: TextStyle(
//                                             color: _SIndex == index
//                                                 ? AppTheme.white
//                                                 : AppTheme.TextBoldLite,
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.bold),
//                                       ))),
//                             ),
//                           );
//                         }),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         left: 10.0, right: 10.0, top: 3.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Latest Vacancies",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         Text(
//                           "See all",
//                           style:
//                               TextStyle(color: AppTheme.primary, fontSize: 12),
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 190,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.all(8.0),
//                       itemCount: 10,
//                       itemBuilder: (BuildContext context, int index) {
//                         return InkWell(
//                             splashColor: Colors.transparent,
//                             highlightColor: Colors.transparent,
//                             onTap: () {
//                               Nav.to(context, JobDetails());
//                             },
//                             child: const Latest());
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         left: 10.0, right: 10.0, top: 3.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Recommended for you",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         Text(
//                           "See all",
//                           style:
//                               TextStyle(color: AppTheme.primary, fontSize: 12),
//                         )
//                       ],
//                     ),
//                   ),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     padding: const EdgeInsets.all(8.0),
//                     itemCount: 10,
//                     itemBuilder: (BuildContext context, int index) {
//                       return InkWell(
//                           splashColor: Colors.transparent,
//                           highlightColor: Colors.transparent,
//                           onTap: () {
//                             Nav.to(context, const JobDetails());
//                           },
//                           child: const Recommeded());
//                     },
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Latest Vacancies Helper Widget
// class Latest extends StatelessWidget {
//   const Latest({super.key});

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Container(
//         width: screenWidth * 0.75,
//         margin: const EdgeInsets.all(8.0),
//         padding: const EdgeInsets.all(12.0),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10.0),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.grey.shade300,
//                   offset: const Offset(0.2, 0.2),
//                   blurRadius: 6.0)
//             ]),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Row(
//                     children: [
//                       Image.asset(
//                         "assets/images/frame.png",
//                         height: 45,
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       Expanded(
//                         child: SizedBox(
//                           height: 45,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 "Product UI Design",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 "Description sffsa sdfsdd fsad dsfsdafsd sdfsadfsdf",
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                     color: AppTheme.TextLite, fontSize: 12),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Image.asset(
//                   "assets/icons/bookmark_light.png",
//                   height: 25,
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 25,
//               child: ListView.builder(
//                   itemCount: 3,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5.0),
//                           color: AppTheme.primary_light),
//                       margin: const EdgeInsets.only(left: 5.0, right: 5.0),
//                       padding: const EdgeInsets.only(left: 5, right: 5),
//                       child: Center(
//                         child: Text(
//                           "Full-time",
//                           style: TextStyle(
//                               color: AppTheme.primary,
//                               fontSize: 10,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     );
//                   }),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Image.asset(
//                       "assets/icons/time.png",
//                       height: 20,
//                     ),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     Text(
//                       "1 hr ago",
//                       style:
//                           TextStyle(color: AppTheme.TextBoldLite, fontSize: 11),
//                     )
//                   ],
//                 ),
//                 Text(
//                   "₹12k - 20k/years",
//                   style: TextStyle(color: AppTheme.success),
//                 )
//               ],
//             )
//           ],
//         ));
//   }
// }

// // Recommended for you Helper Widget

// class Recommeded extends StatelessWidget {
//   const Recommeded({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         margin: const EdgeInsets.all(8.0),
//         padding: const EdgeInsets.all(12.0),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10.0),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.grey.shade300,
//                   offset: const Offset(0.2, 0.2),
//                   blurRadius: 6.0)
//             ]),
//         // height: 50,
//         // color: Colors.red,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Row(
//                     children: [
//                       Image.asset(
//                         "assets/images/back.png",
//                         height: 50,
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       Expanded(
//                         child: SizedBox(
//                           height: 45,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 "UI/UX Designer",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 "Description sffsa sdfsdd fsad dsfsdafsd sdfsadfsdf",
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                     color: AppTheme.TextLite, fontSize: 13),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Image.asset(
//                   "assets/icons/bookmark_light.png",
//                   height: 25,
//                 )
//               ],
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             SizedBox(
//               height: 25,
//               child: ListView.builder(
//                   itemCount: 3,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5.0),
//                           color: AppTheme.primary_light),
//                       margin: const EdgeInsets.only(left: 5.0, right: 5.0),
//                       padding: const EdgeInsets.only(left: 5, right: 5),
//                       child: Center(
//                         child: Text(
//                           "Full-time",
//                           style: TextStyle(
//                               color: AppTheme.primary,
//                               fontSize: 10,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     );
//                   }),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Row(
//               children: [
//                 ClipOval(
//                   child: Image.asset(
//                     "assets/images/ellipse.png",
//                     height: 35,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Text(
//                   "Your Profile match this job",
//                   style: TextStyle(
//                       color: AppTheme.primary,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 12),
//                 )
//               ],
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Image.asset(
//                       "assets/icons/time.png",
//                       height: 20,
//                     ),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     Text(
//                       "1 hr ago",
//                       style:
//                           TextStyle(color: AppTheme.TextBoldLite, fontSize: 11),
//                     )
//                   ],
//                 ),
//                 Text(
//                   "₹12k - 20k/years",
//                   style: TextStyle(color: AppTheme.success),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(7.0),
//                   decoration: BoxDecoration(
//                       color: AppTheme.primary,
//                       borderRadius: BorderRadius.circular(5.0)),
//                   child: const Text(
//                     "Apply Now",
//                     style: TextStyle(color: AppTheme.white, fontSize: 9),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ));
//   }
// }
