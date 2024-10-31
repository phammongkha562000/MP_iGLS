import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/booking/booking_search/booking_search_bloc.dart';
import 'package:igls_new/data/models/customer/global_visibility/booking/customer_booking_request.dart';
import 'package:igls_new/data/models/customer/global_visibility/track_and_trace/get_unloc_res.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/contact_dropdown.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

class BookingSearchView extends StatefulWidget {
  const BookingSearchView({super.key});

  @override
  State<BookingSearchView> createState() => _BookingSearchViewState();
}

class _BookingSearchViewState extends State<BookingSearchView> {
  final _navigationService = getIt<NavigationService>();

  late CustomerBloc customerBloc;
  late BookingSearchBloc _bloc;
  final TextEditingController _carrierBCNoController = TextEditingController();
  final TextEditingController _bookingNoController = TextEditingController();
  final TextEditingController _vesselController = TextEditingController();
  TextEditingController fromDateCtrl = TextEditingController(
      text: FileUtils.formatToStringFromDatetime2(
          DateTime.now().subtract(const Duration(days: 7))));
  DateTime fromDateFormat = DateTime.now().subtract(const Duration(days: 7));
  TextEditingController toDateCtrl = TextEditingController(
      text: FileUtils.formatToStringFromDatetime2(DateTime.now()));
  DateTime toDateFormat = DateTime.now();

  ValueNotifier<List<GetUnlocResult>> lstUnlocPod = ValueNotifier([]);
  GetUnlocResult? unblocPodSelected;
  final podCtrl = TextEditingController();

  String? contactSelected;

  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _bloc = BlocProvider.of<BookingSearchBloc>(context);
    _bloc.add(BookingSearchViewLoaded());
    contactSelected = customerBloc.userLoginRes?.userInfo?.defaultClient ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text('5502'.tr()),
      ),
      body: BlocConsumer<BookingSearchBloc, BookingSearchState>(
        listener: (context, state) {
          if (state is GetUnlocPodSuccess) {
            lstUnlocPod.value = state.lstUnloc;
          }

          if (state is GetUnlocFail) {
            CustomDialog()
                .error(context, err: state.message, btnOkOnPress: () {});
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildCarrierBLNo(),
              _buildBookingNo(),
              _buildVessel(),
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 12.h, 0, 6.h),
                child: Text(
                  '184'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              _buildTimePicker(),
              _buildPod(),
              _buildContactCode(),
            ]),
          );
        },
      ),
      bottomNavigationBar: buildBtnSearch(),
    );
  }

  Widget _buildCarrierBLNo() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: _carrierBCNoController,
        decoration: InputDecoration(label: Text('3719'.tr())),
      ),
    );
  }

  Widget _buildBookingNo() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: _bookingNoController,
        decoration: InputDecoration(label: Text('3718'.tr())),
      ),
    );
  }

  Widget _buildVessel() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: _vesselController,
        decoration: InputDecoration(label: Text('3608'.tr())),
      ),
    );
  }

  _buildTimePicker() => Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              pickDate(
                  date: fromDateFormat,
                  lastDate: toDateFormat,
                  context: context,
                  function: (selectDate) {
                    fromDateCtrl.text =
                        FileUtils.formatToStringFromDatetime2(selectDate);
                    fromDateFormat = selectDate;
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
              FocusManager.instance.primaryFocus?.unfocus();
              pickDate(
                  date: toDateFormat,
                  firstDate: fromDateFormat,
                  context: context,
                  function: (selectDate) {
                    toDateCtrl.text =
                        FileUtils.formatToStringFromDatetime2(selectDate);
                    toDateFormat = selectDate;
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
  Widget _buildPod() {
    final formKey = GlobalKey<FormState>();

    return Form(
        key: formKey,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  onChanged: (value) {
                    lstUnlocPod.value = [];
                    unblocPodSelected = null;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '5067'.tr();
                    }
                    return null;
                  },
                  controller: podCtrl,
                  decoration: InputDecoration(
                    label: Text('3643'.tr()),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                    onTap: () {
                      unblocPodSelected = null;
                      if (formKey.currentState!.validate()) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _bloc.add(GetUnlocPodEvent(unlocCode: podCtrl.text));
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                                colors: <Color>[
                                  colors.defaultColor,
                                  Colors.blue.shade100
                                ]),
                            borderRadius: BorderRadius.circular(10.r)),
                        margin: EdgeInsets.only(left: 4.w),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ))),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  flex: 4,
                  child: ValueListenableBuilder(
                      valueListenable: lstUnlocPod,
                      builder: (context, value, child) {
                        return value.isNotEmpty
                            ? DropdownButtonFormField2(
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
                                value: value.isNotEmpty
                                    ? unblocPodSelected ?? value[0]
                                    : GetUnlocResult(),
                                isExpanded: true,
                                onChanged: (value) {
                                  unblocPodSelected = value as GetUnlocResult;
                                  podCtrl.text =
                                      unblocPodSelected?.unlocCode ?? '';
                                },
                                selectedItemBuilder: (context) {
                                  return value.map((e) {
                                    return Text(
                                      e.placeName ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    );
                                  }).toList();
                                },
                                items: value
                                    .map<DropdownMenuItem<GetUnlocResult>>(
                                        (GetUnlocResult value) {
                                  return DropdownMenuItem<GetUnlocResult>(
                                    value: value,
                                    child: Text(
                                      value.placeName.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  );
                                }).toList(),
                              )
                            : const SizedBox();
                      }))
            ])));
  }

  Widget _buildContactCode() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: CustomerContactDropdown(
            lstContact: [...customerBloc.contactList!.map((e) => e.clientId!)],
            value: contactSelected,
            label: '1326',
            onChanged: (p0) {
              String contactCode = p0 as String;
              contactSelected = contactCode;
            }),
      );

  buildBtnSearch() => Padding(
        padding: EdgeInsets.all(8.w),
        child: ElevatedButtonWidget(
            onPressed: () {
              final content = CustomerBookingReq(
                  bookingNo: _bookingNoController.text.trim(),
                  carrierBcNo: _carrierBCNoController.text.trim(),
                  contactCode: contactSelected ?? '',
                  destination: unblocPodSelected?.unlocCode ?? '',
                  etdf: fromDateCtrl.text.trim(),
                  etdt: toDateCtrl.text.trim(),
                  vessel: _vesselController.text.trim());
              _navigationService.pushNamed(routes.customerBookingRoute,
                  args: {key_params.cusBookingModel: content});
            },
            text: '36'),
      );
}
