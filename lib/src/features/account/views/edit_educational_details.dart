// // ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unused_local_variable

// import 'package:flutter/material.dart';
// import 'package:job/src/core/utils/app_loader.dart';
// import 'package:job/src/core/utils/app_theme.dart';
// import 'package:job/src/core/utils/common_search_modal.dart';
// import 'package:job/src/core/utils/local_storage.dart';
// import 'package:job/src/core/utils/navigation.dart';
// import 'package:job/src/core/utils/snackbar.dart';
// import 'package:job/src/features/account/user_profile_api.dart';
// import 'package:job/src/features/auth/auth_api.dart';

// class EditEducationalDetails extends StatefulWidget {
//   const EditEducationalDetails({super.key});

//   @override
//   State<EditEducationalDetails> createState() => _EditEducationalDetailsState();
// }

// class _EditEducationalDetailsState extends State<EditEducationalDetails> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController qulification = TextEditingController();
//   TextEditingController specialization = TextEditingController();
//   TextEditingController university = TextEditingController();
//   TextEditingController year = TextEditingController();

//   String EducationType = '';
//   bool isLoading = false;
//   bool _mLoading = false;
//   var s_qulId = "";
//   var s_specId = "";
//   var s_uniName = "";
//   var s_yr = "";
//   var educationId;

//   List Qualification = [];
//   List Specialisations = [];
//   List University = [];
//   List years = [];

//   @override
//   void initState() {
//     // TODO: implement initState
//     // initilize();
//     GetDetails();
//     super.initState();
//   }

//   GetDetails() async {
//     setState(() {
//       _mLoading = true;
//     });
//     var UserResponse = PrefManager.read("UserResponse");

//     var get_edu = await UserProfileApi.GetEducationalDetails(
//         context, UserResponse['data']['id'], UserResponse['data']['api_token']);

//     print(get_edu);
//     if (get_edu.success) {
//       if (get_edu.data['status'].toString() == "1") {
//         setState(() {
//           qulification.text = get_edu.data['data']?[0]?['is_qualification']
//                   ?['qualification'] ??
//               "";
//           specialization.text =
//               get_edu.data['data']?[0]?['is_specialisation'] ?? "";
//           university.text = get_edu.data['data']?[0]?['institute_name'];
//           year.text = (get_edu.data['data']?[0]?['year_of_graduation'] ?? "")
//               .toString();
//           EducationType =
//               (get_edu.data['data']?[0]?['education_type'] ?? "").toString();
//           s_qulId =
//               (get_edu.data['data']?[0]?['qualification_id'] ?? "").toString();
//           s_specId =
//               (get_edu.data['data']?[0]?['specialisation_id'] ?? "").toString();
//           educationId = get_edu.data['data']?[0]?['id'].toString();
//         });
//       }
//     }
//     setState(() {
//       _mLoading = false;
//     });
//   }

//   // initilize() async {
//   //   var UserResponse = PrefManager.read("UserResponse");
//   //   var qul_result = await AuthApi.GetQualification(
//   //       context, UserResponse['data']['id'], UserResponse['data']['api_token']);
//   //   var spl_result = await AuthApi.GetSpecialisations(
//   //       context, UserResponse['data']['id'], UserResponse['data']['api_token']);
//   //   var uni_result = await AuthApi.GetIndustried(
//   //       context, UserResponse['data']['id'], UserResponse['data']['api_token']);
//   //   var yr_result = await AuthApi.GetYears(
//   //       context, UserResponse['data']['id'], UserResponse['data']['api_token']);

//   //   if (qul_result.success) {
//   //     setState(() {
//   //       Qualification = qul_result.data['data'];
//   //     });
//   //   }

//   //   if (spl_result.success) {
//   //     setState(() {
//   //       Specialisations = spl_result.data['data'];
//   //     });
//   //   }
//   //   if (uni_result.success) {
//   //     setState(() {
//   //       University = uni_result.data['data'];
//   //     });
//   //   }
//   //   if (yr_result.success) {
//   //     setState(() {
//   //       years = yr_result.data['data'];
//   //     });
//   //   }
//   // }

//   void _modal(data, type) async {
//     final result = await showModalBottomSheet(
//         context: context,
//         builder: (BuildContext context) {
//           return CommonSearchModal(data: data, type: type);
//         });
//     if (result != null) {
//       setState(() {
//         if (type == "qul") {
//           qulification.text = result['qualification'] ?? "";
//           s_qulId = result['id'].toString();
//         }
//         if (type == "specification") {
//           specialization.text = result['specialise_name'] ?? "";
//           s_specId = result['id'].toString();
//         }
//         if (type == "year") {
//           year.text = (result['year'] ?? "").toString();
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double ScreenWidth = MediaQuery.of(context).size.width;
//     // double ScreenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         iconTheme: IconThemeData(),
//         automaticallyImplyLeading: false,
//         backgroundColor: AppTheme.primary,
//         title: const Text("Educational Details",
//             style: TextStyle(color: AppTheme.white, fontSize: 18)),
//         leading: IconButton(
//             onPressed: () {
//               Nav.back(context);
//             },
//             icon: const Icon(
//               Icons.arrow_back_ios_new,
//               color: AppTheme.white,
//             )),
//       ),
//       body: !_mLoading
//           ? SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Text(
//                             "Highest Qualification",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: AppTheme.TextBoldLite),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           TextFormField(
//                             readOnly: true,
//                             controller: qulification,
//                             onTap: () async {
//                               print("success");
//                               _modal([], "qul");
//                             },
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please Select Qualification';
//                               }
//                               return null;
//                             },
//                             decoration: InputDecoration(
//                               counterText: '',
//                               suffixIcon: SizedBox(
//                                   width: 15,
//                                   height: 15,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(17.0),
//                                     child: Image.asset(
//                                       "assets/icons/down.png",
//                                       fit: BoxFit.contain,
//                                     ),
//                                   )),
//                               hintText: 'Highest Qualification',
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Text(
//                             "Specialization/Major",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: AppTheme.TextBoldLite),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           TextFormField(
//                             readOnly: true,
//                             controller: specialization,
//                             onTap: () async {
//                               _modal([], "specification");
//                             },
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please Select Specialization';
//                               }
//                               return null;
//                             },
//                             decoration: InputDecoration(
//                               counterText: '',
//                               suffixIcon: SizedBox(
//                                   width: 15,
//                                   height: 15,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(17.0),
//                                     child: Image.asset(
//                                       "assets/icons/down.png",
//                                       fit: BoxFit.contain,
//                                     ),
//                                   )),
//                               hintText: 'Specialization',
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Text(
//                             "University/Institute",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: AppTheme.TextBoldLite),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           TextFormField(
//                             // readOnly: true,
//                             controller: university,
//                             onTap: () async {},
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please Enter a University/Institute';
//                               }
//                               return null;
//                             },
//                             decoration: InputDecoration(
//                               counterText: '',
//                               suffixIcon: SizedBox(
//                                   width: 15,
//                                   height: 15,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(17.0),
//                                     child: Image.asset(
//                                       "assets/icons/down.png",
//                                       fit: BoxFit.contain,
//                                     ),
//                                   )),
//                               hintText: 'University/Institute',
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Text(
//                             "Years of Graduation",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: AppTheme.TextBoldLite),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           TextFormField(
//                             readOnly: true,
//                             controller: year,
//                             onTap: () async {
//                               _modal([], "year");
//                             },
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please Select Year';
//                               }
//                               return null;
//                             },
//                             decoration: InputDecoration(
//                               counterText: '',
//                               suffixIcon: SizedBox(
//                                   width: 15,
//                                   height: 15,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(17.0),
//                                     child: Image.asset(
//                                       "assets/icons/down.png",
//                                       fit: BoxFit.contain,
//                                     ),
//                                   )),
//                               hintText: 'Year',
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Text(
//                             "Education Type",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: AppTheme.TextBoldLite),
//                           ),
//                           Row(
//                             // mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Radio(
//                                 value: '1',
//                                 groupValue: EducationType,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     EducationType = value.toString();
//                                   });
//                                 },
//                               ),
//                               const Text(
//                                 'Full Time',
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                               Radio(
//                                 value: '2',
//                                 groupValue: EducationType,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     EducationType = value.toString();
//                                   });
//                                 },
//                               ),
//                               const Text('Part Time',
//                                   style: TextStyle(fontSize: 12)),
//                               Radio(
//                                 value: '3',
//                                 groupValue: EducationType,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     EducationType = value.toString();
//                                   });
//                                 },
//                               ),
//                               const Flexible(
//                                   child: Text('Correspondence',
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(fontSize: 12))),
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 30,
//                           ),
//                           SizedBox(
//                               width: ScreenWidth,
//                               child: ElevatedButton(
//                                   onPressed: () async {
//                                     var UserResponse =
//                                         PrefManager.read("UserResponse");
//                                     if (isLoading == false) {
//                                       setState(() {
//                                         isLoading = true;
//                                       });
//                                       if (_formKey.currentState!.validate()) {
//                                         if (EducationType == "") {
//                                           Snackbar.show(
//                                               "Please Select Education Type",
//                                               Colors.black);
//                                         } else {
//                                           var data = {
//                                             "user_id": UserResponse['data']
//                                                 ['id'],
//                                             "qualification_id": s_qulId,
//                                             "specialisation_id": s_specId,
//                                             "institute_name": university.text,
//                                             "year_of_graduation": year.text,
//                                             "education_type": EducationType,
//                                             "education_id": educationId
//                                           };
//                                           print(data);
//                                           var result =
//                                               await AuthApi.updateUserEducation(
//                                                   context,
//                                                   data,
//                                                   UserResponse['data']
//                                                       ['api_token']);
//                                           if (result.success) {
//                                             if (result.data['status']
//                                                     .toString() ==
//                                                 "1") {
//                                               Snackbar.show(
//                                                   "Update Successfully",
//                                                   Colors.green);
//                                               // Nav.to(context, JobPreference());
//                                             } else if (result.data['message'] !=
//                                                 null) {
//                                               Snackbar.show(
//                                                   result.data['message'],
//                                                   Colors.black);
//                                             } else {
//                                               Snackbar.show(
//                                                   "Some Error", Colors.black);
//                                             }
//                                           } else {
//                                             Snackbar.show(
//                                                 "Some Error", Colors.red);
//                                           }
//                                           print(data);
//                                         }
//                                       }
//                                       setState(() {
//                                         isLoading = false;
//                                       });
//                                     }

//                                     // Nav.to(context, const JobPreference());
//                                   },
//                                   child: !isLoading
//                                       ? Text("Update")
//                                       : Loader.common())),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           : Center(
//               child: SizedBox(
//                 height: 30,
//                 width: 30,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 3,
//                   color: AppTheme.primary,
//                 ),
//               ),
//             ),
//     );
//   }
// }
