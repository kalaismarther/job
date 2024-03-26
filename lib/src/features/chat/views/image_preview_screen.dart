import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job/src/core/utils/navigation.dart';

class ImagePreviewScreen extends StatefulWidget {
  const ImagePreviewScreen.fileImage({super.key, required this.fileImagePath})
      : networkUrl = null;
  const ImagePreviewScreen.networkImage({super.key, required this.networkUrl})
      : fileImagePath = null;

  final String? fileImagePath;
  final String? networkUrl;

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Nav.back(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      body: widget.networkUrl != null
          ? CachedNetworkImage(
              imageUrl: widget.networkUrl!,
              imageBuilder: (context, imageProvider) => Container(
                alignment: Alignment.center,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider),
                    ),
                  ),
                ),
              ),
              placeholder: (context, url) => const SizedBox(
                height: 200,
                width: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.image,
              ),
            )
          : Center(
              child: Image.file(
                File(widget.fileImagePath!),
              ),
            ),
    );
  }
}
