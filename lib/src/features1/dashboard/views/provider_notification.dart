import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/features/dashboard/user_dashboard_api.dart';

class ProviderNotifications extends StatefulWidget {
  const ProviderNotifications({super.key});

  @override
  State<ProviderNotifications> createState() => _ProviderNotificationsState();
}

class _ProviderNotificationsState extends State<ProviderNotifications> {
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

    var get_list = await UserDashboardApi.getNotificationlist(context,
        UserResponse['data']['id'], page_no, UserResponse['data']['api_token']);
    print(get_list);
    if (get_list.success) {
      if (get_list.data['status'].toString() == "1") {
        setState(() {
          list.addAll(get_list.data['data'] ?? []);
        });
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
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text("Notifications",
            style: TextStyle(
              color: AppTheme.white,
            )),
        leading: IconButton(
            onPressed: () {
              Nav.back(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme.white,
            )),
      ),
      body:
          // Container(
          //   color: Colors.amber,
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height,
          //   child: Column(
          //     // crossAxisAlignment: CrossAxisAlignment.end,
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       Container(
          //         width: 100,
          //         height: 100,
          //         color: Colors.red,
          //         child: Text("Welcome"),
          //       ),
          //       Container(
          //         width: 100,
          //         height: 100,
          //         color: Colors.red,
          //         child: Text("Welcome"),
          //       )
          //     ],
          //   ),
          // )
          !isLoading
              ? list.length > 0
                  ? ListView.builder(
                      controller: controller,
                      itemCount: list.length + 1,
                      itemBuilder: (context, index) {
                        // final data = list[index];
                        if (index < list.length) {
                          final data = list[index];
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: AppTheme.TextLite))),
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ClipOval(
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(4.0),
                                //     child: Image.asset(
                                //       "assets/images/ellipse.png",
                                //       height: 35,
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(
                                //   width: 10,
                                // ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['title'] ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      data['message'] ?? "",
                                      // maxLines: 2,
                                      // overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: AppTheme.TextBoldLite,
                                          fontSize: 13),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      data['is_created_ago'] ?? "",
                                      style: TextStyle(
                                        color: AppTheme.TextLite,
                                        fontSize: 11,
                                      ),
                                    )
                                  ],
                                )),
                              ],
                            ),
                          );
                        } else {
                          return page_loading
                              ? Center(
                                  child: SingleChildScrollView(
                                      child: ShimmerLoader(type: "")),
                                )
                              : Container(
                                  height: page_no != list.length ? 100 : 0,
                                );
                        }
                      })
                  : const Center(child: Text("No Notifications list"))
              : SingleChildScrollView(child: ShimmerLoader(type: "")),
    );
  }
}
