import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/cy_site_response.dart';
import 'package:igls_new/data/models/setting/local_permission/local_permission_response.dart';
import 'package:igls_new/data/services/extension/extensions.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/shared/mixin/alert.dart';
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/components/drop_down_button_form_field2_widget.dart';
import 'package:igls_new/presentations/widgets/layout_common.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../widgets/card_custom/card_custom.dart';
import '../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../businesses_logics/bloc/user_profile/user_profile_bloc.dart';

import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import '../../widgets/dropdown_custom/dropdown_custom.dart' as dropdown_custom;

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> with Alert {
  final _formKey = GlobalKey<FormState>();
  String? customer;
  String? tags;

  DcLocal? selectedValueDCLocal;
  ContactLocal? selectedValueContactLocal;
  CySiteResponse? selectedCY;

  final ValueNotifier<String> _customerNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _dcNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _cyNotifier = ValueNotifier<String>('');

  final searchCustomerController = TextEditingController();
  final _phoneController = TextEditingController();
  final _driverIdController = TextEditingController();
  final _equipmentController = TextEditingController();
  final _emailController = TextEditingController();
  final _navigationService = getIt<NavigationService>();
  late UserProfileBloc _bloc;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<UserProfileBloc>(context);
    _bloc.add(UserProfileLoaded(generalBloc: generalBloc));
    super.initState();
  }

  Future<bool> _back(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, routes.homePageRoute);
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async => _back(context),
      // onPopInvokedWithResult: (didPop, result) => _back(context),
      child: Scaffold(
        appBar: AppBarCustom(
          title: Text("2428".tr()),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _navigationService.canPop()
                  ? Navigator.pop(context)
                  : _navigationService
                      .pushNamedAndRemoveUntil(routes.homePageRoute)),
        ),
        body: BlocConsumer<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileSuccess) {
              if (state.isSuccess == true) {
                CustomDialog().success(context);
              }
            }
            if (state is UserProfileFailure) {
              CustomDialog().error(context, err: state.message);
            }
          },
          builder: (context, state) {
            if (state is UserProfileSuccess) {
              _phoneController.text = state.phone ?? "";
              _driverIdController.text = state.driverId ?? "";
              _equipmentController.text = state.equipment ?? "";
              _emailController.text = generalBloc.generalUserInfo?.email ?? '';
              _cyNotifier.value = state.cyCode ?? "";
              if (state.listContactLocal != null &&
                  state.listContactLocal != [] &&
                  state.listContactLocal!.isNotEmpty) {
                _customerNotifier.value = state.contactCode ?? "";
                if (state.listContactLocal != null) {
                  for (var element in state.listContactLocal!) {
                    if (element.contactCode == _customerNotifier.value) {
                      selectedValueContactLocal = element;
                    }
                  }
                }
              }
              if (state.listDCLocal != null &&
                  state.listDCLocal != [] &&
                  state.listDCLocal!.isNotEmpty) {
                _dcNotifier.value = state.dcCode ?? "";
                selectedValueDCLocal = state.listDCLocal?.firstWhere(
                    (element) => element.dcCode == _dcNotifier.value,
                    orElse: () => DcLocal(dcDesc: ''));
              }

              if (_cyNotifier.value.isEmpty) {
                selectedCY = null;
              } else {
                selectedCY = state.listCY
                    ?.where((element) => element.cyCode == _cyNotifier.value)
                    .single;
              }
              List<CySiteResponse> listLocalCy = <CySiteResponse>[
                CySiteResponse(cyCode: ""),
              ];
              listLocalCy = [
                ...listLocalCy,
                ...state.listCY ?? [],
              ];
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: LayoutCommon.spaceBottomView,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Avt(
                          avt: generalBloc.generalUserInfo?.avartarThumbnail ??
                              '',
                          companyName:
                              generalBloc.subsidiaryRes?.subsidiaryName ?? ''),
                      const TitleCard(text: "2487"),
                      CardCustom(
                        elevation: 3,
                        radius: 32.r,
                        child: Column(
                          children: [
                            buildDriverItem(
                                iconAsset: assets.phone,
                                controller: _phoneController,
                                hintText: '2416'),
                            buildDriverItem(
                                iconAsset: assets.user,
                                controller: _driverIdController,
                                hintText: '2499'),
                            buildDriverItem(
                                iconAsset: assets.equipment,
                                controller: _equipmentController,
                                hintText: '1298'),
                            buildDriverItem(
                                iconAsset: assets.icEmail,
                                controller: _emailController,
                                hintText: '2415'),
                          ],
                        ),
                      ),
                      const TitleCard(text: "4116"),
                      CardCustom(
                        elevation: 3,
                        radius: 32.r,
                        child: Column(
                          children: [
                            _row82(
                                icon2: assets.customer,
                                dropDown8: dropDownCustomer(state, context)),
                            _row82(
                                icon2: assets.tags,
                                dropDown8: dropDownDC(state)),
                            _row82(
                                icon2: assets.parking,
                                dropDown8:
                                    dropDownCY(listLocalCy: listLocalCy)),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildBtnSubmit()
                    ],
                  ),
                ),
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }

  Widget _row82({required String icon2, required Widget dropDown8}) => Row(
        children: [
          IconCustom(iConURL: icon2, size: 26).paddingOnly(right: 20.w),
          Expanded(
            child: dropDown8,
          )
        ],
      ).paddingSymmetric(vertical: MediaQuery.sizeOf(context).height * 0.005);
  Widget _buildBtnSubmit() {
    return ElevatedButtonWidget(
      isPaddingBottom: true,
      text: "37",
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _bloc.add(UserProfileUpdate(
            generalBloc: generalBloc,
            defaultContact: _customerNotifier.value,
            defaultfDC: _dcNotifier.value,
            defaultCY: _cyNotifier.value,
          ));
        }
      },
    );
  }

  Widget buildDriverItem(
      {required String iconAsset,
      required TextEditingController controller,
      required String hintText}) {
    return _row82(
      icon2: iconAsset,
      dropDown8: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          // enabled: false,
          fillColor: colors.textWhite,
          filled: true,

          hintText: hintText.tr(),
        ),
      ),
    );
  }

  Widget dropDownDC(UserProfileSuccess state) {
    return DropdownButtonFormField2<DcLocal>(
      barrierColor: dropdown_custom.bgDrawerColor(),
      decoration: dropdown_custom.customInputDecoration(color: Colors.white),
      validator: (value) {
        if (value == null) {
          return '5067'.tr();
        }
        return null;
      },
      isExpanded: true,
      buttonStyleData: dropdown_custom.customButtonStyleData(),
      menuItemStyleData: dropdown_custom.customMenuItemStyleData(),
      dropdownStyleData: dropdown_custom.customDropdownStyleData(context),
      hint: Text("5084".tr()),
      items: state.listDCLocal
          ?.map((item) => dropDownMenuItemDCLocal(item))
          .toList(),
      selectedItemBuilder: (context) {
        return state.listDCLocal != null
            ? state.listDCLocal!.map((e) {
                return buildSelectedItemDCLocal(e);
              }).toList()
            : [];
      },
      value: selectedValueDCLocal,
      onChanged: (value) {
        value as DcLocal;
        _dcNotifier.value = value.dcCode!;
        log("DC: ${_dcNotifier.value}");
      },
    );
  }

  Widget dropDownCY({required List<CySiteResponse> listLocalCy}) =>
      ValueListenableBuilder(
        valueListenable: _cyNotifier,
        builder: (context, value, child) {
          return DropdownButtonFormField2(
            barrierColor: dropdown_custom.bgDrawerColor(),
            decoration:
                dropdown_custom.customInputDecoration(color: Colors.white),
            isExpanded: true,
            buttonStyleData: dropdown_custom.customButtonStyleData(),
            menuItemStyleData: dropdown_custom.customMenuItemStyleData(),
            dropdownStyleData: dropdown_custom.customDropdownStyleData(context),
            hint: Text(
              "5083".tr(),
              style: const TextStyle(
                color: colors.textGrey,
                fontSize: sizeTextDefault,
              ),
            ),
            items: listLocalCy.map((item) => dropDownMenuItemCY(item)).toList(),
            selectedItemBuilder: (context) {
              return listLocalCy.map((e) {
                return buildSelectedItemCY(e);
              }).toList();
            },
            value: selectedCY ?? (selectedCY = listLocalCy[0]),
            onChanged: (value) {
              value as CySiteResponse;
              _cyNotifier.value = value.cyCode!;
              selectedCY = value;
            },
          );
        },
      );

  Widget dropDownCustomer(UserProfileSuccess state, BuildContext context) {
    return DropdownButtonFormField2<ContactLocal>(
      barrierColor: dropdown_custom.bgDrawerColor(),
      decoration: dropdown_custom.customInputDecoration(color: Colors.white),
      isExpanded: true,
      buttonStyleData: dropdown_custom.customButtonStyleData(),
      menuItemStyleData: dropdown_custom.customMenuItemStyleData(),
      dropdownStyleData: dropdown_custom.customDropdownStyleData(context),
      hint: Text("5082".tr()),
      items: state.listContactLocal
          ?.map((item) => dropDownMenuItemContact(item))
          .toList(),
      selectedItemBuilder: (context) {
        return state.listContactLocal != null
            ? state.listContactLocal!.map((e) {
                return buildSelectedItemContact(e);
              }).toList()
            : [];
      },
      value: selectedValueContactLocal,
      onChanged: (value) {
        value as ContactLocal;
        _customerNotifier.value = value.contactCode!;
        log("Customer: ${_customerNotifier.value}");
      },
      dropdownSearchData: DropdownSearchData(
        searchInnerWidgetHeight: 50,
        searchController: searchCustomerController,
        searchInnerWidget:
            buildSearch(context: context, controller: searchCustomerController),
        searchMatchFn: (item, searchValue) {
          ContactLocal contactLocal = item.value ?? ContactLocal();
          return (contactLocal.contactCode
                  .toString()
                  .toUpperCase()
                  .contains(searchValue.toUpperCase())) ||
              (TiengViet.parse(contactLocal.contactName.toString())
                  .toUpperCase()
                  .contains(TiengViet.parse(searchValue).toUpperCase()));
        },
      ),
    );
  }

  Widget buildSelectedItemDCLocal(DcLocal e) {
    return Text(
      e.dcDesc ?? "",
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: colors.defaultColor,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );
  }

  Widget buildSelectedItemContact(ContactLocal e) {
    return Text(
      e.contactName ?? "",
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: colors.defaultColor,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );
  }

  Widget buildSelectedItemCY(CySiteResponse e) {
    return e.cyCode == ""
        ? Text(
            "5083".tr(),
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: colors.textGrey,
              fontSize: sizeTextDefault,
            ),
          )
        : Text(
            e.cyName ?? "",
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: colors.defaultColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          );
  }

  Widget buildSelectedCY(CySiteResponse e) {
    return Text(
      e.cyName ?? "",
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: colors.defaultColor,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );
  }

  BoxDecoration decorationButton() {
    return BoxDecoration(
      color: colors.textWhite,
      border: Border.all(),
      borderRadius: BorderRadius.circular(32.r),
    );
  }

  DropdownMenuItem<DcLocal> dropDownMenuItemDCLocal(DcLocal item) {
    return DropdownMenuItem<DcLocal>(
      value: item,
      child: CardItemDropdownWidget(
        child: Row(
          children: [
            iconItemDropdown(iconAsset: assets.tags),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.dcDesc ?? "",
                      style: const TextStyle(
                        color: colors.defaultColor,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(
                    item.dcCode ?? "",
                    style: const TextStyle(color: colors.textGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<ContactLocal> dropDownMenuItemContact(ContactLocal item) {
    return DropdownMenuItem<ContactLocal>(
      value: item,
      child: CardItemDropdownWidget(
        child: Row(
          children: [
            iconItemDropdown(iconAsset: assets.customer),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.contactName ?? "",
                      style: const TextStyle(
                        color: colors.defaultColor,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(
                    item.contactCode ?? "",
                    style: const TextStyle(color: colors.textGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<CySiteResponse> dropDownMenuItemCY(CySiteResponse item) {
    return DropdownMenuItem<CySiteResponse>(
      value: item,
      child: CardItemDropdownWidget(
        child: Row(
          children: [
            iconItemDropdown(iconAsset: assets.parking),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.cyName ?? "",
                    style: const TextStyle(
                      color: colors.defaultColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding iconItemDropdown({required String iconAsset}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: IconCustom(iConURL: iconAsset, size: 36),
    );
  }
}

class TitleCard extends StatelessWidget {
  const TitleCard({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.sizeOf(context).width * 0.03, top: 16.h),
      child: Row(
        children: [
          Text(
            text.tr(),
            style: styleTextDefault,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
