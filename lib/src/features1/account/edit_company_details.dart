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

class EditCompnayDetails extends StatefulWidget {
  const EditCompnayDetails({super.key});

  @override
  State<EditCompnayDetails> createState() => _EditCompnayDetailsState();
}

class _EditCompnayDetailsState extends State<EditCompnayDetails> {
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
  List typeOfOrg = [];
  List KycDoc = [];
  File? selectedPdf;
  File? _logoFile;
  var selectedPdf_str = "";
  var _logo_str = "";
  var file_name = "";
  var logo_name = "";
  bool isloading = false;

  //  <kalai>
  Map? loadedCompanyDetail;
  String? previousOrganisationType;
  bool centerLoader = false;
  // </kalai>

  var typeOfOrgnisation;
  var KycDocments;

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
          if (loadedCompanyDetail!['is_company_logo'] != null) {
            loadedCompanyDetail?['is_company_logo'] = null;
          }
          _logoFile = File(result.files.single.path!);
          _logo_str = result.files.single.path!;
          logo_name = result.files.single.name;
        });
      }
    } else {
      // User canceled the file picker.

      print("File picking canceled.");
    }
  }

  // <kalai>
  initilize() async {
    setState(() {
      centerLoader = true;
    });
    await _getOrganisationType();
    await _getKYCdocType();
    await _getCompanyDetail();
    print('------> $KycDoc');
    // var UserResponse = PrefManager.read("UserResponse");
    // var result = await AuthApi.GetOrganisationType(
    //     context, UserResponse['data']['id'], UserResponse['data']['api_token']);
    // var result1 = await AuthApi.GetKycDocType(
    //     context, UserResponse['data']['id'], UserResponse['data']['api_token']);

    // print(result.data);
    // print(result1);

    // if (result.success) {
    //   setState(() {
    //     typeOfOrg = result.data['data'];
    //   });
    //   print(typeOfOrg);
    // }
    // if (result1.success) {
    //   setState(() {
    //     KycDoc = result1.data['data'];
    //   });
    // }
  }

  _getOrganisationType() async {
    var UserResponse = PrefManager.read("UserResponse");
    var result = await AuthApi.GetOrganisationType(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);
    if (result.success) {
      setState(() {
        typeOfOrg = result.data['data'];
      });
      print(typeOfOrg);
    }
  }

  _getKYCdocType() async {
    var UserResponse = PrefManager.read("UserResponse");
    var result1 = await AuthApi.GetKycDocType(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);

    if (result1.success) {
      setState(() {
        KycDoc = result1.data['data'];
      });
    }
  }

  Future<void> _getCompanyDetail() async {
    setState(() {
      centerLoader = true;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var result = await AuthApi.getCompanyDetails(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);

    print(result.data['data']['companydetails']);

    if (result.success) {
      if (result.data['data']?['companydetails'].length != 0) {
        setState(() {
          loadedCompanyDetail = result.data['data']?['companydetails'][0] ?? {};
          emailId.text = loadedCompanyDetail!['registered_email'] ?? '';
          company_name.text = loadedCompanyDetail!['company_name'] ?? '';
          designation.text = loadedCompanyDetail!['current_designation'] ?? '';
          mobileno.text =
              (loadedCompanyDetail!['mobile_number'] ?? '').toString();
          lan_code.text = loadedCompanyDetail!['landline_code'] ?? '';
          lan_num.text = loadedCompanyDetail!['landline_number'] ?? '';
          // previousOrganisationType = typeOfOrg
          //     .firstWhere((element) =>
          //         element['id'] ==
          //         loadedCompanyDetail![
          //             'organisation_type_id'])['organisation_type_name']
          //     .toString();
          typeOfOrgnisation = loadedCompanyDetail?['is_organisation_type'];
          KycDocments = loadedCompanyDetail?['is_kycdoc_type'];
          // is_kycdoc_type
          // KycDocments =
          file_name = loadedCompanyDetail!['kyc_document'] ?? '';

          gst_num.text = loadedCompanyDetail!['gst_number'] ?? '';
          adhar_card.text = loadedCompanyDetail!['adhar_number'] ?? '';
          pan_card.text = loadedCompanyDetail!['pan_number'] ?? '';
          employee_size.text = loadedCompanyDetail!['employee_size'] ?? '';
          // _logo_str = loadedCompanyDetail!['is_company_logo'] ?? '';
          // selectedPdf_str = loadedCompanyDetail?['is_kyc_document'] ?? "";
          s_typeOrg =
              (loadedCompanyDetail?['organisation_type_id'] ?? "").toString();
          s_kyc_Doc = (loadedCompanyDetail?['kycdoc_type_id'] ?? "").toString();
          centerLoader = false;
        });
      }

      print(loadedCompanyDetail);
    }

    setState(() {
      centerLoader = false;
    });
  } // </kalai>

  void _removeLogo() {
    setState(() {
      if (loadedCompanyDetail!['is_company_logo'] != null) {
        loadedCompanyDetail!['is_company_logo'] = null;
      }
      _logoFile = null;
    });
  }

  @override
  void initState() {
    initilize();
    super.initState();
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
        title: const Text("Edit Company Details",
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
      body: //<kalai>
          centerLoader
              ? Center(
                  child: SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ) //   < /kalai>
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                maxLength: 10,
                                readOnly: true,
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
                                    hint: typeOfOrgnisation != null &&
                                            typeOfOrgnisation != ""
                                        ? Text(
                                            typeOfOrgnisation,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          )
                                        : Text(
                                            'Type of Organisation',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                    icon: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: AppTheme.TextBoldLite,
                                        size: 25,
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                    items: typeOfOrg
                                        .map<DropdownMenuItem<String>>((item) {
                                      return DropdownMenuItem(
                                        value: item['id'].toString(),
                                        child: Text(
                                            item['organisation_type_name'] ??
                                                ""),
                                      );
                                    }).toList(),
                                  )),
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: Colors.white,
                              //     borderRadius: BorderRadius.circular(10.0),
                              //   ),
                              //   //<kalai>
                              //   child: DropdownButtonFormField<String>(
                              //       // value: previousOrganisationType ?? '',
                              //       hint: const Text(
                              //         'Type of Organisation',
                              //         style: TextStyle(fontSize: 14),
                              //       ),
                              //       icon: Padding(
                              //         padding:
                              //             const EdgeInsets.only(right: 10.0),
                              //         child: Icon(
                              //           Icons.keyboard_arrow_down,
                              //           color: AppTheme.TextBoldLite,
                              //           size: 25,
                              //         ),
                              //       ),
                              //       decoration: InputDecoration(
                              //         enabledBorder: OutlineInputBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(10),
                              //             borderSide: BorderSide.none),
                              //         focusedBorder: OutlineInputBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(10),
                              //             borderSide: BorderSide.none),
                              //         border: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(10),
                              //         ),
                              //       ),
                              //       onChanged: (String? value) {
                              //         setState(() {
                              //           s_typeOrg = value ?? '';
                              //         });
                              //       },
                              //       items: typeOfOrg
                              //           .map<DropdownMenuItem<String>>(
                              //               (dynamic item) {
                              //             return DropdownMenuItem<String>(
                              //               value:
                              //                   item['organisation_type_name']
                              //                           as String? ??
                              //                       "",
                              //               child: Text(
                              //                   item['organisation_type_name']
                              //                           as String? ??
                              //                       ""),
                              //             );
                              //           })
                              //           .toSet()
                              //           .toList()),
                              // ), //  </kalai>

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
                                    hint:
                                        KycDocments != null && KycDocments != ""
                                            ? Text(
                                                KycDocments,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              )
                                            : const Text(
                                                'Kyc Documents',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                    icon: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: AppTheme.TextBoldLite,
                                        size: 25,
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                    items: KycDoc.map<DropdownMenuItem<String>>(
                                        (item) {
                                      return DropdownMenuItem(
                                        value: item['id'].toString(),
                                        child: SizedBox(
                                            width: ScreenWidth * 0.75,
                                            child: Text(
                                                item['kycdoc_type_name'] ??
                                                    "")),
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
                                      image: AssetImage(
                                          "assets/images/rectangle.png"),
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
                                    loadedCompanyDetail?['is_company_logo'] !=
                                            null
                                        ? Container(
                                            width: 80,
                                            height: 80,
                                            margin: const EdgeInsets.only(
                                                top: 15, right: 15),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                    loadedCompanyDetail![
                                                        'is_company_logo'],
                                                  ),
                                                )),
                                            child: const Center(),
                                          )
                                        : Container(
                                            width: 80,
                                            height: 80,
                                            margin: const EdgeInsets.only(
                                                top: 15, right: 15),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              image: _logoFile != null
                                                  ? DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image:
                                                          FileImage(_logoFile!),
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
                                    if (_logoFile != null ||
                                        loadedCompanyDetail?[
                                                'is_company_logo'] !=
                                            null)
                                      Positioned(
                                        top: -12,
                                        right: -12,
                                        child: IconButton(
                                            icon: const Icon(
                                              Icons.cancel_outlined,
                                              color: Colors.red,
                                            ),
                                            onPressed: _removeLogo),
                                      ),
                                  ],
                                ),
                              ),

                              //<kalai>
                              // loadedCompanyDetail!['is_company_logo'] != null
                              //     ? loadedCompanyDetail!['is_company_logo']
                              //                 .endsWith('.png') ||
                              //             loadedCompanyDetail![
                              //                     'is_company_logo']
                              //                 .endsWith('.jpg') ||
                              //             loadedCompanyDetail![
                              //                     'is_company_logo']
                              //                 .endsWith('.jpeg') ||
                              //             loadedCompanyDetail![
                              //                     'is_company_logo']
                              //                 .endsWith('.gif')
                              //         ? Padding(
                              //             padding:
                              //                 const EdgeInsets.only(top: 15),
                              //             child: Image.network(
                              //               loadedCompanyDetail![
                              //                   'is_company_logo'],
                              //               height: 80,
                              //               width: 80,
                              //             ),
                              //           )
                              //         : Text(loadedCompanyDetail![
                              //             'is_company_logo'])
                              //     : const SizedBox(
                              //         height: 0,
                              //       ), //  </kalai>

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
                                  hintText:
                                      'Enter Employee Size (Example 5-100)',
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              SizedBox(
                                  width: ScreenWidth,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        print(emailId.text);
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

                                          if (_formKey.currentState!
                                              .validate()) {
                                            var UserResponse = PrefManager.read(
                                                "UserResponse");
                                            var data = {
                                              "user_id": UserResponse['data']
                                                  ['id'],
                                              "company_name": company_name.text,
                                              "current_designation":
                                                  designation.text,
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
                                              "employee_size":
                                                  employee_size.text,
                                              "company_logo": _logo_str
                                            };
                                            print(data);

                                            var result = await AuthApi
                                                .updateCompanyProfile(
                                                    context,
                                                    data,
                                                    UserResponse['data']
                                                        ['api_token']);
                                            print(result.data);

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
                                                  Snackbar.show("Successfully",
                                                      Colors.green);
                                                }
                                                PrefManager.write(
                                                    "company_status",
                                                    result
                                                        .data['company_status']
                                                        .toString());
                                                PrefManager.write(
                                                    "update_profile1",
                                                    result.data['data']);
                                                Nav.back(context);
                                                print(result.data);
                                              } else if (result
                                                      .data['message'] !=
                                                  null) {
                                                Snackbar.show(
                                                    result.data['message'],
                                                    Colors.black);
                                              } else {
                                                Snackbar.show(
                                                    "Some Error", Colors.red);
                                              }
                                            } else {
                                              Snackbar.show(
                                                  "Some Error", Colors.red);
                                            }
                                          }
                                          setState(() {
                                            isloading = false;
                                          });
                                        }

                                        // Nav.to(context, const UpdateProfile2());
                                      },
                                      child: !isloading
                                          ? Text("Update")
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
