import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/guestAlert.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/features1/subscription/views/subscription_list.dart';
// class ProviderBottomBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const ProviderBottomBar({
//     Key? key,
//     required this.currentIndex,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       currentIndex: currentIndex,
//       onTap: onTap,
//       selectedItemColor: AppTheme.primary,
//       unselectedItemColor: AppTheme.TextBoldLite,
//       items: [
//         BottomNavigationBarItem(
//           icon: ImageIcon(
//             const AssetImage("assets/icons/Home.png"),
//           ),
//           label: "Home",
//         ),
//         BottomNavigationBarItem(
//           icon: ImageIcon(
//             const AssetImage("assets/icons/Work.png"),
//           ),
//           label: "My post",
//         ),
//           BottomNavigationBarItem(
//           icon: Container(
//             height: 50,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: currentIndex == 2
//                   ? AppTheme.primary
//                   : AppTheme.TextFormFieldBac,
//             ),
//             child: Icon(
//               Icons.add,
//               color: currentIndex == 2 ? AppTheme.white : AppTheme.TextBoldLite,
//               size: 40, // Adjust the size as needed
//             ),
//           ),
//           label: "", // Empty label to hide text
//         ),
//         BottomNavigationBarItem(
//           icon: ImageIcon(
//             const AssetImage("assets/icons/Chat.png"),
//           ),
//           label: "Request",
//         ),
//         BottomNavigationBarItem(
//           icon: ImageIcon(
//             const AssetImage("assets/icons/Profile.png"),
//           ),
//           label: "Account",
//         ),
//       ],
//     );
//   }
// }

class ProviderBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ProviderBottomBar(
      {Key? key, required this.currentIndex, required this.onTap})
      : super(key: key);

  void navigateToSamePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProviderBottomBar(
          currentIndex: currentIndex,
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  State<ProviderBottomBar> createState() => _ProviderBottomBarState();
}

class _ProviderBottomBarState extends State<ProviderBottomBar> {
  Key appBarKey = UniqueKey();
  //  @override
  // void didUpdateWidget(covariant ProviderBottomBar oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   // Check if the currentIndex has changed and update the initialActiveIndex
  //   if (widget.currentIndex != oldWidget.currentIndex) {
  //     WidgetsBinding.instance?.addPostFrameCallback((_) {
  //       // Schedule the update for the next frame to ensure that the build is complete
  //       setState(() {
  //       });
  //     });
  //   }
  // }

  @override
  void didUpdateWidget(covariant ProviderBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the currentIndex has changed and update the ConvexAppBar key
    if (widget.currentIndex != oldWidget.currentIndex) {
      setState(() {
        appBarKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      key: appBarKey,
      style: TabStyle.fixedCircle,

      color: Colors.black,
      backgroundColor: Colors.white,
      // shadowColor: Colors.transparent,
      curveSize: 0,
      elevation: 1,

      activeColor: AppTheme.primary,
      height: 55,
      // elevation: ,
      items: [
        TabItem(
            icon: ImageIcon(
              const AssetImage("assets/icons/Home.png"),
              color: widget.currentIndex == 0 ? AppTheme.primary : null,
            ),
            title: "Home"),
        TabItem(
            icon: ImageIcon(
              const AssetImage("assets/icons/Work.png"),
              color: widget.currentIndex == 1 ? AppTheme.primary : null,
            ),
            title: "My post"),
        TabItem(
            icon: Container(
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.currentIndex == 2
                    ? AppTheme.primary
                    : AppTheme.TextFormFieldBac,
              ),
              child: Icon(
                Icons.add,
                color: widget.currentIndex == 2
                    ? AppTheme.white
                    : AppTheme.TextBoldLite,
                size: 50,
              ),
            ),
            title: "create"),
        TabItem(
            icon: ImageIcon(
              const AssetImage("assets/icons/Chat.png"),
              color: widget.currentIndex == 3 ? AppTheme.primary : null,
            ),
            title: "Request"),
        TabItem(
            icon: ImageIcon(
              const AssetImage("assets/icons/Profile.png"),
              color: widget.currentIndex == 4 ? AppTheme.primary : null,
            ),
            title: "Account"),
      ],
      initialActiveIndex: widget.currentIndex,
      onTap: (int i) {
        var result = PrefManager.read("guest");
        // PrefManager.writebool("home_load", false);
        bool get_HomeLoad = PrefManager.readBoolean("home_load");

        if (result == "yes") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return GuestAlert();
            },
          );
          setState(() {
            appBarKey = UniqueKey();
          });
        } else if (get_HomeLoad) {
          setState(() {
            appBarKey = UniqueKey();
          });
        } else {
          if (i == 2) {
            var job_post_status = PrefManager.read("job_post_status");
            var get_company_status = PrefManager.read("company_status");
            if (get_company_status == "0") {
              widget.onTap(i);
              setState(() {
                appBarKey = UniqueKey();
              });
            } else if (job_post_status.toString() == "0") {
              Nav.to(context, SubscriptionList());
              setState(() {
                appBarKey = UniqueKey();
              });
            } else {
              widget.onTap(i);
            }
          } else {
            widget.onTap(i);
          }
          // widget.onTap(i);
        }
      },
    );
  }
}

// class ProviderBottomBar extends StatelessWidget {
//   // const ProviderBottomBar({super.key});
//   final int currentIndex;
//   final Function(int) onTap;

//   const ProviderBottomBar(
//       {super.key, required this.currentIndex, required this.onTap});
//   @override
//   Widget build(BuildContext context) {
//     return
//         //  Container(
//         // height: 60,

//         // decoration: BoxDecoration(
//         //   color: Colors.white,
//         //   boxShadow: [
//         //     BoxShadow(
//         //       color: Colors.grey.withOpacity(0.5),
//         //       spreadRadius: 5,
//         //       blurRadius: 1, // Use a negative blur radius for the shadow to appear at the top
//         //       offset: Offset(0, 5),
//         //     ),
//         //   ],
//         // ),
//         // padding: EdgeInsets.only(top: 1.0),
//         // child:
//         // Stack(
//         // alignment: Alignment.topCenter,
//         // children: [
//         ConvexAppBar(
//       style: TabStyle.fixedCircle,

//       color: Colors.black,
//       backgroundColor: Colors.white,
//       // shadowColor: Colors.transparent,
//       curveSize: 0,
//       elevation: 1,

//       activeColor: AppTheme.primary,
//       height: 55,
//       // elevation: ,
//       items: [
//         TabItem(
//             icon: ImageIcon(
//               const AssetImage("assets/icons/Home.png"),
//               color: currentIndex == 0 ? AppTheme.primary : null,
//             ),
//             title: "Home"),
//         TabItem(
//             icon: ImageIcon(
//               const AssetImage("assets/icons/Work.png"),
//               color: currentIndex == 1 ? AppTheme.primary : null,
//             ),
//             title: "My post"),
//         TabItem(
//             icon: Container(
//               height: 50,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: currentIndex == 2
//                     ? AppTheme.primary
//                     : AppTheme.TextFormFieldBac,
//               ),
//               child: Icon(
//                 Icons.add,
//                 color:
//                     currentIndex == 2 ? AppTheme.white : AppTheme.TextBoldLite,
//                 size: 50,
//               ),
//             ),
//             title: "create"),
//         TabItem(
//             icon: ImageIcon(
//               const AssetImage("assets/icons/Chat.png"),
//               color: currentIndex == 3 ? AppTheme.primary : null,
//             ),
//             title: "Request"),
//         TabItem(
//             icon: ImageIcon(
//               const AssetImage("assets/icons/Profile.png"),
//               color: currentIndex == 4 ? AppTheme.primary : null,
//             ),
//             title: "Account"),
//       ],
//       initialActiveIndex: currentIndex,
//       onTap: (int i) {
//         onTap(i);
//       },

//     );
//     //  BottomNavigationBar(
//     //   // landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
//     //   backgroundColor: Colors.white,
//     //   items: const <BottomNavigationBarItem>[
//     //     BottomNavigationBarItem(
//     //       icon: ImageIcon(AssetImage("assets/icons/Home.png")),
//     //       label: 'Home',
//     //     ),
//     //     BottomNavigationBarItem(
//     //       icon: ImageIcon(AssetImage("assets/icons/Work.png")),
//     //       label: 'Jobs',
//     //     ),
//     //     BottomNavigationBarItem(
//     //       icon: Icon(Icons.abc),
//     //       label: '',
//     //     ),
//     //      BottomNavigationBarItem(
//     //       icon: ImageIcon(AssetImage("assets/icons/Chat.png")),
//     //       label: 'Chat',
//     //     ),
//     //     BottomNavigationBarItem(
//     //       icon: ImageIcon(AssetImage("assets/icons/Profile.png")),
//     //       label: 'Account',
//     //     ),
//     //   ],
//     //   currentIndex: currentIndex,
//     //   selectedItemColor: AppTheme.primary,
//     //   unselectedItemColor: AppTheme.TextBoldLite,
//     //   showUnselectedLabels: true,
//     //   type: BottomNavigationBarType.fixed,
//     //   onTap: onTap,
//     // );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:job/src/core/utils/app_theme.dart';

// class ProviderBottomBar extends StatefulWidget {
//   const ProviderBottomBar(
//       {super.key, required this.currentIndex, required this.onTap});
//   final int currentIndex;
//   final Function(int) onTap;

//   @override
//   State<ProviderBottomBar> createState() => _ProviderBottomBarState();
// }

// class _ProviderBottomBarState extends State<ProviderBottomBar> {
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Container(
//       height: 55,
//       color: Colors.transparent,
//       child: Stack(
//         alignment: Alignment.topCenter,
//         children: [
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               padding:
//                   const EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
//               height: 55,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey, // Shadow color at the top
//                     offset: Offset(0,
//                         2), // Offset of the shadow (0 for x-axis, -2 for y-axis to make it appear at the top)
//                     blurRadius: 5.0, // Spread or blur radius of the shadow
//                     spreadRadius: 1.0, // Extent of the shadow
//                   ),
//                 ],
//               ),
//               child: Row(
//                 // crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   SizedBox(
//                       width: screenWidth * 0.18,
//                       child: InkWell(
//                         splashColor: Colors.transparent,
//                         highlightColor: Colors.transparent,
//                         onTap: () {
//                           widget.onTap(0);
//                         },
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               "assets/icons/Home.png",
//                               width: 25,
//                               color: widget.currentIndex == 0
//                                   ? AppTheme.primary
//                                   : null,
//                             ),
//                             Text(
//                               "Home",
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: widget.currentIndex == 0
//                                     ? AppTheme.primary
//                                     : null,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       )),
//                   SizedBox(
//                       width: screenWidth * 0.18,
//                       child: InkWell(
//                         splashColor: Colors.transparent,
//                         highlightColor: Colors.transparent,
//                         onTap: () {
//                           widget.onTap(1);
//                         },
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               "assets/icons/mypost.png",
//                               width: 25,
//                               color: widget.currentIndex == 1
//                                   ? AppTheme.primary
//                                   : null,
//                             ),
//                             Text(
//                               "My Post",
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: widget.currentIndex == 1
//                                     ? AppTheme.primary
//                                     : null,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       )),
//                   SizedBox(
//                       width: screenWidth * 0.14,
//                       child: const Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Text(
//                             "Create",
//                             style: TextStyle(fontSize: 12),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ))),
//                   SizedBox(
//                       width: screenWidth * 0.18,
//                       child: InkWell(
//                         splashColor: Colors.transparent,
//                         highlightColor: Colors.transparent,
//                         onTap: () {
//                           widget.onTap(3);
//                         },
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               "assets/icons/request.png",
//                               width: 25,
//                               color: widget.currentIndex == 3
//                                   ? AppTheme.primary
//                                   : null,
//                             ),
//                             Text(
//                               "Request",
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: widget.currentIndex == 3
//                                     ? AppTheme.primary
//                                     : null,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       )),
//                   SizedBox(
//                       width: screenWidth * 0.18,
//                       child: InkWell(
//                         splashColor: Colors.transparent,
//                         highlightColor: Colors.transparent,
//                         onTap: () {
//                           widget.onTap(4);
//                         },
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               "assets/icons/Profile.png",
//                               width: 25,
//                               color: widget.currentIndex == 4
//                                   ? AppTheme.primary
//                                   : null,
//                             ),
//                             Text(
//                               "Account",
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: widget.currentIndex == 4
//                                     ? AppTheme.primary
//                                     : null,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       )),
//                 ],
//               ),
//             ),
//           ),
//           // Container(
//           //   height: 55,
//           //   width: 55,
//           //   decoration: BoxDecoration(
//           //     shape: BoxShape.circle,
//           //     color: AppTheme.primary,
//           //   ),
//           //   child: const Center(
//           //       child: Icon(
//           //     Icons.add,
//           //     size: 45,
//           //     color: Colors.white,
//           //   )),
//           // )
//         ],
//       ),
//     );
//   }
// }
