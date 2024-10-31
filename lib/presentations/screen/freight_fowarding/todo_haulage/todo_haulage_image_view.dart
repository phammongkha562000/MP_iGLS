import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/freight_fowarding/todo_haulage/todo_haulage_image/todo_haulage_image_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/data/models/login/login.dart';
import 'package:igls_new/presentations/presentations.dart';
import 'package:photo_view/photo_view.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../widgets/app_bar_custom.dart';

class TodoHaulageImageView extends StatefulWidget {
  const TodoHaulageImageView({super.key, required this.trailerNo});
  final String trailerNo;
  @override
  State<TodoHaulageImageView> createState() => _TodoHaulageImageViewState();
}

class _TodoHaulageImageViewState extends State<TodoHaulageImageView> {
  late GeneralBloc generalBloc;
  late TodoHaulageImageBloc _bloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<TodoHaulageImageBloc>(context);
    _bloc.add(TodoHaulageImageViewLoaded(
        trailerNo: widget.trailerNo,
        userInfo: generalBloc.generalUserInfo ?? UserInfo()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text(widget.trailerNo)),
      body: BlocBuilder<TodoHaulageImageBloc, TodoHaulageImageState>(
        builder: (context, state) {
          if (state is TodoHaulageImageSuccess) {
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
