import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/local_distribution/put_away/put_away_search/put_away_search_bloc.dart';
import 'package:igls_new/data/models/ware_house/put_away/order_type_response.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/widgets/admin_component/text_form_field_admin.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/components/dropdown_button_custom/dropdown_button_custom_staff.dart';
import 'package:rxdart/rxdart.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;

import 'package:igls_new/presentations/common/colors.dart' as colors;

import '../../../../data/services/services.dart';

class PutAwaySearchView extends StatefulWidget {
  const PutAwaySearchView({super.key});

  @override
  State<PutAwaySearchView> createState() => _PutAwaySearchViewState();
}

class _PutAwaySearchViewState extends State<PutAwaySearchView> {
  final TextEditingController _orderNoController = TextEditingController();

  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime toDate = DateTime.now();
  DateTime grDate = DateTime.now();
  final _grDateController = TextEditingController();

  BehaviorSubject<List<OrderTypeRes>> lstOrderType =
      BehaviorSubject<List<OrderTypeRes>>();
  BehaviorSubject<List<StaffsResponse>> lstStaffWorking =
      BehaviorSubject<List<StaffsResponse>>();

  final ValueNotifier<StaffsResponse> _staffNotifier =
      ValueNotifier<StaffsResponse>(StaffsResponse());
  StaffsResponse? staffSelected;

  final ValueNotifier<StaffsResponse> _doneByNotifier =
      ValueNotifier<StaffsResponse>(StaffsResponse());
  StaffsResponse? doneBySelected;
  late GeneralBloc generalBloc;
  late PutAwaySearchBloc _bloc;

  final _navigationService = getIt<NavigationService>();

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<PutAwaySearchBloc>(context);
    _bloc.add(PutAwaySearchViewLoaded(generalBloc: generalBloc));
    _fromDateController.text = FileUtils.formatToStringFromDatetime2(fromDate);
    _toDateController.text = FileUtils.formatToStringFromDatetime2(toDate);
    _grDateController.text = FileUtils.formatToStringFromDatetime2(grDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text('226'.tr())),
      body: BlocConsumer<PutAwaySearchBloc, PutAwaySearchState>(
        listener: (context, state) {
          if (state is PutAwaySearchSuccess) {
            lstOrderType.add(state.lstOrderType);
            lstStaffWorking.add(state.lstStaffWorking);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(title: 'General'),
                CardCustom(
                  margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
                  color: Colors.white,
                  elevation: 5,
                  radius: 32.r,
                  child: Column(
                    children: [
                      TextFormFieldAdmin(
                          controller: _orderNoController, label: 'Order No'),
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: DropdownButtonFormField2(
                          dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                          )),
                          menuItemStyleData: MenuItemStyleData(
                              selectedMenuItemBuilder: (context, child) {
                            return ColoredBox(
                              color: colors.defaultColor.withOpacity(0.2),
                              child: child,
                            );
                          }),
                          decoration:
                              const InputDecoration(label: Text('Order Type')),
                          items: lstOrderType.hasValue
                              ? lstOrderType.value
                                  .map<DropdownMenuItem<OrderTypeRes>>(
                                      (OrderTypeRes value) {
                                  return DropdownMenuItem<OrderTypeRes>(
                                    value: value,
                                    child: Text(
                                      value.orderTypeDesc.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  );
                                }).toList()
                              : [],
                          onChanged: (value) {},
                        ),
                      ),
                      _buildFromToDate(),
                      _buildStaff(
                          label: 'Assigned Staff',
                          onChanged: (value) {
                            _staffNotifier.value = value as StaffsResponse;
                            staffSelected = value;
                          },
                          staffSelected: staffSelected),
                    ],
                  ),
                ),
                _buildTitle(title: 'Put Away'),
                CardCustom(
                  margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
                  color: Colors.white,
                  elevation: 5,
                  radius: 32.r,
                  child: Column(
                    children: [
                      _buildGRDate(),
                      _buildStaff(
                          label: 'Done By',
                          onChanged: (value) {
                            _doneByNotifier.value = value as StaffsResponse;
                            doneBySelected = value;
                          },
                          staffSelected: doneBySelected)
                    ],
                  ),
                ),
                ElevatedButtonWidget(onPressed: () {}, text: '36'),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigationService.pushNamed(routes.addPutAwayRoute);
          },
          child: const Icon(Icons.add)),
    );
  }

  Widget _buildTitle({required String title}) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _buildStaff(
      {required String label,
      required dynamic Function(Object?) onChanged,
      StaffsResponse? staffSelected}) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: DropDownButtonFormField2StaffsWidget(
          isRequired: false,
          onChanged: onChanged,
          value: staffSelected,
          label: label,
          hintText: label,
          list: lstStaffWorking.hasValue ? lstStaffWorking.value : []),
    );
  }

  Widget _buildFromToDate() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 8.w),
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

  Widget _buildGRDate() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      child: InkWell(
        onTap: () {
          pickDate(
              date: grDate,
              context: context,
              function: (selectDate) {
                _grDateController.text =
                    FileUtils.formatToStringFromDatetime2(selectDate);
                grDate = selectDate;
                log(_grDateController.text);
              });
        },
        child: TextFormField(
          controller: _grDateController,
          enabled: false,
          decoration: InputDecoration(
              label: Text('GR Date'.tr()),
              suffixIcon:
                  const Icon(Icons.calendar_month, color: colors.defaultColor)),
        ),
      ),
    );
  }
}
