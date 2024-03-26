import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/features/account/user_profile_api.dart';
import 'package:job/src/features/account/views/edit_employmentDetails.dart';

class EmploymentList extends StatefulWidget {
  const EmploymentList({super.key});

  @override
  State<EmploymentList> createState() => _EmploymentListState();
}

class _EmploymentListState extends State<EmploymentList> {
  List months = [
    {"id": "0", "month": "January"},
    {"id": "1", "month": "February"},
    {"id": "2", "month": "March"},
    {"id": "3", "month": "April"},
    {"id": "4", "month": "May"},
    {"id": "5", "month": "June"},
    {"id": "6", "month": "July"},
    {"id": "7", "month": "August"},
    {"id": "8", "month": "September"},
    {"id": "9", "month": "October"},
    {"id": "10", "month": "November"},
    {"id": "11", "month": "December"}
  ];
  List EmploymentList = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    initilize();
    super.initState();
  }

  getMonthById(months, id) {
    var result;
    for (Map<String, String> month in months) {
      if (month['id'] == id.toString()) {
        result = month;
        break;
      }
    }
    return result['month'];
  }

  initilize() async {
    setState(() {
      isLoading = true;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var get_employeDetails = await UserProfileApi.GetUserEmployeDetails(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);

    if (get_employeDetails.success) {
      if (get_employeDetails.data['status'].toString() == "1") {
        setState(() {
          EmploymentList.clear();
          EmploymentList.addAll(get_employeDetails.data['data'] ?? []);
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
        iconTheme: IconThemeData(),
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text("Employment Details",
            style: TextStyle(color: AppTheme.white, fontSize: 18)),
        leading: IconButton(
            onPressed: () {
              Nav.back(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme.white,
            )),
        actions: [
          IconButton(
              onPressed: () async {
                await Nav.to(context, EditEmployment(type: "new", data: {}));
                initilize();
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      body: !isLoading
          ? Padding(
              padding: const EdgeInsets.all(5.0),
              child: EmploymentList.length > 0
                  ? ListView.builder(
                      itemCount: EmploymentList.length,
                      itemBuilder: (context, index) {
                        final data = EmploymentList[index];
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: ()async{
                              await Nav.to(context, EditEmployment(type: "edit", data: data));
                              initilize();
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          data['designation'] ?? "",
                                        )),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 3, right: 3),
                                          child: Icon(
                                            Icons.edit,
                                            size: 15,
                                            color: AppTheme.primary,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      data['company_name'] ?? "",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.TextBoldLite),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "${(data['start_year'] ?? "").toString()} ${getMonthById(months, (data['start_month'] ?? "0").toString())} - ${(data['end_year'] ?? "").toString()} ${getMonthById(months, (data['end_month'] ?? "0").toString())}",
                                      style: TextStyle(
                                          fontSize: 11, color: AppTheme.TextLite),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  : Center(
                      child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        await Nav.to(context, EditEmployment(type: "new", data: {}));
                        initilize();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: AppTheme.primary),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Add Employment details",
                              style: TextStyle(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    )),
            )
          : Center(
              child: CircularProgressIndicator(
                color: AppTheme.primary,
              ),
            ),
    );
  }
}
