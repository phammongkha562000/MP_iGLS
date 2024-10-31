import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/haulage_daily/haulage_daily_cntr_image/haulage_daily_cntr_image_bloc.dart';
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:photo_view/photo_view.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

class HaulageDailyCNTRImageView extends StatefulWidget {
  const HaulageDailyCNTRImageView({super.key, required this.customerWoTaskID});
  final String customerWoTaskID;
  @override
  State<HaulageDailyCNTRImageView> createState() =>
      _HaulageDailyCNTRImageViewState();
}

class _HaulageDailyCNTRImageViewState extends State<HaulageDailyCNTRImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text(widget.customerWoTaskID)),
      body: BlocBuilder<HaulageDailyCNTRImageBloc, HaulageDailyCNTRImageState>(
        builder: (context, state) {
          if (state is HaulageDailyCNTRImageSuccess) {
            return ListView.separated(
              itemCount: state.imageList.length,
              itemBuilder: (context, index) => InkWell(
                  onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _photoView(state.imageList[index].filePath!
                              .replaceAll(constants.pathLocal,
                                  constants.urlGetImageTrailer));
                        },
                      ),
                  child: Image.network(state.imageList[index].filePath!
                      .replaceAll(
                          constants.pathLocal, constants.urlGetImageTrailer))),
              separatorBuilder: (context, index) => const Divider(),
            );
          }
          return const ItemLoading();
        },
      ),
    );
  }

  Widget _photoView(path) {
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
                imageProvider: NetworkImage('$path'),
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
