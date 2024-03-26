import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/navigation.dart';

class JobStatus extends StatefulWidget {
  const JobStatus({super.key, required this.data});

  final Map data;

  @override
  State<JobStatus> createState() => _JobStatusState();
}

class _JobStatusState extends State<JobStatus> {
  @override
  void initState() {
    // TODO: implement initState
    print(widget.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(),
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text("Application Status",
            style: TextStyle(color: AppTheme.white, fontSize: 18)),
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          offset: const Offset(0.2, 0.2),
                          blurRadius: 6.0)
                    ]),
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                          widget.data['company_details']['is_company_logo'],
                          fit: BoxFit.fill,
                          height: 55,
                          width: 55, errorBuilder: (BuildContext context,
                              Object exception, StackTrace? stackTrace) {
                        // Handle the error here
                        return const Center(
                          child: Icon(Icons.image_not_supported),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.data['job_title'] ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              // Container(
                              //     padding: const EdgeInsets.only(
                              //         left: 5.0,
                              //         right: 5.0,
                              //         top: 1.0,
                              //         bottom: 1.0),
                              //     decoration: BoxDecoration(
                              //       color: AppTheme.success_light,
                              //       borderRadius: BorderRadius.circular(5.0),
                              //     ),
                              //     child: Text(
                              //       "Accepted",
                              //       style: TextStyle(
                              //           color: AppTheme.success,
                              //           fontSize: 12,
                              //           fontWeight: FontWeight.bold),
                              //     ))
                            ],
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
                                widget.data['company_details']
                                        ?['company_name'] ??
                                    "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppTheme.TextBoldLite,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "State Tracking",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.data['status_track'] != null
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.data['status_track'].length,
                          itemBuilder: (context, index) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    // Image.asset(
                                    //   "assets/icons/verify.png",
                                    //   height: 25,
                                    // ),
                                    Icon(
                                      Icons.circle,
                                      color: index == 0
                                          ? AppTheme.primary
                                          // ? AppTheme.TextLite
                                          : AppTheme.primary,
                                    ),
                                    SizedBox(
                                        height: index ==
                                                (widget.data['status_track']
                                                        .length -
                                                    1)
                                            ? 0
                                            : 90,
                                        child: VerticalDivider(
                                          thickness: 3,
                                          color: index == 0
                                              ? AppTheme.primary
                                              // ? AppTheme.TextLite
                                              : AppTheme.primary,
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.data['status_track'][index]
                                                ['display_status'] ??
                                            "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: index == 0
                                              ? AppTheme.primary
                                              // ?AppTheme.TextLite
                                              : AppTheme.primary,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        widget.data['status_track'][index]
                                                ['comments'] ??
                                            "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: index == 0
                                                ? AppTheme.primary
                                                // ? AppTheme.TextLite
                                                : AppTheme.primary,
                                            fontSize: 13),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Image.asset(
                                      //       "assets/icons/calender.png",
                                      //       height: 15,
                                      //       color: index == 0
                                      //           ? AppTheme.primary
                                      //           : AppTheme.TextLite,
                                      //     ),
                                      //     const SizedBox(
                                      //       width: 5,
                                      //     ),
                                      //     Text(
                                      //       "20 Dec 23",
                                      //       maxLines: 1,
                                      //       overflow: TextOverflow.ellipsis,
                                      //       style: TextStyle(
                                      //           color: index == 0
                                      //               ? AppTheme.primary
                                      //               : AppTheme.TextLite,
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
                                      //           color: index == 0
                                      //               ? AppTheme.primary
                                      //               : AppTheme.TextLite,
                                      //           fontSize: 11),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          })
                      : SizedBox())
            ],
          ),
        ),
      ),
    );
  }
}
