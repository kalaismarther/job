// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/common_search_modal.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features/account/user_profile_api.dart';
import 'package:job/src/features/auth/auth_api.dart';
import 'package:job/src/features/auth/views/educational_details.dart';

class ProffesionalDetails extends StatefulWidget {
  // const ProffesionalDetails({super.key});
  const ProffesionalDetails({Key? key}) : super(key: key);

  @override
  State<ProffesionalDetails> createState() => _ProffesionalDetailsState();
}

class _ProffesionalDetailsState extends State<ProffesionalDetails> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final _formKey3 = GlobalKey<FormState>();

  TextEditingController year = TextEditingController();
  TextEditingController month = TextEditingController();

  List menu = ["Fresher", "Internship", "Experience"];
  int _sMenu = 0;
  bool isLoading = false;
  bool uploadCv = false;
  bool download_pdf = false;

  var s_cityId = "";
  var s_qulId = "";
  var s_specId = "";
  var s_yr = "";
  var s_m = "";
  var check_years = "";

  File? selectedPdf;
  var file_name = "";
  var selectedPdf_str = "";

  TextEditingController location = TextEditingController();
  TextEditingController qulification = TextEditingController();
  TextEditingController specialization = TextEditingController();

  List Qualification = [];
  List Specialisations = [];
  List years = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];

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

  void _showModal(data, type) async {
    // final result = await showModalBottomSheet(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return SearchModal();
    //   },
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

    // district

    // Handle the selected value from the modal
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
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // initilize();
    super.initState();
  }

  // initilize() async {
  //   var UserResponse = PrefManager.read("UserResponse");
  //   var qul_result = await AuthApi.GetQualification(
  //       context, UserResponse['data']['id'], "", UserResponse['data']['api_token']);
  //   var spl_result = await AuthApi.GetSpecialisations(
  //       context, UserResponse['data']['id'], "", UserResponse['data']['api_token']);
  //   if (qul_result.success) {
  //     setState(() {
  //       Qualification = qul_result.data['data'];
  //     });
  //   }

  //   if (spl_result.success) {
  //     setState(() {
  //       Specialisations = spl_result.data['data'];
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    double ScreenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ScreenWidth,
                height: ScreenHeight * 0.3,
                // padding: const EdgeInsets.all(30.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25.0),
                        bottomRight: Radius.circular(25.0))),
                child: Center(
                  child: SizedBox(
                    child: Image.asset("assets/images/logo_light.png"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Update Profile",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
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
                          border:
                              Border.all(width: 2, color: AppTheme.TextLite)),
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
                            image: AssetImage("assets/images/rectangle.png"),
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
                                                ? file_name
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
                                              var result = await UserProfileApi
                                                  .deleteUserCv(
                                                      context,
                                                      UserResponse['data']
                                                          ['id'],
                                                      UserResponse['data']
                                                          ['api_token']);
                                              if (result.success) {
                                                if (result.data['status']
                                                        .toString() ==
                                                    "1") {
                                                  if (result.data['message'] !=
                                                      null) {
                                                    Snackbar.show(
                                                        result.data['message'],
                                                        Colors.green);
                                                  } else {
                                                    Snackbar.show("Some Error",
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
                    const SizedBox(
                      height: 20,
                    ),
                    // uploadCv ? Text("CV Uploading ....") : Text(file_name),
                    // SizedBox(
                    //   height: 20,
                    // ),
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
                                var response = PrefManager.read("UserResponse");
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
                                    "current_location_district_id": s_cityId
                                  };
                                  await update_Profession(
                                      data, response['data']['api_token']);
                                  print(data);
                                }
                                // }
                              }

                              // Nav.to(context, const EducationalDetails());
                            },
                            child: !isLoading
                                ? const Text(
                                    "Continue",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : Loader.common())),
                  ],
                ),
              )
            ],
          ),
        ),
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
          // Container(
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     child: DropdownButtonFormField(
          //       hint: const Text(
          //         'City',
          //         style: TextStyle(fontSize: 14),
          //       ),
          //       icon: Padding(
          //         padding: const EdgeInsets.only(right: 10.0),
          //         child: Icon(
          //           Icons.keyboard_arrow_down,
          //           color: AppTheme.TextBoldLite,
          //           size: 25,
          //         ),
          //       ),
          //       decoration: InputDecoration(
          //         enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(10),
          //             borderSide: BorderSide.none),
          //         focusedBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(10),
          //             borderSide: BorderSide.none),
          //         // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         //  filled: true,
          //         //  fillColor: Colors.greenAccent,
          //       ),
          //       onChanged: (value) {},
          //       items: ['Salem', 'Chennai', 'Perumpakkam']
          //           .map<DropdownMenuItem<String>>((item) {
          //         return DropdownMenuItem(
          //           value: item,
          //           child: Text(item),
          //         );
          //       }).toList(),
          //     )),
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
          // Container(
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     child: DropdownButtonFormField(
          //       hint: const Text(
          //         'Enter Qualification',
          //         style: TextStyle(fontSize: 14),
          //       ),
          //       validator: (value) {
          //         if (value == null || value.isEmpty) {
          //           return 'Please select Qualification';
          //         }
          //         return null;
          //       },
          //       icon: Padding(
          //         padding: const EdgeInsets.only(right: 10.0),
          //         child: Icon(
          //           Icons.keyboard_arrow_down,
          //           color: AppTheme.TextBoldLite,
          //           size: 25,
          //         ),
          //       ),
          //       decoration: InputDecoration(
          //         enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(10),
          //             borderSide: BorderSide.none),
          //         focusedBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(10),
          //             borderSide: BorderSide.none),
          //         // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         //  filled: true,
          //         //  fillColor: Colors.greenAccent,
          //       ),
          //       onChanged: (value) {
          //         setState(() {
          //           s_qulId = value.toString();
          //         });
          //       },
          //       items: Qualification.map<DropdownMenuItem<String>>((item) {
          //         return DropdownMenuItem(
          //           value: item['id'].toString(),
          //           child: Text(item['qualification']),
          //         );
          //       }).toList(),
          //     )),
          // const SizedBox(
          //   height: 20,
          // ),
          // const Text("Course"),
          // const SizedBox(
          //   height: 10,
          // ),
          // Container(
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     child: DropdownButtonFormField(
          //       hint: const Text(
          //         'Select Course',
          //         style: TextStyle(fontSize: 14),
          //       ),
          //       validator: (value) {
          //         if (value == null || value.isEmpty) {
          //           return 'Please Select Course';
          //         }
          //         return null;
          //       },
          //       icon: Padding(
          //         padding: const EdgeInsets.only(right: 10.0),
          //         child: Icon(
          //           Icons.keyboard_arrow_down,
          //           color: AppTheme.TextBoldLite,
          //           size: 25,
          //         ),
          //       ),
          //       decoration: InputDecoration(
          //         enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(10),
          //             borderSide: BorderSide.none),
          //         focusedBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(10),
          //             borderSide: BorderSide.none),
          //         // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         //  filled: true,
          //         //  fillColor: Colors.greenAccent,
          //       ),
          //       onChanged: (value) {
          //         setState(() {
          //           s_specId = value.toString();
          //         });
          //       },
          //       items: Specialisations.map<DropdownMenuItem<String>>((item) {
          //         return DropdownMenuItem(
          //           value: item['id'].toString(),
          //           child: Text(item['specialise_name']),
          //         );
          //       }).toList(),
          //     )),
        ],
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Container(
                    //       width: MediaQuery.of(context).size.width * 0.45,
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(10.0),
                    //       ),
                    //       child: TextFormField(
                    //         controller: year,
                    //         onTap: () async {},
                    //         // validator: (value) {
                    //         //   if (value == null || value.isEmpty) {
                    //         //     return 'Please Enter a years';
                    //         //   }
                    //         //   return null;
                    //         // },
                    //         onChanged: (value) {
                    //           setState(() {
                    //             check_years = value;
                    //           });
                    //         },
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.digitsOnly,
                    //           LengthLimitingTextInputFormatter(2),
                    //           FilteringTextInputFormatter.deny(RegExp('0')),
                    //         ],
                    //         keyboardType: TextInputType.number,
                    //         decoration: InputDecoration(
                    //             counterText: '',
                    //             hintText: 'Years',
                    //             labelText: 'Years',
                    //             labelStyle: TextStyle(
                    //                 color: AppTheme.TextBoldLite,
                    //                 fontSize: 14)),
                    //       ),
                    //     ),
                    //     Container(
                    //       width: MediaQuery.of(context).size.width * 0.45,
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(10.0),
                    //       ),
                    //       child: TextFormField(
                    //         controller: month,
                    //         onTap: () async {},
                    //         validator: (value) {
                    //           if (check_years.isEmpty) {
                    //             return 'Please enter a months';
                    //           }
                    //           return null;
                    //         },
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.digitsOnly,
                    //           LengthLimitingTextInputFormatter(2),
                    //           MaxValueInputFormatter(12),
                    //           FilteringTextInputFormatter.deny(
                    //               RegExp(check_years.isEmpty ? '0' : ''))
                    //         ],
                    //         keyboardType: TextInputType.number,
                    //         decoration: InputDecoration(
                    //           counterText: '',
                    //           labelText: 'Months',
                    //           labelStyle: TextStyle(
                    //               color: AppTheme.TextBoldLite, fontSize: 14),
                    //           hintText: 'Months',
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter  City';
              }
              return null;
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

  Experience() {
    return Form(
      key: _formKey3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text("Current Designation"),
          // const SizedBox(
          //   height: 10,
          // ),
          // Container(
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     child: DropdownButtonFormField(
          //       hint: const Text(
          //         'Enter Designation',
          //         style: TextStyle(fontSize: 14),
          //       ),
          //       icon: Padding(
          //         padding: const EdgeInsets.only(right: 10.0),
          //         child: Icon(
          //           Icons.keyboard_arrow_down,
          //           color: AppTheme.TextBoldLite,
          //           size: 25,
          //         ),
          //       ),
          //       decoration: InputDecoration(
          //         enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(10),
          //             borderSide: BorderSide.none),
          //         focusedBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(10),
          //             borderSide: BorderSide.none),
          //         // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         //  filled: true,
          //         //  fillColor: Colors.greenAccent,
          //       ),
          //       onChanged: (value) {},
          //       items: ['Salem', 'Chennai', 'Perumpakkam']
          //           .map<DropdownMenuItem<String>>((item) {
          //         return DropdownMenuItem(
          //           value: item,
          //           child: Text(item),
          //         );
          //       }).toList(),
          //     )),
          // const SizedBox(
          //   height: 20,
          // ),
          // const Text("Company"),
          // const SizedBox(
          //   height: 10,
          // ),
          // Container(
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     child: DropdownButtonFormField(
          //       hint: const Text(
          //         'Enter Company',
          //         style: TextStyle(fontSize: 14),
          //       ),
          //       icon: Padding(
          //         padding: const EdgeInsets.only(right: 10.0),
          //         child: Icon(
          //           Icons.keyboard_arrow_down,
          //           color: AppTheme.TextBoldLite,
          //           size: 25,
          //         ),
          //       ),
          //       decoration: InputDecoration(
          //         enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(10),
          //             borderSide: BorderSide.none),
          //         focusedBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(10),
          //             borderSide: BorderSide.none),
          //         // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         //  filled: true,
          //         //  fillColor: Colors.greenAccent,
          //       ),
          //       onChanged: (value) {},
          //       items: ['Salem', 'Chennai', 'Perumpakkam']
          //           .map<DropdownMenuItem<String>>((item) {
          //         return DropdownMenuItem(
          //           value: item,
          //           child: Text(item),
          //         );
          //       }).toList(),
          //     )),
          // const SizedBox(
          //   height: 20,
          // ),
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
                      labelStyle:
                          TextStyle(color: AppTheme.TextBoldLite, fontSize: 14)
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
                    labelStyle:
                        TextStyle(color: AppTheme.TextBoldLite, fontSize: 14),
                    hintText: 'Months',
                  ),
                ),
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Container(
          //         width: MediaQuery.of(context).size.width * 0.45,
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(10.0),
          //         ),
          //         child: DropdownButtonFormField(
          //           hint: const Text(
          //             'Years',
          //             style: TextStyle(fontSize: 14),
          //           ),
          //           validator: (value) {
          //             if (value == null || value.isEmpty) {
          //               return 'Please select Year';
          //             }
          //             return null;
          //           },
          //           icon: Padding(
          //             padding: const EdgeInsets.only(right: 10.0),
          //             child: Icon(
          //               Icons.keyboard_arrow_down,
          //               color: AppTheme.TextBoldLite,
          //               size: 25,
          //             ),
          //           ),
          //           decoration: InputDecoration(
          //             enabledBorder: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(10),
          //                 borderSide: BorderSide.none),
          //             focusedBorder: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(10),
          //                 borderSide: BorderSide.none),
          //             // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(10),
          //             ),
          //             //  filled: true,
          //             //  fillColor: Colors.greenAccent,
          //           ),
          //           onChanged: (value) {
          //             setState(() {
          //               s_yr = value.toString();
          //             });
          //           },
          //           items: years.map<DropdownMenuItem<String>>((item) {
          //             return DropdownMenuItem(
          //               value: item,
          //               child: Text("${item} Years"),
          //             );
          //           }).toList(),
          //         )),
          //     Container(
          //         width: MediaQuery.of(context).size.width * 0.45,
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(10.0),
          //         ),
          //         child: DropdownButtonFormField(
          //           hint: const Text(
          //             'Months',
          //             style: TextStyle(fontSize: 14),
          //           ),
          //           validator: (value) {
          //             if (value == null || value.isEmpty) {
          //               return 'Please select Month';
          //             }
          //             return null;
          //           },
          //           icon: Padding(
          //             padding: const EdgeInsets.only(right: 10.0),
          //             child: Icon(
          //               Icons.keyboard_arrow_down,
          //               color: AppTheme.TextBoldLite,
          //               size: 25,
          //             ),
          //           ),
          //           decoration: InputDecoration(
          //             enabledBorder: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(10),
          //                 borderSide: BorderSide.none),
          //             focusedBorder: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(10),
          //                 borderSide: BorderSide.none),
          //             // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(10),
          //             ),
          //             //  filled: true,
          //             //  fillColor: Colors.greenAccent,
          //           ),
          //           onChanged: (value) {
          //             setState(() {
          //               s_m = value.toString();
          //             });
          //           },
          //           items: years.map<DropdownMenuItem<String>>((item) {
          //             return DropdownMenuItem(
          //               value: item,
          //               child: Text("${item} Months"),
          //             );
          //           }).toList(),
          //         )),
          //   ],
          // ),
          const SizedBox(
            height: 20,
          ),
          const Text("Job Location"),
          const SizedBox(
            height: 10,
          ),
          // Container(
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     child: DropdownButtonFormField(
          //       hint: const Text(
          //         'Enter Location',
          //         style: TextStyle(fontSize: 14),
          //       ),
          //       icon: Padding(
          //         padding: const EdgeInsets.only(right: 10.0),
          //         child: Icon(
          //           Icons.keyboard_arrow_down,
          //           color: AppTheme.TextBoldLite,
          //           size: 25,
          //         ),
          //       ),
          //       decoration: InputDecoration(
          //         enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(10),
          //             borderSide: BorderSide.none),
          //         focusedBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(10),
          //             borderSide: BorderSide.none),
          //         // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         //  filled: true,
          //         //  fillColor: Colors.greenAccent,
          //       ),
          //       onChanged: (value) {},
          //       items: ['Salem', 'Chennai', 'Perumpakkam']
          //           .map<DropdownMenuItem<String>>((item) {
          //         return DropdownMenuItem(
          //           value: item,
          //           child: Text(item),
          //         );
          //       }).toList(),
          //     )),
          TextFormField(
            readOnly: true,
            controller: location,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter  City';
              }
              return null;
            },
            onTap: () {
              print("click");
              // _showModal([], "district");
              _showModal([], "district_edit");
            },
            decoration: const InputDecoration(hintText: "City"),
          )
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     // controller: searchController,
          //     onChanged: (value) {
          //       // filterSearchResults(value);
          //     },
          //     decoration: InputDecoration(
          //       hintText: 'Search...',
          //     ),
          //   ),
          // ),
          // Container(
          //   width: 100,
          //   child: DropdownButton<String>(
          //     // value: selectedValue,
          //     onChanged: (newValue) {
          //       setState(() {
          //         // selectedValue = newValue;
          //       });
          //     },
          //     items: filteredItems.map((String item) {
          //       return DropdownMenuItem<String>(
          //         value: item,
          //         child: Text(item),
          //       );
          //     }).toList(),
          //   ),
          // ),
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
        Snackbar.show("Successfully", Colors.green);
        Nav.to(context, EducationalDetails());
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
          const SizedBox(height: 20),
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
