// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/features/jobs/user_job_api.dart';
import 'package:job/src/features/jobs/views/job_details.dart';

class UserSearchFilter extends StatefulWidget {
  const UserSearchFilter({super.key, required this.getskill});

  final String getskill;

  @override
  State<UserSearchFilter> createState() => _UserSearchFilterState();
}

class _UserSearchFilterState extends State<UserSearchFilter> {
  final List<Map<String, dynamic>> filterValues = [
    {"id": 1, "name": "BE"},
    {"id": 2, "name": "MCA"},
    {"id": 3, "name": "MBA"},
    {"id": 4, "name": "M-Tech"},
    {"id": 1, "name": "BE"},
    {"id": 2, "name": "MCA"},
    {"id": 3, "name": "MBA"},
    {"id": 4, "name": "M-Tech"},
    {"id": 1, "name": "BE"},
    {"id": 2, "name": "MCA"},
    {"id": 3, "name": "MBA"},
    {"id": 4, "name": "M-Tech"},
  ];
  TextEditingController _searchController = TextEditingController();

  bool isLoading = false;
  bool page_loading = false;

  bool focus_node = true;
  bool auto_focus = true;

  List searchlist = [];
  List filterList = [];
  Map selectedFilters = {};
  FocusNode _focusNode = FocusNode();

  final controller = ScrollController();

  var page_no;

  void _showModal() async {
    var result = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: FilterModal(
              filters: filterList,
              selectedFilters: selectedFilters,
              onFiltersSelected: (values) {
                setState(() {
                  selectedFilters = values;
                });
                initilize(selectedFilters, "");
              },
            ),
            //  FilterSelectionScreen(
            //   filters: filterList,
            //   selectedFilters: selectedFilters,
            //   onFiltersSelected: (values) {
            //     setState(() {
            //       selectedFilters = values;
            //     });
            //     initilize(selectedFilters, "");
            //   },
            // ),
          );
        });
  }

  void scrollEvent() {
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        if (page_no != null && page_no != searchlist.length) {
          initilize(selectedFilters, "scroll");
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    initilize([], "");
    scrollEvent();
    super.initState();
  }

  initilize(filter, type) async {
    setState(() {
      if (widget.getskill != "") {
        _searchController.text = widget.getskill;
//  _focusNode.unfocus();
        auto_focus = false;
      }

      type == "scroll" ? page_loading = true : isLoading = true;
      page_no = searchlist.length;
      if (type != "scroll") {
        searchlist.clear();
      }
    });

    final output = filter.length > 0
        ? filter.entries.map((entry) {
            return {entry.key: entry.value};
          }).toList()
        : [];
    var UserResponse = PrefManager.read("UserResponse");
    var data = {
      "user_id": UserResponse['data']['id'],
      "page_no": searchlist.length,
      "search": _searchController.text,
      "filter": output
    };
    print(data);
    print(output);
    var search_result = await UserJobApi.getAllJobs(
        context, data, UserResponse['data']['api_token']);
    print(search_result);
    // setState(() {
    if (search_result.success) {
      if (search_result.data['status']?.toString() == "1") {
        // latest = lat_result.data['data'];
        // searchlist.clear();
        setState(() {
          searchlist.addAll(search_result.data['data'] ?? []);
        });
        if (filter.length == 0) {
          await getuserFilter();
        }
      }
    }
    setState(() {
      type == "scroll" ? page_loading = false : isLoading = false;
    });
    // });
  }

  getuserFilter() async {
    var UserResponse = PrefManager.read("UserResponse");
    var data = {
      "user_id": UserResponse['data']['id'],
      "search": _searchController.text
    };
    var filter_result = await UserJobApi.getUserFilter(
        context, data, UserResponse['data']['api_token']);

    print(filter_result);
    setState(() {
      filterList.clear();
      if (filter_result.success) {
        if (filter_result.data['status']?.toString() == "1") {
          // latest = lat_result.data['data'];
          // searchlist.clear();
          filterList.addAll(filter_result.data['data'] ?? []);
        }
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Nav.back(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppTheme.white,
              )),
          title: null, // Remove the title
          actions: [
            SizedBox(
              width: screenWidth * 0.88,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: TextFormField(
                      autofocus: auto_focus,
                      // readOnly: true,
                      focusNode: _focusNode,
                      controller: _searchController,
                      onTap: () {
                        // Nav.to(context, UserSearchFilter());
                      },
                      onEditingComplete: () {
                        print(_searchController.text);
                        setState(() {
                          // focus_node = false;
                        });
                        if (!isLoading && _searchController.text.isNotEmpty) {
                          _focusNode.unfocus();
                          filterList.clear();
                          selectedFilters.clear();
                          initilize([], "");
                        } else {
                          _focusNode.unfocus();
                        }

                        // initilize();
                      },
                      decoration: InputDecoration(
                        hintText: "Search Company, jobs, location",
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            "assets/icons/search.png",
                            height: 20,
                            width: 20,
                          ),
                        ),
                        // suffixIcon: InkWell(
                        //   splashColor: Colors.white,
                        //   highlightColor: Colors.white,
                        //   onTap: () {
                        //     // _showModal();
                        //     filterList.clear();
                        //     selectedFilters.clear();
                        //     initilize([]);
                        //   },
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(12.0),
                        //     child: Image.asset(
                        //       "assets/icons/fliter.png",
                        //       height: 20,
                        //       width: 20,
                        //     ),
                        //   ),
                        // ),
                      )),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: !isLoading
            ? filterList.length > 0
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _showModal();
                          },
                          child: Icon(
                            Icons.filter_list,
                            size: 40,
                            color: AppTheme.primary,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 45.0, // Set your desired height
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: filterList.length,
                              itemBuilder: (context, index) {
                                final filter_data = filterList[index];
                                return InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    _showModal();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppTheme.primary),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Center(
                                          child: Text(
                                        filter_data['filter_name'] ?? "",
                                        style:
                                            TextStyle(color: AppTheme.primary),
                                      )),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(
                    height: 0,
                  )
            : const SizedBox(
                height: 0,
              ),
        body: resultUi());
  }

  resultUi() {
    return !isLoading
        ? searchlist.length != 0
            ? ListView.builder(
                controller: controller,
                // shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                itemCount: searchlist.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index < searchlist.length) {
                    final re_data = searchlist[index];
                    return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Nav.to(
                              context,
                              JobDetails(
                                job_id: re_data['id'].toString(),
                              ));
                        },
                        child: Recommeded(
                          recommed_data: re_data,
                          onTap: () {
                            setState(() {
                              // load_check = true;
                            });
                          },
                        ));
                  } else {
                    return page_loading
                        ? Center(
                            child: SingleChildScrollView(
                                child: ShimmerLoader(type: "")),
                          )
                        : Container(
                            height: page_no != searchlist.length ? 100 : 0,
                          );
                  }
                },
              )
            : const Center(
                child: Text("No Job List"),
              )
        : SingleChildScrollView(child: ShimmerLoader(type: ""));
  }
}

class FilterModal extends StatefulWidget {
  final List filters;
  final Map selectedFilters;
  final Function(Map selectedFilters) onFiltersSelected;

  const FilterModal({
    required this.filters,
    required this.selectedFilters,
    required this.onFiltersSelected,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late Map selectedFilters;
  String? selectedFilterName;
  String? selectedFilterKey;

  @override
  void initState() {
    super.initState();
    selectedFilters = Map.from(widget.selectedFilters);
    selectedFilterName = widget.filters.isNotEmpty
        ? widget.filters.length > 0
            ? widget.filters[0]["filter_name"]
            : null
        : null;
    selectedFilterKey = widget.filters.isNotEmpty
        ? widget.filters.length > 0
            ? widget.filters[0]["filter_key"]
            : null
        : null;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filter",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Text(
              //   "Clear all",
              //   style: TextStyle(fontSize: 12, color: AppTheme.primary),
              // )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: screenWidth * 0.3,
                decoration: BoxDecoration(
                    // color: Colors.red,
                    border: Border(
                        top: BorderSide(width: 1, color: AppTheme.TextBoldLite),
                        right: BorderSide(
                            width: 1, color: AppTheme.TextBoldLite))),
                child: ListView.builder(
                  itemCount: widget.filters.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedFilterName =
                              widget.filters[index]["filter_name"];
                          selectedFilterKey =
                              widget.filters[index]["filter_key"];
                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          // color: selectedFilterName ==
                          //         widget.filters[index]["filter_name"]
                          //     ? AppTheme.primary_light
                          //     : null,
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: AppTheme.TextBoldLite,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            VerticalDivider(
                              width: 5,
                              thickness: 5,
                              color: selectedFilterName ==
                                      widget.filters[index]["filter_name"]
                                  ? AppTheme.primary
                                  : Colors.transparent,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              widget.filters[index]["filter_name"] as String,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  width: screenWidth * 0.7,
                  decoration: BoxDecoration(
                      // color: Colors.green,
                      border: Border(
                          top: BorderSide(
                              width: 1, color: AppTheme.TextBoldLite))),
                  child: selectedFilterName != null
                      ? ListView.builder(
                          itemCount: widget.filters
                              .firstWhere((element) =>
                                  element["filter_name"] ==
                                  selectedFilterName)["filter_value"]
                              .length,
                          itemBuilder: (context, index) {
                            final filterValue = widget.filters.firstWhere(
                                (element) =>
                                    element["filter_name"] ==
                                    selectedFilterName)["filter_value"][index];
                            // final filterKey = selectedFilterName!;
                            final filterKey = selectedFilterKey;
                            final filterId = filterValue["id"] as int;
                            final isSelected = selectedFilters
                                    .containsKey(filterKey) &&
                                selectedFilters[filterKey]!.contains(filterId);

                            return CheckboxListTile(
                              title: Text(filterValue["name"] as String),
                              value: isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (selectedFilters.containsKey(filterKey)) {
                                    if (value!) {
                                      selectedFilters[filterKey]!.add(filterId);
                                    } else {
                                      selectedFilters[filterKey]!
                                          .remove(filterId);
                                    }
                                  } else {
                                    selectedFilters[filterKey] = [filterId];
                                  }
                                });
                              },
                            );
                          },
                        )
                      : SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () {
                    // Handle button click
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.primary),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () {
                    // Handle button click
                    widget.onFiltersSelected(selectedFilters);
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.primary),
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: const Text(
                    "Apply",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

// class FilterModal extends StatefulWidget {
//   const FilterModal({super.key});

//   @override
//   State<FilterModal> createState() => _FilterModalState();
// }

// class _FilterModalState extends State<FilterModal> {
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Container(),
//         const SizedBox(
//           height: 10,
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "Filter",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 "Clear all",
//                 style: TextStyle(fontSize: 12, color: AppTheme.primary),
//               )
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         Expanded(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                   decoration: BoxDecoration(
//                       // color: Colors.red,
//                       border: Border(
//                           top: BorderSide(
//                               width: 1, color: AppTheme.TextBoldLite),
//                           right: BorderSide(
//                               width: 1, color: AppTheme.TextBoldLite))),
//                   width: screenWidth * 0.3,
//                   child: ListView.builder(
//                     itemCount: 20,
//                     itemBuilder: (context, index){
//                     return Container(
//                         height: 50,
//                         decoration: BoxDecoration(
//                             border: Border(
//                                 bottom: BorderSide(
//                                     width: 1, color: AppTheme.TextBoldLite))),
//                         child: const Center(child: Text('Work Mode')),
//                       );
//                   })),
//               Expanded(
//                 child: Container(
//                     width: screenWidth * 0.7,
//                     decoration: BoxDecoration(
//                         color: Colors.green,
//                         border: Border(
//                             top: BorderSide(
//                                 width: 1, color: AppTheme.TextBoldLite))),
//                     child: ListView.builder(
//                         itemCount: 10,
//                         itemBuilder: (context, index) {
//                           return Container(
//                             child: Text("data"),
//                           );
//                         })),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 10),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: OutlinedButton(
//                   onPressed: () {
//                     // Handle button click
//                     Nav.back(context);
//                   },
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: AppTheme.primary),
//                     backgroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                   ),
//                   child: Text(
//                     "Cancel",
//                     style: TextStyle(
//                       color: AppTheme.primary,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                 flex: 1,
//                 child: OutlinedButton(
//                   onPressed: () {
//                     // Handle button click
//                   },
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: AppTheme.primary),
//                     backgroundColor: AppTheme.primary,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                   ),
//                   child: const Text(
//                     "Continue",
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//       ],
//     );
//   }
// }

class Recommeded extends StatefulWidget {
  const Recommeded(
      {super.key, required this.recommed_data, required this.onTap});

  final Map<String, dynamic> recommed_data;
  final Function onTap;

  @override
  State<Recommeded> createState() => _RecommededState();
}

class _RecommededState extends State<Recommeded> {
  String currencySymbol = '؋'; // AFN currency symbol

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8.0),
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
        // height: 50,
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // Image.asset(
                      //   "assets/images/back.png",
                      //   height: 50,
                      // ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                            widget.recommed_data['company_details']
                                ['is_company_logo'],
                            fit: BoxFit.fill,
                            height: 50,
                            width: 60, errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                          // Handle the error here
                          return const Center(
                            child: Icon(Icons.image_not_supported),
                          );
                        }),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.recommed_data['job_title'] ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.recommed_data['job_description'] ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: AppTheme.TextLite, fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                widget.recommed_data['is_saved'] == 0
                    ? InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          bool result = await JobSaved(
                              widget.recommed_data['id'], context);
                          if (result == true) {
                            setState(() {
                              widget.recommed_data['is_saved'] = 1;
                            });
                            widget.onTap();
                          }
                        },
                        child: Image.asset(
                          "assets/icons/bookmark_light.png",
                          height: 25,
                        ),
                      )
                    : InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          bool result = await JobUnSaved(
                              widget.recommed_data['id'], context);
                          if (result == true) {
                            setState(() {
                              widget.recommed_data['is_saved'] = 0;
                            });
                            widget.onTap();
                          }
                        },
                        child: Image.asset(
                          "assets/icons/bookmark_dark.png",
                          height: 25,
                        ),
                      )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 25,
              child: ListView.builder(
                  itemCount: widget.recommed_data['is_employment_types'].length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final job_type =
                        widget.recommed_data['is_employment_types'][index];
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: AppTheme.primary_light),
                      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Center(
                        child: Text(
                          job_type['employmenttype'],
                          style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/time.png",
                      height: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.recommed_data['is_ago'] ?? "",
                      style:
                          TextStyle(color: AppTheme.TextBoldLite, fontSize: 11),
                    )
                  ],
                ),
                // Text(
                //   "₹12k - 20k/years",
                //   style: TextStyle(color: AppTheme.success),
                // ),
                // Row(
                //   children: [
                //     Text(currencySymbol),
                //     Text(
                //                 '100', // Concatenate symbol and amount
                //                 style: TextStyle(
                //                   fontSize: 20, // Adjust font size as needed
                //                 ),
                //               ),
                //   ],
                // ),
                Row(
                  children: [
                    Text(
                        "${(widget.recommed_data['from_currency'] ?? "").toString()} ",
                        style: TextStyle(
                          color: AppTheme.success,
                        )),
                    Text(
                        "${widget.recommed_data['from_sal'] ?? ""} - ${widget.recommed_data['to_sal'] ?? ""}",
                        style: TextStyle(
                          color: AppTheme.success,
                        )),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: const Text(
                    "Apply Now",
                    style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ));
  }
}

class FilterSelectionScreen extends StatefulWidget {
  final List filters;
  final Map selectedFilters;
  final Function(Map selectedFilters) onFiltersSelected;

  FilterSelectionScreen({
    required this.filters,
    required this.selectedFilters,
    required this.onFiltersSelected,
  });

  @override
  _FilterSelectionScreenState createState() => _FilterSelectionScreenState();
}

class _FilterSelectionScreenState extends State<FilterSelectionScreen> {
  late Map selectedFilters;

  @override
  void initState() {
    super.initState();
    selectedFilters = Map.from(widget.selectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Filter Selection'),
      // ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("Filter",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.filters.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(widget.filters[index]["filter_name"] as String),
                  children: [
                    Wrap(
                      children: (widget.filters[index]["filter_value"] as List)
                          .map((filterValue) {
                        final filterKey =
                            widget.filters[index]["filter_key"] as String;
                        final filterId = filterValue["id"] as int;
                        final isSelected =
                            selectedFilters.containsKey(filterKey) &&
                                selectedFilters[filterKey]!.contains(filterId);

                        return CheckboxListTile(
                          title: Text(filterValue["name"] as String),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (selectedFilters.containsKey(filterKey)) {
                                if (value!) {
                                  selectedFilters[filterKey]!.add(filterId);
                                } else {
                                  selectedFilters[filterKey]!.remove(filterId);
                                }
                              } else {
                                selectedFilters[filterKey] = [filterId];
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle button click
                      Nav.back(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.primary),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle button click
                      widget.onFiltersSelected(selectedFilters);
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.primary),
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Platform.isIOS
              ? const SizedBox(
                  height: 20,
                )
              : const SizedBox(
                  height: 0,
                )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     widget.onFiltersSelected(selectedFilters);
      //     Navigator.of(context)
      //         .pop(); // Close the bottom sheet after submitting
      //   },
      //   child: Icon(Icons.check),
      // ),
    );
  }
}



// class FilterModal extends StatefulWidget {
//   const FilterModal({super.key});

//   @override
//   State<FilterModal> createState() => _FilterModalState();
// }

// class _FilterModalState extends State<FilterModal> {
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return FractionallySizedBox(
//       heightFactor: 0.9,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(),
//           const SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Filter",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   "Clear all",
//                   style: TextStyle(fontSize: 12, color: AppTheme.primary),
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           Expanded(
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                     decoration: BoxDecoration(
//                         // color: Colors.red,
//                         border: Border(
//                             top: BorderSide(
//                                 width: 1, color: AppTheme.TextBoldLite),
//                             right: BorderSide(
//                                 width: 1, color: AppTheme.TextBoldLite))),
//                     width: screenWidth * 0.3,
//                     child: ListView(
//                       padding: const EdgeInsets.all(0),
//                       children: <Widget>[
//                         Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       width: 1, color: AppTheme.TextBoldLite))),
//                           child: const Center(child: Text('Work Mode')),
//                         ),
//                         Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       width: 1, color: AppTheme.TextBoldLite))),
//                           child: const Center(child: Text('Experience')),
//                         ),
//                         Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       width: 1, color: AppTheme.TextBoldLite))),
//                           child: const Center(child: Text('Salary')),
//                         ),
//                         Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       width: 1, color: AppTheme.TextBoldLite))),
//                           child: const Center(child: Text('Department')),
//                         ),
//                         Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       width: 1, color: AppTheme.TextBoldLite))),
//                           child: const Center(child: Text('Industry')),
//                         ),
//                         Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       width: 1, color: AppTheme.TextBoldLite))),
//                           child: const Center(child: Text('Educations')),
//                         ),
//                       ],
//                     )),
//                 Expanded(
//                   child: Container(
//                     width: screenWidth * 0.7,
//                     decoration: BoxDecoration(
//                         color: Colors.green,
//                         border: Border(
//                             top: BorderSide(
//                                 width: 1, color: AppTheme.TextBoldLite))),
//                     child: const SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           Text("data"),
//                           // Add more widgets as needed
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 10),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Expanded(
          //         flex: 1,
          //         child: OutlinedButton(
          //           onPressed: () {
          //             // Handle button click
          //             Nav.back(context);
          //           },
          //           style: OutlinedButton.styleFrom(
          //             side: BorderSide(color: AppTheme.primary),
          //             backgroundColor: Colors.white,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(15.0),
          //             ),
          //           ),
          //           child: Text(
          //             "Cancel",
          //             style: TextStyle(
          //               color: AppTheme.primary,
          //             ),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(
          //         width: 10,
          //       ),
          //       Expanded(
          //         flex: 1,
          //         child: OutlinedButton(
          //           onPressed: () {
          //             // Handle button click
          //           },
          //           style: OutlinedButton.styleFrom(
          //             side: BorderSide(color: AppTheme.primary),
          //             backgroundColor: AppTheme.primary,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(15.0),
          //             ),
          //           ),
          //           child: const Text(
          //             "Continue",
          //             style: TextStyle(
          //               color: Colors.white,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
//           const SizedBox(
//             height: 20,
//           ),
//         ],
//       ),
//     );
//   }
// }
