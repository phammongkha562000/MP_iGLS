import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:cached_network_image/cached_network_image.dart';

class CacheImageAvatar extends StatelessWidget {
  const CacheImageAvatar({super.key, required this.urlAvatar});
  final String urlAvatar;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: urlAvatar,
      imageBuilder: (context, imageProvider) => Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.contain,
          ),
        ),
      ),
      placeholder: (context, url) => const SizedBox(
        height: 80,
        width: 80,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
      errorWidget: (context, url, error) => SizedBox(
        height: 80,
        width: 80,
        child: Center(
          child: Image.asset(assets.avtUser),
        ),
      ),
    );
  }
}
