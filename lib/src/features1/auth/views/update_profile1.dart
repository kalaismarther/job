// ignore_for_file: non_constant_identifier_names, unused_field

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/core/utils/validate.dart';
import 'package:job/src/features/auth/auth_api.dart';
import 'package:job/src/features1/auth/views/update_profile2.dart';

class UpdateProfile1 extends StatefulWidget {
  const UpdateProfile1({
    super.key,
  });

  @override
  State<UpdateProfile1> createState() => _UpdateProfile1State();
}

class _UpdateProfile1State extends State<UpdateProfile1> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController company_name = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController mobileno = TextEditingController();
  TextEditingController lan_code = TextEditingController();
  TextEditingController lan_num = TextEditingController();
  TextEditingController emailId = TextEditingController();
  TextEditingController gst_num = TextEditingController();
  TextEditingController adhar_card = TextEditingController();
  TextEditingController pan_card = TextEditingController();
  TextEditingController employee_size = TextEditingController();

  var s_typeOrg = "";
  var s_kyc_Doc = "";
  late File SelectedPdf;
  List TypeOfOrg = [];
  List KycDoc = [];
  File? selectedPdf;
  File? _logoFile;
  var selectedPdf_str = "";
  var _logo_str = "";
  var file_name = "";
  var logo_name = "";
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    initilize();
    super.initState();
  }

  Future<void> _pickPDF(context, type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: type == "kyc"
          ? [
              'pdf',
              // 'jpg',
              // 'jpeg',
              // 'png',
              // 'gif'
            ]
          : [
              'pdf',
              'jpg',
              'jpeg',
              'png',
              'gif'
            ], // Add image file extensions here
    );

    if (result != null) {
      if (type == "kyc") {
        setState(() {
          selectedPdf = File(result.files.single.path!);
          selectedPdf_str = result.files.single.path!;
          file_name = result.files.single.name;
        });
      } else {
        setState(() {
          _logoFile = File(result.files.single.path!);
          _logo_str = result.files.single.path!;
          logo_name = result.files.single.name;
        });
      }

      // Display the selected file name in a SnackBar.
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Selected file: ${result.files.single.name}'),
      //   ),
      // );
    } else {
      // User canceled the file picker.
      print("File picking canceled.");
    }
  }

  // Future<void> _pickPDF(context, type) async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //   );

  //   if (result != null) {

  //     if(type == "kyc"){
  //       setState(() {
  //       selectedPdf = File(result.files.single.path!);
  //       selectedPdf_str = result.files.single.path!;
  //       file_name = result.files.single.name;
  //       });
  //     } else {
  //       _logoFile = File(result.files.single.path!);
  //       _logo_str = result.files.single.path!;
  //       logo_name = result.files.single.name;
  //     }

  //     // Display the selected file name in a SnackBar.
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(
  //     //     content: Text('Selected PDF file: ${result.files.single.name}'),
  //     //   ),
  //     // );
  //   } else {
  //     // User canceled the file picker.
  //     print("File picking canceled.");
  //   }
  // }

  initilize() async {
    var UserResponse = PrefManager.read("UserResponse");
    var get_c_signup = PrefManager.read("c_signup");
    setState(() {
      mobileno.text = get_c_signup['mobileno'];
      emailId.text = get_c_signup['emailId'];
    });
    var result = await AuthApi.GetOrganisationType(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);
    var result1 = await AuthApi.GetKycDocType(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);

    print(result);
    print(result1);

    if (result.success) {
      setState(() {
        TypeOfOrg = result.data['data'];
      });
    }
    if (result1.success) {
      setState(() {
        KycDoc = result1.data['data'];
      });
    }
  }

  void _removeLogo() {
    setState(() {
      _logoFile = null;
    });
  }

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
          child: Form(
            key: _formKey,
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
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Update Profile",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          InkWell(
                            onTap: () {
                              Nav.to(context, UpdateProfile2());
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 2, bottom: 2, right: 6, left: 6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: AppTheme.primary),
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Company / Freelancer details / Institutions",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Company Name / Freelancer"),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        // maxLength: 10,
                        controller: company_name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Company Name';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Image.asset(
                          //     "assets/icons/email.png",
                          //     height: 20,
                          //     width: 20,
                          //   ),
                          // ),
                          hintText: 'Company Name',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Current Designation"),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        // maxLength: 10,
                        controller: designation,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Desgnation';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Image.asset(
                          //     "assets/icons/email.png",
                          //     height: 20,
                          //     width: 20,
                          //   ),
                          // ),
                          hintText: 'Enter Designation',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Mobile Number"),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: mobileno,
                        readOnly: true,
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Mobile Number';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Image.asset(
                          //     "assets/icons/email.png",
                          //     height: 20,
                          //     width: 20,
                          //   ),
                          // ),
                          hintText: 'Enter Mobile Number',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Landline Code"),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLength: 6,
                        controller: lan_code,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Landline Code';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Image.asset(
                          //     "assets/icons/email.png",
                          //     height: 20,
                          //     width: 20,
                          //   ),
                          // ),
                          hintText: 'Enter Landline Code',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Landline Number"),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLength: 10,
                        controller: lan_num,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Landline Number';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Image.asset(
                          //     "assets/icons/email.png",
                          //     height: 20,
                          //     width: 20,
                          //   ),
                          // ),
                          hintText: 'Enter Landline Number',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Register Mail id"),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        // maxLength: 10,
                        readOnly: true,
                        controller: emailId,
                        validator: Validate.email,
                        decoration: const InputDecoration(
                          counterText: '',
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Image.asset(
                          //     "assets/icons/email.png",
                          //     height: 20,
                          //     width: 20,
                          //   ),
                          // ),
                          hintText: 'Enter mail id',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Type of Organisation"),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: DropdownButtonFormField(
                            hint: const Text(
                              'Type of Organisation',
                              style: TextStyle(fontSize: 14),
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: AppTheme.TextBoldLite,
                                size: 25,
                              ),
                            ),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              //  filled: true,
                              //  fillColor: Colors.greenAccent,
                            ),
                            onChanged: (value) {
                              setState(() {
                                s_typeOrg = value.toString();
                              });
                            },
                            items:
                                TypeOfOrg.map<DropdownMenuItem<String>>((item) {
                              return DropdownMenuItem(
                                value: item['id'].toString(),
                                child:
                                    Text(item['organisation_type_name'] ?? ""),
                              );
                            }).toList(),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Kyc Documents"),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: DropdownButtonFormField(
                            hint: const Text(
                              'Kyc Documents',
                              style: TextStyle(fontSize: 14),
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: AppTheme.TextBoldLite,
                                size: 25,
                              ),
                            ),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              //  filled: true,
                              //  fillColor: Colors.greenAccent,
                            ),
                            onChanged: (value) {
                              setState(() {
                                s_kyc_Doc = value.toString();
                              });
                            },
                            items: KycDoc.map<DropdownMenuItem<String>>((item) {
                              return DropdownMenuItem(
                                value: item['id'].toString(),
                                child: SizedBox(
                                    width: ScreenWidth * 0.75,
                                    child:
                                        Text(item['kycdoc_type_name'] ?? "")),
                              );
                            }).toList(),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Kyc Documents"),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          _pickPDF(context, "kyc");
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
                      Text(file_name),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Company Logo"),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          _pickPDF(context, "logo");
                        },
                        child: Stack(
                          // alignment: Alignment.topRight,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              margin: EdgeInsets.only(top: 15, right: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: _logoFile != null
                                    ? DecorationImage(
                                        fit: BoxFit.fill,
                                        image: FileImage(_logoFile!),
                                      )
                                    : const DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            "assets/images/rectangle.png"),
                                      ),
                              ),
                              child: Center(
                                child: _logoFile != null
                                    ? null
                                    : Image.asset(
                                        "assets/images/upload.png",
                                        width: 50,
                                      ),
                              ),
                            ),
                            // Add a button to remove the selected logo
                            if (_logoFile != null)
                              Positioned(
                                top: -12,
                                right: -12,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                    ),
                                    onPressed: _removeLogo),
                              ),
                          ],
                        ),
                      ),
                      // InkWell(
                      //   splashColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   onTap: () {
                      //     _pickPDF(context, "");
                      //   },
                      //   child: Container(
                      //     width: 80,
                      //     height: 80,
                      //     decoration: const BoxDecoration(
                      //       color: Colors.white,
                      //       // shape: BoxShape.circle,
                      //       image: DecorationImage(
                      //         fit: BoxFit.fill,
                      //         image: AssetImage("assets/images/rectangle.png"),
                      //       ),
                      //     ),
                      //     child: Center(
                      //         child: Image.asset(
                      //       "assets/images/upload.png",
                      //       width: 50,
                      //     )),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Text(logo_name),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("GST Number "),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        // maxLength: 10,
                        controller: gst_num,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter GST Number';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Image.asset(
                          //     "assets/icons/email.png",
                          //     height: 20,
                          //     width: 20,
                          //   ),
                          // ),
                          hintText: 'Enter GST Number',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Aadhar Card Number"),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLength: 12,
                        keyboardType: TextInputType.number,
                        controller: adhar_card,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Aadhar Card Number';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Image.asset(
                          //     "assets/icons/email.png",
                          //     height: 20,
                          //     width: 20,
                          //   ),
                          // ),
                          hintText: 'Enter Aadhar Card Number',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Pan Card Number "),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        // maxLength: 10,
                        controller: pan_card,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Pan Card Number';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Image.asset(a
                          //     "assets/icons/email.png",
                          //     height: 20,
                          //     width: 20,
                          //   ),
                          // ),
                          hintText: 'Enter Pan Card Number',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Employee Size "),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        // maxLength: 10,
                        controller: employee_size,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Employee size';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Image.asset(a
                          //     "assets/icons/email.png",
                          //     height: 20,
                          //     width: 20,
                          //   ),
                          // ),
                          hintText: 'Enter Employee Size (Example 5-100)',
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                          width: ScreenWidth,
                          child: ElevatedButton(
                              onPressed: () async {
                                // if (_formKey.currentState!.validate()) {
                                //   var data = {
                                //     "email": email.text,
                                //     "password": mobileno.text,
                                //     "fcm_token": "fcm_token",
                                //     "device_id": "deviceid",
                                //     "device_type": "IOS"
                                //   };
                                //   print(data);
                                // } else {
                                //   // Form is invalid, do something accordingly
                                //   print('Form is invalid');
                                // }

                                if (isloading == false) {
                                  setState(() {
                                    isloading = true;
                                  });

                                  if (_formKey.currentState!.validate()) {
                                    var UserResponse =
                                        PrefManager.read("UserResponse");
                                    var data = {
                                      "user_id": UserResponse['data']['id'],
                                      "company_name": company_name.text,
                                      "current_designation": designation.text,
                                      "mobile_number": mobileno.text,
                                      "registered_email": emailId.text,
                                      "landline_code": lan_code.text,
                                      "landline_number": lan_num.text,
                                      "organisation_type_id": s_typeOrg,
                                      "kycdoc_type_id": s_kyc_Doc,
                                      "kyc_document": selectedPdf_str,
                                      "gst_number": gst_num.text,
                                      "pan_number": pan_card.text,
                                      "adhar_number": adhar_card.text,
                                      "employee_size": employee_size.text,
                                      "company_logo": _logo_str
                                    };
                                    print(data);
                                    var result =
                                        await AuthApi.updateCompanyProfile(
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
                                          Snackbar.show(
                                              "Successfully", Colors.green);
                                        }
                                        PrefManager.write("update_profile1",
                                            result.data['data']);
                                        Nav.to(context, UpdateProfile2());
                                        print(result.data);
                                      } else if (result.data['message'] !=
                                          null) {
                                        Snackbar.show(result.data['message'],
                                            Colors.black);
                                      } else {
                                        Snackbar.show("Some Error", Colors.red);
                                      }
                                    } else {
                                      Snackbar.show("Some Error", Colors.red);
                                    }
                                  }
                                  setState(() {
                                    isloading = false;
                                  });
                                }

                                // Nav.to(context, const UpdateProfile2());
                              },
                              child: !isloading
                                  ? Text("Continue")
                                  : Loader.common())),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
