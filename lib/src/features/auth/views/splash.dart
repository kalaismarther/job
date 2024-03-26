// ignore_for_file: non_constant_identifier_names

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/notification_service.dart';
import 'package:job/src/core/utils/validate.dart';
import 'package:job/src/features/auth/views/login.dart';
import 'package:job/src/features/dashboard/views/dashboard.dart';
import 'package:job/src/features1/dashboard/views/provider_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool? isLoggin = false;
  bool theme = false;
  var type = "";

  @override
  void initState() {
    super.initState();
    initPreferences();
    notification();
  }

  notification() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("on msggggggggg ===============> ${message}");
      NotificationService().showNotification(
          title: message.notification?.title, body: message.notification?.body);
    });
    print(fcmToken);
  }

  initPreferences() async {
    pref = await SharedPreferences.getInstance();
    var UserResponse = PrefManager.read("UserResponse");
    var UserResponse1 = PrefManager.read("UserResponse_verify");
    PrefManager.writebool("home_load", true);

    print(UserResponse);
    print(UserResponse1);
    setState(() {
      isLoggin = pref.getBool('isLoggin');
      if (UserResponse.isNotEmpty) {
        // print("yes");
        type = UserResponse?['data']?['user_type'] ?? "";
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        theme = true;
      });
      if (isLoggin == true) {
        if (type == "COMPANY" || type == "GUEST_COMPANY") {
          Nav.off(context, ProviderDashboard());
        } else {
          Nav.off(
            context,
            Dashboard(
              current_index: 0,
            ),
          );
        }
      } else {
        Nav.off(context, const Login());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    double ScreenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        // statusBarColor: Color(_primary),
        statusBarColor: theme == true ? HexColor("#565BDB") : Colors.white,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: ScreenHeight * 0.2,
                  width: ScreenWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/images/logo_dark1.png",
                    ),
                  )),
            ],
          )),
    );
  }
}
