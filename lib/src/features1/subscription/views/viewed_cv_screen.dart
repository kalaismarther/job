import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/features1/account/profile_details.dart';
import 'package:job/src/features1/dashboard/views/latest_profile.dart';

class ViewedCvScreen extends StatefulWidget {
  const ViewedCvScreen({super.key, required this.packageInfo});

  final Map packageInfo;

  @override
  State<ViewedCvScreen> createState() => _ViewedCvScreenState();
}

class _ViewedCvScreenState extends State<ViewedCvScreen> {
  @override
  void initState() {
    print(widget.packageInfo);
    super.initState();
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
          widget.packageInfo['package_title'] ?? '',
          style: const TextStyle(
              color: AppTheme.white,
              fontSize: 16,
              overflow: TextOverflow.ellipsis),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            widget.packageInfo['downloaded_cvs'] != null &&
                    widget.packageInfo['downloaded_cvs'].isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        widget.packageInfo['downloaded_cvs']?.length ?? 0,
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
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
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: Image.network(
                                      widget.packageInfo['downloaded_cvs']
                                          ?[index]?['is_profile_image'],
                                      fit: BoxFit.fill,
                                      height: 40,
                                      width: 40, errorBuilder:
                                          (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                    // Handle the error here
                                    return const Icon(
                                        Icons.image_not_supported);
                                  }),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.packageInfo['downloaded_cvs']?[index]
                                            ?['name'] ??
                                        "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Nav.to(
                                  context,
                                  LatestProfile(
                                      user_id: widget
                                              .packageInfo['downloaded_cvs']
                                                  ?[index]?['id']
                                              .toString() ??
                                          ''));
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
                          ),
                        ],
                      ),
                    ),
                  )
                : const Text('No profiles you\'ve viewed under this package'),
          ],
        ),
      ),
    );
  }
}
