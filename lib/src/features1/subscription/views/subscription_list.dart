import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/features1/subscription/subscription_api.dart';
import 'package:job/src/features1/subscription/views/package_details.dart';

class SubscriptionList extends StatefulWidget {
  const SubscriptionList({super.key});

  @override
  State<SubscriptionList> createState() => _SubscriptionListState();
}

class _SubscriptionListState extends State<SubscriptionList> {
  List list = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    initilize();
    super.initState();
  }

  initilize() async {
    setState(() {
      isLoading = true;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var get_list = await SubscriptionApi.getCompanyPackages(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);

    print(get_list);

    if (get_list.success) {
      if (get_list.data['status'].toString() == "1") {
        setState(() {
          list.addAll(get_list.data['data'] ?? []);
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
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text("Packages",
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
      body: !isLoading
          ? list.isNotEmpty
              ? ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    // final data = list[index];
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Nav.to(
                            context,
                            PackageDetails(
                              details: list[index],
                            ));
                      },
                      child: SubscriptionCard(
                        package: list[index],
                        index: index,
                      ),
                    );
                  },
                )
              : const Center(child: Text("No list"))
          : SingleChildScrollView(child: ShimmerLoader(type: "")),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final Map package;
  final int index;

  const SubscriptionCard({Key? key, required this.package, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Colors.amber,
      Colors.green,
      Colors.deepOrange,
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          // margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: colors[index % colors.length].withOpacity(0.15),
              // Transparent background with different colors
              borderRadius: BorderRadius.circular(10),
              border: Border(
                left: BorderSide(
                  color:
                      colors[index % colors.length], // Set desired border color
                  width: 10.0, // Set desired border width
                ),
              )),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package['package_title'] ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                package['id'].toString() == "1"
                    ? Text(
                        "₹ ${(package['per_job_post_amount'] ?? "").toString()}",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                    : package['id'].toString() == "2"
                        ? Text(
                            "₹ ${(package['per_req_amount'] ?? "").toString()}",
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                // Text(
                //   package['package_title'] ?? "",
                //   style: TextStyle(fontSize: 16, color: AppTheme.TextLite),
                // ),
                const SizedBox(height: 10),
                Text(
                  package['short_description'] ?? "",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                // ElevatedButton(
                //   onPressed: () {
                //     // Implement subscription action
                //   },
                //   child: Text('Subscribe'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubscriptionPackage {
  final String name;
  final String price;
  final String duration;
  final String benefits;

  SubscriptionPackage({
    required this.name,
    required this.price,
    required this.duration,
    required this.benefits,
  });
}
