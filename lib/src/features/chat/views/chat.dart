import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:job/app.dart';
import 'package:job/src/core/utils/api_response.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/local_storage.dart';
import 'package:job/src/core/utils/logout.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/core/utils/notification_service.dart';
import 'package:job/src/core/utils/uri.dart';
import 'package:job/src/features/chat/chat_api.dart';
import 'package:job/src/features/chat/views/image_preview_screen.dart';
import 'package:job/src/features/chat/views/message_bubble.dart';
import 'package:http/http.dart' as http;

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  // late Future _chats;

  @override
  void initState() {
    initialize();
    _getTesting();
    super.initState();
  }

  initialize() async {
    await _getChatMessages();
    // checkingCurrentTime();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        if (pageNo != null && pageNo != chats.length) {
          setState(() {
            paginationLoader = true;
          });
          _getChatMessages();
        }
      }
    });
  }

  //
  bool showedAlert = false;

  _getTesting() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _getChatMessagesAfterNotification();
      print('success');
    });
  }

  //CONTROLLERS
  final _msgController = TextEditingController();
  final _scrollController = ScrollController();

  //LIST FOR STORING PREVIOUS CHAT MESSAGES
  List chats = [];

  //LIST FOR STORING PICKED IMAGES
  List<String> userPickedImages = [];

  //FOR PAGINATION
  int? pageNo;
  bool paginationLoader = false;

  //FOR LOADER
  bool isloading = true;
  bool imageSending = false;
  int? loadingListNo;

  //FOR SELECTED IMAGE
  String? selectedImage;

  Future<void> _getChatMessages() async {
    setState(() {
      pageNo = chats.length;
    });

    var UserResponse = PrefManager.read("UserResponse");

    var data = {
      "user_id": UserResponse['data']['id'],
      "page_no": chats.length,
      "sender_id": UserResponse['data']['id'],
      "receiver_id": 1
    };

    print(data);

    try {
      var result = await ChatApi()
          .loadChatApi(data, UserResponse['data']['api_token'], context);

      print(result);

      if (result['status'] == 3 || result['status'] == "3") {
        // print("Logout");
        await Logout.logout(context, "session");
        return;
      } else {
        setState(() {
          chats.addAll(result['data'] ?? []);
          paginationLoader = false;
          isloading = false;
        });
        if (result?['datemessage'] != null &&
            result['datemessage'].toString().isNotEmpty &&
            !showedAlert) {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              contentPadding: const EdgeInsets.all(25),
              children: [
                Text(
                  result?['datemessage'] ?? '',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.infinity, 47)),
                  onPressed: () {
                    Nav.back(context);
                  },
                  child: const Text('OK'),
                )
              ],
            ),
          );
          setState(() {
            showedAlert = true;
          });
        }

        print(chats[0]);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getChatMessagesAfterNotification() async {
    var UserResponse = PrefManager.read("UserResponse");

    var data = {
      "user_id": UserResponse['data']['id'],
      "page_no": 0,
      "sender_id": UserResponse['data']['id'],
      "receiver_id": 1
    };

    print(data);

    try {
      var result = await ChatApi()
          .loadChatApi(data, UserResponse['data']['api_token'], context);

      if (result['status'] == 3 || result['status'] == "3") {
        // print("Logout");
        await Logout.logout(context, "session");
        return;
      } else {
        setState(() {
          chats.clear();
          chats.addAll(result['data'] ?? []);
          paginationLoader = false;
          isloading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // void _sendTextMessage(Map newMessage) async {
  //   setState(() {
  //     chats.insert(0, newMessage);
  //   });

  //   var UserResponse = PrefManager.read("UserResponse");
  //   var data = {
  //     "user_id": UserResponse['data']['id'],
  //     "sender_id": UserResponse['data']['id'],
  //     "receiver_id": 1,
  //     "message_type": 1,
  //     "message": newMessage['message']
  //   };

  //   var response = await http.post(
  //     Uri.parse('http://18.189.69.82/jobs/api/post_chat'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'x-api-key': UserResponse['data']['api_token']
  //     },
  //     body: json.encode(data),

  //   );

  //   if (response.statusCode == 200) {
  //     var result = json.decode(response.body);

  //     if (result['status'] == 3 || result['status'] == "3") {
  //       // print("Logout");
  //       await Logout.logout(context, "session");
  //       return;
  //     } else {
  //       print(chats);
  //     }
  //   } else {
  //     throw Exception('Failed');
  //   }
  // }

  void _sendMessageWithImage(Map message) async {
    setState(() {
      chats.insert(0, message);
      userPickedImages.isNotEmpty ? userPickedImages.removeAt(0) : () {};
      loadingListNo = 0;
      imageSending = true;
    });
    var UserResponse = PrefManager.read("UserResponse");
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(URI.post_chat),
      );

      //HEADERS
      request.headers['x-api-key'] = UserResponse['data']['api_token'];

      //BODY
      request.fields['user_id'] = UserResponse['data']['id'].toString();
      request.fields['sender_id'] = UserResponse['data']['id'].toString();
      request.fields['receiver_id'] = '1';
      request.fields['message_type'] = selectedImage == null ? '1' : '4';
      request.fields['message'] = message['message'];

      print(message['message']);

      //ADD FILES
      if (selectedImage != null) {
        print('****************************');
        request.files.add(
            await http.MultipartFile.fromPath('preview_image', selectedImage!));
      }
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var result = json.decode(responseBody);

      print(result);
      if (result['status'].toString() == '1') {
        setState(() {
          imageSending = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _pickImage() async {
    setState(() {
      userPickedImages.clear();
    });
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage.path;
        userPickedImages.add(selectedImage!);
      });
    }
  }

  // void checkingCurrentTime() async {
  //   final currentTime = DateTime.now();
  //   print(currentTime.weekday);

  //   String message =
  //       'Our working Monday to Friday 9 to 6 clock.  Please drop your message we will get back to you at earliest.  You can call to customer service number +91 9740449939';

  //   if (currentTime.weekday == 6 ||
  //       currentTime.weekday == 7 ||
  //       currentTime.hour < 9 ||
  //       currentTime.hour > 18 ||
  //       (currentTime.hour == 18 && currentTime.minute > 01)) {
  //     // Get.rawSnackbar(
  //     //   dismissDirection: DismissDirection.horizontal,
  //     //   duration: Duration(days: 1),
  //     //   backgroundColor: Colors.black,
  //     //   snackPosition: SnackPosition.TOP,
  //     //   message: message,
  //     //   margin: EdgeInsets.only(top: 60),
  //     // );

  //   }
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String changeDateFormat(String date) {
      DateTime dateWithTime = DateTime.parse(date);
      String formattedDate = DateFormat('dd/MM/yy HH:mm').format(dateWithTime);
      return formattedDate;
    }

    var UserResponse = PrefManager.read("UserResponse");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text("Help and Support",
            style: TextStyle(color: AppTheme.white, fontSize: 18)),
        leading: IconButton(
          onPressed: () {
            Nav.back(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppTheme.white,
          ),
        ),
      ),
      body: Column(
        children: [
          paginationLoader
              ? const Column(
                  children: [
                    SizedBox(height: 5),
                    Center(
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                )
              : const SizedBox(
                  height: 0,
                ),
          Expanded(
              child: isloading
                  ? const Center(child: CircularProgressIndicator())
                  : chats.isEmpty
                      ? const Center(child: Text('No messages'))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: chats.length,
                          reverse: true,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemBuilder: (context, index) {
                            // final data = list[index];
                            String message = chats[index]['message'];
                            bool isMe = chats[index]['sender_id'] ==
                                UserResponse['data']['id'];
                            bool offline = chats[index]['addedLastly'] ?? false;
                            String date = chats[index]['created_date'];
                            String image = chats[index]['preview_image'] ?? '';

                            // return MessageBubble(
                            //     message: chats[index]['message'],
                            //     date: chats[index]['created_date'],
                            //     image: chats[index]['preview_image'] ?? '',
                            //     online: chats[index]['addedLastly'] ?? false,
                            //     isMe: chats[index]['sender_id'] ==
                            //             UserResponse['data']['id']
                            //         ? true
                            //         : false);

                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: isMe
                                              ? const Color.fromARGB(
                                                  213, 133, 136, 238)
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        constraints:
                                            const BoxConstraints(maxWidth: 250),
                                        padding: EdgeInsets.only(
                                            top: image.isEmpty ? 10 : 5,
                                            bottom: 22,
                                            left: image.isEmpty ? 8 : 5,
                                            right: image.isEmpty &&
                                                    message.length <= 5
                                                ? 60
                                                : image.isEmpty &&
                                                        message.length < 6
                                                    ? 45
                                                    : image.isEmpty
                                                        ? 22
                                                        : 5),
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 12,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            image.isNotEmpty
                                                ? !offline
                                                    ? image.endsWith('jpg') ||
                                                            image.endsWith(
                                                                'png') ||
                                                            image.endsWith(
                                                                'jpeg')
                                                        ? ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: image,
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      InkWell(
                                                                onTap: () {
                                                                  Nav.to(
                                                                      context,
                                                                      ImagePreviewScreen.networkImage(
                                                                          networkUrl:
                                                                              image));
                                                                },
                                                                child: Hero(
                                                                  tag: image,
                                                                  child:
                                                                      Container(
                                                                    height: 200,
                                                                    width: double
                                                                        .infinity,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .cover),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const SizedBox(
                                                                height: 200,
                                                                width: double
                                                                    .infinity,
                                                                child: Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(
                                                                Icons.image,
                                                              ),
                                                            ),
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .image_not_supported,
                                                            color: Colors.black,
                                                          )
                                                    : InkWell(
                                                        onTap: () {
                                                          Nav.to(
                                                            context,
                                                            ImagePreviewScreen
                                                                .fileImage(
                                                                    fileImagePath:
                                                                        selectedImage),
                                                          );
                                                        },
                                                        child: Hero(
                                                          tag: selectedImage!,
                                                          child: Image.file(
                                                              File(image)),
                                                        ))
                                                : const SizedBox(
                                                    height: 0,
                                                  ),
                                            if (image.isNotEmpty)
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            if (message.isNotEmpty) ...[
                                              Text(
                                                message,
                                                style: const TextStyle(
                                                  height: 1.3,
                                                  color: Colors.black87,
                                                ),
                                                softWrap: true,
                                              ),
                                            ]
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        right: 18,
                                        bottom: 9,
                                        child: loadingListNo == index &&
                                                imageSending
                                            ? const SizedBox(
                                                height: 5,
                                                width: 5,
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : Text(
                                                changeDateFormat(date)
                                                    .substring(0, 14),
                                                style: const TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.black54,
                                                ),
                                                softWrap: true,
                                              ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          })),
          // Container(
          //   padding: const EdgeInsets.all(10.0),
          //   child: Row(
          //     // mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       ClipOval(
          //         child: Padding(
          //           padding: const EdgeInsets.all(4.0),
          //           child: Image.asset(
          //             "assets/images/ellipse.png",
          //             height: 35,
          //           ),
          //         ),
          //       ),
          //       const SizedBox(
          //         width: 10,
          //       ),
          //       Expanded(
          //           child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         // mainAxisAlignment: MainAxisAlignment.start,
          //         children: [
          //           Row(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               const Text(
          //                 "Ganesh",
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 15,
          //                 ),
          //               ),
          //               const SizedBox(
          //                 width: 5,
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.only(top: 5.0),
          //                 child: Text(
          //                   "10.19 am",
          //                   style: TextStyle(
          //                     color: AppTheme.TextLite,
          //                     fontSize: 10,
          //                   ),
          //                 ),
          //               )
          //             ],
          //           ),
          //           const SizedBox(
          //             height: 3,
          //           ),
          //           Text(
          //             "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor.",
          //             maxLines: 2,
          //             overflow: TextOverflow.ellipsis,
          //             style: TextStyle(
          //                 color: AppTheme.TextBoldLite, fontSize: 13),
          //           ),
          //           const SizedBox(
          //             height: 3,
          //           ),
          //         ],
          //       )),
          //     ],
          //   ),
          // );
          //}),

          Padding(
            padding: const EdgeInsets.only(left: 10, right: 5, top: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: userPickedImages.isNotEmpty
                            ? BorderRadius.circular(10)
                            : BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade400,
                              spreadRadius: 1,
                              blurRadius: 1)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (userPickedImages.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Image.file(
                              File(selectedImage!),
                              height: 35,
                              width: 35,
                            ),
                          ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: _msgController,
                          decoration: InputDecoration(
                            constraints: BoxConstraints(maxHeight: 50),
                            hintText: selectedImage != null
                                ? 'Add caption'
                                : 'Enter your message',
                            filled: false,
                            suffixIcon: Container(
                              padding: const EdgeInsets.only(right: 5),
                              child: IconButton(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.image_rounded),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: AppTheme.primary),
                  child: IconButton(
                    onPressed: () {
                      if (selectedImage != null &&
                              _msgController.text.trim().isNotEmpty ||
                          _msgController.text.trim().isEmpty &&
                              selectedImage != null ||
                          selectedImage == null &&
                              _msgController.text.trim().isNotEmpty) {
                        Map newMsg = {
                          "message": _msgController.text,
                          "sender_id": UserResponse['data']['id'],
                          "created_date": DateTime.now().toString(),
                          "addedLastly": true,
                          "preview_image": selectedImage ?? '',
                        };
                        _sendMessageWithImage(newMsg);
                        try {
                          _scrollController.animateTo(
                              _scrollController.position.minScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                        } catch (e) {
                          print(e);
                        }
                        _msgController.clear();
                        return;
                      }
                      print('hi');
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10)
          // Container(
          //   decoration: BoxDecoration(
          //       border: Border(
          //           top: BorderSide(color: AppTheme.primary, width: 2),
          //           bottom: BorderSide(color: AppTheme.primary, width: 2))),
          //   child: TextFormField(
          //     maxLines: 3,
          //     decoration: const InputDecoration(
          //         fillColor: Colors.white,
          //         filled: true,
          //         hintText: "Write your Message"),
          //   ),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     // const Icon(Icons.edit_document),

          //     InkWell(
          //       onTap: () {},
          //       child: Padding(
          //         padding: const EdgeInsets.only(left: 10.0),
          //         child: Image.asset(
          //           "assets/icons/attach.png",
          //           height: 25,
          //         ),
          //       ),
          //     ),
          //     SizedBox(
          //       width: 100,
          //       height: 40,
          //       child: Padding(
          //         padding: const EdgeInsets.all(5.0),
          //         child: ElevatedButton(
          //             onPressed: () {}, child: const Text("Send")),
          //       ),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class OneToOneChatScreen extends StatefulWidget {
//   @override
//   _OneToOneChatScreenState createState() => _OneToOneChatScreenState();
// }

// class _OneToOneChatScreenState extends State<OneToOneChatScreen> {
//   List<Map<String, dynamic>> _messages = []; // List to store chat messages
//   TextEditingController _messageController = TextEditingController();
//   ScrollController _scrollController = ScrollController();
//   FocusNode _focusNode = FocusNode();

//   void _onFocusChange() {
//     if (_focusNode.hasFocus) {
//       // Scroll to the top when TextFormField gains focus
//       _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//     }
//   }

//   @override
//   void dispose() {
//     _focusNode.removeListener(_onFocusChange);
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(_onFocusChange);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat Screen'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index];
//                 print(message);
//                 return Container(
//                     // Existing message display code...
//                     margin: EdgeInsets.all(20.0),
//                     child: Text(message['text']));
//               },
//               //  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     focusNode: _focusNode,
//                     controller: _messageController,
//                     decoration:
//                         const InputDecoration(hintText: "Enter a Message"),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     _sendMessage(_messageController.text);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _sendMessage(String messageText) {
//     if (messageText.isNotEmpty) {
//       // Simulate sending a message (you would replace this with your actual logic)
//       Map<String, dynamic> newMessage = {
//         'sender': 'You',
//         'time': DateTime.now().toString(),
//         'text': messageText,
//       };

//       // Update the UI
//       setState(() {
//         _messages.add(newMessage);
//       });

//       //   _scrollController.animateTo(
//       //   _scrollController.position.maxScrollExtent,
//       //   duration: Duration(milliseconds: 300),
//       //   curve: Curves.easeOut,
//       // );

//       // Clear the input field
//       _messageController.clear();
//     }
//   }
// }
