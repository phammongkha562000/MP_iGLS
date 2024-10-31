import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/inbound_order_status/inbound_order_status_search/inbound_order_status_search_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_inbound_order_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_inbound_order_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import 'package:igls_new/data/models/customer/home/customer_permission_res.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/contact_dropdown.dart';
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/std_code_dropdown.dart';
import 'package:igls_new/presentations/widgets/default_button.dart';
import 'package:igls_new/presentations/widgets/dialog/custom_dialog.dart';
import 'package:igls_new/presentations/widgets/pick_date_previous_next.dart';
import 'package:rxdart/rxdart.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

class InboundOrderStatusSearchView extends StatefulWidget {
  const InboundOrderStatusSearchView({super.key});

  @override
  State<InboundOrderStatusSearchView> createState() =>
      _InboundOrderStatusSearchViewState();
}

class _InboundOrderStatusSearchViewState
    extends State<InboundOrderStatusSearchView> {
  final _orderNoController = TextEditingController();
  final _navigationService = getIt<NavigationService>();

  late CustomerBloc customerBloc;
  late InboundOrderStatusSearchBloc _bloc;

  final ValueNotifier _viewDetailNotifier = ValueNotifier(false);
  final fromDateCtrl = TextEditingController(
      text: FileUtils.formatToStringFromDatetime2(
          DateTime.now().subtract(const Duration(days: 1))));
  final toDateCtrl = TextEditingController(
      text: FileUtils.formatToStringFromDatetime2(DateTime.now()));
  final BehaviorSubject<List<GetInboundOrderRes>> lstInoundCtrl =
      BehaviorSubject<List<GetInboundOrderRes>>();
  ValueNotifier<List<GetStdCodeRes>> lstOrdStatus = ValueNotifier([]);
  ValueNotifier<List<GetStdCodeRes>> lstInboundDateser = ValueNotifier([]);
  ValueNotifier<List<UserDCResult>> lstDC = ValueNotifier([]);
  ValueNotifier inboundDateserSelected = ValueNotifier(GetStdCodeRes());
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime toDate = DateTime.now();

  GetStdCodeRes? orderStatusSelected;
  UserDCResult? dcSelected;
  String? contactSelected;
  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _bloc = BlocProvider.of<InboundOrderStatusSearchBloc>(context);
    _bloc.add(InboundOrderStatusSearchViewLoaded(customerBloc: customerBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text('5537'.tr())),
      body: BlocConsumer<InboundOrderStatusSearchBloc,
          InboundOrderStatusSearchState>(listener: (context, state) {
        if (state is InboundOrderStatusSearchFailure) {
          CustomDialog().error(context, err: state.message, btnOkOnPress: () {
            Navigator.pop(context);
          });
        }
        if (state is InboundOrderStatusSearchSuccess) {
          lstOrdStatus.value = state.lstOrdStatus;
          lstInboundDateser.value = state.lstInboundDateser;
          lstDC.value = state.lstDC;
          if (state.lstInboundDateser.isNotEmpty) {
            inboundDateserSelected.value = state.lstInboundDateser
                .where((element) => element.codeID == 'ETA')
                .first;
          }
          contactSelected =
              customerBloc.userLoginRes?.userInfo?.defaultClient ?? '';
        }
      }, builder: (context, state) {
        return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            child: Column(
              children: [
                _buildOrderNo(),
                _buildOrderStatus(),
                _buildFromToDate(),
                _buildDC(),
                _buildContractCode(),
              ],
            ));
      }),
      bottomNavigationBar: _buildBtnSearch(),
    );
  }

  _buildOrderNo() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: TextFormField(
          controller: _orderNoController,
          decoration: InputDecoration(label: Text('122'.tr())),
        ),
      );

  _buildOrderStatus() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(children: [
          Expanded(
              child: ValueListenableBuilder(
            valueListenable: lstOrdStatus,
            builder: (context, value, child) {
              return CustomerSTDCodeDropdown(
                  value:
                      value.isNotEmpty ? orderStatusSelected ?? value[0] : null,
                  onChanged: (p0) {
                    orderStatusSelected = p0 as GetStdCodeRes;
                  },
                  label: '124',
                  listSTD: value);
            },
          )),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
              child: ValueListenableBuilder(
            valueListenable: lstInboundDateser,
            builder: (context, value, child) {
              return CustomerSTDCodeDropdown(
                  value: value.isNotEmpty
                      ? inboundDateserSelected.value ?? value[0]
                      : null,
                  onChanged: (p0) {
                    inboundDateserSelected.value = p0 as GetStdCodeRes;
                  },
                  label: '',
                  listSTD: value);
            },
          )),
        ]),
      );

  _buildFromToDate() => Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              pickDate(
                  date: fromDate,
                  context: context,
                  function: (selectDate) {
                    fromDateCtrl.text =
                        FileUtils.formatToStringFromDatetime2(selectDate);
                    fromDate = selectDate;
                  });
            },
            child: TextFormField(
              controller: fromDateCtrl,
              enabled: false,
              decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.calendar_month),
                  label: Text('5273'.tr())),
            ),
          )),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: GestureDetector(
            onTap: () {
              pickDate(
                  date: toDate,
                  context: context,
                  function: (selectDate) {
                    toDateCtrl.text =
                        FileUtils.formatToStringFromDatetime2(selectDate);
                    toDate = selectDate;
                  });
            },
            child: TextFormField(
              controller: toDateCtrl,
              enabled: false,
              decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.calendar_month),
                  label: Text('5274'.tr())),
            ),
          )),
        ],
      ));

  _buildDC() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: ValueListenableBuilder(
                    valueListenable: lstDC,
                    builder: (context, value, child) {
                      return DropdownButtonFormField2(
                        value: value.isNotEmpty
                            ? dcSelected ?? value[0]
                            : UserDCResult(),
                        isExpanded: true,
                        decoration: InputDecoration(
                          label: Text('90'.tr()),
                        ),
                        dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16))),
                        menuItemStyleData: MenuItemStyleData(
                            selectedMenuItemBuilder: (context, child) {
                          return ColoredBox(
                            color: colors.defaultColor.withOpacity(0.2),
                            child: child,
                          );
                        }),
                        onChanged: (value) {
                          dcSelected = value as UserDCResult;
                        },
                        selectedItemBuilder: (context) {
                          return value.map((e) {
                            return Text(
                              e.dCDesc ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            );
                          }).toList();
                        },
                        items: value.map<DropdownMenuItem<UserDCResult>>(
                            (UserDCResult value) {
                          return DropdownMenuItem<UserDCResult>(
                            value: value,
                            child: Text(
                              value.dCDesc.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                      );
                    })),
            Expanded(
                flex: 2,
                child: ValueListenableBuilder(
                  valueListenable: _viewDetailNotifier,
                  builder: (context, value, child) => CheckboxListTile(
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    title: Text('5275'.tr()),
                    value: value,
                    onChanged: (value) {
                      _viewDetailNotifier.value = value;
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ))
          ],
        ),
      );
  _buildContractCode() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.w),
        child: CustomerContactDropdown(
            lstContact: [...customerBloc.contactList!.map((e) => e.clientId!)],
            value: contactSelected,
            label: '1326',
            onChanged: (p0) {
              String contactCode = p0 as String;
              contactSelected = contactCode;

              // iosBloc.add(CustomerGetInboundOrder(
              //     subsidiaryId: userInfo.subsidiaryId ?? '',
              //     model: GetInboundOrderReq(
              //         contactCode: contactSelected ?? '',
              //         dcNo: userInfo.defaultCenter ?? '',
              //         dateF: FileUtils.formatToStringFromDatetime(fromDate),
              //         dateT: FileUtils.formatToStringFromDatetime(toDate),
              //         dateTypeSearch:
              //             inboundDateserSelected.value.codeDesc ?? '',
              //         isViewDetail:
              //             _viewDetailNotifier.value == true ? "1" : "0",
              //         orderNo: _orderNoController.text,
              //         orderStatus: orderStatusSelected?.codeDesc ?? '')));
            }),
      );
  _buildBtnSearch() => Padding(
        padding: EdgeInsets.all(8.0.w),
        child: ElevatedButtonWidget(
            onPressed: () {
              _navigationService.pushNamed(routes.customerIOSRoute, args: {
                key_params.cusIOSModel: GetInboundOrderReq(
                    contactCode: contactSelected ?? '',
                    dcNo: customerBloc.userLoginRes?.userInfo?.defaultCenter ??
                        '',
                    dateF: FileUtils.formatToStringFromDatetime(fromDate),
                    dateT: FileUtils.formatToStringFromDatetime(toDate),
                    dateTypeSearch: inboundDateserSelected.value.codeDesc ?? '',
                    isViewDetail: _viewDetailNotifier.value == true ? "1" : "0",
                    orderNo: _orderNoController.text,
                    orderStatus: orderStatusSelected?.codeDesc ?? '')
              });
              /*  UserInfo userInfo =
                  customerBloc.userLoginRes?.userInfo ?? UserInfo();
              iosBloc.add(CustomerGetInboundOrder(
                  subsidiaryId: userInfo.subsidiaryId ?? '',
                  model: GetInboundOrderReq(
                      contactCode: contactSelected ?? '',
                      dcNo: userInfo.defaultCenter ?? '',
                      dateF: FileUtils.formatToStringFromDatetime(fromDate),
                      dateT: FileUtils.formatToStringFromDatetime(toDate),
                      dateTypeSearch:
                          inboundDateserSelected.value.codeDesc ?? '',
                      isViewDetail:
                          _viewDetailNotifier.value == true ? "1" : "0",
                      orderNo: _orderNoController.text,
                      orderStatus: orderStatusSelected?.codeDesc ?? '')));
              Navigator.pop(context); */
            },
            text: '36'),
      );
}
