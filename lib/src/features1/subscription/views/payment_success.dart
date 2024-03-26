import 'package:flutter/material.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features1/dashboard/views/provider_dashboard.dart';
import 'package:job/src/features1/subscription/subscription_api.dart';

class PaymentSuccessPage extends StatefulWidget {
  const PaymentSuccessPage(
      {super.key, required this.status, required this.data});

  final String status;
  final Map data;

  @override
  _PaymentSuccessPageState createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  bool _isLoading = false;
  String status = "";

  @override
  void initState() {
    print('-----> ${widget.data}');
    super.initState();
    initilize();
    // Simulate a 2-second delay before showing the payment success message
    // Future.delayed(const Duration(seconds: 2), () {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
  }

  initilize() async {
    setState(() {
      status = widget.status;
    });

    if (widget.status == "success") {
      setState(() {
        _isLoading = true;
      });
      var UserResponse = PrefManager.read("UserResponse");

      var result = await SubscriptionApi.postPackagePurchase(
          context, widget.data, UserResponse['data']['api_token']);
      print('//////// ${result.data}');
      if (result.success) {
        if (result.data['status'].toString() == "1") {
          setState(() {
            status = widget.status;
          });
        }
      } else {
        setState(() {
          status = "fail";
        });
        print("Faild ========================== ");
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (!_isLoading) {
          return true;
        } else {
          Snackbar.show("Please Wait ....", Colors.black);
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: status == "success"
            ? Colors.green
            : Colors.red, // Green background color
        body: Center(
          child: _isLoading
              ? const CircularProgressIndicator(
                  // Loading indicator
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    status == "success"
                        ? const Icon(
                            Icons.check_circle_outline,
                            size: 100,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.cancel_outlined, // Checkmark icon
                            size: 100,
                            color: Colors.white, // White icon color
                          ),
                    const SizedBox(height: 20),
                    status == "success"
                        ? const Text(
                            'Payment Successfully', // Text indicating payment success
                            style: TextStyle(
                              color: Colors.white, // White text color
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Text(
                            "Failed",
                            style: TextStyle(
                              color: Colors.white, // White text color
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const SizedBox(height: 40),
                    status == "success"
                        ? SizedBox(
                            width: screenWidth * 0.7,
                            child: ElevatedButton(
                              onPressed: () {
                                Nav.offAll(context, ProviderDashboard());
                                // Navigate back or perform any other action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.white, // White button color
                                foregroundColor:
                                    Colors.green, // Green text color
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Done', // Done button
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                        : SizedBox(
                            width: screenWidth * 0.85,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.red, // Background color
                                          foregroundColor:
                                              Colors.white, // Text color
                                          side: const BorderSide(
                                              color: Colors.white,
                                              width: 2), // Border color
                                        ),
                                        onPressed: () {
                                          Nav.offAll(
                                              context, ProviderDashboard());
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ))),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.white, // Background color
                                          foregroundColor:
                                              Colors.white, // Text color
                                          side: const BorderSide(
                                              color:
                                                  Colors.white), // Border color
                                        ),
                                        onPressed: () {
                                          Nav.back(context);
                                        },
                                        child: const Text(
                                          "Try again",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )))
                              ],
                            ),
                          )
                  ],
                ),
        ),
      ),
    );
  }
}
