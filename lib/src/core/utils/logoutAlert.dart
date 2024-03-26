// import 'package:flutter/material.dart';
// import 'package:job/src/core/utils/logout.dart';

// class logoutAlert extends StatefulWidget {
//   const logoutAlert({super.key});

//   @override
//   State<logoutAlert> createState() => _logoutAlertState();
// }

// class _logoutAlertState extends State<logoutAlert> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       // title: Text('Login your Account'),
//       content: const Padding(
//         padding: EdgeInsets.all(5.0),
//         child: Text(
//           'Do you want to logout?',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       actions: <Widget>[
//         Expanded(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               SizedBox(
//                 height: 40,
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('No'),
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               SizedBox(
//                 height: 40,
//                 child: TextButton(
//                   onPressed: () async {
//                     await Logout.logout(context, "logout");
//                   },
//                   child: const Text('Yes'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:job/src/core/utils/logout.dart';

class LogoutAlert extends StatefulWidget {
  const LogoutAlert({Key? key});

  @override
  State<LogoutAlert> createState() => _LogoutAlertState();
}

class _LogoutAlertState extends State<LogoutAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          'Do you want to logout?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () async {
            await Logout.logout(context, "logout");
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}

