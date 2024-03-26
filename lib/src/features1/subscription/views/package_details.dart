import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features1/subscription/subscription_api.dart';
import 'package:job/src/features1/subscription/views/payment_success.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PackageDetails extends StatefulWidget {
  const PackageDetails({super.key, required this.details});

  final Map details;

  @override
  State<PackageDetails> createState() => _PackageDetailsState();
}

class _PackageDetailsState extends State<PackageDetails> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController no_post = TextEditingController();
  TextEditingController cv_req = TextEditingController();
  TextEditingController promo_code = TextEditingController();

  bool btn = false;
  bool purchase_check = false;
  List bill_details = [];
  double total = 0.00;
  var bill_title;
  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    // showAlertDialog(context, "Payment Failed",
    //     "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");

    Nav.to(context, PaymentSuccessPage(status: "fail", data: {}));
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */

    print(response.data.toString());
    postData(response);
    // showAlertDialog(
    //     context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    // showAlertDialog(
    //     context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  postData(response) async {
    var UserResponse = PrefManager.read("UserResponse");

    var data = {
      "user_id": UserResponse['data']['id'],
      "package_id": widget.details['id'],
      "jop_post_qty": no_post.text.isNotEmpty ? no_post.text : 0,
      "cv_req_qty": cv_req.text.isNotEmpty ? cv_req.text : 0,
      "promo_code": promo_code.text,
      "transaction_id": response.paymentId
    };
    Nav.to(context, PaymentSuccessPage(status: "success", data: data));
    // var result = await SubscriptionApi.postPackagePurchase(context, data, UserResponse['data']['api_token']);
    // print(result);
    // if(result.success){
    //   if(result.data['status'].toString() == "1"){
    // showAlertDialog(
    //     context, "Payment Successful", "Payment ID: ${response.paymentId}");
    //   }
    // }else{
    //   print("Faild ========================== ");
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    initilize();
    super.initState();
  }

  initilize() {
    print(widget.details);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text(
          "Package Details",
          style: TextStyle(
            color: AppTheme.white,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Nav.back(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme.white,
            )),
      ),
      bottomNavigationBar: btn
          ? Container(
              height: 60,
              // color: Colors.red,
              margin: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          var UserResponse = PrefManager.read("UserResponse");

                          Razorpay razorpay = Razorpay();
                          int amountInPaise = (total * 100).toInt();

                          var options = {
                            // 'key': 'rzp_test_1DP5mmOlF5G5ag',
                            'key': 'rzp_test_JT2tJ6Y2BXRs8s',
                            'amount': amountInPaise,
                            'name': UserResponse['data']?['name'] ?? "",
                            'description':
                                widget.details['package_title'] ?? "",
                            'retry': {'enabled': true, 'max_count': 1},
                            'send_sms_hash': true,
                            'prefill': {
                              'contact': UserResponse['data']['mobile'] ?? "",
                              'email': UserResponse['data']['email'] ?? ""
                            },
                            // 'external': {
                            //   'wallets': ['paytm']
                            // }
                          };
                          razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                              handlePaymentErrorResponse);
                          razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                              handlePaymentSuccessResponse);
                          razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                              handleExternalWalletSelected);
                          razorpay.open(options);
                        },
                        child: Text(
                          "Pay ${total.toString()}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ))
                ],
              ),
            )
          : const SizedBox(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: screenWidth,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    widget.details['package_title'] ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  widget.details['id'].toString() == "1"
                      ? Text(
                          "₹ ${(widget.details['per_job_post_amount'] ?? "").toString()}",
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        )
                      : widget.details['id'].toString() == "2"
                          ? Text(
                              "₹ ${(widget.details['per_req_amount'] ?? "").toString()}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(widget.details['short_description'] ?? ""),
                  const SizedBox(
                    height: 15,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Package Details",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.details['long_description'] ?? ""),
                  const SizedBox(
                    height: 10,
                  ),
                  // widget.details['id'].toString() == "1" ||
                  // widget.details['id'].toString() == "3"
                  widget.details['per_job_post_amount'] > 0
                      ? Column(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Number of Job Posting",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: TextFormField(
                                  controller: no_post,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      btn = false;
                                    });
                                  },
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Please Enter No of post';
                                  //   } else {
                                  //     if (!(int.parse(no_post.text) > 0)) {
                                  //       return 'Invalid';
                                  //     } else {
                                  //       return null;
                                  //     }
                                  //   }
                                  // },
                                  decoration: const InputDecoration(
                                    // labelText: 'Enter Digits',
                                    hintText: "Enter Number",
                                    fillColor: Colors.white, filled: true,
                                    border: OutlineInputBorder(
                                        // Set border color here
                                        ),
                                  ),
                                )),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                    "* ${(widget.details['per_job_post_amount'] ?? "").toString()}"),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : const SizedBox(
                          height: 0,
                        ),
                  // widget.details['id'].toString() == "2" ||
                  // widget.details['id'].toString() == "3"
                  widget.details['per_req_amount'] > 0
                      ? Column(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "CV views per requirement",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: TextFormField(
                                  controller: cv_req,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      btn = false;
                                    });
                                  },
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Please Enter No of CV';
                                  //   } else {
                                  //     if (!(int.parse(cv_req.text) > 0)) {
                                  //       return 'Invalid';
                                  //     } else {
                                  //       return null;
                                  //     }
                                  //   }
                                  //   // if (value == null || value.isEmpty) {
                                  //   //   return 'Please Enter Number';
                                  //   // }
                                  //   // return null;
                                  // },
                                  decoration: const InputDecoration(
                                    // labelText: 'Enter Digits',
                                    hintText: "Enter Number",
                                    fillColor: Colors.white, filled: true,
                                    border: OutlineInputBorder(
                                        // Set border color here
                                        ),
                                  ),
                                )),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                    "* ${(widget.details['per_req_amount'] ?? "").toString()}"),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : const SizedBox(
                          height: 0,
                        ),

                  Row(
                    children: [
                      const Text(
                        "Promo Code",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "(Optional)",
                        style: TextStyle(color: AppTheme.TextLite),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: promo_code,
                    // keyboardType: TextInputType.number,
                    // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      setState(() {
                        btn = false;
                      });
                    },
                    decoration: const InputDecoration(
                      // labelText: 'Enter Digits',
                      hintText: "Enter Promo code",
                      fillColor: Colors.white, filled: true,

                      border: OutlineInputBorder(// Set border color here
                          ),
                    ),
                  ),

                  // ListView.builder(
                  //     itemCount: 5,
                  //     shrinkWrap: true,
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     itemBuilder: (context, index) {
                  //       return const Row(
                  //         children: [
                  //           Icon(
                  //             Icons.done_all,
                  //             color: Colors.green,
                  //           ),
                  //           SizedBox(
                  //             width: 10,
                  //           ),
                  //           Expanded(
                  //               child: Text(
                  //                   "Add will be for 30 days day start from fasdf fas posting")),
                  //         ],
                  //       );
                  //     }),
                  const SizedBox(
                    height: 15,
                  ),
                  !btn
                      ? SizedBox(
                          width: screenWidth,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (!purchase_check) {
                                  if (no_post.text.isEmpty &&
                                      cv_req.text.isEmpty) {
                                    Snackbar.show(
                                        "Please fill atleast one requirement",
                                        Colors.black);
                                  } else if (_formKey.currentState!
                                      .validate()) {
                                    setState(() {
                                      purchase_check = true;
                                    });
                                    // if (!(int.parse(no_post.text) > 0)) {
                                    //   Snackbar.show(
                                    //       "No of post must be more then one",
                                    //       Colors.black);
                                    // } else {
                                    var UserResponse =
                                        PrefManager.read("UserResponse");

                                    var data = {
                                      "user_id": UserResponse['data']['id'],
                                      "package_id": widget.details['id'],
                                      "jop_post_qty": no_post.text.isNotEmpty
                                          ? no_post.text
                                          : 0,
                                      "cv_req_qty": cv_req.text.isNotEmpty
                                          ? cv_req.text
                                          : 0,
                                      "promo_code": promo_code.text
                                    };
                                    print(data);
                                    var result = await SubscriptionApi
                                        .checkPackagePurchase(context, data,
                                            UserResponse['data']['api_token']);
                                    print(result.data);
                                    if (result.success) {
                                      if (result.data['status'].toString() ==
                                          "1") {
                                        setState(() {
                                          bill_details =
                                              result.data['data'] ?? [];
                                          bill_title =
                                              result.data['title'] ?? "";
                                          total = double.parse(
                                              result.data['total'].toString());
                                          btn = true;
                                        });
                                      } else if (result.data['message'] !=
                                          null) {
                                        Snackbar.show(result.data['message'],
                                            Colors.black);
                                      } else {
                                        Snackbar.show(
                                            "Some Error", Colors.black);
                                      }
                                    }
                                    setState(() {
                                      purchase_check = false;
                                    });
                                  }
                                }
                                // } else {
                                //   Snackbar.show("Already Load please wait ...",
                                //       Colors.black);
                                // }
                              },
                              child: !purchase_check
                                  ? const Text("Next")
                                  : Loader.common()))
                      : Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  bill_title ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Table(
                              border: TableBorder.all(),
                              children: List.generate(
                                bill_details.length,
                                (index) => TableRow(
                                  children: [
                                    TableCell(
                                      child: Center(
                                        child: Text(
                                            bill_details[index]['title'] ?? ""),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Text(
                                            (bill_details[index]['qty'] ?? "")
                                                .toString()),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Text((bill_details[index]
                                                    ['per_amount'] ??
                                                "")
                                            .toString()),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Text((bill_details[index]
                                                    ['sub_total'] ??
                                                "")
                                            .toString()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )

                  // Table(
                  //     border: TableBorder.all(),
                  //     children:  [

                  //       TableRow(
                  //         children: [
                  //           TableCell(
                  //             child: Center(
                  //               child: Text('1'),
                  //             ),
                  //           ),
                  //           TableCell(
                  //             child: Center(
                  //               child: Text('2'),
                  //             ),
                  //           ),
                  //           TableCell(
                  //             child: Center(
                  //               child: Text('3'),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
