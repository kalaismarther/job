import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job/src/core/utils/logout.dart';
import 'package:job/src/core/utils/uri.dart';

class ChatApi {
  Future loadChatApi(data, token, context) async {
    var response = await http.post(
      Uri.parse(URI.load_chat),
      headers: {'Content-Type': 'application/json', 'x-api-key': token},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      if (result['status'] == 3 || result['status'] == "3") {
        // print("Logout");
        await Logout.logout(context, "session");
        return;
      } else {
        return json.decode(response.body);
      }
    } else {
      throw Exception('Failed');
    }
  }
}
