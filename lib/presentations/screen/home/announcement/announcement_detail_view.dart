import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:igls_new/businesses_logics/bloc/home/announcement/announcement_detail/announcement_detail_bloc.dart';
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/presentations.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/app_bar_custom.dart';

class AnnouncementDetailView extends StatefulWidget {
  const AnnouncementDetailView({
    super.key,
    required this.annId,
  });
  final int annId;

  @override
  State<AnnouncementDetailView> createState() => _AnnouncementDetailViewState();
}

class _AnnouncementDetailViewState extends State<AnnouncementDetailView> {
  final cmtController = TextEditingController();
  late GeneralBloc generalBloc;
  late AnnouncementDetailBloc _bloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<AnnouncementDetailBloc>(context);
    _bloc.add(AnnouncementDetailViewLoaded(
        annId: widget.annId, generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text('5546'.tr()),
      ),
      body: BlocListener<AnnouncementDetailBloc, AnnouncementDetailState>(
        listener: (context, state) {
          if (state is AnnouncementDetailFailure) {
            CustomDialog().error(context, err: state.message);
          }
        },
        child: BlocBuilder<AnnouncementDetailBloc, AnnouncementDetailState>(
          builder: (context, state) {
            if (state is AnnouncementDetailSuccess) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.detail.subject ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              '${'5547'.tr()}:  ${state.detail.annTypeDesc ?? ''}',
                            ),
                          ),
                          Text(
                            '${'62'.tr()}: ${FormatDateConstants.convertMMddyyyy(state.detail.createDate ?? '')}',
                          ),
                          const Divider(
                            color: colors.btnGreyDisable,
                            thickness: 1,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: CardCustom(
                      margin: EdgeInsets.zero,
                      child: ListView(
                        children: [
                          HtmlWidget(state.detail.contents ?? ''),
                        ],
                      ),
                    )),
                    Expanded(
                        flex: -1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(
                              color: colors.btnGreyDisable,
                              thickness: 1,
                            ),
                            Text(
                              "${'63'.tr()} ${state.detail.createUser}",
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            state.detail.requestforDriverAgreement == "1"
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ElevatedButtonWidget(
                                        isPadding: false,
                                        backgroundColor:
                                            state.detail.comment == null
                                                ? colors.defaultColor
                                                : colors.btnGreyDisable,
                                        text: 'Agreement'.tr(),
                                        onPressed: state.detail.comment == null
                                            ? () => _showComment(context,
                                                annId: state.detail.annId!)
                                            : null),
                                  )
                                : const SizedBox(),
                          ],
                        )),
                  ],
                ),
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }

  _showComment(BuildContext context, {required int annId}) async {
    final formKey = GlobalKey<FormState>();
    AwesomeDialog(
      padding: const EdgeInsets.all(24),
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      btnCancelColor: colors.textRed,
      btnOkColor: colors.textGreen,
      btnOkText: "5589".tr(),
      btnCancelText: "26".tr(),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Row(children: [
              Expanded(
                flex: 9,
                child: TextFormField(
                  controller: cmtController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    label: Text(
                      "Comment".tr(),
                      style: styleLabelInput,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          // clearText();
                          cmtController.clear();
                        },
                        icon: const IconCustom(
                          iConURL: assets.toastError,
                          size: 25,
                        )),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      return;
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      showToastWidget(
                        ErrorToast(
                          error: '5067'.tr(),
                        ),
                        position: StyledToastPosition.top,
                        animation: StyledToastAnimation.slideFromRightFade,
                        //SlideFromRightAnim
                        context: context,
                      );
                      return '5067'.tr();
                    }
                    return null;
                  },
                ),
              ),
            ]),
            const HeightSpacer(height: 0.01),
          ],
        ),
      ),
      btnCancelOnPress: () {
        cmtController.clear();
      },
      btnOkOnPress: () {
        if (formKey.currentState!.validate()) {
          BlocProvider.of<AnnouncementDetailBloc>(context).add(
              AnnouncementDetailUpdate(
                  cmt: cmtController.text,
                  annId: annId,
                  generalBloc: generalBloc));
        }
      },
    ).show();
  }
}
