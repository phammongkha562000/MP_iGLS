import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/global_visibility/haulage_daily/haulage_daily_req.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/contact_dropdown.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

import '../../../../presentations.dart';

class HaulageDailySearchView extends StatefulWidget {
  const HaulageDailySearchView({super.key});

  @override
  State<HaulageDailySearchView> createState() => _HaulageDailySearchViewState();
}

class _HaulageDailySearchViewState extends State<HaulageDailySearchView> {
  final _navigationService = getIt<NavigationService>();

  final _bcblNoController = TextEditingController();
  final _cntrNoController = TextEditingController();
  DateTime planDate = DateTime.now();
  final _planDateController = TextEditingController();
  String? contactSelected;
  final ValueNotifier _contactNotifier = ValueNotifier<String>('');

  late CustomerBloc customerBloc;
  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _planDateController.text = FileUtils.formatToStringFromDatetime2(planDate);
    contactSelected = customerBloc.userLoginRes?.userInfo?.defaultClient;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBarCustom(
          title: Text('5534'.tr()), 
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
          child: Column(
            children: [
              _buildContact(),
              _buildPlanDate(),
              _buildBCBLNo(),
              _buildCNTRNo(),
            ],
          ),
        ),
        bottomNavigationBar: _buildBtnSearch(),
      ),
    );
  }

  Widget _buildPlanDate() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: InkWell(
        onTap: () {
          pickDate(
              date: planDate,
              context: context,
              function: (selectDate) {
                _planDateController.text =
                    FileUtils.formatToStringFromDatetime2(selectDate);
                planDate = selectDate;
              });
        },
        child: TextFormField(
          controller: _planDateController,
          enabled: false,
          decoration: InputDecoration(
              label: Text('3849'.tr()),
              suffixIcon:
                  const Icon(Icons.calendar_month, color: colors.defaultColor)),
        ),
      ),
    );
  }

  Widget _buildBCBLNo() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: _bcblNoController,
        decoration: InputDecoration(label: Text('5474'.tr())),
      ),
    );
  }

  Widget _buildCNTRNo() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: _cntrNoController,
        decoration: InputDecoration(label: Text('3645'.tr())),
      ),
    );
  }

  Widget _buildContact() {
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

  Widget _buildBtnSearch() {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: ElevatedButtonWidget(
          onPressed: () {
            _navigationService
                .pushNamed(routes.customerHaulageDailyRoute, args: {
              key_params.cusHaulageDailyModel: CustomerHaulageDailyReq(
                  blNo: _bcblNoController.text,
                  brachCode:
                      customerBloc.userLoginRes?.userInfo?.defaultBranch ?? '',
                  cntrNo: _cntrNoController.text,
                  company:
                      customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? '',
                  contactCode: contactSelected == ''
                      ? customerBloc
                          .cusPermission!.userSubsidaryResult![0].contactCode!
                          .trim()
                      : contactSelected ?? '',
                  date: FileUtils.formatToStringNoFlashFromDatetime(planDate))
            });
          },
          text: '36'),
    );
  }
}
