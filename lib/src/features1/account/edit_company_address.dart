import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/common_search_modal.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features/auth/auth_api.dart';

class EditCompanyAddress extends StatefulWidget {
  const EditCompanyAddress({super.key});

  @override
  State<EditCompanyAddress> createState() => _EditCompanyAddressState();
}

class _EditCompanyAddressState extends State<EditCompanyAddress> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController zipcode = TextEditingController();

  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();

  bool acceptTerms = false;

  bool cityLoad = false;
  bool stateLoad = false;
  bool isLoading = false;
  var countryId;
  var stateId;
  var districtId;
  var _SCountry_code = "";

  // <kalai>
  bool centerLoader = false;
  // </kalai>

  void _SelectModal1(data, type) async {
    final result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CommonSearchModal(data: data, type: type);
        });

    if (result != null) {
      setState(() {
        if (type == "country") {
          country.text = result['name'] ?? "";
          countryId = result['id'] ?? "";
          _SCountry_code = result['phonecode'].toString();
          state.text = "";
          city.text = "";
          districtId = "";
          stateId = "";
          stateLoad = true;
          cityLoad = false;
        } else if (type == "state") {
          state.text = result['state_name'] ?? "";
          stateId = result['id'] ?? "";
          districtId = "";
          city.text = "";
          cityLoad = true;
        } else {
          city.text = result['district_name'] ?? "";
          districtId = result['id'] ?? "";
        }
        // s_Location = result;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initilize();
    super.initState();
  }

  initilize() async {
    setState(() {
      centerLoader = true;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var get_details = await AuthApi.getCompanyProfileDetails(
      context,
      UserResponse['data']['id'],
      UserResponse['data']['api_token'],
    );

    print(get_details.data['data']);

    // <kalai>
    if (get_details.success) {
      if (get_details.data['data']?['companydetails'].length != 0) {
        if (get_details.data['data']['companydetails'] != null ||
            get_details.data['data']['companydetails'].isNotEmpty) {
          address1.text =
              get_details.data['data']['companydetails'][0]['address1'] ?? '';
          address2.text =
              get_details.data['data']['companydetails'][0]['address2'] ?? '';
          country.text = get_details.data['data']['is_country_name'] ?? '';
          state.text = get_details.data['data']['is_state_name'] ?? '';
          city.text = get_details.data['data']['is_district_name'] ?? '';
          zipcode.text =
              get_details.data['data']['companydetails'][0]['pincode'] ?? '';
          countryId =
              get_details.data['data']?['companydetails']?[0]?['country_id'];
          stateId =
              get_details.data['data']?['companydetails']?[0]?['state_id'];
          districtId =
              get_details.data['data']?['companydetails']?[0]?['district_id'];
          setState(() {
            // country.text = CommonSearchModal(data: [], type: "country");
            centerLoader = false;
          });
        } else {
          setState(() {
            centerLoader = false;
          });
          return;
        }
      }
    }
    setState(() {
      centerLoader = false;
    });
    // </kalai>
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(),
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text("Edit Company Address",
            style: TextStyle(color: AppTheme.white, fontSize: 18)),
        leading: IconButton(
            onPressed: () {
              Nav.back(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme.white,
            )),
      ),
      body:
          //<kalai>
          centerLoader
              ? Center(
                  child: SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ) //   < /kalai>
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Address 1"),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: address1,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Address';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  counterText: '',
                                  hintText: 'Enter Address',
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text("Address 2"),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: address2,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Address';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  counterText: '',
                                  hintText: 'Enter Address',
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text("Country"),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                // maxLength: 10,aa
                                readOnly: true,
                                controller: country,
                                onTap: () async {
                                  print("Success");
                                  // final result = _SelectModal("", "", "country");
                                  final result = _SelectModal1([], "country");
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Select Country';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  counterText: '',
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(
                                      "assets/icons/countries.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  suffixIcon: SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: Padding(
                                        padding: const EdgeInsets.all(17.0),
                                        child: Image.asset(
                                          "assets/icons/down.png",
                                          fit: BoxFit.contain,
                                        ),
                                      )),
                                  hintText: 'Country',
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text("State"),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                maxLength: 10,
                                readOnly: true,
                                controller: state,
                                onTap: () {
                                  // if (!stateLoad) {
                                  //   Snackbar.show(
                                  //       "Please Select Country", Colors.black);
                                  // } else {
                                  //   _SelectModal1([
                                  //     {"country_id": countryId.toString()}
                                  //   ], "state");
                                  // }
                                  if (countryId != null && countryId != "") {
                                    _SelectModal1([
                                      {"country_id": countryId.toString()}
                                    ], "state");
                                  } else {
                                    Snackbar.show(
                                        "Please Select Country", Colors.black);
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Selet State';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  counterText: '',
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(
                                      "assets/icons/state.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  suffixIcon: SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: Padding(
                                        padding: const EdgeInsets.all(17.0),
                                        child: Image.asset(
                                          "assets/icons/down.png",
                                          fit: BoxFit.contain,
                                        ),
                                      )),
                                  hintText: 'State',
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text("City"),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                maxLength: 10,
                                readOnly: true,
                                controller: city,
                                onTap: () {
                                  // if (stateId == null ||
                                  //     stateId == "" ||
                                  //     !cityLoad) {
                                  //   Snackbar.show(
                                  //       "Please Select State", Colors.black);
                                  // } else {
                                  //   _SelectModal1([
                                  //     {"id": stateId.toString()}
                                  //   ], "district_edit");
                                  // }

                                  if (stateId != null && stateId != "") {
                                    _SelectModal1([
                                      {"id": stateId.toString()}
                                    ], "district_edit");
                                  } else {
                                    Snackbar.show(
                                        "Please Select State", Colors.black);
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Select City';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  counterText: '',
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(
                                      "assets/icons/city.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  suffixIcon: SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: Padding(
                                        padding: const EdgeInsets.all(17.0),
                                        child: Image.asset(
                                          "assets/icons/down.png",
                                          fit: BoxFit.contain,
                                        ),
                                      )),
                                  hintText: 'City',
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text("Zip Code"),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                maxLength: 10,
                                controller: zipcode,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter zip code';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  counterText: '',
                                  hintText: 'Enter Zip Code',
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                  width: ScreenWidth,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        // if (_formKey.currentState!.validate()) {
                                        //   var data = {
                                        //     "email": email.text,
                                        //     "password": mobileno.text,
                                        //     "fcm_token": "fcm_token",
                                        //     "device_id": "deviceid",
                                        //     "device_type": "IOS"
                                        //   };
                                        //   print(data);
                                        // } else {
                                        //   // Form is invalid, do something accordingly
                                        //   print('Form is invalid');
                                        // }
                                        // Nav.to(context, ProviderDashboard());

                                        if (isLoading == false) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          if (_formKey.currentState!
                                              .validate()) {
                                            var UserResponse = PrefManager.read(
                                                "UserResponse");
                                            var data = {
                                              "user_id": UserResponse['data']
                                                  ['id'],
                                              "address1": address1.text,
                                              "address2": address2.text,
                                              "country_id": countryId,
                                              "state_id": stateId,
                                              "district_id": districtId,
                                              // "country_id": _SCountry,
                                              // "state_id": _SState,
                                              // "district_id": _SCity,
                                              "pincode": zipcode.text
                                            };
                                            print(data);

                                            var result = await AuthApi
                                                .UpdateCompanyAddress(
                                                    context,
                                                    data,
                                                    UserResponse['data']
                                                        ['api_token']);

                                            if (result.success) {
                                              if (result.data['status']
                                                      .toString() ==
                                                  "1") {
                                                if (result.data['message'] !=
                                                    null) {
                                                  Snackbar.show(
                                                      result.data['message'],
                                                      Colors.green);
                                                } else {
                                                  Snackbar.show("Successfully",
                                                      Colors.green);
                                                }
                                                PrefManager.write(
                                                    "company_status",
                                                    result
                                                        .data['company_status']
                                                        .toString());
                                                Nav.back(context);
                                              } else if (result
                                                      .data['message'] !=
                                                  null) {
                                                Snackbar.show(
                                                    result.data['message'],
                                                    Colors.black);
                                              } else {
                                                Snackbar.show(
                                                    "Some Error", Colors.red);
                                              }
                                            } else {
                                              Snackbar.show(
                                                  "Some Error", Colors.red);
                                            }
                                            // }
                                          }
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      },
                                      child: !isLoading
                                          ? const Text("Submit")
                                          : Loader.common())),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
