import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rent_space/helpers/my_shimmer.dart';

Widget cachedImage(
  String url, {
  double? width,
  double? height,
  BoxFit? fit,
}) {
  return CachedNetworkImage(
    imageUrl: url,
    height: height,
    width: width,
    fit: fit,
    progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
        height: height,
        width: width,
        // color: Colors.grey,
        child: const MyShimmer(
          child: Icon(
            Icons.house_outlined,
            color: Colors.grey,
          ),
        )),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}
