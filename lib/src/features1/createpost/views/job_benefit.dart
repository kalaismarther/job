import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_loader.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/snackbar.dart';
import 'package:job/src/features1/createpost/post_api.dart';
import 'package:job/src/features1/createpost/views/steps.dart';
import 'package:job/src/features1/dashboard/views/provider_dashboard.dart';

class JobBenefit extends StatefulWidget {
  const JobBenefit({super.key, required this.user_id});

  final String user_id;

  @override
  State<JobBenefit> createState() => _JobBenefitState();
}

class _JobBenefitState extends State<JobBenefit> {
  List benefit = [];
  List selectedType = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    initilize();
    super.initState();
  }

  merge(values, name) {
    return values.map((value) => value[name]).join(',');
  }

  initilize() async {
    var UserResponse = PrefManager.read("UserResponse");
    var result = await PostApi.getCompnybenefits(
        context, UserResponse['data']['id'], UserResponse['data']['api_token']);

    setState(() {
      if (result.success) {
        benefit = result.data['data'];
      }
    });

    print(result.success);
    print(result.data);
  }

  void _showModal(value) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BenefitModal(
          benefitList: value,
          selectBenefit: selectedType,
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedType = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text("Create Post",
            style: TextStyle(color: AppTheme.white, fontSize: 18)),
        leading: IconButton(
            onPressed: () {
              Nav.back(
                context,
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme.white,
            )),
      ),
      bottomNavigationBar: SizedBox(
        width: ScreenWidth,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 8.0, top: 8.0, bottom: 25.0, right: 15.0),
          child: ElevatedButton(
              onPressed: () async {
                if (isLoading == false) {
                  setState(() {
                    isLoading = true;
                  });
                  // if (selectedType.length == 0) {
                  //   Snackbar.show('Please Add Benefit', Colors.black);
                  // } else {
                  var UserResponse = PrefManager.read("UserResponse");
                  var data = {
                    "user_id": UserResponse['data']['id'],
                    "job_benefits":
                        selectedType.isEmpty ? "" : merge(selectedType, "id"),
                    "job_id": widget.user_id
                  };
                  var result = await PostApi.updateJobBenefit(
                      context, data, UserResponse['data']['api_token']);
                  if (result.success) {
                    if (result.data['status'].toString() == "1") {
                      if (result.data['message'] != null) {
                        Snackbar.show(result.data['message'], Colors.green);
                      } else {
                        Snackbar.show("Successfully", Colors.green);
                      }
                      Nav.offAll(context, ProviderDashboard());
                    } else if (result.data['message'] != null) {
                      Snackbar.show(result.data['message'], Colors.black);
                    } else {
                      Snackbar.show("Some Error", Colors.red);
                    }
                  } else {
                    Snackbar.show("Some Error", Colors.red);
                  }
                  // }
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: !isLoading ? Text("Submit") : Loader.common()),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Steps(),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Perks & Benefit',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  _showModal(benefit);
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
                        "Add Benefit",
                        style: TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: selectedType.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data = selectedType[index];
                    return Container(
                      margin: const EdgeInsets.all(3.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: const Offset(0.2, 0.2),
                                blurRadius: 6.0)
                          ]),
                      // decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     border: Border.all(color: AppTheme.TextLite)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Image.asset(
                              //   "assets/images/logo_dark.png",
                              //   width: 45,
                              // ),
                              Image.network(data['is_benefit_image'],
                                  width: 35, fit: BoxFit.fitWidth, errorBuilder:
                                      (BuildContext context, Object exception,
                                          StackTrace? stackTrace) {
                                // Handle the error here
                                return Center(
                                  child: Text('UnSupported Image'),
                                );
                              }),
                              InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      selectedType.removeAt(index);
                                    });
                                  },
                                  child: const Icon(Icons.close))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            data['benefit_name'] ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            data['benefit_description'] ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(color: AppTheme.TextLite),
                          )
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class BenefitModal extends StatefulWidget {
  const BenefitModal(
      {super.key, required this.benefitList, required this.selectBenefit});
  final List benefitList;
  final List selectBenefit;

  @override
  State<BenefitModal> createState() => _BenefitModalState();
}

class _BenefitModalState extends State<BenefitModal> {
  late List benefitList;
  late List selectBenefit;
  @override
  void initState() {
    super.initState();
    // Initialize local state variables with the values passed from the widget
    benefitList = widget.benefitList;
    selectBenefit = widget.selectBenefit;

    // Initialize selectedDistricts with default values
    selectBenefit = selectBenefit.map((selected) {
      int index = benefitList
          .indexWhere((district) => district["id"] == selected["id"]);
      return (index != -1 && index < benefitList.length)
          ? benefitList[index]
          : selected;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: widget.benefitList.length,
                itemBuilder: (context, index) {
                  final data = widget.benefitList[index];
                  return CheckboxListTile(
                    title: Text(data['benefit_name']),
                    // value: selectedTypes.contains(data),
                    value: selectBenefit.contains(benefitList[index]),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value!) {
                          selectBenefit.add(benefitList[index]);
                        } else {
                          selectBenefit.remove(benefitList[index]);
                        }
                      });
                    },
                  );
                })),
        SizedBox(
          width: ScreenWidth,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              onPressed: () {
                Nav.back(context, selectBenefit);
                // print(selectedDistricts);
              },
              child: Text("Add Benefit"),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
