// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/common_search_modal.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/logout.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features/account/user_profile_api.dart';
import 'package:job/src/features/auth/auth_api.dart';
import 'package:job/src/features1/account/edit_company_address.dart';
import 'package:job/src/features1/account/edit_company_details.dart';

class ProviderProfile extends StatefulWidget {
  const ProviderProfile({super.key});

  @override
  State<ProviderProfile> createState() => _ProviderProfileState();
}

class _ProviderProfileState extends State<ProviderProfile> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController mobileno = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController city = TextEditingController();

  TextEditingController country = TextEditingController();

  bool visiable = false;
  bool _imageLoading = false;
  bool isLoading = false;
  bool m_loading = false;

  var _image1;
  var _userResponse;
  File? _image;
  var _image_sr;
  var countryId;
  var _SCountry_code = "";

  var company_details;
  @override
  void initState() {
    // TODO: implement initState
    // print("profile");
    initilize();
    initilize1();
    super.initState();
  }

  initilize() {
    var UserResponse = PrefManager.read("UserResponse");
    print(UserResponse);
    setState(() {
      _image1 = UserResponse?['data']?['is_profile_image'];
      _userResponse = UserResponse?['data'];
    });
    stateUpdate();
  }

  initilize1() async {
    setState(() {
      m_loading = true;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var get_details = await AuthApi.getCompanyProfileDetails(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);

    if (get_details.success) {
      setState(() {
        // company_details = get_details.data['data'];
        if (get_details.data['data']?['companydetails'].length != 0) {
          company_details = get_details.data['data'];
        }
      });

      setState(() {
        m_loading = false;
      });

      print(company_details);
    }
  }

  Future _getImage() async {
    // final galleryPermissionGranted = await _requestGalleryPermission();

    // if (galleryPermissionGranted) {
    setState(() {
      _imageLoading = true;
    });
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _image_sr = pickedFile.path;
      });
      print(_image_sr);
      print(_userResponse);
      var data = {"user_id": _userResponse['id'], "profile_image": _image_sr};
      print(_userResponse);

      var result = await UserProfileApi.updateUserProfile(
          context, data, _userResponse['api_token']);
      print(result);
      if (result.success) {
        if (result.data['status'].toString() == "1") {
          print(result);
          await PrefManager.write("UserResponse", result.data);
          initilize();
        }
      }

      // var result = await Api.uploadImage(context, _image!,
      //     UserResponse['id'].toString(), UserResponse['api_token']);
      // if (result.success) {
      //   print(result.data);
      // } else {
      //   Snackbar.show("Faild", "logout");
      // }
    }
    setState(() {
      _imageLoading = false;
    });
  }

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
        }
        // s_Location = result;
      });
    }
  }

  stateUpdate() {
    var get_user_details = PrefManager.read("UserResponse");
    setState(() {
      mobileno.text = get_user_details['data']?['mobile'] ?? "";
      name.text = get_user_details['data']?['name'] ?? "";
      email.text = get_user_details['data']?['email'] ?? "";
      countryId = get_user_details['data']?['country_id'];
      city.text = get_user_details['data']?['is_district_name'] ?? "";
      country.text = get_user_details['data']?['is_country_name'] ?? "";
      print(country.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    // double ScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: AppTheme.primary,
      //   title: const Text("Profile",
      //       style: TextStyle(
      //         color: AppTheme.white,
      //       )),
      //   leading: IconButton(
      //       onPressed: () {
      //         Nav.back(context);
      //       },
      //       icon: const Icon(
      //         Icons.arrow_back_ios_new,
      //         color: AppTheme.white,
      //       )),
      // ),
      body: !m_loading
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: const Offset(0.2, 0.2),
                                blurRadius: 6.0)
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ClipOval(
                          //   child: Image.asset(
                          //     "assets/images/ellipse.png",
                          //     width: ScreenWidth * 0.17,
                          //   ),
                          // ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: company_details?['is_company_logo'] != null
                                ? Image.network(
                                    company_details['is_company_logo'],
                                    fit: BoxFit.cover,
                                    height: 60,
                                    width: 60, errorBuilder:
                                        (BuildContext context, Object exception,
                                            StackTrace? stackTrace) {
                                    // Handle the error here
                                    return const Center(
                                      child: Text('UnSupported Image'),
                                    );
                                  })
                                : Image.asset(
                                    "assets/icons/Profile.png",
                                    fit: BoxFit.cover,
                                    height: 60,
                                    width: 60,
                                  ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            // width: ScreenWidth * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      company_details?['companydetails']?[0]
                                              ?['company_name'] ??
                                          "Company Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          await Nav.to(
                                              context, EditCompnayDetails());
                                          initilize1();
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: AppTheme.primary,
                                        ))
                                  ],
                                ),
                                // Text(
                                //   "Social Media Assistant",
                                //   style: TextStyle(color: AppTheme.TextBoldLite),
                                // ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/email.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        company_details?['companydetails']?[0]
                                                ?['registered_email'] ??
                                            "Email",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/phone.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        company_details?['companydetails']?[0]
                                                ?['mobile_number'] ??
                                            "Mobile Number",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: const Offset(0.2, 0.2),
                                blurRadius: 6.0)
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Address 1",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await Nav.to(context, EditCompanyAddress());
                                    initilize1();
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: AppTheme.primary,
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            company_details?['companydetails']?[0]
                                    ?['address1'] ??
                                "Address 1",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Address 2",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            company_details?['companydetails']?[0]
                                    ?['address2'] ??
                                "Address 2",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/city.png",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                company_details?['is_district_name'] ??
                                    "District Name",
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/state.png",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                company_details?['is_state_name'] ??
                                    "State Name",
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/countries.png",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                company_details?['is_country_name'] ??
                                    "Country",
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: AppTheme.primary,
              ),
            ),
      // SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       const SizedBox(
      //         height: 20,
      //       ),
      //       SizedBox(
      //         width: double.infinity,
      //         child: Center(
      //           child: GestureDetector(
      //             onTap: () {
      //               // print("click");
      //               // Navigator.push(
      //               //     context,
      //               //     (MaterialPageRoute(
      //               //         builder: (context) => EditProfile())));
      //             },
      //             child: Stack(
      //               children: [
      //                 Container(
      //                     width: 100.0,
      //                     height: 100.0,
      //                     decoration: BoxDecoration(
      //                       shape: BoxShape.circle,
      //                       border: Border.all(
      //                         color: Colors.white,
      //                         width: 2.0,
      //                       ),
      //                     ),
      //                     child:
      //                         // !_imageLoading ?
      //                         //  Padding(
      //                         //    padding: const EdgeInsets.all(30.0),
      //                         //    child: CircularProgressIndicator(
      //                         //      strokeWidth: 3,
      //                         //      color: AppTheme.primary,
      //                         //    ),
      //                         //  )
      //                         //  :
      //                         _image1 != null
      //                             ? ClipOval(
      //                                 child: _imageLoading
      //                                     ? CircularProgressIndicator() // Show loader when _isLoading is true
      //                                     : FadeInImage(
      //                                         placeholder: const AssetImage(
      //                                             'assets/icons/Profile.png'),
      //                                         image: NetworkImage(_image1),
      //                                         fit: BoxFit.cover,
      //                                         width: 100.0,
      //                                         height: 100.0,
      //                                       ), // Show image when _isLoading is false
      //                               )
      //                             // ClipOval(
      //                             //     child: FadeInImage(
      //                             //       placeholder: const AssetImage(
      //                             //           'assets/icons/Profile.png'),
      //                             //       image: NetworkImage(_image1),
      //                             //       fit: BoxFit.cover,
      //                             //       width: 100.0,
      //                             //       height: 100.0,
      //                             //     ),
      //                             //   )
      //                             // CircleAvatar(
      //                             //     backgroundColor: Colors.white,
      //                             //     radius: 60,
      //                             //     backgroundImage: NetworkImage(_image1),
      //                             //   )
      //                             : const CircleAvatar(
      //                                 radius: 60,
      //                                 backgroundImage: AssetImage(
      //                                     "assets/icons/Profile.png'"),
      //                               )),
      //                 // Container(
      //                 //     decoration: BoxDecoration(
      //                 //       shape: BoxShape.circle,
      //                 //       border: Border.all(
      //                 //         color: Colors.white,
      //                 //         width: 2.0,
      //                 //       ),
      //                 //     ),
      //                 //     child: const CircleAvatar(
      //                 //       radius: 60,
      //                 //       backgroundImage:
      //                 //           AssetImage("assets/images/ellipse.png"),
      //                 //     )
      //                 //     // _image1 != null
      //                 //     //     ? CircleAvatar(
      //                 //     //         radius: 70,
      //                 //     //         backgroundImage: NetworkImage(_image1),
      //                 //     //       )
      //                 //     //     : _image == null
      //                 //     //         ? CircleAvatar(
      //                 //     //             radius: 70,
      //                 //     //             backgroundImage: AssetImage(
      //                 //     //                 "assets/images/slider1.png"),
      //                 //     //           )
      //                 //     //         : CircleAvatar(
      //                 //     //             radius: 70,
      //                 //     //             backgroundImage: FileImage(_image!),
      //                 //     //           ),
      //                 //     ),
      //                 Positioned(
      //                     bottom: 0,
      //                     right: 0,
      //                     child: InkWell(
      //                       splashColor: Colors.transparent,
      //                       highlightColor: Colors.transparent,
      //                       onTap: () {
      //                         _getImage();
      //                       },
      //                       child: SizedBox(
      //                         height: 40,
      //                         child: Image.asset("assets/icons/edit_dark.png"),
      //                       ),
      //                     ))
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(15.0),
      //         child: Form(
      //           key: _formKey,
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               const SizedBox(
      //                 height: 20,
      //               ),
      //               TextFormField(
      //                 // maxLength: 10,
      //                 controller: name,
      //                 validator: (value) {
      //                   if (value == null || value.isEmpty) {
      //                     return 'Please enter a name';
      //                   }
      //                   return null;
      //                 },
      //                 // keyboardType: TextInputType.phone,
      //                 decoration: InputDecoration(
      //                   counterText: '',
      //                   prefixIcon: Padding(
      //                     padding: const EdgeInsets.all(12.0),
      //                     child: Image.asset(
      //                       "assets/icons/person.png",
      //                       height: 20,
      //                       width: 20,
      //                     ),
      //                   ),
      //                   hintText: 'Name',
      //                 ),
      //               ),
      //               const SizedBox(
      //                 height: 20,
      //               ),
      //               TextFormField(
      //                 // maxLength: 10,
      //                 readOnly: true,
      //                 controller: mobileno,
      //                 // validator: Validate.mobile,
      //                 // keyboardType: TextInputType.phone,
      //                 decoration: InputDecoration(
      //                   counterText: '',
      //                   prefixIcon: Padding(
      //                     padding: const EdgeInsets.all(12.0),
      //                     child: Image.asset(
      //                       "assets/icons/phone.png",
      //                       height: 20,
      //                       width: 20,
      //                     ),
      //                   ),
      //                   hintText: 'Mobile Number',
      //                   // labelText: "Password"
      //                 ),
      //               ),
      //               const SizedBox(
      //                 height: 20,
      //               ),
      //               TextFormField(
      //                 // maxLength: 10,
      //                 readOnly: true,
      //                 controller: email,
      //                 // validator: Validate.email,
      //                 // keyboardType: TextInputType.phone,
      //                 decoration: InputDecoration(
      //                   counterText: '',
      //                   prefixIcon: Padding(
      //                     padding: const EdgeInsets.all(12.0),
      //                     child: Image.asset(
      //                       "assets/icons/email.png",
      //                       height: 20,
      //                       width: 20,
      //                     ),
      //                   ),
      //                   hintText: 'Email Address',
      //                   // labelText: "Password"
      //                 ),
      //               ),
      //               const SizedBox(
      //                 height: 20,
      //               ),
      //               TextFormField(
      //                 // maxLength: 10,aa
      //                 readOnly: true,
      //                 controller: country,
      //                 onTap: () async {
      //                   print("Success");
      //                   // final result = _SelectModal("", "", "country");
      //                   final result = _SelectModal1([], "country");
      //                 },
      //                 validator: (value) {
      //                   if (value == null || value.isEmpty) {
      //                     return 'Please Select Country';
      //                   }
      //                   return null;
      //                 },
      //                 decoration: InputDecoration(
      //                   counterText: '',
      //                   prefixIcon: Padding(
      //                     padding: const EdgeInsets.all(12.0),
      //                     child: Image.asset(
      //                       "assets/icons/countries.png",
      //                       height: 20,
      //                       width: 20,
      //                     ),
      //                   ),
      //                   suffixIcon: SizedBox(
      //                       width: 15,
      //                       height: 15,
      //                       child: Padding(
      //                         padding: const EdgeInsets.all(17.0),
      //                         child: Image.asset(
      //                           "assets/icons/down.png",
      //                           fit: BoxFit.contain,
      //                         ),
      //                       )),
      //                   hintText: 'Country',
      //                 ),
      //               ),
      //               // Container(
      //               //     decoration: BoxDecoration(
      //               //       color: Colors.white,
      //               //       borderRadius: BorderRadius.circular(10.0),
      //               //     ),
      //               //     child: DropdownButtonFormField(
      //               //       hint: const Text(
      //               //         'Country',
      //               //         style: TextStyle(fontSize: 14),
      //               //       ),
      //               //       icon: Padding(
      //               //         padding: const EdgeInsets.only(right: 10.0),
      //               //         child: Icon(
      //               //           Icons.keyboard_arrow_down,
      //               //           color: AppTheme.TextBoldLite,
      //               //           size: 25,
      //               //         ),
      //               //       ),
      //               //       decoration: InputDecoration(
      //               //         prefixIcon: Padding(
      //               //           padding: const EdgeInsets.all(12.0),
      //               //           child: Image.asset(
      //               //             "assets/icons/countries.png",
      //               //             height: 20,
      //               //             width: 20,
      //               //           ),
      //               //         ),
      //               //         enabledBorder: OutlineInputBorder(
      //               //             borderRadius: BorderRadius.circular(10),
      //               //             borderSide: BorderSide.none),
      //               //         focusedBorder: OutlineInputBorder(
      //               //             borderRadius: BorderRadius.circular(10),
      //               //             borderSide: BorderSide.none),
      //               //         border: OutlineInputBorder(
      //               //           borderRadius: BorderRadius.circular(10),
      //               //         ),
      //               //       ),
      //               //       onChanged: (value) {},
      //               //       items: ['Salem', 'Chennai', 'Perumpakkam']
      //               //           .map<DropdownMenuItem<String>>((item) {
      //               //         return DropdownMenuItem(
      //               //           value: item,
      //               //           child: Text(item),
      //               //         );
      //               //       }).toList(),
      //               //     )),
      //               // const SizedBox(
      //               //   height: 20,
      //               // ),
      //               // Container(
      //               //     decoration: BoxDecoration(
      //               //       color: Colors.white,
      //               //       borderRadius: BorderRadius.circular(10.0),
      //               //     ),
      //               //     child: DropdownButtonFormField(
      //               //       hint: const Text(
      //               //         'State',
      //               //         style: TextStyle(fontSize: 14),
      //               //       ),
      //               //       icon: Padding(
      //               //         padding: const EdgeInsets.only(right: 10.0),
      //               //         child: Icon(
      //               //           Icons.keyboard_arrow_down,
      //               //           color: AppTheme.TextBoldLite,
      //               //           size: 25,
      //               //         ),
      //               //       ),
      //               //       decoration: InputDecoration(
      //               //         prefixIcon: Padding(
      //               //           padding: const EdgeInsets.all(12.0),
      //               //           child: Image.asset(
      //               //             "assets/icons/state.png",
      //               //             height: 20,
      //               //             width: 20,
      //               //           ),
      //               //         ),
      //               //         enabledBorder: OutlineInputBorder(
      //               //             borderRadius: BorderRadius.circular(10),
      //               //             borderSide: BorderSide.none),
      //               //         focusedBorder: OutlineInputBorder(
      //               //             borderRadius: BorderRadius.circular(10),
      //               //             borderSide: BorderSide.none),
      //               //         border: OutlineInputBorder(
      //               //           borderRadius: BorderRadius.circular(10),
      //               //         ),
      //               //       ),
      //               //       onChanged: (value) {},
      //               //       items: ['Salem', 'Chennai', 'Perumpakkam']
      //               //           .map<DropdownMenuItem<String>>((item) {
      //               //         return DropdownMenuItem(
      //               //           value: item,
      //               //           child: Text(item),
      //               //         );
      //               //       }).toList(),
      //               //     )),
      //               // const SizedBox(
      //               //   height: 20,
      //               // ),
      //               // Container(
      //               //     decoration: BoxDecoration(
      //               //       color: Colors.white,
      //               //       borderRadius: BorderRadius.circular(10.0),
      //               //     ),
      //               //     child: DropdownButtonFormField(
      //               //       hint: const Text(
      //               //         'City',
      //               //         style: TextStyle(fontSize: 14),
      //               //       ),
      //               //       icon: Padding(
      //               //         padding: const EdgeInsets.only(right: 10.0),
      //               //         child: Icon(
      //               //           Icons.keyboard_arrow_down,
      //               //           color: AppTheme.TextBoldLite,
      //               //           size: 25,
      //               //         ),
      //               //       ),
      //               //       decoration: InputDecoration(
      //               //         prefixIcon: Padding(
      //               //           padding: const EdgeInsets.all(12.0),
      //               //           child: Image.asset(
      //               //             "assets/icons/city.png",
      //               //             height: 20,
      //               //             width: 20,
      //               //           ),
      //               //         ),
      //               //         enabledBorder: OutlineInputBorder(
      //               //             borderRadius: BorderRadius.circular(10),
      //               //             borderSide: BorderSide.none),
      //               //         focusedBorder: OutlineInputBorder(
      //               //             borderRadius: BorderRadius.circular(10),
      //               //             borderSide: BorderSide.none),
      //               //         // contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 20),
      //               //         border: OutlineInputBorder(
      //               //           borderRadius: BorderRadius.circular(10),
      //               //         ),
      //               //         //  filled: true,
      //               //         //  fillColor: Colors.greenAccent,
      //               //       ),
      //               //       onChanged: (value) {},
      //               //       items: ['Salem', 'Chennai', 'Perumpakkam']
      //               //           .map<DropdownMenuItem<String>>((item) {
      //               //         return DropdownMenuItem(
      //               //           value: item,
      //               //           child: Text(item),
      //               //         );
      //               //       }).toList(),
      //               //     )),
      //               const SizedBox(
      //                 height: 20,
      //               ),
      //               InkWell(
      //                 splashColor: Colors.transparent,
      //                 highlightColor: Colors.transparent,
      //                 onTap: () {
      //                   // Nav.to(context, EditJobPreference());
      //                 },
      //                 child: Container(
      //                   width: ScreenWidth,
      //                   height: 50,
      //                   decoration: BoxDecoration(
      //                       color: AppTheme.primary_light,
      //                       borderRadius: BorderRadius.circular(05)),
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       const Padding(
      //                         padding: EdgeInsets.only(left: 8.0),
      //                         child: Text(
      //                           "Company details ",
      //                           style: TextStyle(fontWeight: FontWeight.w600),
      //                         ),
      //                       ),
      //                       IconButton(
      //                           onPressed: () {
      //                             Nav.to(context, EditCompnayDetails());
      //                           },
      //                           icon: Icon(
      //                             Icons.edit,
      //                             color: AppTheme.primary,
      //                           ))
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               const SizedBox(
      //                 height: 20,
      //               ),
      //               InkWell(
      //                 splashColor: Colors.transparent,
      //                 highlightColor: Colors.transparent,
      //                 onTap: () {
      //                   // Nav.to(context, EditJobPreference());
      //                 },
      //                 child: Container(
      //                   width: ScreenWidth,
      //                   height: 50,
      //                   decoration: BoxDecoration(
      //                       color: AppTheme.primary_light,
      //                       borderRadius: BorderRadius.circular(05)),
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       const Padding(
      //                         padding: EdgeInsets.only(left: 8.0),
      //                         child: Text(
      //                           "Comapany address ",
      //                           style: TextStyle(fontWeight: FontWeight.w600),
      //                         ),
      //                       ),
      //                       IconButton(
      //                           onPressed: () {
      //                             Nav.to(context, EditCompanyAddress());
      //                           },
      //                           icon: Icon(
      //                             Icons.edit,
      //                             color: AppTheme.primary,
      //                           ))
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               const SizedBox(
      //                 height: 35,
      //               ),
      //               SizedBox(
      //                   width: ScreenWidth,
      //                   child: ElevatedButton(
      //                       onPressed: () async {
      //                         // if (_formKey.currentState!.validate()) {
      //                         //   var data = {
      //                         //     "email": email.text,
      //                         //     "password": mobileno.text,
      //                         //     "fcm_token": "fcm_token",
      //                         //     "device_id": "deviceid",
      //                         //     "device_type": "IOS"
      //                         //   };
      //                         //   print(data);
      //                         // } else {
      //                         //   // Form is invalid, do something accordingly
      //                         //   print('Form is invalid');
      //                         // }

      //                         if (_formKey.currentState!.validate()) {
      //                           if (isLoading == false) {
      //                             setState(() {
      //                               isLoading = true;
      //                             });

      //                             var data = {
      //                               "name": name.text,
      //                               "email": email.text,
      //                               "country_code": _SCountry_code,
      //                               "mobile": mobileno.text,
      //                               "password": "",
      //                               "device_type":
      //                                   _userResponse['user_source_from'] ?? "",
      //                               "device_id": "",
      //                               "fcm_token": "",
      //                               "user_id": _userResponse['id'] ?? ""
      //                             };
      //                             print(data);
      //                             var result = await AuthApi.ProviderSignup(
      //                                 context, data);
      //                             print(result);
      //                             if (result.success) {
      //                               if (result.data['status'].toString() ==
      //                                   "1") {
      //                                 if (result.data['message'] != null) {
      //                                   Snackbar.show(result.data['message'],
      //                                       Colors.black);
      //                                 } else {
      //                                   Snackbar.show("Some Error", Colors.red);
      //                                 }
      //                                 // PrefManager.write(
      //                                 //     "UserResponse", result.data);
      //                                 print(result.data);
      //                               } else if (result.data['message'] != null) {
      //                                 Snackbar.show(
      //                                     result.data['message'], Colors.black);
      //                               } else {
      //                                 Snackbar.show("Some Error", Colors.red);
      //                               }
      //                             }
      //                             setState(() {
      //                               isLoading = false;
      //                             });
      //                           }
      //                         } else {
      //                           // Form is invalid, do something accordingly
      //                           print('Form is invalid');
      //                         }
      //                       },
      //                       child: !isLoading
      //                           ? Text("Update Profile")
      //                           : Loader.common())),
      //               const SizedBox(
      //                 height: 20,
      //               ),
      //               TextFormField(
      //                 // controller: mobileno,
      //                 // enabled: false,
      //                 readOnly: true,
      //                 decoration: InputDecoration(
      //                     suffixIcon: IconButton(
      //                         onPressed: () async {
      //                           await Logout.logout(context, "logout");
      //                         },
      //                         icon: const Icon(
      //                           Icons.logout,
      //                           color: Colors.red,
      //                         )),
      //                     counterText: '',
      //                     hintText: 'Logout',
      //                     hintStyle: const TextStyle(color: Colors.red)),
      //               ),
      //               const SizedBox(
      //                 height: 20,
      //               ),
      //               // InkWell(
      //               //   onTap: () {
      //               //     Nav.to(context, const UpdateProfile1());
      //               //   },
      //               //   child: const Text("test"),
      //               // )
      //             ],
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
