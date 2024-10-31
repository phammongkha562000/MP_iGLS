import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/freight_fowarding/haulage_activity/haulage_activity_bloc.dart';
import 'package:igls_new/data/models/setting/local_permission/local_permission_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';

import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/components/drop_down_button_form_field2_widget.dart';
import 'package:igls_new/presentations/widgets/dropdown_custom/dropdown_custom_widget.dart'
    as dropdown_custom;

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/app_bar_custom.dart';

class HaulageActivityView extends StatefulWidget {
  const HaulageActivityView({super.key});

  @override
  State<HaulageActivityView> createState() => _HaulageActivityViewState();
}

class _HaulageActivityViewState extends State<HaulageActivityView> {
  final _formKey = GlobalKey<FormState>();
  String? hourSelected;
  final _localNotifier = ValueNotifier<String>('');
  final List<int> hourList = <int>[1, 3, 6, 12, 24];
  final _hourNotifier = ValueNotifier<String>('');
  final _navigationService = getIt<NavigationService>();
  bool isTap = false;
  String haHour = '24';
  late HaulageActivityBloc _bloc;
  final ValueNotifier<ContactLocal> _customerNotifer =
      ValueNotifier<ContactLocal>(
          ContactLocal(contactCode: '', contactName: ''));
  ContactLocal? customerSelected;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    hourSelected = null;
    _bloc = BlocProvider.of<HaulageActivityBloc>(context);
    _bloc.add(HaulageActivityViewLoaded(generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text('4769'.tr()),
      ),
      body: BlocConsumer<HaulageActivityBloc, HaulageActivityState>(
        listener: (context, state) {
          if (state is HaulageActivitySuccess) {
            if (state.url != null) {
              _navigationService.pushNamed(routes.webViewRoute, args: {
                key_params.urlCheckList: state.url,
                key_params.tripNo: customerSelected!.contactName
              });
            }
          }
          if (state is HaulageActivityFailure) {
            CustomDialog().error(context, err: state.message);
          }
        },
        builder: (context, state) {
          if (state is HaulageActivitySuccess) {
            return Form(
              key: _formKey,
              child: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: ValueListenableBuilder(
                        valueListenable: _localNotifier,
                        builder: (context, value, child) =>
                            DropDownButtonFormField2ContactLocalWidget(
                          onChanged: (value) {
                            _customerNotifer.value = value as ContactLocal;
                            customerSelected = value;
                          },
                          value: customerSelected,
                          hintText: '5082',
                          label: Text.rich(TextSpan(children: [
                            TextSpan(
                                text: '1272'.tr(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            const TextSpan(
                                text: ' *',
                                style: TextStyle(color: colors.textRed)),
                          ])),
                          list: state.contactList,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.h, bottom: 32.h),
                      child: ValueListenableBuilder(
                        valueListenable: _hourNotifier,
                        builder: (context1, value, child) =>
                            DropdownButtonFormField2(
                          barrierColor: dropdown_custom.bgDrawerColor(),
                          value: hourSelected,
                          isExpanded: true,
                          decoration: InputDecoration(
                            label: Text.rich(TextSpan(children: [
                              TextSpan(text: '4330'.tr()),
                              const TextSpan(
                                  text: ' *',
                                  style: TextStyle(color: colors.textRed)),
                            ])),
                          ),
                          buttonStyleData:
                              dropdown_custom.customButtonStyleData(),
                          menuItemStyleData:
                              dropdown_custom.customMenuItemStyleData(),
                          dropdownStyleData:
                              dropdown_custom.customDropdownStyleData(context),
                          validator: (value) {
                            if (value == null) {
                              return "5067".tr();
                            }
                            return null;
                          },
                          hint: Text("4330".tr()),
                          onChanged: (value) {
                            _hourNotifier.value = value as String;
                            hourSelected = value;
                          },
                          selectedItemBuilder: (context) {
                            return hourList.map((e) {
                              return Text(
                                e.toString(),
                                textAlign: TextAlign.left,
                              );
                            }).toList();
                          },
                          items: hourList
                              .map((e) => e.toString())
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child:
                                  dropdown_custom.cardItemDropdown(children: [
                                Center(
                                  child: Text(value.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                )
                              ]),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    ElevatedButtonWidget(
                      text: '36'.tr(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<HaulageActivityBloc>(context)
                              .add(HaulageActivityPressed(
                            generalBloc: generalBloc,
                            hour: int.parse(hourSelected!),
                            contactCode: customerSelected!.contactCode!,
                          ));
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          }
          return const ItemLoading();
        },
      ),
    );
  }
}
