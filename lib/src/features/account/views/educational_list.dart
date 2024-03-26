import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/features/account/user_profile_api.dart';
import 'package:job/src/features/account/views/edit_educationDetails.dart';

class EducationalList extends StatefulWidget {
  const EducationalList({super.key});

  @override
  State<EducationalList> createState() => _EducationalListState();
}

class _EducationalListState extends State<EducationalList> {
  List educationList = [];
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

    var get_edu = await UserProfileApi.GetEducationalDetails(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);
    if (get_edu.success) {
      if (get_edu.data['status'].toString() == "1") {
        setState(() {
          educationList.clear();
          educationList.addAll(get_edu.data['data'] ?? []);
        });
      }
    }
    setState(() {
      isLoading = false;
    });
    print(educationList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(),
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text("Educational Details",
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
                await Nav.to(
                    context, const EditEducational(type: "new", data: {}));
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
              child: educationList.length > 0
                  ? ListView.builder(
                      itemCount: educationList.length,
                      itemBuilder: (context, index) {
                        final data = educationList[index];
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await Nav.to(context,
                                  EditEducational(type: "edit", data: data));
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
                                          data['is_qualification']
                                                  ?['qualification'] ??
                                              "",
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
                                      data['institute_name'] ?? "",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.TextBoldLite),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      data['is_education_type'] ?? "",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.TextLite),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      (data['year_of_graduation'] ?? "")
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.TextLite),
                                    )
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
                        await Nav.to(context,
                            const EditEducational(type: "new", data: {}));
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
                              "Add Educational details",
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
