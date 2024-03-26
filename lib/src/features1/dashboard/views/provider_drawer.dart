import 'package:flutter/material.dart';
import 'package:job/src/core/utils/logoutAlert.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/features/auth/views/terms_conditions.dart';
import 'package:job/src/features/chat/views/chat.dart';
import 'package:job/src/features1/subscription/views/my_plan_list.dart';
import 'package:job/src/features1/subscription/views/subscription_list.dart';

class ProviderDrawer extends StatefulWidget {
  const ProviderDrawer({super.key, required this.onTap});

  final Function onTap;

  @override
  State<ProviderDrawer> createState() => _ProviderDrawerState();
}

class _ProviderDrawerState extends State<ProviderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TextButton(
          //   onPressed: () {
          //     // Handle logout logic here
          //     print('Logout pressed');
          //   },
          //   child: const Row(
          //     mainAxisSize: MainAxisSize.max,
          //     children: <Widget>[
          //       Icon(Icons.exit_to_app),
          //       SizedBox(width: 8), // Add some spacing between icon and text
          //       Text('Logout'),
          //     ],
          //   ),
          // ),
          // TextButton(
          //   onPressed: () {
          //     // Handle logout logic here
          //     print('Logout pressed');
          //   },
          //   child: const Row(
          //     mainAxisSize: MainAxisSize.max,
          //     children: <Widget>[
          //       Icon(
          //         Icons.person_outline_outlined,
          //         color: Colors.black,
          //       ),
          //       SizedBox(width: 8), // Add some spacing between icon and text
          //       Text(
          //         'Account',
          //         style: TextStyle(color: Colors.black),
          //       ),
          //     ],
          //   ),
          // ),
          TextButton(
            onPressed: () {
              // Handle logout logic here
              widget.onTap();
              Nav.to(context, TermsConditions());
              // print('Logout pressed');
            },
            child: const Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(
                  Icons.policy_outlined,
                  color: Colors.black,
                ),
                SizedBox(width: 8), // Add some spacing between icon and text
                Text(
                  'Terms and Conditions',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              widget.onTap();
              // _scaffoldKey.currentState?.openEndDrawer();
              Nav.to(context, SubscriptionList());

              // Handle logout logic here
              print('Logout pressed');
            },
            child: const Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(
                  Icons.add_card_outlined,
                  color: Colors.black,
                ),
                SizedBox(width: 8), // Add some spacing between icon and text
                Text(
                  'Subscription',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              widget.onTap();
              // _scaffoldKey.currentState?.openEndDrawer();
              Nav.to(context, MyPlanList());

              // Handle logout logic here
              print('Logout pressed');
            },
            child: const Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(
                  Icons.library_add_check_outlined,
                  color: Colors.black,
                ),
                SizedBox(width: 8), // Add some spacing between icon and text
                Text(
                  'My plans',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          // TextButton(
          //   onPressed: () async {
          //     widget.onTap();
          //     // _scaffoldKey.currentState?.openEndDrawer();
          //     Nav.to(context, Chat());
          //   },
          //   child: const Row(
          //     mainAxisSize: MainAxisSize.max,
          //     children: <Widget>[
          //       Icon(
          //         Icons.chat,
          //         color: Colors.black,
          //       ),
          //       SizedBox(width: 8), // Add some spacing between icon and text
          //       Text(
          //         'Help & Support',
          //         style: TextStyle(color: Colors.black),
          //       ),
          //     ],
          //   ),
          // ),
          TextButton(
            onPressed: () async {
              widget.onTap();
              // _scaffoldKey.currentState?.openEndDrawer();
              // Nav.to(context, const SubscriptionList());
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const LogoutAlert();
                },
              );

              // Handle logout logic here
              print('Logout pressed');
            },
            child: const Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                SizedBox(width: 8), // Add some spacing between icon and text
                Text(
                  'logout',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
