import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/features1/account/profile_details.dart';
import 'package:job/src/features1/request/request_api.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  final controller = ScrollController();

  bool isLoading = false;
  bool listLoading = false;
  List appliedList = [];
  var page_no;

  @override
  void initState() {
    // TODO: implement initState
    initilize();
    super.initState();
    scrollEvent();
  }

  initilize() async {
    setState(() {
      isLoading = true;
    });
    await _appliedList();

    setState(() {
      isLoading = false;
    });
  }

  _appliedList() async {
    setState(() {
      listLoading = true;
      page_no = appliedList.length;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var data = {"user_id": UserResponse['data']['id'], "page_no": page_no};
    var get_request_list = await RequestApi.getCompanyJobAppliedList(
        context, data, UserResponse['data']['api_token']);
    print(get_request_list);

    if (get_request_list.success) {
      if (get_request_list.data['status'].toString() == "1") {
        setState(() {
          appliedList.addAll(get_request_list.data['data'] ?? []);
        });
      }
    }
    setState(() {
      listLoading = false;
    });
  }

  void scrollEvent() {
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        if (page_no != null && page_no != appliedList.length) {
          // Latest();
          _appliedList();
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
      //   title: const Text("Applied",
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
          ? appliedList.length > 0
              ? ListView.builder(
                  controller: controller,
                  itemCount: appliedList.length + 1,
                  itemBuilder: (context, index) {
                    if (index < appliedList.length) {
                      final applied_data = appliedList[index];
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: Image.network(
                                            applied_data['is_profile_image'],
                                            fit: BoxFit.fill,
                                            height: 40,
                                            width: 40, errorBuilder:
                                                (BuildContext context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                          // Handle the error here
                                          return const Center(
                                            child: Text('UnSupported Image'),
                                          );
                                        }),
                                      ),
                                    ),
                                    // ClipOval(
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(4.0),
                                    //     child: Image.asset(
                                    //       "assets/images/ellipse.png",
                                    //       height: 35,
                                    //     ),
                                    //   ),
                                    // ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      applied_data['name'] ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Text(
                                  applied_data['applied_at'] ?? "",
                                  style: TextStyle(color: AppTheme.TextLite),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  applied_data['job_title'] ?? "",
                                  style: TextStyle(color: AppTheme.TextLite),
                                )
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Nav.to(
                                    context,
                                    ProfileDetails(
                                      applied_user_id:
                                          applied_data['user_id'].toString(),
                                      job_id: applied_data['job_id'].toString(),
                                      jobs_applied_id:
                                          applied_data['jobs_applied_id']
                                              .toString(),
                                    ));
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 5.0,
                                    bottom: 5.0,
                                    left: 10.0,
                                    right: 10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: AppTheme.primary),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(
                                  "See Application",
                                  style: TextStyle(
                                      fontSize: 10, color: AppTheme.primary),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return listLoading
                          ? Center(
                              child: SingleChildScrollView(
                                  child: ShimmerLoader(type: "")),
                            )
                          : Container(
                              height: page_no != appliedList.length ? 100 : 0,
                            );
                    }
                  })
              : const Center(
                  child: Text("No List"),
                )
          : SingleChildScrollView(child: ShimmerLoader(type: "")),
    );
  }
}
