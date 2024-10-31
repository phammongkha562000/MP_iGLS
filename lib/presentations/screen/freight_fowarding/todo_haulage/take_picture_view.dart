import 'package:flutter/material.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';

import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import 'package:photo_view/photo_view.dart';

import 'package:igls_new/presentations/common/key_params.dart' as key_params;

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/app_bar_custom.dart';

class TakePictureView extends StatefulWidget {
  const TakePictureView(
      {super.key,
      required this.title,
      required this.refNoType,
      required this.docRefType,
      required this.refNoValue,
      required this.allowEdit});
  final String title;
  final String refNoType;
  final String docRefType;
  final String refNoValue;
  final bool allowEdit;
  @override
  State<TakePictureView> createState() => _TakePictureViewState();
}

class _TakePictureViewState extends State<TakePictureView> {
  final _navigationService = getIt<NavigationService>();
  late TakePictureBloc _bloc;
  late GeneralBloc generalBloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<TakePictureBloc>(context);
    _bloc.add(TakePictureViewLoaded(
        generalBloc: generalBloc,
        docRefType: widget.docRefType,
        refNoType: widget.refNoType,
        refNoValue: widget.refNoValue));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text(widget.title),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            tooltip: 'ChooseGallery'.tr(),
            onPressed: () => BlocProvider.of<TakePictureBloc>(context).add(
                TakePicturePickGallery(
                    docRefType: widget.docRefType,
                    refNoType: widget.refNoType,
                    refNoValue: widget.refNoValue.toString())),
          ),
          // IconButton(
          //     onPressed: () {}, icon: const Icon(Icons.video_collection_sharp)),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.delete),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: colors.defaultColor,
          child: const Icon(Icons.photo_camera),
          onPressed: () => BlocProvider.of<TakePictureBloc>(context).add(
              TakePictureTakeCamera(
                  docRefType: widget.docRefType,
                  refNoType: widget.refNoType,
                  refNoValue: widget.refNoValue.toString()))),
      body: BlocListener<TakePictureBloc, TakePictureState>(
        listener: (context, state) async {
          if (state is TakePictureSuccess) {
            if (state.imageFiles != [] && state.imageFiles != null) {
              final result = await _navigationService
                  .navigateAndDisplaySelection(routes.displayPictureRoute,
                      args: {
                    key_params.pictureFile: state.imageFiles,
                    key_params.docRefType: widget.docRefType,
                    key_params.refNoType: widget.refNoType,
                    key_params.refNoValue: widget.refNoValue
                  });
              if (result != null) {
                _bloc.add(TakePictureViewLoaded(
                    generalBloc: generalBloc,
                    docRefType: widget.docRefType,
                    refNoType: widget.refNoType,
                    refNoValue: widget.refNoValue));
              }
            }
          } else if (state is TakePictureFailure) {
            if (state.errorCode == constants.errorNoConnect) {
              CustomDialog().error(context,
                  err: state.message,
                  btnMessage: '5038'.tr(),
                  btnOkOnPress: () => BlocProvider.of<TakePictureBloc>(context)
                      .add(TakePictureViewLoaded(
                          generalBloc: generalBloc,
                          docRefType: widget.docRefType,
                          refNoType: widget.refNoType,
                          refNoValue: widget.refNoValue)));
              return;
            }
            CustomDialog().error(context, err: state.message);
          }
        },
        child: BlocBuilder<TakePictureBloc, TakePictureState>(
          builder: (context, state) {
            if (state is TakePictureSuccess) {
              return state.imageListGet!.isEmpty
                  ? const EmptyWidget()
                  : GridView.count(
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      crossAxisCount: 4,
                      children: List.generate(state.imageListGet!.length, (i) {
                        return InkWell(
                            onTap: () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _photoView(
                                        state.imageListGet![i].filePath);
                                  },
                                ),
                            child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                              image: getImage(
                                  state.imageListGet![i].filePath ?? ''),
                              fit: BoxFit.cover,
                            ))));
                      }),
                    );
            }

            return const ItemLoading();
          },
        ),
      ),
    );
  }

  ImageProvider getImage(String url) {
    ImageProvider<Object> image;
    List<String> extensionAray = url.split('.');
    String extension = extensionAray[extensionAray.length - 1];
    switch (extension.toLowerCase()) {
      case 'png':
      case 'jpg':
      case 'jpeg':
        image = NetworkImage(url);
        break;
      case 'pdf':
        image = const AssetImage(assets.avtUser);
        break;
      // case 'ppt':
      //   image = AssetImage('assets/doc/ppt.png');
      //   break;
      // case 'xls':
      // case 'xlsx':
      //   image = AssetImage('assets/doc/xls.png');
      //   break;
      default:
        image = const AssetImage(assets.avtUser);
    }
    return image;
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
