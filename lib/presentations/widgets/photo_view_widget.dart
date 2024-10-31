import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewWidget extends StatefulWidget {
  const PhotoViewWidget({super.key, required this.path});
  final String path;
  @override
  State<PhotoViewWidget> createState() => _PhotoViewMaterialState();
}

class _PhotoViewMaterialState extends State<PhotoViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Column(
        children: [
          Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.cancel_rounded,
                    color: Colors.white,
                    size: 32,
                  ))),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: PhotoView(
                tightMode: true,
                imageProvider: NetworkImage('$widget.path'),
                initialScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.contained * 2,
                backgroundDecoration:
                    const BoxDecoration(color: Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
