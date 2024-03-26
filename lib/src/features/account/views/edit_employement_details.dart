// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:job/src/core/utils/app_loader.dart';
// import 'package:job/src/core/utils/app_theme.dart';
// import 'package:job/src/core/utils/common_search_modal.dart';
// import 'package:job/src/core/utils/local_storage.dart';
// import 'package:job/src/core/utils/navigation.dart';
// import 'package:job/src/core/utils/snackbar.dart';
// import 'package:job/src/features/account/user_profile_api.dart';
// import 'package:job/src/features/auth/auth_api.dart';

// class EditEmploymentDetails extends StatefulWidget {
//   const EditEmploymentDetails({super.key});

//   @override
//   State<EditEmploymentDetails> createState() => _EditEmploymentDetailsState();
// }

// class _EditEmploymentDetailsState extends State<EditEmploymentDetails> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController designation = TextEditingController();
//   TextEditingController company_name = TextEditingController();
//   TextEditingController start_yr = TextEditingController();
//   TextEditingController start_month = TextEditingController();
//   TextEditingController end_yr = TextEditingController();
//   TextEditingController end_month = TextEditingController();
//   TextEditingController currency = TextEditingController();
//   TextEditingController salary = TextEditingController();
//   TextEditingController notice_period = TextEditingController();

//   late int selectedYear;
//   late List<int> years;
//   bool hideSalary = false;
//   bool isCurrent = false;
//   bool isLoading = false;
//   bool _mLoading = false;
//   var s_startMonth;
//   var s_endMonth;
//   var s_currencyId;
//   var s_noticePeriod;

//   List months = [
//     {"id": "0", "month": "January"},
//     {"id": "1", "month": "February"},
//     {"id": "2", "month": "March"},
//     {"id": "3", "month": "April"},
//     {"id": "4", "month": "May"},
//     {"id": "5", "month": "June"},
//     {"id": "6", "month": "July"},
//     {"id": "7", "month": "August"},
//     {"id": "8", "month": "September"},
//     {"id": "9", "month": "October"},
//     {"id": "10", "month": "November"},
//     {"id": "11", "month": "December"}
//   ];

//   List notice_period_list = [
//     {"id": "0", "month": "0 Month"},
//     {"id": "1", "month": "1 Month"},
//     {"id": "2", "month": "2 Months"},
//     {"id": "3", "month": "3 Months"},
//     {"id": "4", "month": "4 Months"},
//     {"id": "5", "month": "5 Months"},
//     {"id": "6", "month": "6 Months"},
//     {"id": "7", "month": "7 Months"},
//     {"id": "8", "month": "8 Months"},
//     {"id": "9", "month": "9 Months"},
//     {"id": "10", "month": "10 Months"},
//   ];

//   @override
//   void initState() {
//     initilize();
//     super.initState();
//     int currentYear = DateTime.now().year;
//     years = List.generate(51, (index) => currentYear - index);
//   }

//   initilize() async {
//     setState(() {
//       _mLoading = true;
//     });
//     var UserResponse = PrefManager.read("UserResponse");
//     var get_employeDetails = await UserProfileApi.GetUserEmployeDetails(
//         context, UserResponse['data']['id'], UserResponse['data']['api_token']);
//     print(get_employeDetails);

//     if (get_employeDetails.success) {
//       if (get_employeDetails.data['status'].toString() == "1") {
//         setState(() {
//           designation.text =
//               get_employeDetails.data['data']?[0]?['designation'] ?? "";
//           company_name.text =
//               get_employeDetails.data['data']?[0]?['company_name'] ?? "";
//           start_yr.text =
//               (get_employeDetails.data['data']?[0]?['start_year'] ?? "")
//                   .toString();
//           end_yr.text = (get_employeDetails.data['data']?[0]?['end_year'] ?? "")
//               .toString();
//           isCurrent =
//               (get_employeDetails.data['data']?[0]?['is_current'] ?? 0) == 1
//                   ? true
//                   : false;
//           hideSalary =
//               (get_employeDetails.data['data']?[0]?['is_current'] ?? 0) == 1
//                   ? true
//                   : false;
//           salary.text =
//               (get_employeDetails.data['data']?[0]?['salary_annual'] ?? "")
//                   .toString();
//           currency.text =
//               get_employeDetails.data['data']?[0]?['is_salary_currency'] ?? "";
//           s_noticePeriod =
//               (get_employeDetails.data['data']?[0]?['notice_months'] ?? "")
//                   .toString();
//           s_currencyId =
//               (get_employeDetails.data['data']?[0]?['salary_currency_id'] ?? "")
//                   .toString();
//           // designation.text =
//           //     get_employeDetails.data['data']?[0]?['designation'] ?? "";
//           // designation.text =
//           //     get_employeDetails.data['data']?[0]?['designation'] ?? "";
//           // designation.text =
//           //     get_employeDetails.data['data']?[0]?['designation'] ?? "";
//           if (get_employeDetails.data['data']?[0]?['start_month'] != null) {
//             start_month.text = getMonthById(
//                 months, get_employeDetails.data['data']?[0]?['start_month']);
//             s_startMonth =
//                 (get_employeDetails.data['data']?[0]?['start_month'] ?? "")
//                     .toString();
//           }
//           if (get_employeDetails.data['data']?[0]?['end_month'] != null) {
//             end_month.text = getMonthById(
//                 months, get_employeDetails.data['data']?[0]?['end_month']);
//             s_endMonth =
//                 (get_employeDetails.data['data']?[0]?['end_month'] ?? "")
//                     .toString();
//           }
//           if (get_employeDetails.data['data']?[0]?['notice_months'] != null) {
//             notice_period.text = getMonthById(notice_period_list,
//                 get_employeDetails.data['data']?[0]?['notice_months']);
//           }
//         });
//       }
//     }
//      setState(() {
//       _mLoading = false;
//     });
//   }

//   //   if (resultMonth != null) {
//   //   print("Month for ID $inputId: ${resultMonth['month']}");
//   // } else {
//   //   print("Invalid ID: $inputId");
//   // }
// // }

//   getMonthById(months, id) {
//     var result;
//     for (Map<String, String> month in months) {
//       if (month['id'] == id.toString()) {
//         result = month;
//         break;
//       }
//     }
//     return result['month'];
//   }

//   void _showModal(data, type) async {
//     final result = await showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return CommonSearchModal(
//           data: data,
//           type: type,
//         );
//       },
//     );

//     if (result != null) {
//       setState(() {
//         if (type == "start_year") {
//           start_yr.text = result.toString();
//         } else if (type == "start_month") {
//           start_month.text = result['month'];
//           s_startMonth = result['id'];
//         } else if (type == "end_year") {
//           end_yr.text = result.toString();
//         } else if (type == "end_month") {
//           end_month.text = result['month'];
//           s_endMonth = result['id'];
//         } else if (type == "currency") {
//           currency.text = result['currency'];
//           s_currencyId = result['id'];
//         } else if (type == "notice_period") {
//           notice_period.text = result['month'];
//           s_noticePeriod = result['id'];
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double ScreenWidth = MediaQuery.of(context).size.width;
//     // double ScreenHeight = MediaQuery.of(context).size.height;
//     return WillPopScope(
//       onWillPop: () async {
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           iconTheme: IconThemeData(),
//           automaticallyImplyLeading: false,
//           backgroundColor: AppTheme.primary,
//           title: const Text("Employment Details",
//               style: TextStyle(color: AppTheme.white, fontSize: 18)),
//           leading: IconButton(
//               onPressed: () {
//                 Nav.back(context);
//               },
//               icon: const Icon(
//                 Icons.arrow_back_ios_new,
//                 color: AppTheme.white,
//               )),
//         ),
//         body:
//         !_mLoading ?
//          SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Container(
//                 //   width: ScreenWidth,
//                 //   height: ScreenHeight * 0.3,
//                 //   padding: const EdgeInsets.all(30.0),
//                 //   decoration: BoxDecoration(
//                 //       color: AppTheme.primary,
//                 //       borderRadius: const BorderRadius.only(
//                 //           bottomLeft: Radius.circular(25.0),
//                 //           bottomRight: Radius.circular(25.0))),
//                 //   child: Center(
//                 //     child: SizedBox(
//                 //       child: Image.asset("assets/images/logo_light.png"),
//                 //     ),
//                 //   ),
//                 // ),
//                 Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Current Designation",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: AppTheme.TextBoldLite),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       TextFormField(
//                         controller: designation,
//                         onTap: () async {
//                           print("success");
//                           // _modal([], "qul");
//                         },
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter current designation';
//                           }
//                           return null;
//                         },
//                         decoration: const InputDecoration(
//                           counterText: '',
//                           hintText: 'Current Designation',
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         "Company Name",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: AppTheme.TextBoldLite),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       TextFormField(
//                         // readOnly: true,
//                         controller: company_name,
//                         onTap: () async {
//                           print("success");
//                           // _modal([], "qul");
//                         },
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter company name';
//                           }
//                           return null;
//                         },
//                         decoration: const InputDecoration(
//                           counterText: '',
//                           hintText: 'Company Name',
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         "Start Date",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: AppTheme.TextBoldLite),
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.45,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             child: TextFormField(
//                               readOnly: true,
//                               controller: start_yr,
//                               onTap: () async {
//                                 // _modal([], "specification");
//                                 _showModal(years, "start_year");
//                               },
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please select years';
//                                 }
//                                 return null;
//                               },
//                               // keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                   counterText: '',
//                                   suffixIcon: SizedBox(
//                                       width: 15,
//                                       height: 15,
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(17.0),
//                                         child: Image.asset(
//                                           "assets/icons/down.png",
//                                           fit: BoxFit.contain,
//                                         ),
//                                       )),
//                                   hintText: 'Years',
//                                   labelText: 'Years',
//                                   labelStyle: TextStyle(
//                                       color: AppTheme.TextBoldLite,
//                                       fontSize: 14)
//                                   // suffixText : 'Years'
//                                   ),
//                             ),
//                           ),
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.45,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             child: TextFormField(
//                               readOnly: true,
//                               controller: start_month,
//                               onTap: () async {
//                                 _showModal(months, "start_month");
//                               },
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please select month';
//                                 }
//                                 return null;
//                               },
//                               // keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                 counterText: '',
//                                 suffixIcon: SizedBox(
//                                     width: 15,
//                                     height: 15,
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(17.0),
//                                       child: Image.asset(
//                                         "assets/icons/down.png",
//                                         fit: BoxFit.contain,
//                                       ),
//                                     )),
//                                 labelText: 'Month',
//                                 labelStyle: TextStyle(
//                                     color: AppTheme.TextBoldLite, fontSize: 14),
//                                 hintText: 'Month',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         "End Date",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: AppTheme.TextBoldLite),
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.45,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             child: TextFormField(
//                               readOnly: true,
//                               controller: end_yr,
//                               onTap: () async {
//                                 // _modal([], "specification");
//                                 _showModal(years, "end_year");
//                               },
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please select years';
//                                 }
//                                 return null;
//                               },
//                               // keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                   counterText: '',
//                                   suffixIcon: SizedBox(
//                                       width: 15,
//                                       height: 15,
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(17.0),
//                                         child: Image.asset(
//                                           "assets/icons/down.png",
//                                           fit: BoxFit.contain,
//                                         ),
//                                       )),
//                                   hintText: 'Years',
//                                   labelText: 'Years',
//                                   labelStyle: TextStyle(
//                                       color: AppTheme.TextBoldLite,
//                                       fontSize: 14)
//                                   // suffixText : 'Years'
//                                   ),
//                             ),
//                           ),
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.45,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             child: TextFormField(
//                               readOnly: true,
//                               controller: end_month,
//                               onTap: () async {
//                                 _showModal(months, "end_month");
//                               },
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please select month';
//                                 }
//                                 return null;
//                               },
//                               // keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                 counterText: '',
//                                 suffixIcon: SizedBox(
//                                     width: 15,
//                                     height: 15,
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(17.0),
//                                       child: Image.asset(
//                                         "assets/icons/down.png",
//                                         fit: BoxFit.contain,
//                                       ),
//                                     )),
//                                 labelText: 'Month',
//                                 labelStyle: TextStyle(
//                                     color: AppTheme.TextBoldLite, fontSize: 14),
//                                 hintText: 'Month',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         "Current Salary(Annual)",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: AppTheme.TextBoldLite),
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.30,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             child: TextFormField(
//                               readOnly: true,
//                               controller: currency,
//                               onTap: () async {
//                                 // _modal([], "specification");
//                                 _showModal([], "currency");
//                               },
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please Select Currency';
//                                 }
//                                 return null;
//                               },
//                               // inputFormatters: [
//                               //   FilteringTextInputFormatter.digitsOnly,
//                               //   LengthLimitingTextInputFormatter(2),
//                               // ],
//                               // keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                   counterText: '',
//                                   suffixIcon: SizedBox(
//                                       width: 15,
//                                       height: 15,
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(17.0),
//                                         child: Image.asset(
//                                           "assets/icons/down.png",
//                                           fit: BoxFit.contain,
//                                         ),
//                                       )),
//                                   hintText: 'Currency',
//                                   labelText: 'Currency',
//                                   labelStyle: TextStyle(
//                                       color: AppTheme.TextBoldLite,
//                                       fontSize: 14)
//                                   // suffixText : 'Years'
//                                   ),
//                             ),
//                           ),
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.60,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             child: TextFormField(
//                               controller: salary,
//                               onTap: () async {},
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter salary';
//                                 }
//                                 return null;
//                               },
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.digitsOnly,
//                                 // LengthLimitingTextInputFormatter(2),
//                               ],
//                               keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                 counterText: '',
//                                 labelText: 'Salary',
//                                 labelStyle: TextStyle(
//                                     color: AppTheme.TextBoldLite, fontSize: 14),
//                                 hintText: 'Salary',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         "Notice Period",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: AppTheme.TextBoldLite),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       TextFormField(
//                         readOnly: true,
//                         controller: notice_period,
//                         onTap: () async {
//                           // _modal([], "specification");
//                           _showModal(notice_period_list, "notice_period");
//                         },
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please select notice period';
//                           }
//                           return null;
//                         },

//                         // inputFormatters: [
//                         //   FilteringTextInputFormatter.digitsOnly,
//                         //   LengthLimitingTextInputFormatter(2),
//                         // ],
//                         // keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                             counterText: '',
//                             suffixIcon: SizedBox(
//                                 width: 15,
//                                 height: 15,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(17.0),
//                                   child: Image.asset(
//                                     "assets/icons/down.png",
//                                     fit: BoxFit.contain,
//                                   ),
//                                 )),
//                             hintText: 'Notice Period',
//                             // labelText: 'Currency',
//                             labelStyle: TextStyle(
//                                 color: AppTheme.TextBoldLite, fontSize: 14)
//                             // suffixText : 'Years'
//                             ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         children: [
//                           Checkbox(
//                             value: isCurrent,
//                             onChanged: (value) {
//                               setState(() {
//                                 isCurrent = value!;
//                               });
//                             },
//                           ),
//                           Expanded(
//                             child: RichText(
//                               text: TextSpan(
//                                 children: [
//                                   const TextSpan(
//                                     text: '',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.blue,
//                                         fontSize: 14),
//                                     // recognizer: TapGestureRecognizer()
//                                     //   ..onTap = () {
//                                     //     Nav.to(context, const TermsConditions());
//                                     // Navigate to a new page or perform any action here
//                                     // print(
//                                     //     'Navigate to Terms and Conditions page');
//                                     // Add your navigation logic here
//                                     // },
//                                   ),
//                                   TextSpan(
//                                       text: 'Currently working here',
//                                       style: TextStyle(
//                                           color: AppTheme.TextBoldLite,
//                                           fontSize: 14,
//                                           height: 1.3)),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Checkbox(
//                             value: hideSalary,
//                             onChanged: (value) {
//                               setState(() {
//                                 hideSalary = value!;
//                               });
//                             },
//                           ),
//                           Expanded(
//                             child: RichText(
//                               text: TextSpan(
//                                 children: [
//                                   const TextSpan(
//                                     text: '',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.blue,
//                                         fontSize: 14),
//                                     // recognizer: TapGestureRecognizer()
//                                     //   ..onTap = () {
//                                     //     Nav.to(context, const TermsConditions());
//                                     // Navigate to a new page or perform any action here
//                                     // print(
//                                     //     'Navigate to Terms and Conditions page');
//                                     // Add your navigation logic here
//                                     // },
//                                   ),
//                                   TextSpan(
//                                       text:
//                                           'Hide my salary from potential employers',
//                                       style: TextStyle(
//                                           color: AppTheme.TextBoldLite,
//                                           fontSize: 14,
//                                           height: 1.3)),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       SizedBox(
//                           width: ScreenWidth,
//                           child: ElevatedButton(
//                               onPressed: () async {
//                                 if (isLoading == false) {
//                                   if (_formKey.currentState!.validate()) {
//                                     // Retrieve the selected start and end dates
//                                     DateTime startDate = DateTime(
//                                         int.parse(start_yr.text),
//                                         int.parse(s_startMonth));
//                                     DateTime endDate = DateTime(
//                                         int.parse(end_yr.text),
//                                         int.parse(s_endMonth));

//                                     // Check if the start date is earlier than the end date
//                                     if (startDate.isAfter(endDate)) {
//                                       // Show an error message or handle the invalid case as needed
//                                       // print(
//                                       //     'Error: Start date must be earlier than end date');
//                                       Snackbar.show(
//                                           "Start date must be earlier than end date",
//                                           Colors.black);
//                                     } else {
//                                       setState(() {
//                                         isLoading = true;
//                                       });
//                                       var UserResponse =
//                                           PrefManager.read("UserResponse");
//                                       var data = {
//                                         "user_id": UserResponse['data']['id'],
//                                         "company_name": company_name.text,
//                                         "designation": designation.text,
//                                         "start_month": s_startMonth,
//                                         "start_year": start_yr.text,
//                                         "end_month": s_endMonth,
//                                         "end_year": end_yr.text,
//                                         "is_current": isCurrent ? 1 : 0,
//                                         "salary_currency_id": s_currencyId,
//                                         "salary_annual": salary.text,
//                                         "is_hide_salary": hideSalary ? 1 : 0,
//                                         "notice_months": s_noticePeriod,
//                                         // "employment_id": 2
//                                       };
//                                       print(data);

//                                       var result =
//                                           await AuthApi.UpdateUserEmployement(
//                                               context,
//                                               data,
//                                               UserResponse['data']
//                                                   ['api_token']);
//                                       print(result);
//                                       if (result.success) {
//                                         if (result.data['status'].toString() ==
//                                             "1") {
//                                           // Nav.offAll(
//                                           //     context,
//                                           //     Dashboard(
//                                           //       current_index: 0,
//                                           //     ));
//                                           // print(result.data);
//                                           if (result.data['message'] != null) {
//                                             Snackbar.show(
//                                                 result.data['message'],
//                                                 Colors.green);
//                                           } else {
//                                             Snackbar.show(
//                                                 "Successfully", Colors.green);
//                                           }
//                                         } else if (result.data['message'] !=
//                                             null) {
//                                           Snackbar.show(result.data['message'],
//                                               Colors.black);
//                                         } else {
//                                           Snackbar.show(
//                                               "Some Error", Colors.black);
//                                         }
//                                       } else {
//                                         Snackbar.show(
//                                             "Some Error", Colors.black);
//                                       }

//                                       setState(() {
//                                         isLoading = false;
//                                       });
//                                     }
//                                   }
//                                 } else {
//                                   print('Form is invalid');
//                                 }
//                               },
//                               child: !isLoading
//                                   ? const Text("Continue")
//                                   : Loader.common())),
//                       const SizedBox(
//                         height: 30,
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         )
//         : Center(
//               child: SizedBox(
//                 height: 30,
//                 width: 30,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 3,
//                   color: AppTheme.primary,
//                 ),
//               ),
//             ),
//       ),
//     );
//   }
// }
