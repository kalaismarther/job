import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/features/dashboard/views/dashboard.dart';

class JobApply extends StatefulWidget {
  const JobApply({super.key});

  @override
  State<JobApply> createState() => _JobApplyState();
}

class _JobApplyState extends State<JobApply> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: screenWidth,
                  height: screenHeight * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/apply_success.png"),
                      const Text(
                        "Yeay!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("Your application has been sent")
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: screenWidth,
              child: TextButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(0, 50)),
                    backgroundColor: const MaterialStatePropertyAll(
                      Colors.white,
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: AppTheme.primary),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Nav.offAll(
                        context,
                        Dashboard(
                          current_index: 1,
                        ));
                  },
                  child: const Text(
                    "Find a similar job",
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: screenWidth,
              child: ElevatedButton(
                  onPressed: () {
                    Nav.offAll(
                        context,
                        Dashboard(
                          current_index: 0,
                        ));
                  },
                  child: const Text("Back to home")),
            )
          ],
        ),
      ),
    );
  }
}
