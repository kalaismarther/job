import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:job/app.dart';
import 'package:job/firebase_options.dart';
import 'package:job/src/core/utils/network.dart';
import 'package:job/src/core/utils/notification_service.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  //Path for database
  var document = await path_provider.getApplicationDocumentsDirectory();
  // Log(document.path);

  //Database initializtion
  Hive.init(document.path);

  //Opening the database box
  await Hive.openBox("LOCAL_STORAGE");

  runApp(const App());

  // network check
  DependencyInjection.init();
}

// import 'package:flutter/material.dart';

// class Filter {
//   final String filterName;
//   final List<Map<String, dynamic>> filterValues;
//   final String filterKey;

//   Filter({
//     required this.filterName,
//     required this.filterValues,
//     required this.filterKey,
//   });
// }

// class FilterSelectionScreen extends StatefulWidget {
//   @override
//   _FilterSelectionScreenState createState() => _FilterSelectionScreenState();
// }

// class _FilterSelectionScreenState extends State<FilterSelectionScreen> {
//   List<Filter> filters = [
//     // Populate your filters here
//     Filter(
//       filterName: "Work mode",
//       filterValues: [
//         {"id": 1, "name": "Full time"},
//         {"id": 2, "name": "Part time"},
//         {"id": 3, "name": "Remote"},
//         {"id": 4, "name": "Internship"},
//         {"id": 6, "name": "WFH"},
//       ],
//       filterKey: "work_mode",
//     ),
//     Filter(
//       filterName: "Role Category",
//       filterValues: [
//         {"id": 2, "name": "CEO"},
//         {"id": 3, "name": "Sr. Project Manager"},
//         {"id": 8, "name": "Programmer"},
//       ],
//       filterKey: "job_level_id",
//     ),
//     Filter(
//       filterName: "Departments",
//       filterValues: [
//         {"id": 1, "name": "Advertising / Entertainment / Media"},
//         {"id": 2, "name": "Banking / Insurance / Financial Services"},
//         {"id": 3, "name": "IT Services"},
//       ],
//       filterKey: "department_id",
//     ),
//     Filter(
//       filterName: "Education",
//       filterValues: [
//         {"id": 1, "name": "BE"},
//         {"id": 2, "name": "MCA"},
//         {"id": 3, "name": "MBA"},
//         {"id": 4, "name": "M-Tech"},
//       ],
//       filterKey: "education_id",
//     ),
//   ];

//   Map<String, List<int>> selectedFilters = {}; // Initialize with an empty map

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Filter Selection'),
//       ),
//       body: ListView.builder(
//         itemCount: filters.length,
//         itemBuilder: (context, index) {
//           return ExpansionTile(
//             title: Text(filters[index].filterName),
//             children: [
//               Wrap(
//                 children: filters[index].filterValues.map((filterValue) {
//                   return InkWell(
//                     onTap: () {
//                       setState(() {
//                         if (selectedFilters
//                             .containsKey(filters[index].filterKey)) {
//                           if (selectedFilters[filters[index].filterKey]!
//                               .contains(filterValue["id"])) {
//                             selectedFilters[filters[index].filterKey]!
//                                 .remove(filterValue["id"]);
//                           } else {
//                             selectedFilters[filters[index].filterKey]!
//                                 .add(filterValue["id"]);
//                           }
//                         } else {
//                           selectedFilters[filters[index].filterKey] = [
//                             filterValue["id"]
//                           ];
//                         }
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Chip(
//                         label: Text(filterValue["name"]),
//                         backgroundColor:
//                             (selectedFilters[filters[index].filterKey] ?? [])
//                                     .contains(filterValue["id"])
//                                 ? Colors.blue
//                                 : null,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Perform some action with the selected filters
//           print(selectedFilters);
//         },
//         child: Icon(Icons.check),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: FilterSelectionScreen(),
//   ));
// }

// import 'package:flutter/material.dart';

// class FilterSelectionScreen extends StatefulWidget {
//   @override
//   _FilterSelectionScreenState createState() => _FilterSelectionScreenState();
// }

// class _FilterSelectionScreenState extends State<FilterSelectionScreen> {
//   List<Map<String, dynamic>> filters = [
//     {
//       "filterName": "Work mode",
//       "filterValues": [
//         {"id": 1, "name": "Full time"},
//         {"id": 2, "name": "Part time"},
//         {"id": 3, "name": "Remote"},
//         {"id": 4, "name": "Internship"},
//         {"id": 6, "name": "WFH"},
//       ],
//       "filterKey": "work_mode",
//     },
//     {
//       "filterName": "Role Category",
//       "filterValues": [
//         {"id": 2, "name": "CEO"},
//         {"id": 3, "name": "Sr. Project Manager"},
//         {"id": 8, "name": "Programmer"},
//       ],
//       "filterKey": "job_level_id",
//     },
//     {
//       "filterName": "Departments",
//       "filterValues": [
//         {"id": 1, "name": "Advertising / Entertainment / Media"},
//         {"id": 2, "name": "Banking / Insurance / Financial Services"},
//         {"id": 3, "name": "IT Services"},
//       ],
//       "filterKey": "department_id",
//     },
//     {
//       "filterName": "Education",
//       "filterValues": [
//         {"id": 1, "name": "BE"},
//         {"id": 2, "name": "MCA"},
//         {"id": 3, "name": "MBA"},
//         {"id": 4, "name": "M-Tech"},
//       ],
//       "filterKey": "education_id",
//     },
//   ];

//   Map<String, List<int>> selectedFilters = {};

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Filter Selection'),
//       ),
//       body: ListView.builder(
//         itemCount: filters.length,
//         itemBuilder: (context, index) {
//           return ExpansionTile(
//             title: Text(filters[index]["filterName"]),
//             children: [
//               Wrap(
//                 children: (filters[index]["filterValues"] as List<Map<String, dynamic>>).map((filterValue) {
//                   return InkWell(
//                     onTap: () {
//                       setState(() {
//                         final filterKey = filters[index]["filterKey"] as String;
//                         final filterId = filterValue["id"] as int;

//                         if (selectedFilters.containsKey(filterKey)) {
//                           if (selectedFilters[filterKey]!.contains(filterId)) {
//                             selectedFilters[filterKey]!.remove(filterId);
//                           } else {
//                             selectedFilters[filterKey]!.add(filterId);
//                           }
//                         } else {
//                           selectedFilters[filterKey] = [filterId];
//                         }
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Chip(
//                         label: Text(filterValue["name"]),
//                         backgroundColor: (selectedFilters[filters[index]["filterKey"] as String] ?? [])
//                                 .contains(filterValue["id"] as int)
//                             ? Colors.blue
//                             : null,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Print the selected filters in the desired format
//           final output = selectedFilters.entries.map((entry) {
//             return {entry.key: entry.value};
//           }).toList();
//           print(output);
//           print(selectedFilters);
//         },
//         child: Icon(Icons.check),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: FilterSelectionScreen(),
//   ));
// }

//bottom modal

// import 'package:flutter/material.dart';

// class FilterSelectionScreen extends StatefulWidget {
//   final List<Map<String, dynamic>> filters;
//   final Map<String, List<int>> selectedFilters;
//   final Function(Map<String, List<int>> selectedFilters) onFiltersSelected;

//   FilterSelectionScreen({
//     required this.filters,
//     required this.selectedFilters,
//     required this.onFiltersSelected,
//   });

//   @override
//   _FilterSelectionScreenState createState() => _FilterSelectionScreenState();
// }

// class _FilterSelectionScreenState extends State<FilterSelectionScreen> {
//   late Map<String, List<int>> selectedFilters;

//   @override
//   void initState() {
//     super.initState();
//     selectedFilters = Map.from(widget.selectedFilters);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Filter Selection'),
//       ),
//       body: ListView.builder(
//         itemCount: widget.filters.length,
//         itemBuilder: (context, index) {
//           return ExpansionTile(
//             title: Text(widget.filters[index]["filterName"] as String),
//             children: [
//               Wrap(
//                 children: (widget.filters[index]["filterValues"]
//                         as List<Map<String, dynamic>>)
//                     .map((filterValue) {
//                   final filterKey =
//                       widget.filters[index]["filterKey"] as String;
//                   final filterId = filterValue["id"] as int;
//                   final isSelected = selectedFilters.containsKey(filterKey) &&
//                       selectedFilters[filterKey]!.contains(filterId);

//                   return CheckboxListTile(
//                     title: Text(filterValue["name"] as String),
//                     value: isSelected,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         if (selectedFilters.containsKey(filterKey)) {
//                           if (value!) {
//                             selectedFilters[filterKey]!.add(filterId);
//                           } else {
//                             selectedFilters[filterKey]!.remove(filterId);
//                           }
//                         } else {
//                           selectedFilters[filterKey] = [filterId];
//                         }
//                       });
//                     },
//                   );
//                 }).toList(),
//               ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           widget.onFiltersSelected(selectedFilters);
//           Navigator.of(context)
//               .pop(); // Close the bottom sheet after submitting
//         },
//         child: Icon(Icons.check),
//       ),
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   List<Map<String, dynamic>> filters = [
//     {
//       "filterName": "Work mode",
//       "filterValues": [
//         {"id": 1, "name": "Full time"},
//         {"id": 2, "name": "Part time"},
//         {"id": 3, "name": "Remote"},
//         {"id": 4, "name": "Internship"},
//         {"id": 6, "name": "WFH"},
//       ],
//       "filterKey": "work_mode",
//     },
//     {
//       "filterName": "Role Category",
//       "filterValues": [
//         {"id": 2, "name": "CEO"},
//         {"id": 3, "name": "Sr. Project Manager"},
//         {"id": 8, "name": "Programmer"},
//       ],
//       "filterKey": "job_level_id",
//     },
//     {
//       "filterName": "Departments",
//       "filterValues": [
//         {"id": 1, "name": "Advertising / Entertainment / Media"},
//         {"id": 2, "name": "Banking / Insurance / Financial Services"},
//         {"id": 3, "name": "IT Services"},
//       ],
//       "filterKey": "department_id",
//     },
//     {
//       "filterName": "Education",
//       "filterValues": [
//         {"id": 1, "name": "BE"},
//         {"id": 2, "name": "MCA"},
//         {"id": 3, "name": "MBA"},
//         {"id": 4, "name": "M-Tech"},
//       ],
//       "filterKey": "education_id",
//     },
//   ];

//   Map<String, List<int>> selectedFilters = {};

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Main Screen'),
//       // ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             final result = await showModalBottomSheet(
//               context: context,
//               isScrollControlled: true,
//               builder: (context) => FractionallySizedBox(
//                 heightFactor: 0.9,
//                 child: FilterSelectionScreen(
//                   filters: filters,
//                   selectedFilters: selectedFilters,
//                   onFiltersSelected: (selectedFilters) {
//                     setState(() {
//                       this.selectedFilters = selectedFilters;
//                     });
//                     print("Selected Filters: $selectedFilters");
//                   },
//                 ),
//               ),
//             );
//             // Do not update selectedFilters here to keep the previous state
//           },
//           child: Text('Open Bottom Sheet'),
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: MainScreen(),
//   ));
// }



//success


// import 'package:flutter/material.dart';

// class FilterSelectionScreen extends StatefulWidget {
//   @override
//   _FilterSelectionScreenState createState() => _FilterSelectionScreenState();
// }

// class _FilterSelectionScreenState extends State<FilterSelectionScreen> {
//   List<Map<String, dynamic>> filters = [
//     {
//       "filterName": "Work mode",
//       "filterValues": [
//         {"id": 1, "name": "Full time"},
//         {"id": 2, "name": "Part time"},
//         {"id": 3, "name": "Remote"},
//         {"id": 4, "name": "Internship"},
//         {"id": 6, "name": "WFH"},
//       ],
//       "filterKey": "work_mode",
//     },
//     {
//       "filterName": "Role Category",
//       "filterValues": [
//         {"id": 2, "name": "CEO"},
//         {"id": 3, "name": "Sr. Project Manager"},
//         {"id": 8, "name": "Programmer"},
//       ],
//       "filterKey": "job_level_id",
//     },
//     {
//       "filterName": "Departments",
//       "filterValues": [
//         {"id": 1, "name": "Advertising / Entertainment / Media"},
//         {"id": 2, "name": "Banking / Insurance / Financial Services"},
//         {"id": 3, "name": "IT Services"},
//       ],
//       "filterKey": "department_id",
//     },
//     {
//       "filterName": "Education",
//       "filterValues": [
//         {"id": 1, "name": "BE"},
//         {"id": 2, "name": "MCA"},
//         {"id": 3, "name": "MBA"},
//         {"id": 4, "name": "M-Tech"},
//       ],
//       "filterKey": "education_id",
//     },
//   ];

//   Map<String, List<int>> selectedFilters = {};

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Filter Selection'),
//       ),
//       body: ListView.builder(
//         itemCount: filters.length,
//         itemBuilder: (context, index) {
//           return ExpansionTile(
//             title: Text(filters[index]["filterName"]),
//             children: [
//               Wrap(
//                 children: (filters[index]["filterValues"]
//                         as List<Map<String, dynamic>>)
//                     .map((filterValue) {
//                   final filterKey = filters[index]["filterKey"] as String;
//                   final filterId = filterValue["id"] as int;
//                   final isSelected = selectedFilters.containsKey(filterKey) &&
//                       selectedFilters[filterKey]!.contains(filterId);

//                   return CheckboxListTile(
//                     title: Text(filterValue["name"]),
//                     value: isSelected,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         if (selectedFilters.containsKey(filterKey)) {
//                           if (value!) {
//                             selectedFilters[filterKey]!.add(filterId);
//                           } else {
//                             selectedFilters[filterKey]!.remove(filterId);
//                           }
//                         } else {
//                           selectedFilters[filterKey] = [filterId];
//                         }
//                       });
//                     },
//                   );
//                 }).toList(),
//               ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Print the selected filters in the desired format
//           final output = selectedFilters.entries.map((entry) {
//             return {entry.key: entry.value};
//           }).toList();
//           print(output);
//           print(selectedFilters);
//         },
//         child: Icon(Icons.check),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: FilterSelectionScreen(),
//   ));
// }




// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<String> numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
//   List<Map<String, String>> result = [];
//   Set<String> addedNumbers = Set();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Odd and Even Numbers'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: numbers.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(numbers[index]),
//                   onTap: () {
//                     addToResult(numbers[index]);
//                   },
//                 );
//               },
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               printResult();
//             },
//             child: Text('Show Result'),
//           ),
//         ],
//       ),
//     );
//   }

//   void addToResult(String number) {
//     if (addedNumbers.contains(number)) {
//       // Number has already been added, don't proceed
//       return;
//     }

//     int num = int.parse(number);
//     if (num == 1) {
//       addToMapList("sampple", number);
//     } else if (num % 2 == 0) {
//       addToMapList("even", number);
//     } else {
//       addToMapList("odd", number);
//     }

//     addedNumbers.add(number); // Mark the number as added
//   }

//   void addToMapList(String key, String value) {
//     bool keyExists = false;
//     for (var entry in result) {
//       if (entry['Key'] == key) {
//         keyExists = true;
//         entry['Value'] =
//             entry['Value'] != null ? entry['Value']! + ',' + value : value;
//         break;
//       }
//     }
//     if (!keyExists) {
//       result.add({"Key": key, "Value": value});
//     }
//   }

//   void printResult() {
//     print(result);
//   }
// }


// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<String> numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
//   List<Map<String, String>> result = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Odd and Even Numbers'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: numbers.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(numbers[index]),
//                   onTap: () {
//                     addToResult(numbers[index]);
//                   },
//                 );
//               },
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               printResult();
//             },
//             child: Text('Show Result'),
//           ),
//         ],
//       ),
//     );
//   }

//   void addToResult(String number) {
//     int num = int.parse(number);
//     if (num % 2 == 0) {
//       addToMapList("even", number);
//     } else {
//       addToMapList("odd", number);
//     }
//   }

// void addToMapList(String key, String value) {
//   bool keyExists = false;
//   for (var entry in result) {
//     if (entry['Key'] == key) {
//       keyExists = true;
//       entry['Value'] = entry['Value'] != null ? entry['Value']! + ',' + value : value;
//       break;
//     }
//   }
//   if (!keyExists) {
//     result.add({"Key": key, "Value": value});
//   }
// }


//   void printResult() {
//     print(result);
//   }
// }


// // /// API integrated using http include common api integrated class file and using common class state value like create user loading, get user list loading and store state value and using modals and must using everyone page just any call Api function change automatic state value in flutter
// // ///  another page API Call to change automatic state value current page, example notification received to call api function retunr the value change current state
// // /// API integrated using Riverpod and http clean stucture and example Auth Folder include login and signup and Dashboard Folder show user list, create user and update user
// // /// API integrated best method clean structure and example include createuser, get userlist, update user in flutter
// // /// using multiple provider Auth Provider include login, sigin and dashboard provider get user list , create and update user
// // /// using create loader, updater loader and getlist loader
// // // import 'package:flutter/material.dart';

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('PDF File Picker'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () {
//               _pickPDF(context);
//             },
//             child: Text('Pick PDF'),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _pickPDF(context) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       File file = File(result.files.single.path!);

//       // Display the selected file name in a SnackBar.
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(
//       //     content: Text('Selected PDF file: ${result.files.single.name}'),
//       //   ),
//       // );

//       // Use the selected PDF file as needed (e.g., display, process, or upload).
//       print("Selected PDF file path: ${file.path}");
//       print("Selected PDF file path: ${result.files.single.name}");
//     } else {
//       // User canceled the file picker.
//       print("File picking canceled.");
//     }
//   }
// }


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('PDF File Picker'),
//         ),
//         body: PdfPickerWidget(),
//       ),
//     );
//   }
// }

// class PdfPickerWidget extends StatefulWidget {
//   @override
//   _PdfPickerWidgetState createState() => _PdfPickerWidgetState();
// }

// class _PdfPickerWidgetState extends State<PdfPickerWidget> {
//   File? selectedPdf;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               _pickPDF(context);
//             },
//             child: Text('Pick PDF'),
//           ),
//           SizedBox(height: 20),
//           if (selectedPdf != null)
//             Text('Selected PDF file: ${selectedPdf!.path}'),
//           if (selectedPdf != null)
//             ElevatedButton(
//               onPressed: () {
//                 _removePDF();
//               },
//               child: Text('Remove PDF'),
//             ),
//         ],
//       ),
//     );
//   }

//   Future<void> _pickPDF(context) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       setState(() {
//         selectedPdf = File(result.files.single.path!);
//       });

//       // Display the selected file name in a SnackBar.
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Selected PDF file: ${result.files.single.name}'),
//         ),
//       );
//     } else {
//       // User canceled the file picker.
//       print("File picking canceled.");
//     }
//   }

//   void _removePDF() {
//     if (selectedPdf != null) {
//       selectedPdf!.deleteSync(); // Remove the selected PDF file
//       setState(() {
//         selectedPdf = null; // Clear the selected file reference
//       });
//       print("Removed the selected PDF file.");
//     }
//   }
// }


/// 
/// 
/// 
/// 
/// this picture not clear , so please once check my tamil name mam



// await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );




