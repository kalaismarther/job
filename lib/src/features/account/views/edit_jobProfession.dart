import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/common_search_modal.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features/account/user_profile_api.dart';
import 'package:job/src/features/auth/auth_api.dart';
import 'package:path_provider/path_provider.dart';

class EditJobProfession extends StatefulWidget {
  const EditJobProfession({super.key});

  @override
  State<EditJobProfession> createState() => _EditJobProfessionState();
}

class _EditJobProfessionState extends State<EditJobProfession> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  TextEditingController qulification = TextEditingController();
  TextEditingController specialization = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController month = TextEditingController();

  TextEditingController country = TextEditingController();

  List menu = ["Fresher", "Internship", "Experience"];
  int _sMenu = 0;
  bool isLoading = false;
  bool _mLoading = false;
  bool uploadCv = false;
  bool download_pdf = false;

  var s_cityId = "";
  var s_qulId = "";
  var s_specId = "";
  var s_yr = "";
  var s_m = "";
  var check_years = '';
  var s_countryId;

  File? selectedPdf;
  var file_name = "";
  var selectedPdf_str = "";

  List Qualification = [];
  List Specialisations = [];
  List years = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];

  // void _showModal() async {
  //   final result = await showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SearchModal();
  //     },
  //   );

  //   // Handle the selected value from the modal
  //   if (result != null) {
  //     print(result);
  //     print(result['id']);
  //     setState(() {
  //       s_cityId = result['id'].toString();
  //       location.text = result['district_name'];
  //     });
  //   }
  // }

  void handleBackspace() {
    if (month.text.isNotEmpty) {
      month.text = month.text.substring(0, month.text.length - 1);
    } else {
      month.clear();
    }
  }

  void _showModal(data, type) async {
    // );
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CommonSearchModal(
          data: data,
          type: type,
        );
      },
    );
    if (result != null) {
      print(result);
      print(result['id']);
      setState(() {
        if (type == "qul") {
          qulification.text = result['qualification'] ?? "";
          s_qulId = result['id'].toString();
        }
        if (type == "specification") {
          specialization.text = result['specialise_name'] ?? "";
          s_specId = result['id'].toString();
        }

        if (type == "district") {
          s_cityId = result['id'].toString();
          location.text = result['district_name'];
        }
        if (type == "country") {
          s_countryId = result['id'].toString();
          country.text = result['name'];
        }
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
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // initilize();
    GetDetails();
    super.initState();
  }

  GetDetails() async {
    setState(() {
      _mLoading = true;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var get_details = await UserProfileApi.GetJobProfessionDetails(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);
    print(get_details);

    if (get_details.success) {
      if (get_details.data['status'].toString() == "1") {
        setState(() {
          s_cityId =
              (get_details.data['data']?['current_location_district_id'] ?? "")
                  .toString();
          s_qulId =
              (get_details.data['data']?['qualification_id'] ?? "").toString();
          s_specId =
              (get_details.data['data']?['specialisation_id'] ?? "").toString();
          location.text =
              get_details.data['data']?['is_current_location'] ?? "";
          year.text =
              ((get_details.data['data']?['exp_years'] ?? "").toString()) == "0"
                  ? ""
                  : (get_details.data['data']?['exp_years'] ?? "").toString();
          check_years =
              ((get_details.data['data']?['exp_years'] ?? "").toString()) == "0"
                  ? ""
                  : (get_details.data['data']?['exp_years'] ?? "").toString();
          month.text =
              ((get_details.data['data']?['exp_months'] ?? "").toString()) ==
                      "0"
                  ? ""
                  : (get_details.data['data']?['exp_months'] ?? "").toString();
          // qulification.text =
          //     get_details.data['data']?['is_qualification'] ?? "";
          qulification.text = get_details.data['data']?['is_qualification']
                  ?['qualification'] ??
              "";
          specialization.text =
              get_details.data['data']?['is_specialisation'] ?? "";
          _sMenu = get_details.data['data']['profession_type'].toString() == "1"
              ? 0
              : get_details.data['data']['profession_type'].toString() == "2"
                  ? 1
                  : 2;

          file_name = get_details.data['data']['is_resume'];
          selectedPdf_str = get_details.data['data']['is_resume'];
        });
      }
    }
    setState(() {
      _mLoading = false;
    });
  }

  initilize() async {
    var UserResponse = PrefManager.read("UserResponse");
    var qul_result = await AuthApi.GetQualification(
        context,
        UserResponse['data']['id'],
        "",
        Qualification.length,
        UserResponse['data']['api_token']);
    var spl_result = await AuthApi.GetSpecialisations(context,
        UserResponse['data']['id'], "", UserResponse['data']['api_token']);
    if (qul_result.success) {
      setState(() {
        Qualification.addAll(qul_result.data['data'] ?? []);
      });
    }

    if (spl_result.success) {
      setState(() {
        Specialisations = spl_result.data['data'];
      });
    }
  }

  Future<void> _pickPDF(context) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [
      'pdf',
      // 'jpg',
      // 'jpeg',
      // 'png',
      // 'gif'
    ]
            // Add image file extensions here
            );

    if (result != null) {
      var UserResponse = PrefManager.read("UserResponse");
      setState(() {
        uploadCv = true;
        selectedPdf = File(result.files.single.path!);
        selectedPdf_str = result.files.single.path!;
        file_name = result.files.single.name;
      });

      var data = {
        "user_id": UserResponse['data']['id'],
        "resume": selectedPdf_str
      };

      var upload_result = await UserProfileApi.uploadUserCv(
          context, data, UserResponse['data']['api_token']);

      if (upload_result.success) {
        setState(() {
          uploadCv = false;
        });
      }
    } else {
      // User canceled the file picker.
      print("File picking canceled.");
    }
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    // double ScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(),
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text("Job Profession",
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
      body: !_mLoading
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        GridView.builder(
                            primary: false,
                            padding: const EdgeInsets.only(top: 10.0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: menu.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              // mainAxisSpacing: 10,
                              childAspectRatio: 2.5,
                            ),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              final data = menu[index];
                              return InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    _sMenu = index;
                                  });
                                },
                                child: Container(
                                  color: _sMenu == index
                                      ? AppTheme.primary
                                      : AppTheme.TextFormFieldBac,
                                  child: Center(
                                      child: Text(
                                    data,
                                    style: TextStyle(
                                        color: _sMenu == index
                                            ? Colors.white
                                            : AppTheme.TextBoldLite),
                                  )),
                                ),
                              );
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Professional Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.TextBoldLite),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.only(left: 5.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: AppTheme.TextLite)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_box,
                                color: AppTheme.primary,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(menu[_sMenu])
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Upload CV"),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            _pickPDF(context);
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              // shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image:
                                    AssetImage("assets/images/rectangle.png"),
                              ),
                            ),
                            child: Center(
                                child: Image.asset(
                              "assets/images/upload.png",
                              width: 50,
                            )),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        uploadCv
                            ? const Text("CV Uploading ....")
                            : InkWell(
                                onTap: () async {
                                  // if (!download_pdf) {
                                  //   setState(() {
                                  //     download_pdf = true;
                                  //   });
                                  //   // Snackbar.show("Please wait ....", Colors.black);
                                  //   await createFileOfPdfUrl(selectedPdf_str)
                                  //       .then((f) {
                                  //     Nav.to(
                                  //         context,
                                  //         viewResume(
                                  //           pdfUrl: f.path,
                                  //         ));
                                  //     // setState(() {
                                  //     //   remotePDFpath = f.path;
                                  //     // });
                                  //   });
                                  //   setState(() {
                                  //     download_pdf = false;
                                  //   });
                                  // }
                                },
                                child: file_name.isNotEmpty
                                    ? Container(
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                            color: AppTheme.danger_light,
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                !download_pdf
                                                    // ? file_name
                                                    ? "Updated Resume"
                                                    : "Please wait loading ...",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            // SizedBox(width: 5,),
                                            IconButton(
                                                onPressed: () async {
                                                  var UserResponse =
                                                      PrefManager.read(
                                                          "UserResponse");
                                                  setState(() {
                                                    file_name = "";
                                                  });
                                                  var result =
                                                      await UserProfileApi
                                                          .deleteUserCv(
                                                              context,
                                                              UserResponse[
                                                                  'data']['id'],
                                                              UserResponse[
                                                                      'data'][
                                                                  'api_token']);
                                                  if (result.success) {
                                                    if (result.data['status']
                                                            .toString() ==
                                                        "1") {
                                                      if (result.data[
                                                              'message'] !=
                                                          null) {
                                                        Snackbar.show(
                                                            result.data[
                                                                'message'],
                                                            Colors.green);
                                                      } else {
                                                        Snackbar.show(
                                                            "Some Error",
                                                            Colors.black);
                                                      }
                                                    }
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  color: AppTheme.danger,
                                                ))
                                          ],
                                        ),
                                      )
                                    : const SizedBox(
                                        height: 0,
                                      )),
                        // : const Text("Please waitc loading ...")),
                        const SizedBox(
                          height: 20,
                        ),
                        // _sMenu == 0
                        //     ? Fresher()
                        //     : _sMenu == 1
                        //         ? InternShip()
                        //         : Experience(),
                        uiChnage(),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                            width: ScreenWidth,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (isLoading == false) {
                                    var response =
                                        PrefManager.read("UserResponse");
                                    // if (_sMenu == 0) {
                                    //   if (_formKey1.currentState!.validate()) {
                                    //     var data = {
                                    //       "user_id": response['data']['id'],
                                    //       "profession_type": 1,
                                    //       "qualification_id": 0,
                                    //       "specialisation_id": 0,
                                    //       "exp_years": 0,
                                    //       "exp_months": 0,
                                    //       "current_location_district_id": s_cityId
                                    //     };
                                    //     await update_Profession(
                                    //         data, response['data']['api_token']);
                                    //     print(data);
                                    //   }
                                    // } else if (_sMenu == 1) {
                                    //   if (_formKey2.currentState!.validate()) {
                                    //     var data = {
                                    //       "user_id": response['data']['id'],
                                    //       "profession_type": 2,
                                    //       "qualification_id": s_qulId,
                                    //       "specialisation_id": s_specId,
                                    //       "exp_years": 0,
                                    //       "exp_months": 0,
                                    //       "current_location_district_id": 0
                                    //     };
                                    //     await update_Profession(
                                    //         data, response['data']['api_token']);
                                    //     print(data);
                                    //   }
                                    // } else {
                                    if (_formKey3.currentState!.validate()) {
                                      var data = {
                                        "user_id": response['data']['id'],
                                        "profession_type": _sMenu == 0
                                            ? 1
                                            : _sMenu == 1
                                                ? 2
                                                : 3,
                                        "qualification_id": s_qulId,
                                        "specialisation_id": s_specId,
                                        "exp_years":
                                            year.text.isEmpty ? 0 : year.text,
                                        "exp_months":
                                            month.text.isEmpty ? 0 : month.text,
                                        "current_location_district_id":
                                            s_cityId,
                                      };
                                      await update_Profession(
                                          data, response['data']['api_token']);
                                      print(data);
                                    }
                                    // }
                                  }
                                  // if (isLoading == false) {
                                  //   var response = PrefManager.read("UserResponse");
                                  //   if (_sMenu == 0) {
                                  //     if (_formKey1.currentState!.validate()) {
                                  //       var data = {
                                  //         "user_id": response['data']['id'],
                                  //         "profession_type": 1,
                                  //         "qualification_id": 0,
                                  //         "specialisation_id": 0,
                                  //         "exp_years": 0,
                                  //         "exp_months": 0,
                                  //         "current_location_district_id": s_cityId
                                  //       };
                                  //       await update_Profession(
                                  //           data, response['data']['api_token']);
                                  //       print(data);
                                  //     }
                                  //   } else if (_sMenu == 1) {
                                  //     if (_formKey2.currentState!.validate()) {
                                  //       var data = {
                                  //         "user_id": response['data']['id'],
                                  //         "profession_type": 2,
                                  //         "qualification_id": s_qulId,
                                  //         "specialisation_id": s_specId,
                                  //         "exp_years": 0,
                                  //         "exp_months": 0,
                                  //         "current_location_district_id": 0
                                  //       };
                                  //       await update_Profession(
                                  //           data, response['data']['api_token']);
                                  //       print(data);
                                  //     }
                                  //   } else {
                                  //     if (_formKey3.currentState!.validate()) {
                                  //       var data = {
                                  //         "user_id": response['data']['id'],
                                  //         "profession_type": 3,
                                  //         "qualification_id": 0,
                                  //         "specialisation_id": 0,
                                  //         "exp_years": year.text,
                                  //         "exp_months": month.text.isEmpty ? 0 : month.text,
                                  //         "current_location_district_id": s_cityId
                                  //       };
                                  //       await update_Profession(
                                  //           data, response['data']['api_token']);
                                  //       print(data);
                                  //     }
                                  //   }
                                  // }

                                  // Nav.to(context, const EducationalDetails());
                                },
                                child: !isLoading
                                    ? const Text(
                                        "Update",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Loader.common())),
                      ],
                    ),
                  )
                ],
              ),
            )
          : Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppTheme.primary,
                ),
              ),
            ),
    );
  }

  uiChnage() {
    return Form(
      key: _formKey3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Qualification"),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            readOnly: true,
            controller: qulification,
            onTap: () async {
              print("success");
              _showModal([], "qul");
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
              hintText: 'Qualification',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Specialization",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppTheme.TextBoldLite),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            readOnly: true,
            controller: specialization,
            onTap: () async {
              _showModal([], "specification");
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
          _sMenu == 2
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Total Experience"),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextFormField(
                            controller: year,
                            onTap: () async {},
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please Enter a years';
                            //   }
                            //   return null;
                            // },
                            onChanged: (value) {
                              setState(() {
                                check_years = value;
                              });
                              // if (value.isNotEmpty && int.parse(value) != 0) {
                              //   setState(() {
                              //     month.text = "0";
                              //   });
                              // }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                              // FilteringTextInputFormatter.deny(RegExp('0')),
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                counterText: '',
                                hintText: 'Years',
                                labelText: 'Years',
                                labelStyle: TextStyle(
                                    color: AppTheme.TextBoldLite,
                                    fontSize: 14)),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextFormField(
                            controller: month,
                            onTap: () async {},
                            onChanged: (value) {
                              // if(value.length == 1){
                              //   setState(() {
                              //     month.text = "";
                              //   });
                              // }
                              // handleBackspace();
                            },
                            // validator: (value) {
                            //   if (check_years.isEmpty) {
                            //     return 'Please enter a months';
                            //   }
                            //   return null;
                            // },
                            validator: (value) {
                              if (year.text.isNotEmpty) {
                                return null;
                              } else {
                                if ((value == null || value.isEmpty) &&
                                    year.text.isEmpty) {
                                  return 'Please enter a months';
                                }

                                // Check if the input is a valid number
                                // if (!RegExp(r'^\d{1,2}$').hasMatch(value!)) {
                                //   return 'Please enter a valid number with max 2 digits';
                                // }

                                // Check if the number is within the allowed range (max 12)
                                if (value != null && value.isNotEmpty) {
                                  int intValue = int.parse(value);
                                  if (intValue == 0) {
                                    Snackbar.show(
                                        "Number must be more than one",
                                        Colors.black);
                                    return "Invalid";
                                  }
                                  if (intValue > 12) {
                                    // return 'Number must be less than or equal to 12';
                                    Snackbar.show(
                                        "Number must be less than or equal to 12",
                                        Colors.black);
                                    return "Invalid";
                                  }
                                }

                                return null;
                              } // Validation passed
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                              // MaxValueInputFormatter(12),

                              // FilteringTextInputFormatter.deny(
                              //     RegExp(check_years.isEmpty ? '0' : ''))
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              counterText: '',
                              labelText: 'Months',
                              labelStyle: TextStyle(
                                  color: AppTheme.TextBoldLite, fontSize: 14),
                              hintText: 'Months',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox(
                  height: 0,
                ),
          // const SizedBox(
          //   height: 20,
          // ),
          // const Text("Country"),
          // const SizedBox(
          //   height: 10,
          // ),
          // TextFormField(
          //   readOnly: true,
          //   controller: country,
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please Enter  Country';
          //     }
          //     return null;
          //   },
          //   onTap: () {
          //     print("click");
          //     _showModal([], "country");
          //   },
          //   decoration: const InputDecoration(hintText: "City"),
          // ),
          const SizedBox(
            height: 20,
          ),
          const Text("Job Location"),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            readOnly: true,
            controller: location,
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please Enter  City';
            //   }
            //   return null;
            // },
            onTap: () {
              print("click");
              // _showModal([], "district");
              _showModal([], "district_edit");
            },
            decoration: const InputDecoration(hintText: "City"),
          )
        ],
      ),
    );
  }

  Fresher() {
    return Form(
      key: _formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Location"),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            readOnly: true,
            controller: location,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please Enter a City";
              } else {
                return null;
              }
            },
            onTap: () {
              print("click");
              _showModal([], "district");
            },
            decoration: const InputDecoration(hintText: "City"),
          )
        ],
      ),
    );
  }

  InternShip() {
    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Qualification"),
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
              hintText: 'Qualification',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Specialization",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppTheme.TextBoldLite),
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
        ],
      ),
    );
  }

  Experience() {
    return Form(
      key: _formKey3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total Experience"),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  // readOnly: true,
                  controller: year,
                  onTap: () async {
                    // _modal([], "specification");
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter a years';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
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
                      hintText: 'Years',
                      labelText: 'Years',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.TextBoldLite)
                      // suffixText : 'Years'
                      ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  controller: month,
                  onTap: () async {},
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
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
                    labelText: 'Months',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.TextBoldLite),
                    hintText: 'Months',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Job Location"),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            readOnly: true,
            controller: location,
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please Enter  City';
            //   }
            //   return null;
            // },
            onTap: () {
              print("click");
              _showModal([], "district");
            },
            decoration: const InputDecoration(hintText: "City"),
          )
        ],
      ),
    );
  }

  Future<void> update_Profession(data, token) async {
    setState(() {
      isLoading = true;
    });

    var result = await AuthApi.updateUserProfession(context, data, token);
    if (result.success) {
      if (result.data['status'].toString() == "1") {
        // Snackbar.show("Successfully", Colors.green);
        // Nav.to(context, EducationalDetails());
        Nav.back(context);
        if (result.data['message'] != null) {
          Snackbar.show(result.data['message'], Colors.green);
        } else {
          Snackbar.show("Successfully", Colors.green);
        }
      } else if (result.data['message'] != null) {
        Snackbar.show(result.data['message'], Colors.black);
      } else {
        Snackbar.show("Some Error", Colors.black);
      }
    } else {
      Snackbar.show("Some Error", Colors.red);
    }
    setState(() {
      isLoading = false;
    });
  }
}

class SearchModal extends StatefulWidget {
  @override
  _SearchModalState createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  TextEditingController _searchController = TextEditingController();
  List searchResults = [];

  void _search() async {
    var data = {"state_id": 0, "search": _searchController.text};
    // final response = await http.get(
    //   Uri.parse('https://api.example.com/search?q=${_searchController.text}'),
    // );
    final response = await AuthApi.getCity(context, data);

    if (response.success) {
      setState(() {
        searchResults = response.data['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            onChanged: (value) {
              _search();
            },
            controller: _searchController,
            decoration: InputDecoration(
              // labelText: 'Search',
              hintText: "Search District Name",
              suffixIcon: IconButton(
                onPressed: _search,
                icon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchResults[index]['district_name']),
                  onTap: () {
                    // Return the selected value to the main screen
                    Navigator.of(context).pop(searchResults[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MaxValueInputFormatter extends TextInputFormatter {
  final int maxValue;

  MaxValueInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Parse the entered value as an integer
    try {
      int enteredValue = int.parse(newValue.text);

      // Check if the entered value exceeds the maximum allowed value
      if (enteredValue > maxValue) {
        // If it exceeds, return the old value
        return oldValue;
      }
    } catch (e) {
      // Handle the case where parsing fails (non-integer input)
      // You can add custom error handling here if needed
      return oldValue;
    }

    // If the entered value is valid, allow the update
    return newValue;
  }
}

class viewResume extends StatefulWidget {
  final String pdfUrl;

  const viewResume({super.key, required this.pdfUrl});

  @override
  State<viewResume> createState() => _viewResumeState();
}

class _viewResumeState extends State<viewResume> {
  late int pageNumber = 1;
  late int totalPages = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text(
          "View CV",
          style: const TextStyle(color: AppTheme.white, fontSize: 18),
        ),
        leading: IconButton(
            onPressed: () {
              Nav.back(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme.white,
            )),
      ),
      // appBar: AppBar(
      //   title: Text('PDF Viewer', style: TextStyle(color: Colors.white),),
      // ),
      body: Center(
        child: PDFView(
          filePath: widget.pdfUrl,
          autoSpacing: true,
          pageSnap: true,
          pageFling: true,
          onPageChanged: (page, total) {
            setState(() {
              pageNumber = page!.toInt();
              totalPages = total!.toInt();
            });
          },
          onError: (error) {
            print('PDFView Error: $error');
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Page $pageNumber of $totalPages',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// Future<File> createFileOfPdfUrl(url_str) async {
//   Completer<File> completer = Completer();
//   print("Start download file from internet!");
//   try {
//     final url = url_str;
//     final filename = url.substring(url.lastIndexOf("/") + 1);
//     var request = await HttpClient().getUrl(Uri.parse(url));
//     var response = await request.close();
//     var bytes = await consolidateHttpClientResponseBytes(response);
//     var dir = await getApplicationDocumentsDirectory();
//     print("Download files");
//     print("${dir.path}/$filename");
//     File file = File("${dir.path}/$filename");

//     await file.writeAsBytes(bytes, flush: true);
//     completer.complete(file);
//   } catch (e) {
//     // return url_str;
//     throw Exception('Error parsing asset file!');
//   }

//   return completer.future;
// }

Future<File> createFileOfPdfUrl(String urlOrFilePath) async {
  Completer<File> completer = Completer();
  print("Start processing file!");

  try {
    // Check if the provided string is a URL or a local file path
    Uri uri = Uri.parse(urlOrFilePath);

    if (uri.scheme == '') {
      // Local file path
      var file = File(uri.path);

      if (await file.exists()) {
        print("File already exists locally: ${file.path}");
        completer.complete(file);
      } else {
        return file;
        // Handle the case where the file doesn't exist locally
        // throw Exception('File does not exist locally!');
      }
    } else if (uri.scheme == 'http' || uri.scheme == 'https') {
      // URL
      var request = await HttpClient().getUrl(uri);
      var response = await request.close();

      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        print("Downloaded file from the network");

        // Save the file locally
        var dir = await getApplicationDocumentsDirectory();
        var filename = uri.pathSegments.last;
        File file = File("${dir.path}/$filename");

        await file.writeAsBytes(bytes, flush: true);
        completer.complete(file);
      } else {
        throw Exception(
            'Failed to download file. Status code: ${response.statusCode}');
      }
    } else {
      throw Exception('Invalid URL or file path format!');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Error processing file!');
  }

  return completer.future;
}
