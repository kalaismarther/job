// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, prefer_typing_uninitialized_variables, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/features/auth/auth_api.dart';
import 'package:job/src/features1/createpost/post_api.dart';

class CommonSearchModal extends StatefulWidget {
  const CommonSearchModal({super.key, required this.data, required this.type});

  final List data;
  final String type;

  @override
  State<CommonSearchModal> createState() => _CommonSearchModalState();
}

class _CommonSearchModalState extends State<CommonSearchModal> {
  TextEditingController _searchController = TextEditingController();

  //CONTROLLERS
  final _scrollController = ScrollController();

  bool isLoading = false;
  bool isSearch = false;
  bool noList = false;
  var msg;
  List list = [];
  var _userResponse;

  //FOR PAGINATION
  bool paginationLoader = false;
  int? pageNo;

  @override
  void initState() {
    // TODO: implement initState
    print(widget.type);
    setState(() {
      isLoading = true;
    });
    initilize();

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        if (pageNo != null && pageNo != list.length) {
          print(pageNo != list.length);
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
  }

  initilize() async {
    var UserResponse = PrefManager.read("UserResponse");

    setState(() {
      // isLoading = true;
      _userResponse = UserResponse;
    });

    if (widget.type == "qul") {
      setState(() {
        pageNo = list.length;
      });
      var qul_result = await AuthApi.GetQualification(
          context,
          UserResponse['data']['id'],
          "",
          list.length,
          UserResponse['data']['api_token']);
      if (qul_result.success) {
        setState(() {
          list.addAll(qul_result.data['data'] ?? []);
          if (list.isEmpty) {
            setState(() {
              noList = true;
            });
          }
          paginationLoader = false;
        });
      }
    } else if (widget.type == "specification") {
      setState(() {
        pageNo = list.length;
      });
      var spl_result = await AuthApi.GetSpecialisations(context,
          UserResponse['data']['id'], "", UserResponse['data']['api_token']);
      if (spl_result.success) {
        setState(() {
          list.addAll(spl_result.data['data'] ?? []);
          if (list.isEmpty) {
            setState(() {
              noList = true;
            });
          }
          paginationLoader = false;
        });
      }
    } else if (widget.type == "year") {
      var yr_result = await AuthApi.GetYears(context,
          UserResponse['data']['id'], UserResponse['data']['api_token']);
      if (yr_result.success) {
        setState(() {
          list.addAll(yr_result.data['data']);
        });
      }
    } else if (widget.type == "country") {
      setState(() {
        pageNo = list.length;
      });
      var data = {"search": "", "page_no": list.length};
      var get_countries = await AuthApi.getCountry(context, data);
      print(get_countries.data);
      _success1(get_countries);
    } else if (widget.type == "state") {
      setState(() {
        pageNo = list.length;
      });
      var get_states = await AuthApi.getStates(context,
          {"country_id": widget.data[0]['country_id'], "page_no": list.length});

      if (get_states.success) {
        setState(() {
          list.addAll(get_states.data['data'] ?? []);
          if (list.isEmpty) {
            setState(() {
              noList = true;
            });
          }
          paginationLoader = false;
        });
      }
    } else if (widget.type == "district" || widget.type == "district_edit") {
      setState(() {
        pageNo = list.length;
      });

      var get_city = await AuthApi.getCity(context, {
        "state_id": widget.data.isNotEmpty ? (widget.data[0]?['id'] ?? 0) : 0,
        "search": "",
        "page_no": list.length
      });

      if (get_city.success) {
        setState(() {
          list.addAll(get_city.data['data'] ?? []);
          if (list.isEmpty) {
            setState(() {
              noList = true;
            });
          }
          paginationLoader = false;
        });
      }
    } else if (widget.type == "start_year" || widget.type == "end_year") {
      setState(() {
        list.addAll(widget.data);
      });
    } else if (widget.type == "start_month" || widget.type == "end_month") {
      setState(() {
        pageNo = list.length;
      });
      setState(() {
        list.addAll(widget.data);
      });
    } else if (widget.type == "currency") {
      setState(() {
        pageNo = list.length;
      });
      var get_currency = await PostApi.getCurrency(
          context,
          UserResponse['data']['id'],
          "",
          list.length,
          UserResponse['data']['api_token']);
      if (get_currency.success) {
        setState(() {
          list.addAll(get_currency.data['data'] ?? []);
          if (list.isEmpty) {
            setState(() {
              noList = true;
            });
          }
          paginationLoader = false;
        });
      }
    } else if (widget.type == "notice_period") {
      setState(() {
        list.addAll(widget.data);
      });
    } else if (widget.type == "depart") {
      setState(() {
        pageNo = list.length;
      });
      var get_jobCat = await AuthApi.GetDepartments(
          context,
          UserResponse['data']['id'],
          "",
          list.length,
          UserResponse['data']['api_token']);
      if (get_jobCat.success) {
        setState(() {
          list.addAll(get_jobCat.data['data'] ?? []);
          if (list.isEmpty) {
            setState(() {
              noList = true;
            });
          }
          paginationLoader = false;
        });
      }
    } else if (widget.type == "job_level") {
      setState(() {
        pageNo = list.length;
      });
      var get_jobLevel = await PostApi.getJobLevel(context,
          UserResponse['data']['id'], UserResponse['data']['api_token']);
      if (get_jobLevel.success) {
        setState(() {
          list.addAll(get_jobLevel.data['data'] ?? []);
          if (list.isEmpty) {
            setState(() {
              noList = true;
            });
          }
          paginationLoader = false;
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  _search() async {
    setState(() {
      isSearch = true;
    });
    if (widget.type == "district" || widget.type == "district_edit") {
      setState(() {
        pageNo = list.length;
      });
      var data = {
        "state_id": widget.data.isNotEmpty ? (widget.data[0]?['id'] ?? 0) : 0,
        "search": _searchController.text,
        "page_no": list.length
      };

      final response = await AuthApi.getCity(context, data);
      _success(response);
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

    if (widget.type == "specification") {
      setState(() {
        pageNo = list.length;
      });
      var spl_result = await AuthApi.GetSpecialisations(
          context,
          _userResponse['data']['id'],
          _searchController.text,
          _userResponse['data']['api_token']);
      _success(spl_result);
    }

    if (widget.type == "currency") {
      setState(() {
        pageNo = list.length;
      });
      var get_currency = await PostApi.getCurrency(
          context,
          _userResponse['data']['id'],
          _searchController.text,
          list.length,
          _userResponse['data']['api_token']);
      _success(get_currency);
    }
    if (widget.type == "depart") {
      setState(() {
        pageNo = list.length;
      });
      var get_jobCat = await AuthApi.GetDepartments(
          context,
          _userResponse['data']['id'],
          _searchController.text,
          list.length,
          _userResponse['data']['api_token']);
      _success(get_jobCat);
    }

    if (widget.type == "country") {
      setState(() {
        pageNo = list.length;
      });
      var data = {"search": _searchController.text, "page_no": list.length};
      var get_countries = await AuthApi.getCountry(context, data);
      _success(get_countries);
    }
    if (widget.type == "state") {
      setState(() {
        pageNo = list.length;
      });
      var get_states = await AuthApi.getStates(context, {
        "country_id": widget.data[0]['country_id'],
        "search": _searchController.text,
        "page_no": list.length
      });
      _success(get_states);
    }
  }

  _success1(response) {
    if (response.success) {
      if (response.data['status'].toString() == "1") {
        // if (response.data['search'] == _searchController.text) {
        setState(() {
          list.addAll(response.data['data'] ?? []);
          paginationLoader = false;
          isSearch = false;
          noList = false;
        });
        // }
      } else {
        setState(() {
          noList = true;
          paginationLoader = false;
          response.data['message'] != null
              ? msg = response.data['message']
              : "No List";
        });
      }
    }
  }

  _success(response) {
    print(response.data);
    if (response.success) {
      if (response.data['status'].toString() == "1") {
        if (response.data['search'] == _searchController.text ||
            response.data['search'] == null) {
          setState(() {
            list.addAll(response.data['data'] ?? []);
            paginationLoader = false;
            isSearch = false;
            noList = false;
          });
        }
      } else {
        setState(() {
          list.addAll(response.data['data'] ?? []);
          if (list.isEmpty) {
            setState(() {
              noList = true;
            });
          }
          paginationLoader = false;
          response.data['message'] != null
              ? msg = response.data['message']
              : "No List";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                widget.type == "district" ||
                        widget.type == "qul" ||
                        widget.type == "specification" ||
                        widget.type == "district_edit" ||
                        widget.type == "currency" ||
                        widget.type == "depart" ||
                        widget.type == "country" ||
                        widget.type == "state"
                    ? Column(
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
                            height: 10,
                          ),
                        ],
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                Expanded(
                  child: !noList
                      ? ListView.builder(
                          controller: _scrollController,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final data = list[index];
                            return InkWell(
                              // highlightColor: Colors.red,
                              onTap: () {
                                print(data['id']);
                                Nav.back(context, data);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: widget.type == "qul"
                                    ? Text(data['qualification'])
                                    : widget.type == "specification"
                                        ? Text(data['specialise_name'])
                                        : widget.type == "district" ||
                                                widget.type == "district_edit"
                                            ? Text(data['district_name'])
                                            : widget.type == "country"
                                                ? Text(data['name'])
                                                : widget.type == "state"
                                                    ? Text(data['state_name'])
                                                    : widget.type ==
                                                                "start_year" ||
                                                            widget.type ==
                                                                "end_year"
                                                        ? Text(data.toString())
                                                        : widget.type ==
                                                                    "start_month" ||
                                                                widget.type ==
                                                                    "end_month"
                                                            ? Text(
                                                                data['month'])
                                                            : widget.type ==
                                                                    "currency"
                                                                ? Text(
                                                                    "${data['currency']} - ${data['name']}")
                                                                : widget.type ==
                                                                        "notice_period"
                                                                    ? Text(data[
                                                                        'month'])
                                                                    : widget.type ==
                                                                            "depart"
                                                                        ? Text(data[
                                                                            'department_name'])
                                                                        : widget.type ==
                                                                                "job_level"
                                                                            ? Text(data['job_level'])
                                                                            : Text(data['year'].toString()),
                              ),
                            );
                          })
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
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
