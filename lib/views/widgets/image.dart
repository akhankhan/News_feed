import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  final BoxFit fit;
  final svg;

  const ImageWidget({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.svg,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
            value: downloadProgress.progress,
          ),
        ),
      ),
      errorWidget: (context, url, error) => SizedBox(
        width: width,
        child: Center(
          child: svg ?? const Icon(Icons.person, color: Colors.white),
        ),
      ),
    );
  }
}
