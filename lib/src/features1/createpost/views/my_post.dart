import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/features1/createpost/post_api.dart';
import 'package:job/src/features1/createpost/views/mypost_details.dart';
import 'package:job/src/features1/createpost/views/requested_persons.dart';

class MyPost extends StatefulWidget {
  const MyPost({super.key});

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  final controller = ScrollController();

  List jobList = [];
  bool isLoading = false;
  bool listLoading = false;
  // var _User_Response;

  var page_no;

  // @override
  // void initState() {
  //     initilize();
  //   super.initState();
  //   scrollEvent();
  // }
  @override
  void initState() {
    super.initState();
    scrollEvent();
    initilize();
  }

  initilize() async {
    setState(() {
      isLoading = true;
    });
    // var UserResponse = PrefManager.read("UserResponse");
    // var result = await PostApi.getMypostJob(context, UserResponse['data']['id'],
    //     0, UserResponse['data']['api_token']);
    // print(result);
    await getJobList();
    setState(() {
      // if (result.success) {
      //   jobList = result.data['data'];
      // }
      isLoading = false;
    });
  }

  getJobList() async {
    setState(() {
      listLoading = true;
      page_no = jobList.length;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var result = await PostApi.getMypostJob(context, UserResponse['data']['id'],
        jobList.length, UserResponse['data']['api_token']);
    print(result);
    print(UserResponse['data']['id']);
    print(UserResponse['data']['api_token']);
    setState(() {
      if (result.success) {
        jobList.addAll(result.data['data'] ?? []);
      }
      print(jobList[0]['applied_seekers']);
      listLoading = false;
    });
  }

  void scrollEvent() {
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        if (page_no != null && page_no != jobList.length) {
          // Latest();
          getJobList();
        }
      }
    });
  }

  String changeDateFormat(String date) {
    DateTime _date = DateFormat("yyyy-MM-dd").parse(date);
    String _formattedDate = DateFormat('dd-MM-yyyy').format(_date);
    return _formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: AppTheme.primary,
      //   title: const Text("My Post",
      //       style: TextStyle(color: AppTheme.white, fontSize: 18)),
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
          ? jobList.length != 0
              ? ListView.builder(
                  controller: controller,
                  itemCount: jobList.length + 1,
                  itemBuilder: (context, index) {
                    if (index < jobList.length) {
                      final data = jobList[index];
                      final List skills = data['skills'].toString().split(",");
                      final List education = data['is_education'];
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Nav.to(
                              context,
                              MypostDetails(
                                job_id: data['id'].toString(),
                              ));
                        },
                        child: Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data?['job_title'] ?? "",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Expires on ${changeDateFormat(data!['display_expire_date'].toString().substring(0, 10))}",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    data?['status'] ?? "",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            (data['status'] ?? "") == "ACTIVE"
                                                ? Colors.green
                                                : Colors.red),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                data['job_description'] ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: AppTheme.TextBoldLite),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // ListView.builder(
                              //     shrinkWrap: true,
                              //     physics: NeverScrollableScrollPhysics(),
                              //     itemCount: skills.length,
                              //     itemBuilder: (context, index) {
                              //       final s_data = skills[index];
                              // return
                              Wrap(
                                spacing: 3.0,
                                runSpacing: 2.0,
                                children: skills.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  bool isEven = index % 2 == 0;
                                  return SizedBox(
                                    height: 25,
                                    child: TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8.0,
                                            top: 2.0,
                                            bottom: 2.0),
                                        backgroundColor: isEven
                                            ? AppTheme.app_yellow_lite
                                            : AppTheme.success_light,
                                      ),
                                      child: Text(
                                        entry.value,
                                        style: TextStyle(
                                            color: !isEven
                                                ? AppTheme.success
                                                : AppTheme.app_yellow,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              // }),
                              // Row(
                              //   children: [
                              //     SizedBox(
                              //       height: 25,
                              //       child: TextButton(
                              //         onPressed: () {
                              //           // Add your button onPressed logic here
                              //         },
                              //         style: TextButton.styleFrom(
                              //           // shape: CircleBorder(),
                              //           padding: const EdgeInsets.only(
                              //               left: 5, right: 5.0, top: 2.0, bottom: 2.0),
                              //           backgroundColor: AppTheme
                              //               .app_yellow_lite, // Set your desired background color here
                              //         ),
                              //         child: Text(
                              //           'Marketing',
                              //           style: TextStyle(
                              //               color: AppTheme.app_yellow,
                              //               fontSize: 10,
                              //               fontWeight: FontWeight.bold),
                              //         ),
                              //       ),
                              //     ),
                              //     const SizedBox(
                              //       width: 10,
                              //     ),
                              //     SizedBox(
                              //       height: 25,
                              //       child: TextButton(
                              //         onPressed: () {
                              //           // Add your button onPressed logic here
                              //         },
                              //         style: TextButton.styleFrom(
                              //           // shape: CircleBorder(),
                              //           padding: const EdgeInsets.only(
                              //               left: 5, right: 5.0, top: 2.0, bottom: 2.0),
                              //           backgroundColor: AppTheme
                              //               .success_light, // Set your desired background color here
                              //         ),
                              //         child: Text(
                              //           'Click me',
                              //           style: TextStyle(
                              //               color: AppTheme.success,
                              //               fontSize: 10,
                              //               fontWeight: FontWeight.bold),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              const SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: education.map((value) {
                                  return Text(value['qualification'] + " ");
                                }).toList(),
                              ),

                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: data?['applied_count'] == 0
                                      ? Colors.grey
                                      : AppTheme.primary,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                ),
                                onPressed: data?['applied_count'] == 0
                                    ? () {}
                                    : () {
                                        Nav.to(
                                          context,
                                          RequestedPersons(
                                            jobId: data['id'].toString(),
                                            jobTitle: data?['job_title'] ?? "",
                                          ),
                                        );
                                      },
                                child: data?['applied_count'] == 0
                                    ? const Text('No requests')
                                    : Text(
                                        'View ${data?['applied_count'] ?? ''} requests'),
                              ),
                              // Text(
                              //     'No. of requests : ${data?['applied_count'] ?? ''}')
                              // Text(
                              //   "Bachelor of Commerce (B.com)",
                              //   style: TextStyle(color: AppTheme.TextLite),
                              // )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return listLoading
                          ? Center(
                              child: SingleChildScrollView(
                                  child: ShimmerLoader(type: "")),
                            )
                          : Container(
                              height: page_no != jobList.length ? 100 : 0,
                            );
                    }
                  })
              : const Center(
                  child: Text("No Post"),
                )
          : SingleChildScrollView(
              child: ShimmerLoader(type: ""),
            ),
      // Center(child: CircularProgressIndicator())
    );
  }
}
