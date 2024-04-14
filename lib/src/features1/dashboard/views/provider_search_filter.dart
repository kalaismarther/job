import 'dart:io';
import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features1/dashboard/provider_dashboard_api.dart';
import 'package:job/src/features1/dashboard/views/latest_profile.dart';

class ProviderSearch extends StatefulWidget {
  const ProviderSearch({super.key});

  @override
  State<ProviderSearch> createState() => _ProviderSearchState();
}

class _ProviderSearchState extends State<ProviderSearch> {
  final controller = ScrollController();
  TextEditingController _searchController = TextEditingController();

  bool isLoading = false;
  bool page_loading = false;

  List searchlist = [];
  List filterList = [];
  Map selectedFilters = {};

  var page_no;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    initilize([], "");
    scrollEvent();
    super.initState();
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

  initilize(filter, type) async {
    setState(() {
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
    var search_result = await ProviderDashboardApi.providerSearch(
        context, data, UserResponse['data']['api_token']);
    print(search_result);
    // setState(() async {
    if (search_result.success) {
      if (search_result.data['status']?.toString() == "1") {
        // latest = lat_result.data['data'];
        // searchlist.clear();
        setState(() {
          searchlist.addAll(search_result.data['data']?['latest_users'] ?? []);
        });
        if (filter.length == 0) {
          await getuserFilter();
        }
      }
    }

    setState(() {
      // isLoading = false;
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
    var filter_result = await ProviderDashboardApi.getSearchFilter(
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
            // FilterSelectionScreen(
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                    autofocus: true,
                    // autofocus: auto_focus,
                    // readOnly: true,
                    focusNode: _focusNode,
                    controller: _searchController,
                    onTap: () {
                      // Nav.to(context, UserSearchFilter());
                    },
                    onEditingComplete: () {
                      if (!isLoading && _searchController.text.isNotEmpty) {
                        _focusNode.unfocus();
                        filterList.clear();
                        selectedFilters.clear();
                        initilize([], "");
                      } else {
                        _focusNode.unfocus();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Search Skills, location",
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
                      //     // filterList.clear();
                      //     // selectedFilters.clear();
                      //     // initilize([]);
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
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Center(
                                        child: Text(
                                      filter_data['filter_name'] ?? "",
                                      style: TextStyle(color: AppTheme.primary),
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
      body: !isLoading
          ? searchlist.length > 0
              ? ListView.builder(
                  controller: controller,
                  itemCount: searchlist.length + 1,
                  padding: const EdgeInsets.all(15.0),
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index < searchlist.length) {
                      final latest_data = searchlist[index];
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Nav.to(
                              context,
                              LatestProfile(
                                  user_id: latest_data['id'].toString()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
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
                              Text(latest_data['name'] ?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/city.png",
                                    width: 15,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${latest_data['is_state_name'] ?? ""}, ${latest_data['is_country_name'] ?? ""}",
                                    style: TextStyle(
                                        color: AppTheme.TextLite, height: 3),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/qly.png",
                                    width: 15,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${latest_data['qualification'] ?? ""} (${latest_data['short_qualification'] ?? ""})",
                                    style: TextStyle(color: AppTheme.TextLite),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
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
                  })
              : SizedBox(
                  height: screenHeight * 0.5,
                  child: const Center(child: Text("No job seekers found")))
          : ShimmerLoader(type: ""),
    );
  }
}

// class FilterSelectionScreen extends StatefulWidget {
//   final List filters;
//   final Map selectedFilters;
//   final Function(Map selectedFilters) onFiltersSelected;

//   FilterSelectionScreen({
//     required this.filters,
//     required this.selectedFilters,
//     required this.onFiltersSelected,
//   });

//   @override
//   _FilterSelectionScreenState createState() => _FilterSelectionScreenState();
// }

// class _FilterSelectionScreenState extends State<FilterSelectionScreen> {
//   late Map selectedFilters;

//   @override
//   void initState() {
//     super.initState();
//     selectedFilters = Map.from(widget.selectedFilters);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Filter Selection'),
//       // ),
//       body: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Text("Filter",
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: widget.filters.length,
//               itemBuilder: (context, index) {
//                 return ExpansionTile(
//                   title: Text(widget.filters[index]["filter_name"] as String),
//                   children: [
//                     Wrap(
//                       children: (widget.filters[index]["filter_value"] as List)
//                           .map((filterValue) {
//                         final filterKey =
//                             widget.filters[index]["filter_key"] as String;
//                         final filterId = filterValue["id"] as int;
//                         final isSelected =
//                             selectedFilters.containsKey(filterKey) &&
//                                 selectedFilters[filterKey]!.contains(filterId);

//                         return CheckboxListTile(
//                           title: Text(filterValue["name"] as String),
//                           value: isSelected,
//                           onChanged: (bool? value) {
//                             setState(() {
//                               if (selectedFilters.containsKey(filterKey)) {
//                                 if (value!) {
//                                   selectedFilters[filterKey]!.add(filterId);
//                                 } else {
//                                   selectedFilters[filterKey]!.remove(filterId);
//                                 }
//                               } else {
//                                 selectedFilters[filterKey] = [filterId];
//                               }
//                             });
//                           },
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: OutlinedButton(
//                     onPressed: () {
//                       // Handle button click
//                       Nav.back(context);
//                     },
//                     style: OutlinedButton.styleFrom(
//                       side: BorderSide(color: AppTheme.primary),
//                       backgroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15.0),
//                       ),
//                     ),
//                     child: Text(
//                       "Cancel",
//                       style: TextStyle(
//                         color: AppTheme.primary,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: OutlinedButton(
//                     onPressed: () {
//                       // Handle button click
//                       widget.onFiltersSelected(selectedFilters);
//                       Navigator.of(context).pop();
//                     },
//                     style: OutlinedButton.styleFrom(
//                       side: BorderSide(color: AppTheme.primary),
//                       backgroundColor: AppTheme.primary,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15.0),
//                       ),
//                     ),
//                     child: const Text(
//                       "Continue",
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Platform.isIOS
//               ? const SizedBox(
//                   height: 20,
//                 )
//               : const SizedBox(
//                   height: 0,
//                 )
//         ],
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     widget.onFiltersSelected(selectedFilters);
//       //     Navigator.of(context)
//       //         .pop(); // Close the bottom sheet after submitting
//       //   },
//       //   child: Icon(Icons.check),
//       // ),
//     );
//   }
// }

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

  TextEditingController _startController = TextEditingController();
  TextEditingController _endController = TextEditingController();

  List filteredExperience = [0, 10];

  //initial Range Value
  RangeValues _currentRangeValues = const RangeValues(0, 10);

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

  Map expLimit = {};

  filterByExperience() {
    final filterValue = widget.filters.firstWhere((element) =>
        element["filter_name"] == selectedFilterName)["filter_value"];

    if (selectedFilters.containsKey(selectedFilterKey)) {
      print(selectedFilters[selectedFilterKey]);
      setState(() {
        expLimit = filterValue;

        _currentRangeValues = RangeValues(
            double.parse(selectedFilters[selectedFilterKey][0].toString()),
            double.parse(selectedFilters[selectedFilterKey][1].toString()));
        _startController.text =
            selectedFilters[selectedFilterKey][0].toString();
        _endController.text = selectedFilters[selectedFilterKey][1].toString();
        // _currentRangeValues = RangeValues(
        //     double.parse(filterValue['min'].toString()),
        //     double.parse(filterValue['max'].toString()));
      });
      return;
    }

    if (filterValue.runtimeType != List) {
      print('hi');
      setState(() {
        expLimit = filterValue;
        filteredExperience = [
          int.parse(filterValue['min'].toString()),
          int.parse(filterValue['max'].toString())
        ];

        _startController.text = filterValue['min'].toString();
        _endController.text = filterValue['max'].toString();
        _currentRangeValues = RangeValues(
            double.parse(filterValue['min'].toString()),
            double.parse(filterValue['max'].toString()));
      });
    }
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

                        if (widget.filters[index]["filter_key"] ==
                            'exp_years') {
                          filterByExperience();
                        }
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
                      ? selectedFilterKey == 'exp_years'
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Years',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          // width: 120,
                                          width: screenWidth * 0.2,
                                          child: TextFormField(
                                            controller: _startController,
                                            keyboardType: TextInputType.number,
                                            onEditingComplete: () {
                                              setState(() {
                                                _startController.text =
                                                    _currentRangeValues.start
                                                        .toString();
                                              });
                                            },
                                            onChanged: (text) {
                                              // Update the range slider when the text changes
                                              double startValue =
                                                  double.tryParse(text) ??
                                                      _currentRangeValues.start;

                                              setState(() {
                                                if (startValue <
                                                    _currentRangeValues.end) {
                                                  _currentRangeValues =
                                                      RangeValues(
                                                          startValue,
                                                          _currentRangeValues
                                                              .end);
                                                } else {
                                                  Snackbar.show(
                                                      "Please check end value",
                                                      Colors.black);
                                                  setState(() {
                                                    _startController.text =
                                                        _currentRangeValues
                                                            .start
                                                            .toInt()
                                                            .toString();
                                                  });
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        const Text("to"),
                                        SizedBox(
                                          width: screenWidth * 0.2,
                                          child: TextFormField(
                                            controller: _endController,
                                            keyboardType: TextInputType.number,
                                            onChanged: (text) {
                                              // Update the range slider when the text changes

                                              double endValue =
                                                  double.tryParse(text) ??
                                                      _currentRangeValues.end;
                                              setState(() {
                                                if (endValue >
                                                    _currentRangeValues.start) {
                                                  _currentRangeValues =
                                                      RangeValues(
                                                          _currentRangeValues
                                                              .start,
                                                          endValue);
                                                } else {
                                                  Snackbar.show(
                                                      "Please Check to from value",
                                                      Colors.black);
                                                  // _endController.text =
                                                  //     _currentRangeValues.end.toInt().toString();
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RangeSlider(
                                    values: _currentRangeValues,
                                    min: double.parse(
                                        expLimit['min']?.toString() ?? '0'),
                                    max: double.parse(
                                        expLimit['max']?.toString() ?? '10'),
                                    divisions: expLimit['max'] ?? 10,
                                    labels: RangeLabels(
                                      _currentRangeValues.start
                                          .round()
                                          .toString(),
                                      _currentRangeValues.end
                                          .round()
                                          .toString(),
                                    ),
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        _currentRangeValues = values;
                                        _startController.text =
                                            _currentRangeValues.start
                                                .round()
                                                .toString();
                                        _endController.text =
                                            _currentRangeValues.end
                                                .round()
                                                .toString();

                                        filteredExperience = [
                                          int.parse(_startController.text),
                                          int.parse(_endController.text)
                                        ];

                                        setState(() {
                                          if (selectedFilters
                                              .containsKey('exp_years')) {
                                            print('dkjflk');
                                            selectedFilters['exp_years'] =
                                                filteredExperience;
                                            print(selectedFilters);
                                          } else {
                                            print('ggggg');
                                            selectedFilters['exp_years'] =
                                                filteredExperience;
                                          }
                                        });
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: widget.filters
                                  .firstWhere((element) =>
                                      element["filter_name"] ==
                                      selectedFilterName)["filter_value"]
                                  .length,
                              itemBuilder: (context, index) {
                                final filterValue = widget.filters.firstWhere(
                                        (element) =>
                                            element["filter_name"] ==
                                            selectedFilterName)["filter_value"]
                                    [index];

                                // final filterKey = selectedFilterName!;
                                final filterKey = selectedFilterKey;
                                final filterId = filterValue["id"] as int;
                                final isSelected =
                                    selectedFilters.containsKey(filterKey) &&
                                        selectedFilters[filterKey]!
                                            .contains(filterId);

                                return CheckboxListTile(
                                  title: Text(filterValue["name"] as String),
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (selectedFilters
                                          .containsKey(filterKey)) {
                                        if (value!) {
                                          selectedFilters[filterKey]!
                                              .add(filterId);
                                          print(selectedFilters);
                                        } else {
                                          selectedFilters[filterKey]!
                                              .remove(filterId);
                                        }
                                      } else {
                                        print('helo');
                                        selectedFilters[filterKey] = [filterId];
                                        print(selectedFilters[filterKey]);
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
