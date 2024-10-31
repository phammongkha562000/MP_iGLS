import 'package:flutter/material.dart';

import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/widgets/components/drop_down_button_form_field2_widget.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/services/services.dart';
import '../../../widgets/app_bar_custom.dart';

class AddToDoTripView extends StatefulWidget {
  const AddToDoTripView({
    super.key,
    // required this.pageId,
    // required this.pageName,
  });
  // final String pageId;
  // final String pageName;
  @override
  State<AddToDoTripView> createState() => _AddToDoTripViewState();
}

class _AddToDoTripViewState extends State<AddToDoTripView> {
  ValueNotifier<ContactLocal> _customerNotifer = ValueNotifier<ContactLocal>(
      ContactLocal(contactCode: '', contactName: ''));
  ContactLocal? customerSelected;
  String? tripClassCode;
  final _navigationService = getIt<NavigationService>();

  final _memoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AddTodoTripBloc _bloc;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<AddTodoTripBloc>(context);
    _bloc.add(AddTodoTripViewLoaded(generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBarCustom(
          title: Text('mywork(new)'.tr()),
        ),
        body: BlocListener<AddTodoTripBloc, AddTodoTripState>(
          listener: (context, state) async {
            if (state is AddTodoTripSuccess) {
              if (state.isSuccess == true) {
                _navigationService.pushNamed(routes.editTodoTripRoute, args: {
                  key_params.tripNo: state.simpleTrip!.tripNo,
                  key_params.contactCode: state.simpleTrip!.contactCode,
                  key_params.isPendingTodoTrip:
                      false, //khi được phép add trip tức là không có trip nào pending
                  key_params.tripNoPending: state.simpleTrip!.tripNo,
                  // key_params.pageId: widget.pageId,
                  // key_params.pageName: widget.pageName
                });
                _clearText();
                CustomDialog().success(context);
              }
            } else if (state is AddTodoTripFailure) {
              _clearText();

              if (state.errorCode == constants.errorNoConnect) {
                CustomDialog().error(
                  context,
                  btnMessage: '5038'.tr(),
                  err: state.message,
                  btnOkOnPress: () => BlocProvider.of<AddTodoTripBloc>(context)
                      .add(AddTodoTripViewLoaded(generalBloc: generalBloc)),
                );
                return;
              }
              CustomDialog().error(context, err: state.message);
            }
          },
          child: BlocBuilder<AddTodoTripBloc, AddTodoTripState>(
            builder: (context, state) {
              if (state is AddTodoTripSuccess) {
                return Column(
                  children: [
                    Expanded(
                      child: CardCustom(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ValueListenableBuilder(
                                valueListenable: _customerNotifer,
                                builder: (context, value, child) =>
                                    DropDownButtonFormField2ContactLocalWidget(
                                      bgColor: Colors.white,
                                      hintText: 'choose_customer',
                                      label: Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text: '1272'.tr(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        const TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                                color: colors.textRed)),
                                      ])),
                                      list: state.contactList,
                                      onChanged: (value) {
                                        _customerNotifer.value =
                                            value as ContactLocal;
                                        customerSelected = value;
                                      },
                                      isLabel: true,
                                      value: customerSelected,
                                    )),
                          ),
                          _buildFreqList(
                              listFreq: state.contactList2,
                              listContact: state.contactList),
                          const HeightSpacer(height: 0.015),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  label: Text('1276'.tr()),
                                  fillColor: Colors.white,
                                  filled: true),
                              maxLines: 3,
                              minLines: 1,
                              controller: _memoController,
                            ),
                          )
                        ],
                      )),
                    ),
                    Expanded(
                      flex: -1,
                      child: ElevatedButtonWidget(
                        onPressed: () => _onSubmit(),
                        text: '37',
                      ),
                    ),
                  ],
                );
              }
              return const ItemLoading();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFreqList(
      {required List<ContactLocal> listFreq,
      required List<ContactLocal> listContact}) {
    return Wrap(
        direction: Axis.horizontal,
        children: List.generate(
            listFreq.length,
            (index) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(1),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(100, 30)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      onPressed: () {
                        final item = listContact
                            .where((element) =>
                                element.contactCode! ==
                                listFreq[index].contactCode)
                            .single;
                        _customerNotifer.value = item;
                        customerSelected = item;
                      },
                      child: Text(
                        listFreq[index].contactName!,
                        maxLines: 1,
                        style: const TextStyle(
                            color: colors.defaultColor,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold),
                      )),
                )));
  }

  _onSubmit() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AddTodoTripBloc>(context).add(AddTodoTripSubmit(
          generalBloc: generalBloc,
          contactCode: customerSelected!.contactCode!,
          memo: _memoController.text.trim(),
          tripClassCode: tripClassCode));
    }
  }

  void _clearText() {
    _customerNotifer = ValueNotifier<ContactLocal>(
        ContactLocal(contactCode: '', contactName: ''));
    customerSelected = null;
    _memoController.clear();
  }
}
