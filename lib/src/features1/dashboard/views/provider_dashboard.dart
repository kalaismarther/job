// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/guestAlert.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/logoutAlert.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features/chat/views/chat.dart';
import 'package:job/src/features/dashboard/user_dashboard_api.dart';
import 'package:job/src/features1/account/provider_profile.dart';
import 'package:job/src/features1/createpost/views/job_information.dart';
import 'package:job/src/features1/createpost/views/my_post.dart';
import 'package:job/src/features1/dashboard/provider_dashboard_api.dart';
import 'package:job/src/features1/dashboard/views/latest_profile.dart';
import 'package:job/src/features1/dashboard/views/provider_bottombar.dart';
import 'package:job/src/features1/dashboard/views/provider_drawer.dart';
import 'package:job/src/features1/dashboard/views/provider_notification.dart';
import 'package:job/src/features1/dashboard/views/provider_search_filter.dart';
import 'package:job/src/features1/request/views/request.dart';
import 'package:job/src/features1/subscription/views/my_plan_list.dart';
import 'package:job/src/features1/subscription/views/subscription_list.dart';

class ProviderDashboard extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ProviderDashboard({super.key, this.tabNo = 0});

  final int? tabNo;

  @override
  State<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends State<ProviderDashboard> {
  int _currentIndex = 0;
  bool refresh = true;
  // Set this to true or false based on your condition
  bool shouldRefreshProviderBottomBar = true;
  var check_guest;
  bool isLoading = false;
  List latestList = [];

  @override
  void initState() {
    // TODO: implement initState
    initilize();
    super.initState();
  }

  initilize() {
    var result = PrefManager.read("guest");
    setState(() {
      check_guest = result;
      _currentIndex = widget.tabNo!;
    });
  }

  getHomeContent() async {
    setState(() {
      isLoading = true;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var UserResponse1 = PrefManager.read("update_profile1");
    print(UserResponse1);
    print("${UserResponse1} ===================>");
    var result = await ProviderDashboardApi.getProviderHomeContent(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);

    if (result.success) {
      if (result.data['status'].toString() == "1") {
        setState(() {
          latestList.addAll(result.data['data']?['latest_users'] ?? []);
        });
        PrefManager.write(
            "company_status", result.data['company_status'].toString());
        PrefManager.write(
            "job_post_status", result.data['data']?['job_post_status'] ?? 0);
        PrefManager.write(
            "cv_view_status", result.data['data']?['cv_view_status'] ?? 0);
      }
    }

    // _User_Response = UserResponse['data'];
    // _User_Response1 = UserResponse1;

    print(result);
    setState(() {
      isLoading = false;
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
                        ? "My Plans"
                        : _currentIndex == 2
                            ? "Create Post"
                            : _currentIndex == 3
                                ? "Applied"
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
                    ),
                  ),
                  actions: [
                    _currentIndex == 4
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
                )
              // : null,
              : PreferredSize(
                  preferredSize: Size.fromHeight(0.0),
                  child: AppBar(),
                ),
          bottomNavigationBar: refresh
              ? ProviderBottomBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    var result = PrefManager.read("guest");
                    // PrefManager.writebool("home_load", true);
                    bool get_HomeLoad = PrefManager.readBoolean("home_load");
                    var job_post_status = PrefManager.read("job_post_status");

                    if (result == "yes") {
                      setState(() {
                        refresh = true;
                      });
                    } else {
                      if (!get_HomeLoad) {
                        setState(() {
                          // _perviousIndex = _currentIndex;

                          if (index == 2) {
                            var get_company_status =
                                PrefManager.read("company_status");
                            if (get_company_status == "0") {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    // title: Text('Confirmation'),
                                    content: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Please Update profile'),
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
                                                  Navigator.of(context)
                                                      .pop(false);
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
                                                  // Navigator.of(context).pop(true);

                                                  setState(() {
                                                    _currentIndex = 4;
                                                  });
                                                  Nav.back(context);
                                                },
                                                child: const Text('Ok'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (job_post_status.toString() == "0") {
                              Nav.to(context, SubscriptionList());
                            } else {
                              _currentIndex = index;
                            }
                          } else {
                            _currentIndex = index;
                          }
                        });
                      } else {
                        Snackbar.show(
                            "Already Loading please wait ..", Colors.black);
                      }
                    }
                  })
              : null,
          body: _currentIndex == 0
              ? ProviderHome(
                  onTap: (value) {
                    setState(() {
                      _currentIndex = value;
                    });
                  },
                )
              : _currentIndex == 1
                  ? const MyPlanList()
                  : _currentIndex == 2
                      ? const JobInformation()
                      : _currentIndex == 3
                          ? Request()
                          : const ProviderProfile()),
    );
  }
}

class ProviderHome extends StatefulWidget {
  const ProviderHome({super.key, required this.onTap});
  final Function onTap;

  @override
  State<ProviderHome> createState() => _ProviderHomeState();
}

class _ProviderHomeState extends State<ProviderHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  List latestList = [];
  var _User_Response;
  var _User_Response1;
  var notifiCount = 0;
  int activePlan = 0;

  @override
  void initState() {
    // TODO: implement initState
    initilize();
    getNotify();
    super.initState();
  }

  initilize() async {
    setState(() {
      isLoading = true;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var UserResponse1 = PrefManager.read("update_profile1");
    PrefManager.writebool("home_load", true);
    // print(UserResponse1);
    // print("${UserResponse1} ===================>");
    var result = await ProviderDashboardApi.getProviderHomeContent(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);

    if (result.success) {
      if (result.data['status'].toString() == "1") {
        if (result.data['data']?['cv_view_status']?.toString() == '1') {
          setState(() {
            activePlan = 1;
          });
        } else if (result.data['data']?['cv_view_status']?.toString() == '0') {
          setState(() {
            activePlan = 0;
          });
        }
        setState(() {
          latestList.addAll(result.data['data']?['latest_users'] ?? []);
        });
        PrefManager.writebool("home_load", false);
        PrefManager.write(
            "company_status", result.data['company_status'].toString());
        PrefManager.write(
            "job_post_status", result.data['data']?['job_post_status'] ?? 0);
        PrefManager.write(
            "cv_view_status", result.data['data']?['cv_view_status'] ?? 0);
      }
    }
    PrefManager.writebool("home_load", false);

    _User_Response = UserResponse['data'];
    _User_Response1 = UserResponse1;

    setState(() {
      isLoading = false;
    });
  }

  getNotify() async {
    var UserResponse = PrefManager.read("UserResponse");
    var get_count = await UserDashboardApi.notifyCount(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);

    if (get_count.success) {
      if (get_count.data['status'].toString() == "1") {
        setState(() {
          notifiCount = get_count.data['data'] ?? 0;
        });
      }
    }
  }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0)),
            ),
            child: ProviderDrawer(onTap: () {
              _scaffoldKey.currentState?.openEndDrawer();
            })),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            // Nav.to(context, page)
                            // setState(() {
                            widget.onTap(4);
                            // });
                          },
                          child: Row(
                            children: [
                              _User_Response1?['is_company_logo'] != null
                                  ? ClipOval(
                                      child: FadeInImage(
                                        placeholder: AssetImage(
                                            'assets/icons/Profile.png'),
                                        imageErrorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(Icons.image_not_supported),
                                        image: NetworkImage(_User_Response1?[
                                                'is_company_logo'] ??
                                            ""),
                                        fit: BoxFit.cover,
                                        // width: 100.0,
                                        height: 65,
                                        width: 65,
                                      ),
                                    )
                                  : Image.asset(
                                      "assets/icons/Profile.png",
                                      height: 65,
                                    ),
                              // ClipOval(
                              //   child: Image.asset(
                              //     "assets/images/ellipse.png",
                              //     height: 65,
                              //   ),
                              // ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                // "Hi Welcome!",
                                "Hi ${_User_Response1?['name'] ?? ""}",
                                style: TextStyle(
                                    color: AppTheme.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
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
                              icon: Icon(
                                Icons.chat,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
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
                                  await Nav.to(
                                      context, ProviderNotifications());
                                  getNotify();
                                }
                                // Nav.to(context, ProviderNotifications());
                                // Nav.to(context, MyPost());
                                // Nav.to(
                                //     context,
                                //     const ProfileDetails(
                                //       applied_user_id: '',
                                //       job_id: '',
                                //     ));
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
                                      notifiCount != 0
                                          ? Positioned(
                                              top: 3,
                                              right: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: const BoxDecoration(
                                                  color: Colors
                                                      .red, // You can customize the color
                                                  shape: BoxShape.circle,
                                                ),
                                                child: notifiCount > 9
                                                    ? Text(
                                                        '9+',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 7.5,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    : Text(
                                                        notifiCount.toString(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                              //     child:
                              //         Image.asset("assets/icons/notification.png"),
                              //   ),
                              // ),
                            ),
                            IconButton(
                              onPressed: () {
                                // openDrawer(context);
                                //  Scaffold.of(context).openDrawer();
                                _scaffoldKey.currentState?.openDrawer();
                              },
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                            )
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
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                        readOnly: true,
                        onTap: activePlan == 1
                            ? () {
                                Nav.to(context, ProviderSearch());
                              }
                            : () {
                                Snackbar.show("CV Plan expired", Colors.black);
                              },
                        decoration: InputDecoration(
                          hintText: "Search skills, locations",
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
              !isLoading
                  ? activePlan == 1
                      ? latestList.isNotEmpty
                          ? ListView.builder(
                              itemCount: latestList.length,
                              padding: const EdgeInsets.all(15.0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final latest_data = latestList[index];
                                return InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    Nav.to(
                                        context,
                                        LatestProfile(
                                            user_id:
                                                latest_data['id'].toString()));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          latest_data['name'] ?? "",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/icons/city.png",
                                              width: 15,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "${latest_data['is_state_name'] ?? ""}, ${latest_data['is_country_name'] ?? ""}",
                                              style: TextStyle(
                                                  color: AppTheme.TextLite,
                                                  height: 3),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/icons/qly.png",
                                              width: 15,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "${latest_data['qualification'] ?? ""} (${latest_data['short_qualification'] ?? ""})",
                                              style: TextStyle(
                                                  color: AppTheme.TextLite),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : SizedBox(
                              height: screenHeight * 0.5,
                              child: const Center(child: Text("No List")))
                      : Padding(
                          padding: const EdgeInsets.only(top: 150),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'To view or download job seekers profile please upgrade your CV plan',
                                  style: TextStyle(height: 2),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 15),
                                TextButton(
                                    onPressed: () {
                                      Nav.to(context, SubscriptionList());
                                    },
                                    child: Text('Upgrade'))
                              ],
                            ),
                          ),
                        )
                  : ShimmerLoader(type: "")
            ],
          ),
        ),
      ),
    );
  }
}
