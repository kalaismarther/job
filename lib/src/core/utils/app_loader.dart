import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Loader {
  static common() {
    return const SizedBox(
      height: 30,
      width: 30,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: Colors.white,
      ),
    );
  }
  // static userDashboard(){
  //   return
  // }
}

class ShimmerLoader extends StatefulWidget {
  final String type;
  ShimmerLoader({super.key, required this.type});

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader> {
  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    // double _h = MediaQuery.of(context).size.height;
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            widget.type == "details"
                ? Column(
                    children: [
                      Skeleton(
                        width: _w,
                        height: 150,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Skeleton(
                            width: _w * 0.2,
                            height: _w * 0.1,
                          ),
                          Skeleton(
                            width: _w * 0.2,
                            height: _w * 0.1,
                          ),
                          Skeleton(
                            width: _w * 0.2,
                            height: _w * 0.1,
                          ),
                          Skeleton(
                            width: _w * 0.1,
                            height: _w * 0.1,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : SizedBox(
                    height: 0,
                  ),
            widget.type == "latest"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Skeleton(
                        width: _w * 0.7,
                        height: _w * 0.3,
                      ),
                      Skeleton(
                        width: _w * 0.2,
                        height: _w * 0.3,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Skeleton(
                        width: _w,
                        height: 150,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Skeleton(
                        width: _w,
                        height: 150,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Skeleton(
                        width: _w,
                        height: 150,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Skeleton(
                        width: _w,
                        height: 150,
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton({Key? key, this.height, this.width}) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.all(5.0),
      height: height,
      width: width,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          // color: Colors.grey[500],
          // color: Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}
