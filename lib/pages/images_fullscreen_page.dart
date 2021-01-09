import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImagesFullScreenPage extends StatefulWidget {
  final List<String> images;

  const ImagesFullScreenPage(this.images);

  @override
  _ImagesFullScreenPageState createState() => _ImagesFullScreenPageState();
}

class _ImagesFullScreenPageState extends State<ImagesFullScreenPage> {
  @override
  Widget build(BuildContext context) {
    var image = widget.images.first;
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Hero(
        tag: image,
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
