import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/customer.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/contact_dropdown.dart';
import 'package:igls_new/presentations/widgets/default_button.dart';
import 'package:igls_new/presentations/widgets/pick_date_previous_next.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

class HaulageOverviewSearchView extends StatefulWidget {
  const HaulageOverviewSearchView({super.key});

  @override
  State<HaulageOverviewSearchView> createState() =>
      _HaulageOverviewSearchViewState();
}

class _HaulageOverviewSearchViewState extends State<HaulageOverviewSearchView> {
  final _navigationService = getIt<NavigationService>();
  String? contactSelected;
  final ValueNotifier _contactNotifier = ValueNotifier<String>('');

  DateTime date = DateTime.now();
  final _dateController = TextEditingController();

  late CustomerBloc customerBloc;
  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    contactSelected = customerBloc.userLoginRes?.userInfo?.defaultClient ?? '';
    _dateController.text = FileUtils.formatToStringFromDatetime2(date);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text('5535'.tr()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        child: Column(
          children: [
            _buildContact(),
            _buildDate(),
          ],
        ),
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
          value: contactSelected,
          label: '1326',
          onChanged: (p0) {
            String contactCode = p0 as String;
            contactSelected = contactCode;
            _contactNotifier.value = contactCode;
          }),
    );
  }

  Widget _buildDate() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: InkWell(
        onTap: () {
          pickDate(
              date: date,
              context: context,
              function: (selectDate) {
                _dateController.text =
                    FileUtils.formatToStringFromDatetime2(selectDate);
                date = selectDate;
              });
        },
        child: TextFormField(
          controller: _dateController,
          enabled: false,
          decoration: InputDecoration(
              label: Text('3849'.tr()),
              suffixIcon:
                  const Icon(Icons.calendar_month, color: colors.defaultColor)),
        ),
      ),
    );
  }

  Widget _buildBtnSearch() {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: ElevatedButtonWidget(
          onPressed: () {
            _navigationService
                .pushNamed(routes.customerHaulageOverviewRoute, args: {
              key_params.cusHaulageOverviewModel: CustomerHaulageOverviewReq(
                  company:
                      customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? '',
                  contactCode: contactSelected == null
                      ? customerBloc.userLoginRes?.userInfo?.defaultClient ?? ''
                      : contactSelected ?? '',
                  branchCode:
                      customerBloc.userLoginRes?.userInfo?.defaultBranch ?? '',
                  dataType: 'E',
                  date: FileUtils.formatToStringNoFlashFromDatetime(date))
            });
            // BlocProvider.of<HaulageOverviewBloc>(context).add(
            //     HaulageOverviewSearch(
            //         dataType: _tabNotifier.value == 1 ? 'E' : 'I',
            //         customerBloc: customerBloc,
            //         date: FileUtils.formatToStringNoFlashFromDatetime(date),
            //         contactCode: contactSelected ?? ''));
            // Navigator.of(context).pop();
          },
          text: '36'),
    );
  }
}
