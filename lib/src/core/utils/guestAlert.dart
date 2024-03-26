import 'package:flutter/material.dart';
import 'package:job/src/core/utils/logout.dart';

class GuestAlert extends StatefulWidget {
  const GuestAlert({super.key});

  @override
  State<GuestAlert> createState() => _GuestAlertState();
}

class _GuestAlertState extends State<GuestAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: Text('Login your Account'),
      content: const Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          'Login your Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    // If "Cancel" is pressed, do not pop the route
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    // If "OK" is pressed, pop the route
                    // Navigator.of(context).pop();
                    await Logout.logout(context, "guest");
                  },
                  child: const Text('OK'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
