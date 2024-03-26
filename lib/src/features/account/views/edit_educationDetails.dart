import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/common_search_modal.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features/auth/auth_api.dart';

class EditEducational extends StatefulWidget {
  const EditEducational({super.key, required this.type, required this.data});

  final String type;
  final Map data;

  @override
  State<EditEducational> createState() => _EditEducationalState();
}

class _EditEducationalState extends State<EditEducational> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController qulification = TextEditingController();
  TextEditingController specialization = TextEditingController();
  TextEditingController university = TextEditingController();
  TextEditingController year = TextEditingController();

  String EducationType = '';
  bool isLoading = false;
  var s_qulId = "";
  var s_specId = "";
  var s_uniName = "";
  var s_yr = "";
  var educationId;

  @override
  void initState() {
    // TODO: implement initState
    initilize();
    super.initState();
  }

  initilize() {
    print(widget.data);
    if (widget.type == "edit") {
      setState(() {
        qulification.text =
            widget.data['is_qualification']?['qualification'] ?? "";
        specialization.text = widget.data['is_specialisation'] ?? "";
        university.text = widget.data['institute_name'] ?? "";
        year.text = (widget.data['year_of_graduation'] ?? "").toString();
        EducationType = (widget.data['education_type'] ?? "").toString();
        s_qulId = (widget.data['qualification_id'] ?? "").toString();
        s_specId = (widget.data['specialisation_id'] ?? "").toString();
        educationId = widget.data['id'].toString();
      });
    }
  }

  void _modal(data, type) async {
    final result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CommonSearchModal(data: data, type: type);
        });
    if (result != null) {
      setState(() {
        if (type == "qul") {
          qulification.text = result['qualification'] ?? "";
          s_qulId = result['id'].toString();
        }
        if (type == "specification") {
          specialization.text = result['specialise_name'] ?? "";
          s_specId = result['id'].toString();
        }
        if (type == "year") {
          year.text = (result['year'] ?? "").toString();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;

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
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Highest Qualification",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.TextBoldLite),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: qulification,
                      onTap: () async {
                        print("success");
                        _modal([], "qul");
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Qualification';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        suffixIcon: SizedBox(
                            width: 15,
                            height: 15,
                            child: Padding(
                              padding: const EdgeInsets.all(17.0),
                              child: Image.asset(
                                "assets/icons/down.png",
                                fit: BoxFit.contain,
                              ),
                            )),
                        hintText: 'Highest Qualification',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Specialization/Major",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.TextBoldLite),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: specialization,
                      onTap: () async {
                        _modal([], "specification");
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Specialization';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        suffixIcon: SizedBox(
                            width: 15,
                            height: 15,
                            child: Padding(
                              padding: const EdgeInsets.all(17.0),
                              child: Image.asset(
                                "assets/icons/down.png",
                                fit: BoxFit.contain,
                              ),
                            )),
                        hintText: 'Specialization',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "University/Institute",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.TextBoldLite),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      // readOnly: true,
                      controller: university,
                      onTap: () async {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter a University/Institute';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        counterText: '',
                        // suffixIcon: SizedBox(
                        //     width: 15,
                        //     height: 15,
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(17.0),
                        //       child: Image.asset(
                        //         "assets/icons/down.png",
                        //         fit: BoxFit.contain,
                        //       ),
                        //     )),
                        hintText: 'University/Institute',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Years of Graduation",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.TextBoldLite,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: year,
                      onTap: () async {
                        _modal([], "year");
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Year';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        suffixIcon: SizedBox(
                            width: 15,
                            height: 15,
                            child: Padding(
                              padding: const EdgeInsets.all(17.0),
                              child: Image.asset(
                                "assets/icons/down.png",
                                fit: BoxFit.contain,
                              ),
                            )),
                        hintText: 'Year',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Education Type",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.TextBoldLite),
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: '1',
                          groupValue: EducationType,
                          onChanged: (value) {
                            setState(() {
                              EducationType = value.toString();
                            });
                          },
                        ),
                        const Text(
                          'Full Time',
                          style: TextStyle(fontSize: 12),
                        ),
                        Radio(
                          value: '2',
                          groupValue: EducationType,
                          onChanged: (value) {
                            setState(() {
                              EducationType = value.toString();
                            });
                          },
                        ),
                        const Text('Part Time', style: TextStyle(fontSize: 12)),
                        Radio(
                          value: '3',
                          groupValue: EducationType,
                          onChanged: (value) {
                            setState(() {
                              EducationType = value.toString();
                            });
                          },
                        ),
                        const Flexible(
                            child: Text('Correspondence',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12))),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                        width: ScreenWidth,
                        child: ElevatedButton(
                            onPressed: () async {
                              var UserResponse =
                                  PrefManager.read("UserResponse");
                              if (isLoading == false) {
                                setState(() {
                                  isLoading = true;
                                });
                                if (_formKey.currentState!.validate()) {
                                  if (EducationType == "") {
                                    Snackbar.show(
                                        "Please Select Education Type",
                                        Colors.black);
                                  } else {
                                    var data = {
                                      "user_id": UserResponse['data']['id'],
                                      "qualification_id": s_qulId,
                                      "specialisation_id": s_specId,
                                      "institute_name": university.text,
                                      "year_of_graduation": year.text,
                                      "education_type": EducationType,
                                      "education_id": widget.type == "edit"
                                          ? educationId
                                          : ""
                                    };
                                    print(data);
                                    var result =
                                        await AuthApi.updateUserEducation(
                                            context,
                                            data,
                                            UserResponse['data']['api_token']);
                                    if (result.success) {
                                      if (result.data['status'].toString() ==
                                          "1") {
                                        if (result.data['message'] != null) {
                                          Snackbar.show(result.data['message'],
                                              Colors.green);
                                        } else {
                                          Snackbar.show("Update Successfully",
                                              Colors.green);
                                        }
                                        Nav.back(context);

                                        // Nav.to(context, JobPreference());
                                      } else if (result.data['message'] !=
                                          null) {
                                        Snackbar.show(result.data['message'],
                                            Colors.black);
                                      } else {
                                        Snackbar.show(
                                            "Some Error", Colors.black);
                                      }
                                    } else {
                                      Snackbar.show("Some Error", Colors.red);
                                    }
                                    print(data);
                                  }
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              }

                              // Nav.to(context, const JobPreference());
                            },
                            child: !isLoading
                                ? Text(widget.type == "edit" ? "Update" : "Add")
                                : Loader.common())),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
