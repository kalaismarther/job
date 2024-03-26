import 'package:flutter/material.dart';

class Nav {
  /* ══════════════════════════════╡ proceeds to new screen and doesn't closes old ╞══════════════════════════════ */
  static Future<dynamic> to(BuildContext context, Widget page) async {
    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

 static Future<dynamic> toName(BuildContext context, Widget page) async {
  return await Navigator.of(context).push(
    CustomMaterialPageRoute(builder: (_) => page, maintainState: true),
  );
}

//   static Future<dynamic> toName(BuildContext context, Widget page) async {
//   return await Navigator.of(context).push(
//     MaterialPageRoute(builder: (_) => page),
//     maintainState: true, // Set maintainState to true
//   );
// }

  /* ══════════════════════════════╡ closes current and opens new  ╞══════════════════════════════ */
  static Future<dynamic> off(BuildContext context, Widget page) async {
    return await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /* ══════════════════════════════╡ clears previous screens and opens new ╞══════════════════════════════ */
  static Future<dynamic> offAll(BuildContext context, Widget page) async {
    return await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (r) => false,
    );
  }

  /* ══════════════════════════════╡ only back ╞══════════════════════════════ */
  static Future<dynamic> back(BuildContext context, [Object? result]) async {
    return Navigator.of(context).pop(result);
  }
}

class CustomMaterialPageRoute extends MaterialPageRoute {
  CustomMaterialPageRoute({required WidgetBuilder builder, bool maintainState = true})
      : super(builder: builder, maintainState: maintainState);
}