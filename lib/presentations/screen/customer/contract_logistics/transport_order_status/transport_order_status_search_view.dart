import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/transport_order_status/transport_order_status_search/transport_order_status_search_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/company_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/transport_order_status_req.dart';
import 'package:igls_new/data/models/customer/home/customer_permission_res.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/company_dropdown.dart';
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/contact_dropdown.dart';
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/dc_dropdown.dart';
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/std_code_dropdown.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

import '../../../../../data/services/services.dart';

class CustomerTOSSearchView extends StatefulWidget {
  const CustomerTOSSearchView({super.key});

  @override
  State<CustomerTOSSearchView> createState() => _CustomerTOSSearchViewState();
}

class _CustomerTOSSearchViewState extends State<CustomerTOSSearchView> {
  final _navigationService = getIt<NavigationService>();

  late CustomerBloc customerBloc;
  late CustomerTOSSearchBloc _bloc;

  final _orderNoController = TextEditingController();
  final _tripNoController = TextEditingController();

  CustomerCompanyRes? pickSelected;
  CustomerCompanyRes? shipSelected;
  GetStdCodeRes? orderStatusSelected;
  UserDCResult? dcSelected;

  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime toDate = DateTime.now();

  String? contactSelected;
  final ValueNotifier _contactNotifier = ValueNotifier<String>('');

  ValueNotifier<List<CustomerCompanyRes>> companyLst = ValueNotifier([]);
  ValueNotifier<List<UserDCResult>> lstDC = ValueNotifier([]);
  ValueNotifier<List<GetStdCodeRes>> lstOrdStatus = ValueNotifier([]);
  List<String> lstContact = [];
  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _bloc = BlocProvider.of<CustomerTOSSearchBloc>(context);
    _bloc.add(CustomerTOSSearchViewLoaded(customerBloc: customerBloc));
    contactSelected = customerBloc.userLoginRes?.userInfo?.defaultClient ?? '';

    lstDC.value = customerBloc.cusPermission?.userDCResult ?? [];
    dcSelected = lstDC.value.isNotEmpty
        ? lstDC.value
            .where((element) =>
                element.dCCode ==
                customerBloc.userLoginRes?.userInfo?.defaultCenter)
            .single
        : UserDCResult();
    _fromDateController.text = FileUtils.formatToStringFromDatetime2(fromDate);
    _toDateController.text = FileUtils.formatToStringFromDatetime2(toDate);

    lstContact = customerBloc.contactList!.map((e) => e.clientId!).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text('5538'.tr()),
      ),
      body: BlocConsumer<CustomerTOSSearchBloc, CustomerTOSSearchState>(
        listener: (context, state) {
          if (state is CustomerTOSSearchFailure) {
            CustomDialog().error(context, err: state.message);
          }
          if (state is CustomerTOSSearchSuccess) {
            lstOrdStatus.value = state.lstOrderStatus;
            companyLst.value = state.lstCompany;
          }
        },
        builder: (context, state) {
          if (state is CustomerTOSSearchSuccess) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
              child: Column(children: [
                _buildTFF(label: '122', controller: _orderNoController),
                _buildTFF(label: '2468', controller: _tripNoController),
                _buildDDPick(),
                _buildDDShip(),
                _buildFromToDate(),
                _buildOrderStatus(),
                _buildDC(),
                _buildContact(),
              ]),
            );
          }
          return const ItemLoading();
        },
      ),
      bottomNavigationBar: _buildBtnSearch(),
    );
  }

  Widget _buildTFF(
      {required TextEditingController controller, required String label}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(label: Text(label.tr())),
      ),
    );
  }

  Widget _buildContact() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: CustomerContactDropdown(
          lstContact: lstContact,
          value: contactSelected,
          label: '1326',
          onChanged: (p0) {
            String contactCode = p0 as String;
            contactSelected = contactCode;
            _contactNotifier.value = contactCode;
          }),
    );
  }

  Widget _buildDDPick() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ValueListenableBuilder(
        valueListenable: companyLst,
        builder: (context, value, child) {
          return CustomerCompanyDropdown(
              value: pickSelected,
              onChanged: (p0) {
                pickSelected = p0 as CustomerCompanyRes;
              },
              label: '4575',
              listCompany: companyLst.value);
        },
      ),
    );
  }

  Widget _buildDDShip() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ValueListenableBuilder(
        valueListenable: companyLst,
        builder: (context, value, child) {
          return CustomerCompanyDropdown(
              value: shipSelected,
              onChanged: (p0) {
                shipSelected = p0 as CustomerCompanyRes;
              },
              label: '3855',
              listCompany: companyLst.value);
        },
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ValueListenableBuilder(
          valueListenable: lstOrdStatus,
          builder: (context, value, child) {
            return CustomerSTDCodeDropdown(
                value: orderStatusSelected,
                onChanged: (p0) {
                  orderStatusSelected = p0 as GetStdCodeRes;
                },
                label: '124',
                listSTD: lstOrdStatus.value);
          }),
    );
  }

  Widget _buildDC() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: CustomerDCDropdown(
          value: dcSelected,
          onChanged: (p0) {
            dcSelected = p0 as UserDCResult;
          },
          label: '1297',
          lstDC: lstDC.value),
    );
  }

  Widget _buildBtnSearch() {
    return Padding(
      padding: EdgeInsets.all(8.h),
      child: ElevatedButtonWidget(
          onPressed: () {
            _navigationService.pushNamed(routes.customerTOSRoute, args: {
              key_params.cusTOSModel: CustomerTOSReq(
                  contactCode: contactSelected ?? '',
                  dcNo: dcSelected?.dCCode ?? '',
                  dateF: FileUtils.formatToStringNoFlashFromDatetime(fromDate),
                  dateT: FileUtils.formatToStringNoFlashFromDatetime(toDate),
                  orderNo: _orderNoController.text,
                  orderStatus: orderStatusSelected?.codeID ?? '',
                  pickUp: pickSelected?.companyCode ?? '',
                  shipTo: shipSelected?.companyCode ?? '',
                  tripNo: _tripNoController.text)
            });
          },
          text: '36'),
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
                    log(_fromDateController.text);
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
                    log(_toDateController.text);
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
}
