// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, prefer_final_fields, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features/auth/auth_api.dart';

class CommonMultiSelect extends StatefulWidget {
  const CommonMultiSelect(
      {super.key,
      required this.data,
      required this.type,
      required this.s_list});
  final List data;
  final List s_list;
  final String type;

  @override
  State<CommonMultiSelect> createState() => _CommonMultiSelectState();
}

class _CommonMultiSelectState extends State<CommonMultiSelect> {
  TextEditingController _searchController = TextEditingController();

  //CONTROLLERS
  final _scrollController = ScrollController();

  //FOR PAGINATION
  int? pageNo;

  //FOR LOADER
  bool paginationLoader = false;

  bool isLoading = false;
  bool isSearch = false;
  bool noList = false;
  var msg;
  List list = [];
  List slist = [];
  var _userResponse;

  @override
  void initState() {
    // TODO: implement initState
    print(widget.type);
    initilize();
    setState(() {
      isLoading = true;
    });
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        if (pageNo != null && pageNo != list.length) {
          setState(() {
            paginationLoader = true;
          });
          if (_searchController.text.isEmpty) {
            initilize();
          } else {
            _search();
          }
        }
      }
    });
    super.initState();
    slist = widget.s_list;
  }

  // //FOR SCROLL
  // void scrollFunc(String type) {

  // }

  initilize() async {
    var UserResponse = PrefManager.read("UserResponse");

    setState(() {
      // isLoading = true;
      _userResponse = UserResponse;
    });

    if (widget.type == "") {
      setState(() {
        pageNo = list.length;
      });
      var get_skills = await AuthApi.GetSkills(
          context,
          UserResponse['data']['id'],
          "",
          list.length,
          UserResponse['data']['api_token']);
      if (get_skills.success) {
        setState(() {
          list.addAll(get_skills.data['data'] ?? []);
          isLoading = false;
          if (list.isEmpty) {
            setState(() {
              noList = true;
            });
          }
          paginationLoader = false;
        });
      }
    } else if (widget.type == "industry") {
      setState(() {
        pageNo = list.length;
      });
      var get_industries = await AuthApi.GetIndustried(
          context,
          UserResponse['data']['id'],
          "",
          list.length,
          UserResponse['data']['api_token']);
      if (get_industries.success) {
        setState(() {
          list.addAll(get_industries.data['data'] ?? []);
          isLoading = false;
          if (list.isEmpty) {
            setState(() {
              noList = true;
            });
          }
          paginationLoader = false;
        });
      }
    } else if (widget.type == "depart") {
      setState(() {
        pageNo = list.length;
      });
      var get_departments = await AuthApi.GetDepartments(
          context,
          UserResponse['data']['id'],
          "",
          list.length,
          UserResponse['data']['api_token']);
      if (get_departments.success) {
        setState(() {
          list.addAll(get_departments.data['data'] ?? []);
          isLoading = false;
          if (list.isEmpty) {
            setState(() {
              noList = true;
            });
          }
          paginationLoader = false;
        });
      }
    } else if (widget.type == "preffered") {
      setState(() {
        pageNo = list.length;
      });
      var get_preferred_roles = await AuthApi.GetPreferredRole(context,
          UserResponse['data']['id'], "", UserResponse['data']['api_token']);
      print(get_preferred_roles.data);
      if (get_preferred_roles.success) {
        setState(() {
          list.addAll(get_preferred_roles.data['data']);
          isLoading = false;
          if (list.isEmpty) {
            setState(() {
              noList = true;
            });
          }
          paginationLoader = false;
        });
      }
    } else if (widget.type == "p_country") {
      setState(() {
        pageNo = list.length;
      });
      var data = {"search": "", "page_no": pageNo};
      var get_preferred_roles = await AuthApi.getCountry(context, data);
      if (get_preferred_roles.success) {
        setState(() {
          list.addAll(get_preferred_roles.data['data'] ?? []);
          isLoading = false;
          if (list.isEmpty) {
            setState(() {
              noList = true;
            });
          }
          paginationLoader = false;
        });
      }
    } else if (widget.type == "keywords") {
      setState(() {
        pageNo = list.length;
      });
      var get_keywords = await AuthApi.getKeywords(
          context,
          UserResponse['data']['id'],
          '',
          list.length,
          UserResponse['data']['api_token']);
      if (get_keywords.success) {
        setState(() {
          list.addAll(get_keywords.data['data'] ?? []);
          isLoading = false;
          if (list.isEmpty) {
            setState(() {
              noList = true;
            });
          }
          paginationLoader = false;
        });
      }
    } else if (widget.type == "qul") {
      print('object');
      setState(() {
        pageNo = list.length;
      });
      var qulResult = await AuthApi.GetQualification(
          context,
          _userResponse['data']['id'],
          "",
          pageNo,
          _userResponse['data']['api_token']);
      if (qulResult.success) {
        setState(() {
          list.addAll(qulResult.data['data'] ?? []);
          isLoading = false;
          if (list.isEmpty) {
            setState(() {
              noList = true;
            });
          }
          paginationLoader = false;
        });
      }
    } else if (widget.type == "p_location") {
      print(widget.data);
      setState(() {
        pageNo = list.length;
      });
      var data = {
        "state_id": 0,
        "search": "",
        "page_no": list.length,
        "country_id": widget.data.isNotEmpty ? (widget.data) : []
      };

      var get_city = await AuthApi.getCity(context, data);

      if (get_city.success) {
        setState(() {
          isLoading = false;

          list.addAll(get_city.data['data'] ?? []);
          if (list.isEmpty) {
            setState(() {
              noList = true;
            });
          }
          paginationLoader = false;
        });
      }
    }
    //  else if (widget.type == "p_location") {
    //   var data = await {"state_id": 0, "search": ""};

    //   final get_city = await AuthApi.getCity(context, data);
    //   if (get_city.success) {
    //     setState(() {
    //       list.addAll(get_city.data['data']);
    //     });
    //   }
    // }
    check();
    setState(() {
      isLoading = false;
    });
  }

  check() async {
    widget.type == "" || widget.type == 'keywords'
        ? slist = slist.map((selected) {
            int index = list.indexWhere(
                (district) => district["skill_name"] == selected["skill_name"]);
            return (index != -1 && index < list.length)
                ? list[index]
                : selected;
          }).toList()
        : slist = slist.map((selected) {
            int index =
                list.indexWhere((district) => district["id"] == selected["id"]);
            return (index != -1 && index < list.length)
                ? list[index]
                : selected;
          }).toList();
  }

  _search() async {
    setState(() {
      isSearch = true;
    });
    if (widget.type == "") {
      setState(() {
        pageNo = list.length;
      });
      var get_skills = await AuthApi.GetSkills(
          context,
          _userResponse['data']['id'],
          _searchController.text,
          list.length,
          _userResponse['data']['api_token']);
      _success(get_skills);
    }
    if (widget.type == "industry") {
      setState(() {
        pageNo = list.length;
      });
      var get_industries = await AuthApi.GetIndustried(
          context,
          _userResponse['data']['id'],
          _searchController.text,
          list.length,
          _userResponse['data']['api_token']);
      _success(get_industries);
    }

    if (widget.type == "depart") {
      setState(() {
        pageNo = list.length;
      });
      var get_departments = await AuthApi.GetDepartments(
          context,
          _userResponse['data']['id'],
          _searchController.text,
          list.length,
          _userResponse['data']['api_token']);
      _success(get_departments);
    }
    if (widget.type == "preffered") {
      setState(() {
        pageNo = list.length;
      });
      var get_preferred_roles = await AuthApi.GetPreferredRole(
          context,
          _userResponse['data']['id'],
          _searchController.text,
          _userResponse['data']['api_token']);
      _success(get_preferred_roles);
    }
    if (widget.type == "p_location") {
      setState(() {
        pageNo = list.length;
      });
      var data = {
        "state_id": 0,
        "search": _searchController.text,
        "page_no": list.length,
        "country_id": widget.data.isNotEmpty ? (widget.data[0] ?? "") : ""
      };

      var get_city = await AuthApi.getCity(context, data);
      _success(get_city);
    }
    if (widget.type == "qul") {
      setState(() {
        pageNo = list.length;
      });
      var qulResult = await AuthApi.GetQualification(
          context,
          _userResponse['data']['id'],
          _searchController.text,
          list.length,
          _userResponse['data']['api_token']);
      _success(qulResult);
    }
    if (widget.type == 'keywords') {
      setState(() {
        pageNo = list.length;
      });
      var keywordsResult = await AuthApi.getKeywords(
          context,
          _userResponse['data']['id'],
          _searchController.text,
          list.length,
          _userResponse['data']['api_token']);
      _success(keywordsResult);
    }
    if (widget.type == "p_country") {
      setState(() {
        pageNo = list.length;
      });
      var data = {
        "state_id": 0,
        "search": _searchController.text,
        "page_no": list.length
      };
      var get_countries = await AuthApi.getCountry(context, data);
      _success(get_countries);
    }
    if (widget.type == "") {
      setState(() {
        pageNo = list.length;
      });
      var qulResult = await AuthApi.GetQualification(
          context,
          _userResponse['data']['id'],
          _searchController.text,
          list.length,
          _userResponse['data']['api_token']);
      _success(qulResult);
    }
  }

  _success(response) {
    if (response.success) {
      print(response.data);
      if (response.data['status'].toString() == "1") {
        if (response.data['search'] == _searchController.text ||
            response.data['search'] == null) {
          setState(() {
            list.addAll(response.data['data'] ?? []);
            paginationLoader = false;
            isSearch = false;
            noList = false;
          });
          check();
        }
      } else {
        setState(() {
          noList = false;
          paginationLoader = false;
          list.addAll(response.data['data'] ?? []);
          response.data['message'] != null
              ? msg = response.data['message']
              : "No List";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    return !isLoading
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    TextFormField(
                      onChanged: (value) async {
                        list.clear();
                        _search();
                      },
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: widget.type == "district"
                            ? "Search District Name"
                            : "Search",
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: !noList
                      ? ListView.builder(
                          itemCount: list.length,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              title: widget.type == "industry"
                                  ? Text(list[index]["industry_name"])
                                  : widget.type == "depart"
                                      ? Text(list[index]["department_name"])
                                      : widget.type == "preffered"
                                          ? Text(list[index]["role_name"])
                                          : widget.type == "p_location"
                                              ? Text(
                                                  list[index]["district_name"])
                                              : widget.type == "p_country"
                                                  ? Text(list[index]["name"])
                                                  : widget.type == "qul"
                                                      ? Text(list[index]
                                                          ['qualification'])
                                                      : Text(list[index]
                                                          ["skill_name"]),
                              value: slist.contains(list[index]),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value!) {
                                    slist.add(list[index]);
                                  } else {
                                    slist.remove(list[index]);
                                  }
                                });
                              },
                            );
                          },
                        )
                      : Center(child: Text(msg ?? "")),
                ),
                paginationLoader
                    ? const Center(
                        child: SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator()),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: list.length,
                //     itemBuilder: (context, index) {
                //       return CheckboxListTile(
                //         title: widget.type == "industry"
                //             ? Text(districts[index]["industry_name"])
                //             : widget.type == "depart"
                //                 ? Text(districts[index]["department_name"])
                //                 : widget.type == "preffered"
                //                     ? Text(districts[index]["role_name"])
                //                     : Text(districts[index]["skill_name"]),
                //         value: selectedDistricts.contains(districts[index]),
                //         onChanged: (bool? value) {
                //           setState(() {
                //             if (value!) {
                //               selectedDistricts.add(districts[index]);
                //             } else {
                //               selectedDistricts.remove(districts[index]);
                //             }
                //           });
                //         },
                //       );
                //     },
                //   ),
                // ),
                SizedBox(
                  width: ScreenWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Nav.back(context, slist);
                        // print(slist);
                      },
                      child: Text("Continue"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
