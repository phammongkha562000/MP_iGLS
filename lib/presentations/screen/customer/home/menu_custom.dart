import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import '../../../../data/models/customer/home/customer_permission_res.dart';
import '../../../../data/services/services.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

class MenuCustom extends StatefulWidget {
  const MenuCustom(
      {super.key,
      required this.listMenu,
      required this.lstMenuGroupBy,
      required this.userLang});
  final List<GetMenuResult> listMenu;
  final List<List<GetMenuResult>> lstMenuGroupBy;
  final String userLang;
  @override
  State<MenuCustom> createState() => _MenuCustomState();
}

final _navigationService = getIt<NavigationService>();

class _MenuCustomState extends State<MenuCustom> {
  Map<String, String> mapNaviagte = {
    constants.caseCustomerOOS: routes.customerOOSSearchRoute,
    constants.caseCustomerIOS: routes.customerIOSSearchRoute,
    constants.caseCustomerInventory: routes.customerInventorySearchRoute,
    constants.caseCustomerTOS: routes.customerTOSSearchRoute,
    // constants.caseTrackAndTrace: routes.customerTrackAndTraceRoute,
    constants.caseCNTRHaulage: routes.customerCNTRHaulageSearchRoute,
    constants.caseCNTRAgeing: routes.customerCNTRAgeingRoute,
    constants.caseProfile: routes.customerProfileRoute,
    constants.caseHaulageDaily: routes.customerHaulageDailySearchRoute,
    constants.caseHaulageOverview: routes.customerHaulageOverviewSearchRoute,
    // constants.caseDemDetStatus: routes.customerDemDetStatusRoute,
    constants.caseCustomerBooing: routes.customerBookingSearchRoute,
    constants.caseTransportOverview: routes.customerTransportOverviewRoute,
    constants.caseShuttleOverview: routes.customerShuttleOverviewRoute
  };

  late CustomerBloc customerBloc;
  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
      shrinkWrap: true,
      children: [
        Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: btnMenu(title: "243".tr(), route: constants.caseProfile)),
        Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: btnMenu(title: "5400".tr(), route: constants.caseContact)),
        customerBloc.userLoginRes?.userInfo?.userId != constants.adminId
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 10),
                itemCount: widget.lstMenuGroupBy.length,
                itemBuilder: (context, index) {
                  return itemMenu(
                    listGroup: widget.lstMenuGroupBy[index],
                  );
                })
            : ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 10),
                children: [itemMenu(listGroup: widget.lstMenuGroupBy.first)],
              ),
      ],
    );
  }

  getTitleByMenuId(String menuId) {
    for (var element in widget.listMenu) {
      if (element.menuId == menuId) {
        return widget.userLang == "EN" ? element.eN : element.vI;
      }
    }
  }

  Widget itemMenu({List<GetMenuResult>? listGroup}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            getTitleByMenuId(listGroup?.first.parentsMenu ?? ''),
            style: const TextStyle(
                color: textDarkBlue, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child:
              customerBloc.userLoginRes?.userInfo?.userId != constants.adminId
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: listGroup?.length,
                      itemBuilder: (context, index) {
                        return btnMenu(
                            title: widget.userLang == "EN"
                                ? listGroup![index].eN ?? ''
                                : listGroup![index].vI ?? '',
                            route: listGroup[index].tagVariant ?? '');
                      })
                  : ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: [
                        btnMenu(
                            title: "Cntr Haulage",
                            route: constants.caseCNTRHaulage),
                        btnMenu(
                            title: "Cntr Ageing",
                            route: constants.caseCNTRAgeing)
                      ],
                    ),
        )
      ],
    );
  }

  Widget btnMenu({required String title, required String route}) {
    return ListTile(
      onTap: () {
        route == constants.caseContact
            ? _navigationService.pushNamed(routes.contactRoute,
                args: {key_params.subsidiaryOb: customerBloc.subsidiaryRes})
            : mapNaviagte[route] == null
                ? showUpdateLater(context).show()
                : _navigationService.pushNamed(mapNaviagte[route] ?? '');
      },
      contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      horizontalTitleGap: 1,
      trailing: const Icon(Icons.keyboard_arrow_right_sharp,
          color: Colors.blue, size: 25),
      title: Text(
        title,
        style: const TextStyle(
          color: textDarkBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  AwesomeDialog showUpdateLater(context) {
    return AwesomeDialog(
      dialogType: DialogType.info,
      btnOkColor: colors.textGreen,
      btnOkOnPress: () {},
      context: context,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const HeightSpacer(height: 0.01),
          Text(
            "5251".tr(),
            style: styleTextTitle,
          ),
          const HeightSpacer(height: 0.01),
        ],
      ),
    );
  }
}
