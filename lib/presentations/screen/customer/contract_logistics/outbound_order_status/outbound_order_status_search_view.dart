import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/outbound_order_status/outbound_order_status_search/outbound_order_status_search_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/outbound_order_status/outbound_order_status_req.dart';
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
import 'package:igls_new/presentations/common/colors.dart' as colors;

import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

class OutboundOrderStatusSearchView extends StatefulWidget {
  const OutboundOrderStatusSearchView({super.key});

  @override
  State<OutboundOrderStatusSearchView> createState() =>
      _OutboundOrderStatusSearchViewState();
}

class _OutboundOrderStatusSearchViewState
    extends State<OutboundOrderStatusSearchView> {
  final _navigationService = getIt<NavigationService>();

  late CustomerBloc customerBloc;
  late OutboundOrderStatusSearchBloc _bloc;
  final ValueNotifier _viewDetailNotifier = ValueNotifier(false);

  GetStdCodeRes? orderStatusSelected;
  GetStdCodeRes? outboundDateserSelected;
  UserDCResult? dcSelected;
  final _orderNoController = TextEditingController();

  final fromDateCtrl = TextEditingController(
      text: FileUtils.formatToStringFromDatetime2(
          DateTime.now().subtract(const Duration(days: 1))));
  final toDateCtrl = TextEditingController(
      text: FileUtils.formatToStringFromDatetime2(DateTime.now()));
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime toDate = DateTime.now();
  ValueNotifier<List<GetStdCodeRes>> lstOrdStatus = ValueNotifier([]);
  ValueNotifier<List<GetStdCodeRes>> lstOutboundDateser = ValueNotifier([]);
  ValueNotifier<List<UserDCResult>> lstDC = ValueNotifier([]);
  ContactCodeRes? contactSelected;
  String? contactSelectedCode;

  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _bloc = BlocProvider.of<OutboundOrderStatusSearchBloc>(context);
    _bloc.add(OutboundOrderStatusSearchViewLoaded(customerBloc: customerBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text('5540'.tr())),
      body: BlocConsumer<OutboundOrderStatusSearchBloc,
          OutboundOrderStatusSearchState>(
        listener: (context, state) {
          if (state is OutboundOrderStatusSearchFailure) {
            CustomDialog().error(context, err: state.message, btnOkOnPress: () {
              Navigator.pop(context);
            });
          }
          if (state is OutboundOrderStatusSearchSuccess) {
            lstOrdStatus.value = state.lstOrdStatus;
            lstOutboundDateser.value = state.lstOutboundDateser;
            lstDC.value = state.lstDC;
            dcSelected = (state.lstDC.isNotEmpty
                ? state.lstDC
                    .where((element) =>
                        element.dCCode ==
                        customerBloc.userLoginRes?.userInfo?.defaultCenter)
                    .single
                : UserDCResult());
            contactSelectedCode =
                customerBloc.userLoginRes?.userInfo?.defaultClient ?? '';
            orderStatusSelected = (state.lstOrdStatus.isNotEmpty
                ? state.lstOrdStatus[0]
                : GetStdCodeRes());
            outboundDateserSelected = (state.lstOutboundDateser.isNotEmpty
                ? state.lstOutboundDateser[0]
                : GetStdCodeRes());
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            child: Column(children: [
              _buildOrderNo(),
              _buildOrderStatus(
                  lstOrdStatus: lstOrdStatus.value,
                  lstOutboundDateser: lstOutboundDateser.value),
              _buildFromToDate(),
              _buildDCViewDetail(lstDC: lstDC.value),
              _buildContact(),
            ]),
          );
        },
      ),
      bottomNavigationBar: _buildBtnSearch(),
    );
  }

  Widget _buildContact() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: CustomerContactDropdown(
          lstContact:
              customerBloc.contactList!.map((e) => e.clientId!).toList(),
          value: contactSelectedCode,
          label: '1326',
          onChanged: (p0) {
            String contactCode = p0 as String;
            contactSelectedCode = contactCode;
          }),
    );
  }

  Widget _buildBtnSearch() {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: ElevatedButtonWidget(
          onPressed: () {
            _navigationService.pushNamed(routes.customerOOSRoute, args: {
              key_params.cusOOSModel: CustomerOOSReq(
                  contactCode: contactSelectedCode ?? '',
                  dcNo: dcSelected?.dCCode ?? '',
                  dateF: FileUtils.formatToStringFromDatetime(fromDate),
                  dateT: FileUtils.formatToStringFromDatetime(toDate),
                  dateTypeSearch: outboundDateserSelected?.codeID ?? '',
                  isViewDetail: _viewDetailNotifier.value ? "1" : "0",
                  orderNo: _orderNoController.text,
                  orderStatus: orderStatusSelected?.codeID ?? '')
            });
            // BlocProvider.of<CustomerOOSBloc>(context).add(CustomerOOSSearch(
            //     customerBloc: customerBloc,
            //     orderNo: _orderNoController.text,
            //     orderStatus: orderStatusSelected ?? GetStdCodeRes(),
            //     dateTypeSearch: outboundDateserSelected ?? GetStdCodeRes(),
            //     fromDate: FileUtils.formatToStringFromDatetime(fromDate),
            //     toDate: FileUtils.formatToStringFromDatetime(toDate),
            //     dc: dcSelected ?? UserDCResult(),
            //     isViewDetail: _viewDetailNotifier.value ? "1" : "0",
            //     contactCode: contactSelectedCode ?? ''));
            // Navigator.of(context).pop();
          },
          text: '36'),
    );
  }

  Widget _buildDCViewDetail({required List<UserDCResult> lstDC}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: DropdownButtonFormField2(
              menuItemStyleData:
                  MenuItemStyleData(selectedMenuItemBuilder: (context, child) {
                return ColoredBox(
                  color: colors.defaultColor.withOpacity(0.2),
                  child: child,
                );
              }),
              dropdownStyleData: DropdownStyleData(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(16.r))),
              value: dcSelected,
              isExpanded: true,
              decoration: InputDecoration(
                label: Text('90'.tr()),
              ),
              onChanged: (value) {
                dcSelected = value as UserDCResult;
              },
              selectedItemBuilder: (context) {
                return lstDC.map((e) {
                  return Text(
                    e.dCDesc ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  );
                }).toList();
              },
              items: lstDC
                  .map<DropdownMenuItem<UserDCResult>>((UserDCResult value) {
                return DropdownMenuItem<UserDCResult>(
                  value: value,
                  child: Text(
                    value.dCDesc.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                );
              }).toList(),
            ),
          ),
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
  }

  Widget _buildFromToDate() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
              child: InkWell(
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
                  label: Text('5273'.tr()),
                  suffixIcon: const Icon(Icons.calendar_month,
                      color: colors.defaultColor)),
            ),
          )),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: InkWell(
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
                  label: Text('5274'.tr()),
                  suffixIcon: const Icon(Icons.calendar_month,
                      color: colors.defaultColor)),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildOrderStatus({
    required List<GetStdCodeRes> lstOrdStatus,
    required List<GetStdCodeRes> lstOutboundDateser,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
              child: CustomerSTDCodeDropdown(
                  value: orderStatusSelected,
                  onChanged: (p0) {
                    orderStatusSelected = p0 as GetStdCodeRes;
                  },
                  label: '124',
                  listSTD: lstOrdStatus)),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: CustomerSTDCodeDropdown(
                  value: outboundDateserSelected,
                  onChanged: (p0) {
                    outboundDateserSelected = p0 as GetStdCodeRes;
                  },
                  label: '',
                  listSTD: lstOutboundDateser)),
        ],
      ),
    );
  }

  Widget _buildOrderNo() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: _orderNoController,
        decoration: InputDecoration(label: Text('122'.tr())),
      ),
    );
  }
}
