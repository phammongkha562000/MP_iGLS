import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/inventory_wp/inventory_wp_search/inventory_wp_search_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inventory/inventory_req.dart';
import 'package:igls_new/data/models/customer/home/customer_permission_res.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/contact_dropdown.dart';
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/std_code_dropdown.dart';
import 'package:igls_new/presentations/widgets/default_button.dart';
import 'package:igls_new/presentations/widgets/pick_date_previous_next.dart';
import 'package:rxdart/rxdart.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

class CustomerInventorySearchView extends StatefulWidget {
  const CustomerInventorySearchView({super.key});

  @override
  State<CustomerInventorySearchView> createState() =>
      _CustomerInventorySearchViewState();
}

class _CustomerInventorySearchViewState
    extends State<CustomerInventorySearchView> {
  late CustomerBloc customerBloc;
  late InventoryWpSearchBloc _bloc;

  final _navigationService = getIt<NavigationService>();

  String? contactSelected;
  final ValueNotifier _contactNotifier = ValueNotifier<String>('');

  final _itemCodeController = TextEditingController();

  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime toDate = DateTime.now();
  UserDCResult? dcSelected;
  final ValueNotifier _isSummaryNotifier = ValueNotifier(false);
  final ValueNotifier _filterReceiptNotifier = ValueNotifier(false);
  GetStdCodeRes? itemStatusSelected;
  GetStdCodeRes? gradeSelected;

  BehaviorSubject<List<GetStdCodeRes>> lstGrade =
      BehaviorSubject<List<GetStdCodeRes>>();
  BehaviorSubject<List<GetStdCodeRes>> lstItemStatus =
      BehaviorSubject<List<GetStdCodeRes>>();
  BehaviorSubject<List<UserDCResult>> lstDC =
      BehaviorSubject<List<UserDCResult>>();

  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _bloc = BlocProvider.of<InventoryWpSearchBloc>(context);
    _bloc.add(InventoryWpSearchViewLoaded(customerBloc: customerBloc));
    contactSelected = customerBloc.userLoginRes?.userInfo?.defaultClient ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text('5536'.tr()), 
      ),
      body: BlocConsumer<InventoryWpSearchBloc, InventoryWpSearchState>(
        listener: (context, state) {
          if (state is InventoryWpSearchSuccess) {
            lstGrade.add(state.lstGrade);
            lstItemStatus.add(state.lstItemStatus);
            lstDC.add(state.lstDC);
            dcSelected = dcSelected ??
                (state.lstDC.isNotEmpty
                    ? state.lstDC
                        .where((element) =>
                            element.dCCode ==
                            customerBloc.userLoginRes?.userInfo?.defaultCenter)
                        .single
                    : UserDCResult());

            _fromDateController.text =
                FileUtils.formatToStringFromDatetime2(fromDate);
            _toDateController.text =
                FileUtils.formatToStringFromDatetime2(toDate);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            child: Column(
              children: [
                _buildItemCode(),
                _buildItemStatus(
                    lstItemsStatus:
                        lstItemStatus.hasValue ? lstItemStatus.value : [],
                    lstGrade: lstGrade.hasValue ? lstGrade.value : []),
                _buildFromToDate(),
                _buildFilterReceiptDate(),
                _buildDCSummary(lstDC: lstDC.hasValue ? lstDC.value : []),
                _buildContactList(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBtnSearch(),
    );
  }

  Widget _buildItemCode() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _itemCodeController,
        decoration: InputDecoration(label: Text('128'.tr())),
      ),
    );
  }

  Widget _buildDCSummary({required List<UserDCResult> lstDC}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: DropdownButtonFormField2(
              dropdownStyleData: DropdownStyleData(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(16))),
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
              menuItemStyleData:
                  MenuItemStyleData(selectedMenuItemBuilder: (context, child) {
                return ColoredBox(
                  color: colors.defaultColor.withOpacity(0.2),
                  child: child,
                );
              }),
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
                valueListenable: _isSummaryNotifier,
                builder: (context, value, child) => CheckboxListTile(
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                  title: Text('5368'.tr()),
                  value: value,
                  onChanged: (value) {
                    _isSummaryNotifier.value = value;
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildItemStatus({
    required List<GetStdCodeRes> lstItemsStatus,
    required List<GetStdCodeRes> lstGrade,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
              child: CustomerSTDCodeDropdown(
                  value: itemStatusSelected,
                  onChanged: (p0) {
                    itemStatusSelected = p0 as GetStdCodeRes;
                  },
                  label: '146',
                  listSTD: lstItemsStatus)),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: CustomerSTDCodeDropdown(
                  value: gradeSelected,
                  onChanged: (p0) {
                    gradeSelected = p0 as GetStdCodeRes;
                  },
                  label: '132',
                  listSTD: lstGrade)),
        ],
      ),
    );
  }

  Widget _buildBtnSearch() {
    return Padding(
      padding: EdgeInsets.all(8.h),
      child: ElevatedButtonWidget(
          onPressed: () {
            _navigationService.pushNamed(routes.customerInventoryRoute, args: {
              key_params.cusInventoryModel: CustomerInventoryReq(
                  contactCode: contactSelected ?? '',
                  dcNo: dcSelected?.dCCode ?? '',
                  grf: FileUtils.formatToStringFromDatetime(fromDate),
                  grt: FileUtils.formatToStringFromDatetime(toDate),
                  grade: gradeSelected?.codeID ?? '',
                  isSummary: _isSummaryNotifier.value ? "1" : "0",
                  itemCode: _itemCodeController.text,
                  itemStatus: itemStatusSelected?.codeID ?? "")
            });
          },
          text: '36'),
    );
  }

  Widget _buildContactList() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: CustomerContactDropdown(
          lstContact:
              customerBloc.contactList!.map((e) => e.clientId!).toList(),
          value: contactSelected,
          label: '1326',
          onChanged: (p0) {
            String contactCode = p0 as String;
            contactSelected = contactCode;
            _contactNotifier.value = contactCode;
          }),
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
                    _fromDateController.text =
                        FileUtils.formatToStringFromDatetime2(selectDate);
                    fromDate = selectDate;
                  });
            },
            child: TextFormField(
              controller: _fromDateController,
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
                    _toDateController.text =
                        FileUtils.formatToStringFromDatetime2(selectDate);
                    toDate = selectDate;
                  });
            },
            child: TextFormField(
              controller: _toDateController,
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

  Widget _buildFilterReceiptDate() {
    return ValueListenableBuilder(
      valueListenable: _filterReceiptNotifier,
      builder: (context, value, child) => CheckboxListTile(
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        title: Text('5367'.tr()),
        value: value,
        onChanged: (value) {
          _filterReceiptNotifier.value = value;
        },
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
