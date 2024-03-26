import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features/auth/views/splash.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'JobEasyee',
        theme: AppTheme.lightTheme,
        scaffoldMessengerKey: Snackbar.getKey(),
        home: Splash());
  }
}




// class StackOver extends StatefulWidget {
//   @override
//   _StackOverState createState() => _StackOverState();
// }

// class _StackOverState extends State<StackOver>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     _tabController = TabController(length: 2, vsync: this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _tabController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: DefaultTabController(
//           length: 2,
//           child: Scaffold(
//             appBar: AppBar(
//               backgroundColor: Colors.white,
//               bottom: const TabBar(
//                 dividerColor: Colors.red,
//                 indicatorColor: Colors.green,
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 labelStyle: TextStyle(fontWeight: FontWeight.bold),
//                 // indicator: BoxDecoration(
//                 //   color: Colors.amber
//                 // ),
//                 tabs: [
//                   Tab(child: Text("Latest",),),
//                   Tab(child: Text("Recommed"),),
//                   // Tab(icon: Icon(Icons.directions_transit)),
//                   // Tab(icon: Icon(Icons.directions_bike)),
//                 ],
//               ),
//               // title: const Text('Tabs Demo'),
//             ),
//             body: const TabBarView(
//               children: [
//                 Icon(Icons.directions_car),
//                 Icon(Icons.directions_transit),
//                 // Icon(Icons.directions_bike),
//               ],
//             ),
//           ),
//         ),
//     );
//   }
// }

// class sample extends StatefulWidget {
//   const sample({super.key});

//   @override
//   State<sample> createState() => _sampleState();
// }

// class _sampleState extends State<sample> {
//   List news = [];
//   List add = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//           itemCount: 20,
//           itemBuilder: (context, index) {
//             final _i = index;
//             return index % 5 == 0 && index != 0
//                 ? Container(
//                     child: Text("add"),
//                   )
//                 : Container(
//                     child: Text("news ${index}"),
//                   );
//           }),
//     );
//   }
// }
