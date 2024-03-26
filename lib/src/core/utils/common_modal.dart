import 'package:flutter/material.dart';
import 'package:job/src/core/utils/navigation.dart';

class CommonModal extends StatefulWidget {
  final List districts;
  final List selectedDistricts;
  final String type;
  const CommonModal(
      {Key? key,
      required this.districts,
      required this.selectedDistricts,
      required this.type})
      : super(key: key);

  @override
  State<CommonModal> createState() => _CommonModalState();
}

class _CommonModalState extends State<CommonModal> {
  late List districts;
  late List selectedDistricts;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize local state variables with the values passed from the widget
    districts = widget.districts;
    selectedDistricts = widget.selectedDistricts;

    // Initialize selectedDistricts with default values
    // selectedDistricts = selectedDistricts.map((selected) {
    //   int index =
    //       districts.indexWhere((district) => district["id"] == selected["id"]);
    //   return (index != -1 && index < districts.length)
    //       ? districts[index]
    //       : selected;
    // }).toList();

    initilize();
  }

  initilize() async {
    widget.type == ""
        ? selectedDistricts = selectedDistricts.map((selected) {
            int index = districts.indexWhere(
                (district) => district["skill_name"] == selected["skill_name"]);
            return (index != -1 && index < districts.length)
                ? districts[index]
                : selected;
          }).toList()
        : selectedDistricts = selectedDistricts.map((selected) {
            int index = districts
                .indexWhere((district) => district["id"] == selected["id"]);
            return (index != -1 && index < districts.length)
                ? districts[index]
                : selected;
          }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    return Padding(
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
                  // _search();
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
            child: ListView.builder(
              itemCount: districts.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: widget.type == "industry"
                      ? Text(districts[index]["industry_name"])
                      : widget.type == "depart"
                          ? Text(districts[index]["department_name"])
                          : widget.type == "preffered"
                              ? Text(districts[index]["role_name"])
                              : Text(districts[index]["skill_name"]),
                  value: selectedDistricts.contains(districts[index]),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        selectedDistricts.add(districts[index]);
                      } else {
                        selectedDistricts.remove(districts[index]);
                      }
                    });
                  },
                );
              },
            ),
          ),
          SizedBox(
            width: ScreenWidth,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  Nav.back(context, selectedDistricts);
                  print(selectedDistricts);
                },
                child: const Text("Continue"),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
