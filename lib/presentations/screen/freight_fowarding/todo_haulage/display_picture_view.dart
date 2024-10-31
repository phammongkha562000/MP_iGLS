import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:igls_new/businesses_logics/bloc/freight_fowarding/todo_haulage/display_picture/display_picture_bloc.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/app_bar_custom.dart';
import '../../../widgets/widgets.dart';

class DisplayPictureView extends StatefulWidget {
  const DisplayPictureView({
    super.key,
  });
  @override
  State<DisplayPictureView> createState() => _DisplayPictureViewState();
}

class _DisplayPictureViewState extends State<DisplayPictureView> {
  late GeneralBloc generalBloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DisplayPictureBloc, DisplayPictureState>(
      listener: (context, state) {
        if (state is DisplayPictureSaveSuccess) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            showToastWidget(const SuccessToast(),
                position: StyledToastPosition.top,
                animation: StyledToastAnimation.slideFromRightFade,
                context: context);
          });
          Navigator.pop(
              context, 1); // trả về tùy ý để load lại api ở màn hình trước
        } else if (state is DisplayPictureFailure) {
          if (state.errorCode == constants.errorNoConnect) {
            CustomDialog().error(context,
                err: state.message,
                btnMessage: '5038'.tr(),
                btnOkOnPress: () => Navigator.pop(context));
            return;
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            showToastWidget(ErrorToast(error: state.message),
                position: StyledToastPosition.top,
                animation: StyledToastAnimation.slideFromRightFade,
                context: context);
          });
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<DisplayPictureBloc, DisplayPictureState>(
        builder: (context, state) {
          if (state is DisplayPictureSuccess) {
            return Scaffold(
              appBar: AppBarCustom(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context, state.docRefType);
                  },
                ),
              ),
              body: Center(
                child: ListView.builder(
                  itemCount: state.files.length,
                  itemBuilder: (context, index) => Image.file(
                    File(state.files[index].path),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: colors.defaultColor,
                onPressed: () => BlocProvider.of<DisplayPictureBloc>(context)
                    .add(DisplayPictureSaved(
                        generalBloc: generalBloc,
                        files: state.files,
                        docRefType: state.docRefType,
                        refNoType: state.refNoType,
                        refNoValue: state.refNoValue)),
                child: const Icon(Icons.save),
              ),
            );
          }
          return Scaffold(
            appBar: AppBarCustom(title: Text('Display'.tr())),
            body: const Center(
              child: ItemLoading(),
            ),
          );
        },
      ),
    );
  }
}
