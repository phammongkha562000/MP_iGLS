import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/ware_house/inbound_photo/inbound_photo_bloc.dart';
import 'package:igls_new/data/models/ware_house/inbound_photo/order_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/shared/utils/format_number.dart';
import 'package:igls_new/presentations/presentations.dart';

import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/app_bar_custom.dart';

class InboundPhotoView extends StatefulWidget {
  const InboundPhotoView({super.key});

  @override
  State<InboundPhotoView> createState() => _InboundPhotoViewState();
}

class _InboundPhotoViewState extends State<InboundPhotoView> {
  final _navigationService = getIt<NavigationService>();
  late InboundPhotoBloc _bloc;
  late GeneralBloc generalBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<InboundPhotoBloc>(context);
    _bloc.add(
        InboundPhotoViewLoaded(date: DateTime.now(), generalBloc: generalBloc));
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        log("paging");
        _bloc.add(InboundPhotoPaging(generalBloc: generalBloc));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(
          title: Text('4804'.tr()),
        ),
        body: BlocConsumer<InboundPhotoBloc, InboundPhotoState>(
          listener: (context, state) {
            if (state is InboundPhotoFailure) {
              if (state.errorCode == constants.errorNoConnect) {
                CustomDialog().error(
                  btnMessage: '5038'.tr(),
                  context,
                  err: state.message,
                  btnOkOnPress: () => _bloc.add(InboundPhotoViewLoaded(
                      date: DateTime.now(), generalBloc: generalBloc)),
                );
                return;
              }
              CustomDialog().error(context, err: state.message.tr());
            }
          },
          builder: (context, state) {
            if (state is InboundPhotoSuccess) {
              return PickDatePreviousNextWidget(
                  quantityText: '${state.quantity}',
                  onTapPrevious: () {
                    _bloc.add(InboundPhotoPreviousDateLoaded(
                        generalBloc: generalBloc));
                  },
                  onTapPick: (selectDate) {
                    _bloc.add(InboundPhotoPickDate(
                        date: selectDate, generalBloc: generalBloc));
                  },
                  onTapNext: () {
                    _bloc.add(
                        InboundPhotoNextDateLoaded(generalBloc: generalBloc));
                  },
                  stateDate: state.date,
                  lstChild: [
                    Expanded(
                        child: state.orderList.isNotEmpty
                            ? ListView.builder(
                                controller: _scrollController,
                                itemCount: state.orderList.length,
                                itemBuilder: (context, index) {
                                  return _itemOrder(
                                      item: state.orderList[index]);
                                })
                            : const Center(
                                child: EmptyWidget(),
                              )),
                    state.isPagingLoading
                        ? const PagingLoading()
                        : const SizedBox()
                  ]);
            }
            return const ItemLoading();
          },
        ));
  }

  Widget _itemOrder({required InboundPhotoResult item}) => InkWell(
        onTap: () =>
            _navigationService.pushNamed(routes.takePictureRoute, args: {
          key_params.itemIdPicture: item.orderNo,
          key_params.titleGalleryTodo: item.orderNo,
          key_params.refNoValue: item.iOrdId.toString(),
          key_params.refNoType: "ORD",
          key_params.docRefType: "OT",
          key_params.allowEdit: true
        }),
        child: CardCustom(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.015,
              vertical: MediaQuery.sizeOf(context).width * 0.005),
          child: Column(
            children: [
              _rowItem(title: '122'.tr(), content: item.orderNo.toString()),
              _rowItem(title: '123'.tr(), content: item.iOrdType.toString()),
              _rowItem(
                  title: '4211'.tr(),
                  content: NumberFormatter.numberFormatTotalQty(item.qty ?? 0)),
            ],
          ),
        ),
      );
  Widget _rowItem({required String title, required String content}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).width * 0.007),
      child: RowFlex5and5(
        left: Text(
          title,
          style: styleTextTitle,
        ),
        right: Text(
          content,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
                                                                                                    