// import 'package:flutter/material.dart';
// import 'package:job/src/core/utils/navigation.dart';
// import 'package:job/src/features/auth/auth_api.dart';

// class Locationsearch extends StatefulWidget {
//   // const Locationsearch({super.key});

//   final List location;
//   final List s_Location;
//   final String type;

//   const Locationsearch(
//       {Key? key,
//       required this.location,
//       required this.s_Location,
//       required this.type})
//       : super(key: key);

//   @override
//   State<Locationsearch> createState() => _LocationsearchState();
// }

// class _LocationsearchState extends State<Locationsearch> {
//   late List L;
//   late List sL;

//   TextEditingController _searchController = TextEditingController();
//   List searchResults = [];
//   bool isSearch = false;

//   _search() async {
//     setState(() {
//       isSearch = true;
//     });
//     var data = await {"state_id": 0, "search": _searchController.text};
//     // final response = await http.get(
//     //   Uri.parse('https://api.example.com/search?q=${_searchController.text}'),
//     // );[]
//     print("&&&&&&&&&&&&&& ${data}");
//     final response = await AuthApi.getCity(context, data);
//     print(_searchController.text);
//     print(data);
//     print(data);

//     if (response.success) {
//       if (response.data['search'] == _searchController.text) {
//         setState(() {
//           L = response.data['data'];
//           isSearch = false;
//         });
//         check();
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Initialize local state variables with the values passed from the widget
//     L = widget.location;
//     sL = widget.s_Location;

//     // Initialize selectedDistricts with default values
//     sL = sL.map((selected) {
//       int index = L.indexWhere((district) => district["id"] == selected["id"]);
//       return (index != -1 && index < L.length) ? L[index] : selected;
//     }).toList();
//   }

//   check() {
//     sL = sL.map((selected) {
//       int index = L.indexWhere((district) => district["id"] == selected["id"]);
//       return (index != -1 && index < L.length) ? L[index] : selected;
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double ScreenWidth = MediaQuery.of(context).size.width;
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           const SizedBox(
//             height: 10,
//           ),
//           TextFormField(
//             onChanged: (value) async {
//               // Delay the search to avoid redundant calls
//               // await Future.delayed(Duration(milliseconds: 300));
//               // if(isSearch == false){
//               _search();
//               // }

//               print("=======>${value}");
//               print("*******>${_searchController.text}");

//               // _search();
//             },
//             controller: _searchController,
//             decoration: InputDecoration(
//               // labelText: 'Search',
//               hintText: "Search District Name",
//               suffixIcon: IconButton(
//                 onPressed: () {},
//                 icon: Icon(Icons.search),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: L.length,
//               itemBuilder: (context, index) {
//                 return CheckboxListTile(
//                   title: Text(L[index]["district_name"]),
//                   value: sL.contains(L[index]),
//                   onChanged: (bool? value) {
//                     setState(() {
//                       if (value!) {
//                         sL.add(L[index]);
//                       } else {
//                         sL.remove(L[index]);
//                       }
//                     });
//                   },
//                 );
//               },
//             ),
//           ),
//           SizedBox(
//             width: ScreenWidth,
//             child: Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: ElevatedButton(
//                 onPressed: () {
//                   Nav.back(context, sL);
//                   print(sL);
//                 },
//                 child: Text("Continue"),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           )
//         ],
//       ),
//     );
//   }
// }
