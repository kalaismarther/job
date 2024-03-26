import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {super.key,
      required this.message,
      required this.isMe,
      required this.image,
      required this.online,
      required this.date});

  final String message;
  final String image;
  final String date;
  final bool online;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    String changeDateFormat(String date) {
      DateTime dateWithTime = DateTime.parse(date);

      String formattedDate = DateFormat('dd/MM/yy HH:mm').format(dateWithTime);

      return formattedDate;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isMe
                      ? const Color.fromARGB(213, 133, 136, 238)
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(maxWidth: 250),
                padding: EdgeInsets.only(
                    top: image.isEmpty ? 10 : 5,
                    bottom: 22,
                    left: image.isEmpty ? 8 : 5,
                    right: image.isEmpty && message.length <= 4
                        ? 60
                        : image.isEmpty && message.length < 6
                            ? 45
                            : image.isEmpty
                                ? 22
                                : 5),
                margin: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    image.isNotEmpty
                        ? !online
                            ? image.endsWith('jpg') ||
                                    image.endsWith('png') ||
                                    image.endsWith('jpeg')
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: image,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: 200,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          const SizedBox(
                                        height: 200,
                                        width: double.infinity,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.image,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.black,
                                  )
                            : Image.file(File(image))
                        : const SizedBox(
                            height: 0,
                          ),
                    if (image.isNotEmpty)
                      const SizedBox(
                        height: 10,
                      ),
                    Text(
                      message,
                      style: const TextStyle(
                        height: 1.3,
                        color: Colors.black87,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                bottom: 9,
                child: Text(
                  changeDateFormat(date).substring(0, 14),
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
  }
}
