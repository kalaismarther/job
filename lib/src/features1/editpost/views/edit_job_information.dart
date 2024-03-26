import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/common_modal.dart';
import 'package:job/src/core/utils/common_multiselect.dart';
import 'package:job/src/core/utils/common_search_modal.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features1/createpost/post_api.dart';
import 'package:job/src/features1/createpost/views/steps.dart';
import 'package:job/src/features1/editpost/views/edit_job_description.dart';

class EditJobInformation extends StatefulWidget {
  const EditJobInformation({super.key, required this.editData});

  final Map editData;

  @override
  State<EditJobInformation> createState() => _EditJobInformationState();
}

class _EditJobInformationState extends State<EditJobInformation> {
  final _formKey1 = GlobalKey<FormState>();

  RangeValues _currentRangeValues = const RangeValues(5000, 300000);

  TextEditingController _startController = TextEditingController();
  TextEditingController _endController = TextEditingController();

  TextEditingController job_title = TextEditingController();
  TextEditingController key_word = TextEditingController();
  TextEditingController currency = TextEditingController();
  TextEditingController qulification = TextEditingController();
  TextEditingController categories = TextEditingController();

  TextEditingController joblevel = TextEditingController();
  TextEditingController min_months = TextEditingController();
  TextEditingController max_months = TextEditingController();

  String selectedExperience = '';

  List selectedTypes = [];
  List employeType = [];
  List jobCategories = [];
  List currencies = [];
  List keySkills = [];
  List s_keySkills = [];
  List add_KeyWord = [];
  List s_Education = [];
  var s_currencyId = "";
  var s_jobCatId = "";
  var s_educationId = "";
  var s_currecySympols;
  bool isLoading = false;
  bool m_isLoading = false;
  var s_jobLevelId = "";
  var bac_job_id;
  var company_status;
  bool hideSalary = false;

  @override
  void initState() {
    initilize();
    super.initState();
    _startController.text = _currentRangeValues.start.round().toString();
    _endController.text = _currentRangeValues.end.round().toString();
    // edit_data();
  }

  edit_data() {
    print(widget.editData);
    setState(() {
      job_title.text = widget.editData['job_title'] ?? "";
      selectedExperience = widget.editData['experience_level'].toString();
      joblevel.text = widget.editData['is_job_level'] ?? "";
      s_jobLevelId = widget.editData['job_level_id'].toString();
      min_months.text = (widget.editData['min_exp_months'] ?? "").toString();
      max_months.text = (widget.editData['max_exp_months'] ?? "").toString();
      selectedTypes.addAll(widget.editData['is_employment_types'] ?? []);
      _startController.text = widget.editData['from_sal'] ?? "";
      _endController.text = widget.editData['to_sal'] ?? "";
      currency.text = widget.editData['from_currency'] ?? "";
      hideSalary =
          widget.editData['is_hide_salary'].toString() == '1' ? true : false;
      s_currecySympols = widget.editData['from_currency'] ?? "";
      s_currencyId = (widget.editData['from_sal_currency'] ?? "").toString();
      s_keySkills = parseSkills(widget.editData['skills'] ?? "");
      add_KeyWord = parseSkills(widget.editData['keywords'] ?? "");
      ;
      if (widget.editData['is_education']?[0]?['id'] != null) {
        s_educationId =
            (widget.editData['is_education'][0]['id'] ?? "").toString();
      }
      s_Education.addAll(widget.editData['is_education'] ?? "");
      if (widget.editData['is_education']?[0]?['id'] != null) {
        qulification.text = widget.editData['is_education'][0]['qualification'];
      }
      categories.text = widget.editData['is_department_name'] ?? "";
      s_jobCatId = (widget.editData['deprtment_id'] ?? "").toString();
      print(selectedTypes);
    });
  }

  List<Map<String, String>> parseSkills(String skillsString) {
    List<String> skills = skillsString.split(',');

    List<Map<String, String>> skillsList = skills.map((skill) {
      return {'skill_name': skill.trim()};
    }).toList();

    return skillsList;
  }

  initilize() async {
    setState(() {
      m_isLoading = true;
    });
    var UserResponse = PrefManager.read("UserResponse");
    var get_company_status = PrefManager.read("company_status");
    var get_emp_type = await PostApi.getEmploymentType(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);

    setState(() {
      company_status = get_company_status;
      if (get_emp_type.success) {
        employeType = get_emp_type.data['data'] ?? "";
      }

      // m_isLoading = false;
    });
    await edit_data();
    setState(() {
      m_isLoading = false;
    });
  }

  merge(values, name) {
    return values.map((value) => value[name]).join(',');
  }

  merge1(values) {
    return values.map((value) => value).join(',');
  }

  void _showModal(mv, sv, type) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CommonModal(
          districts: mv,
          selectedDistricts: sv,
          type: type,
        );
      },
    );

    if (result != null) {
      setState(() {
        s_keySkills = result;
      });
    }
  }

  void _showMultiModal(data, sv, type) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CommonMultiSelect(data: data, type: type, s_list: sv);
      },
    );

    if (result != null) {
      setState(() {
        if (type == "qul") {
          s_Education = result;
        } else if (type == 'keywords') {
          add_KeyWord = result;
        } else {
          s_keySkills = result;
        }
      });

      // setState(() {
      //   s_keySkills = result;
      // });
    }
  }

  void _showModal1(data, type) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CommonSearchModal(
          data: data,
          type: type,
        );
      },
    );

    if (result != null) {
      setState(() {
        if (type == "currency") {
          currency.text = result['currency'];
          s_currencyId = result['id'].toString();
          s_currecySympols = result['currency_symbol'].toString();
        }
        if (type == "qul") {
          qulification.text = result['qualification'] ?? "";
          s_educationId = result['id'].toString();
        }
        if (type == "depart") {
          categories.text = result['department_name'];
          s_jobCatId = result['id'].toString();
        }
        if (type == "job_level") {
          joblevel.text = result['job_level'];
          s_jobLevelId = result['id'].toString();
        }
      });
    }
  }

  Widget buildCheckboxListTile(String title, String value) {
    return Row(
      children: [
        Checkbox(
          value: selectedTypes.contains(value),
          onChanged: (bool? isChecked) {
            setState(() {
              if (isChecked != null && isChecked) {
                selectedTypes.add(value);
              } else {
                selectedTypes.remove(value);
              }
            });
          },
        ),
        Text(title),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text("Edit Post",
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
      body: SingleChildScrollView(
        child: !m_isLoading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Steps(),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Job Title",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: job_title,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Job Title';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: "e.g Software Engineer",
                            helperText: "At least 10 characters"),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Job Type',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Radio(
                            value: '1',
                            groupValue: selectedExperience,
                            onChanged: (value) {
                              setState(() {
                                selectedExperience = value!;
                                min_months.text = "";
                                max_months.text = "";
                              });
                            },
                          ),
                          const Text('Internship'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: '2',
                            groupValue: selectedExperience,
                            onChanged: (value) {
                              setState(() {
                                selectedExperience = value!;
                                min_months.text = "";
                                max_months.text = "";
                              });
                            },
                          ),
                          const Text('Fresher'),
                        ],
                      ),

                      // Row for Experienced Radio Button
                      Row(
                        children: [
                          Radio(
                            value: '3',
                            groupValue: selectedExperience,
                            onChanged: (value) {
                              setState(() {
                                selectedExperience = value!;
                              });
                            },
                          ),
                          const Text('Experience'),
                        ],
                      ),

                      selectedExperience == "3"
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: TextFormField(
                                        controller: min_months,
                                        onTap: () async {},
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter min years';
                                          }
                                          return null;
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(3),
                                          // FilteringTextInputFormatter.deny(RegExp('0')),
                                        ],
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            counterText: '',
                                            hintText: 'Min years',
                                            labelText: 'Min years',
                                            labelStyle: TextStyle(
                                                color: AppTheme.TextBoldLite,
                                                fontSize: 14)),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: TextFormField(
                                        controller: max_months,
                                        onTap: () async {},
                                        // validator: (value) {
                                        //   if (check_years.isEmpty) {
                                        //     return 'Please enter a months';
                                        //   }
                                        //   return null;
                                        // },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter max years';
                                          }
                                          return null;
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(3),
                                          // MaxValueInputFormatter(12),
                                          // FilteringTextInputFormatter.deny(
                                          //     RegExp('0')),
                                          // FilteringTextInputFormatter.deny(
                                          //     RegExp(check_years.isEmpty ? '0' : ''))
                                        ],
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          counterText: '',
                                          labelText: ' Max years',
                                          labelStyle: TextStyle(
                                              color: AppTheme.TextBoldLite,
                                              fontSize: 14),
                                          hintText: 'Max years',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                      const SizedBox(height: 20),
                      const Text(
                        'Job Level',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          readOnly: true,
                          controller: joblevel,
                          onTap: () async {
                            // _modal([], "specification");
                            _showModal1([], "job_level");
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select job level';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              counterText: '',
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
                              hintText: 'Job Level',
                              // labelText: 'Currency',
                              labelStyle: TextStyle(
                                  color: AppTheme.TextBoldLite, fontSize: 14)
                              // suffixText : 'Years'
                              ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Select Employment Types:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // ListView.builder(
                      //     itemCount: employeType.length,
                      //     shrinkWrap: true,
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     itemBuilder: (BuildContext context, index) {
                      //       final data = employeType[index];
                      //       return Row(
                      //         children: [
                      //           Checkbox(
                      //             value: selectedTypes.contains(data),
                      //             onChanged: (bool? isChecked) {
                      //               setState(() {
                      //                 if (isChecked != null && isChecked) {
                      //                   selectedTypes.add(data);
                      //                 } else {
                      //                   selectedTypes.remove(data);
                      //                 }
                      //               });
                      //             },
                      //           ),
                      //           Text(data['employmenttype']),
                      //         ],
                      //       );
                      //     }),
                      ListView.builder(
                          itemCount: employeType.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, index) {
                            final data = employeType[index];
                            return Row(
                              children: [
                                Checkbox(
                                  value: selectedTypes.any(
                                      (element) => element['id'] == data['id']),
                                  onChanged: (bool? isChecked) {
                                    setState(() {
                                      if (isChecked != null && isChecked) {
                                        selectedTypes.add(data);
                                      } else {
                                        selectedTypes.removeWhere((element) =>
                                            element['id'] == data['id']);
                                      }
                                    });
                                  },
                                ),
                                Text(data['employmenttype']),
                              ],
                            );
                          }),

                      const SizedBox(height: 20),
                      const Text(
                        'Currency',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          readOnly: true,
                          controller: currency,
                          onTap: () async {
                            // _modal([], "specification");
                            _showModal1([], "currency");
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Select Currency';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              counterText: '',
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
                              hintText: 'Currency',
                              // labelText: 'Currency',
                              labelStyle: TextStyle(
                                  color: AppTheme.TextBoldLite, fontSize: 14)
                              // suffixText : 'Years'
                              ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Salary',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            // width: 120,
                            width: ScreenWidth * 0.35,
                            child: TextFormField(
                              controller: _startController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: SizedBox(
                                  width: 30,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        // Icon(
                                        //   Icons.currency_rupee,
                                        //   size: 18,
                                        // ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Text(s_currecySympols ?? ""),
                                        const SizedBox(
                                            height: 15,
                                            child: VerticalDivider(
                                              thickness: 1,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              onEditingComplete: () {
                                setState(() {
                                  _startController.text =
                                      _currentRangeValues.start.toString();
                                });
                              },
                              onChanged: (text) {
                                // Update the range slider when the text changes
                                double startValue = double.tryParse(text) ??
                                    _currentRangeValues.start;

                                setState(() {
                                  if (startValue < _currentRangeValues.end) {
                                    _currentRangeValues = RangeValues(
                                        startValue, _currentRangeValues.end);
                                  } else {
                                    Snackbar.show(
                                        "Please check end value", Colors.black);
                                    setState(() {
                                      _startController.text =
                                          _currentRangeValues.start
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
                            width: ScreenWidth * 0.35,
                            child: TextFormField(
                              controller: _endController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: SizedBox(
                                  width: 30,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        // Icon(
                                        //   Icons.currency_rupee,
                                        //   size: 18,
                                        // ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Text(s_currecySympols ?? ""),
                                        const SizedBox(
                                            height: 15,
                                            child: VerticalDivider(
                                              thickness: 1,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              onChanged: (text) {
                                // Update the range slider when the text changes

                                double endValue = double.tryParse(text) ??
                                    _currentRangeValues.end;
                                setState(() {
                                  if (endValue > _currentRangeValues.start) {
                                    _currentRangeValues = RangeValues(
                                        _currentRangeValues.start, endValue);
                                  } else {
                                    Snackbar.show("Please Check to from value",
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
                      RangeSlider(
                        values: _currentRangeValues,
                        max: 3000000,
                        // min: 1000,
                        // max: 100,
                        divisions: 1000,
                        labels: RangeLabels(
                          _currentRangeValues.start.round().toString(),
                          _currentRangeValues.end.round().toString(),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _currentRangeValues = values;
                            _startController.text =
                                _currentRangeValues.start.round().toString();
                            _endController.text =
                                _currentRangeValues.end.round().toString();
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CheckboxListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text('Hide Salary on Post'),
                          value: hideSalary,
                          onChanged: (bool? value) {
                            setState(() {
                              hideSalary = !hideSalary;
                            });
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Categories',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          readOnly: true,
                          controller: categories,
                          onTap: () async {
                            // _modal([], "specification");
                            _showModal1([], "depart");
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Select Currency';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              counterText: '',
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
                              hintText: 'Select Job Categories',
                              // labelText: 'Currency',
                              labelStyle: TextStyle(
                                  color: AppTheme.TextBoldLite, fontSize: 14)
                              // suffixText : 'Years'
                              ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Required Skills',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      InkWell(
                        onTap: () {
                          // _showModal(keySkills, s_keySkills, "");
                          _showMultiModal([], s_keySkills, "");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.primary)),
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                color: AppTheme.primary,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Add Skills",
                                style: TextStyle(color: AppTheme.primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        spacing: 3.0,
                        runSpacing: 2.0,
                        children: s_keySkills
                            .asMap()
                            .entries
                            .map(
                              (entry) => GestureDetector(
                                onTap: () {
                                  // Remove the skill when the close icon is clicked
                                  setState(() {
                                    s_keySkills.removeAt(entry.key);
                                  });
                                },
                                child: Chip(
                                  labelStyle:
                                      TextStyle(color: AppTheme.primary),
                                  side: BorderSide(color: AppTheme.primary),
                                  padding: const EdgeInsets.all(0.0),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        entry.value['skill_name'] ?? "",
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      Icon(
                                        Icons.close,
                                        size: 15,
                                        color: AppTheme.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Keywords',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        readOnly: true,
                        onTap: () async {
                          if (kDebugMode) {
                            print("success");
                          }
                          // Snackbar.show("Will be add soon", Colors.red);
                          // _showModal1([], "qul");
                          _showMultiModal([], add_KeyWord, "keywords");
                        },
                        // onFieldSubmitted: (value) {
                        //   final _value = value.trim();
                        //   setState(() {
                        //     if (_value.isNotEmpty) {
                        //       add_KeyWord.add(_value);
                        //       key_word.text = "";
                        //     }
                        //   });
                        // },
                        validator: (value) {
                          if (add_KeyWord.isEmpty) {
                            return 'Please add key word';
                          }
                          return null;
                        },
                        controller: key_word,
                        decoration: InputDecoration(
                          hintText: "Select keywords for this job",
                          // suffixIcon: InkWell(
                          //   onTap: () {
                          //     final _value = key_word.text.trim();
                          //     setState(() {
                          //       if (_value.isNotEmpty) {
                          //         add_KeyWord.add(_value);
                          //         key_word.text = "";
                          //       }
                          //     });
                          //   },
                          //   child: Icon(
                          //     Icons.add,
                          //     color: AppTheme.TextBoldLite,
                          //   ),
                          // )
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
                        ),
                      ),
                      // TextFormField(
                      //   onFieldSubmitted: (value) {
                      //     final _value = value.trim();
                      //     setState(() {
                      //       if (_value.isNotEmpty) {
                      //         add_KeyWord.add(_value);
                      //         key_word.text = "";
                      //       }
                      //     });
                      //   },
                      //   // validator: (value) {
                      //   //   if (value == null || value.isEmpty) {
                      //   //     return 'Please add key word';
                      //   //   }
                      //   //   return null;
                      //   // },
                      //   controller: key_word,
                      //   decoration: InputDecoration(
                      //       hintText: "Add key Word",
                      //       suffixIcon: InkWell(
                      //         onTap: () {
                      //           final _value = key_word.text.trim();
                      //           setState(() {
                      //             if (_value.isNotEmpty) {
                      //               add_KeyWord.add(_value);
                      //               key_word.text = "";
                      //             }
                      //           });
                      //         },
                      //         child: Icon(
                      //           Icons.add,
                      //           color: AppTheme.TextBoldLite,
                      //         ),
                      //       )),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        spacing: 3.0,
                        runSpacing: 2.0,
                        children: add_KeyWord
                            .asMap()
                            .entries
                            .map(
                              (entry) => GestureDetector(
                                onTap: () {
                                  // Remove the skill when the close icon is clicked
                                  setState(() {
                                    add_KeyWord.removeAt(entry.key);
                                  });
                                },
                                child: Chip(
                                  labelStyle:
                                      TextStyle(color: AppTheme.primary),
                                  side: BorderSide(color: AppTheme.primary),
                                  padding: const EdgeInsets.all(0.0),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        entry.value['skill_name'] ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      Icon(
                                        Icons.close,
                                        size: 15,
                                        color: AppTheme.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Education',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        readOnly: true,
                        // controller: qulification,
                        onTap: () async {
                          if (kDebugMode) {
                            print("success");
                          }
                          // _showModal1([], "qul");
                          _showMultiModal([], s_Education, "qul");
                        },
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please Select Qualification';
                        //   }
                        //   return null;
                        // },
                        decoration: InputDecoration(
                          counterText: '',
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
                          hintText: 'Select Educations',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        spacing: 3.0,
                        runSpacing: 2.0,
                        children: s_Education
                            .asMap()
                            .entries
                            .map(
                              (entry) => GestureDetector(
                                onTap: () {
                                  // Remove the skill when the close icon is clicked
                                  setState(() {
                                    s_Education.removeAt(entry.key);
                                  });
                                },
                                child: Chip(
                                  labelStyle:
                                      TextStyle(color: AppTheme.primary),
                                  side: BorderSide(color: AppTheme.primary),
                                  padding: const EdgeInsets.all(0.0),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        entry.value['qualification'] ?? "",
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      Icon(
                                        Icons.close,
                                        size: 15,
                                        color: AppTheme.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: ScreenWidth,
                          child: ElevatedButton(
                              onPressed: () async {
                                // Nav.to(context, JobDescription());
                                if (isLoading == false || isLoading == true) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (_formKey1.currentState!.validate()) {
                                    int minMonths =
                                        int.tryParse(min_months.text) ?? 0;
                                    int maxMonths =
                                        int.tryParse(max_months.text) ?? 0;
                                    if (s_keySkills.length == 0) {
                                      Snackbar.show(
                                          "Please add skills", Colors.black);
                                    } else if (selectedTypes.length == 0) {
                                      Snackbar.show(
                                          "Please select employe type",
                                          Colors.black);
                                    } else if (add_KeyWord.length == 0) {
                                      Snackbar.show(
                                          "Please add key word", Colors.black);
                                    } else if (s_Education.length == 0) {
                                      Snackbar.show(
                                          "Please add education", Colors.black);
                                    } else if (selectedExperience.isEmpty) {
                                      Snackbar.show("Please select job type",
                                          Colors.black);
                                    } else if (maxMonths < minMonths) {
                                      Snackbar.show(
                                          "Max Months must be less than or equal to Min Months",
                                          Colors.black);
                                    } else {
                                      var UserResponse =
                                          PrefManager.read("UserResponse");
                                      var data = {
                                        "user_id": UserResponse['data']['id'],
                                        "job_title": job_title.text,
                                        "employment_type_ids":
                                            merge(selectedTypes, "id"),
                                        "from_sal_currency": s_currencyId,
                                        "from_sal": _currentRangeValues.start
                                            .toInt()
                                            .toString(),
                                        "to_sal_currency": s_currencyId,
                                        "to_sal": _currentRangeValues.end
                                            .toInt()
                                            .toString(),
                                        "is_hide_salary": hideSalary ? 1 : 0,
                                        "deprtment_id": s_jobCatId,
                                        "skills":
                                            merge(s_keySkills, "skill_name"),
                                        "keywords":
                                            merge(add_KeyWord, 'skill_name'),
                                        // "education_id": s_educationId,
                                        "education_id":
                                            merge(s_Education, "id"),
                                        "job_level_id": s_jobLevelId,
                                        "experience_level": selectedExperience,
                                        "min_exp_months":
                                            min_months.text.isEmpty
                                                ? 0
                                                : min_months.text,
                                        "max_exp_months":
                                            max_months.text.isEmpty
                                                ? 0
                                                : max_months.text,
                                        "job_id": widget.editData['id'] ?? ""
                                      };
                                      print(data);

                                      var result = await PostApi.createJob(
                                          context,
                                          data,
                                          UserResponse['data']['api_token']);
                                      print(result);

                                      if (result.success) {
                                        if (result.data['status'].toString() ==
                                            "1") {
                                          Nav.to(
                                              context,
                                              EditJobDescription(
                                                editData: widget.editData,
                                              ));
                                          // var bac_result = await Nav.to(
                                          //     context,
                                          //     JobDescription(
                                          //         job_id: result.data['data']
                                          //                 ['id']
                                          //             .toString()));
                                          setState(() {
                                            // bac_job_id = bac_result;
                                          });
                                        } else if (result.data['message'] !=
                                            null) {
                                          Snackbar.show(result.data['message'],
                                              Colors.black);
                                        } else {
                                          Snackbar.show(
                                              "Some Error", Colors.red);
                                        }
                                      } else {
                                        Snackbar.show("Some Error", Colors.red);
                                      }
                                      // Nav.to(
                                      //     context,
                                      //     JobDescription(
                                      //       job_id: '10',
                                      //     ));
                                    }
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                              child: !isLoading
                                  ? const Text(
                                      "Next Step",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Loader.common())),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )
            : ShimmerLoader(type: ""),
      ),
    );
  }
}
