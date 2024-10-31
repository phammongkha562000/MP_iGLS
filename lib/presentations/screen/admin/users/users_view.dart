import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/admin/users/users/users_bloc.dart';
import 'package:igls_new/data/models/users/users_response.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/admin_component/expansion_tile_custom.dart';
import 'package:igls_new/presentations/widgets/admin_component/quantity_quick_search.dart';
import 'package:igls_new/presentations/widgets/text_rich_required.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/services/services.dart';
import '../../../../data/shared/utils/file_utils.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import '../../../widgets/app_bar_custom.dart';
import '../../../widgets/table_widget/table_widget.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final _navigationService = getIt<NavigationService>();

  List<UsersResponse> usersList = [];
  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _quickSearchController = TextEditingController();

  final ValueNotifier<bool> _isDeletedNotifier = ValueNotifier<bool>(false);

  late UsersBloc _bloc;
  late GeneralBloc generalBloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<UsersBloc>(context);
    _bloc.add(UsersViewLoaded());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text('4040'.tr())),
      body: BlocConsumer<UsersBloc, UsersState>(
        listener: (context, state) {
          if (state is UserResetPWDActiveSuccessfully) {
            CustomDialog().success(context);
          }
          if (state is UserCopySuccessFully) {
            CustomDialog().success(context).whenComplete(() async {
              final result = await _navigationService
                  .navigateAndDisplaySelection(routes.userDetailRoute,
                      args: {key_params.userId: state.userIDNew.trim()});
              if (result != null) {
                _userIDController.clear();
                _bloc.add(UsersViewLoaded());
              }
            });
          } else if (state is UsersFailure) {
            if (state.errorCode == constants.errorNoConnect) {
              CustomDialog().error(
                context,
                btnMessage: '5038'.tr(),
                err: state.message,
                btnOkOnPress: () => _bloc.add(UsersViewLoaded()),
              );
              return;
            }
            CustomDialog().error(context, err: state.message);
          }
        },
        builder: (context, state) {
          if (state is UsersSuccess) {
            usersList = state.userList;
            _isDeletedNotifier.value = state.isDeletedData;
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionTileWidget(
                    initiallyExpanded: true,
                    listWidget: [
                      _buildTextField(
                          controller: _userIDController, label: '2459'),
                      ValueListenableBuilder(
                        valueListenable: _isDeletedNotifier,
                        builder: (context, value, child) => CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text('54'.tr()),
                          value: _isDeletedNotifier.value,
                          onChanged: (value) {
                            _isDeletedNotifier.value = value!;
                          },
                        ),
                      ),
                      ElevatedButtonWidget(
                        text: '36',
                        onPressed: () {
                          BlocProvider.of<UsersBloc>(context).add(UsersSearch(
                              generalBloc: generalBloc,
                              userId: _userIDController.text,
                              isDeletedData: _isDeletedNotifier.value));
                        },
                      ),
                    ],
                  ),
                  QuantityQuickSearchWidget(
                    controller: _quickSearchController,
                    quantity: '${state.userListSearch.length}',
                    onChanged: (value) {
                      _bloc.add(UsersQuickSearch(textSearch: value));
                    },
                  ),
                  _buildTable(usersList: state.userListSearch)
                ]);
          }
          return const ItemLoading();
        },
      ),
    );
  }

  Widget _buildTable({required List<UsersResponse> usersList}) {
    return TableDataWidget(
        listTableRowHeader: [
          const HeaderTable2Widget(label: '5586', width: 50),
          const HeaderTable2Widget(label: '2459', width: 120),
          const HeaderTable2Widget(label: '13', width: 160),
          const HeaderTable2Widget(label: '2415', width: 200),
          const HeaderTable2Widget(label: '2416', width: 110),
          const HeaderTable2Widget(label: '63', width: 150),
          const HeaderTable2Widget(label: '62', width: 150),
          const HeaderTable2Widget(label: '65', width: 150),
          const HeaderTable2Widget(label: '64', width: 150),
          const HeaderTable2Widget(label: '4042', width: 150),
          const HeaderTable2Widget(label: '3506', width: 100),
          const HeaderTable2Widget(label: '3508', width: 170),
          const HeaderTable2Widget(label: '90', width: 100),
          _isDeletedNotifier.value
              ? const HeaderTable2Widget(label: '5115', width: 80)
              : const SizedBox(),
          const HeaderTable2Widget(label: '5116', width: 80),
          const HeaderTable2Widget(label: '4586', width: 80),
        ],
        listTableRowContent: usersList == [] || usersList.isEmpty
            ? [
                CellTableWidget(
                    content: '5058'.tr().toUpperCase(), width: 1920),
              ]
            : List.generate(
                usersList.length,
                (index) {
                  return ColoredBox(
                    color: colorRowTable(index: index),
                    child: InkWell(
                      onTap: _isDeletedNotifier.value
                          ? null
                          : () async {
                              final result = await _navigationService
                                  .navigateAndDisplaySelection(
                                      routes.userDetailRoute,
                                      args: {
                                    key_params.userId: usersList[index]
                                        .userId
                                        .toString()
                                        .trim()
                                  });
                              if (result == true) {
                                _bloc.add(UsersSearch(
                                    generalBloc: generalBloc,
                                    userId: _userIDController.text,
                                    isDeletedData: _isDeletedNotifier.value));
                              }
                            },
                      child: Row(
                        children: [
                          CellTableWidget(
                            width: 50,
                            content: (index + 1).toString(),
                          ),
                          CellTableWidget(
                            width: 120,
                            content: usersList[index].userId ?? '',
                            isAlignLeft: true,
                          ),
                          CellTableWidget(
                            width: 160,
                            content: usersList[index].userName ?? '',
                            isAlignLeft: true,
                          ),
                          CellTableWidget(
                            width: 200,
                            isAlignLeft: true,
                            content: usersList[index].email ?? '',
                          ),
                          CellTableWidget(
                            width: 110,
                            content: usersList[index].mobileNo ?? '',
                          ),
                          CellTableWidget(
                            width: 150,
                            content: usersList[index].createUser ?? '',
                            isAlignLeft: true,
                          ),
                          CellTableWidget(
                              width: 150,
                              content: FileUtils
                                  .converFromDateTimeToStringddMMyyyyHHmm(
                                usersList[index].createDate ?? '',
                              )),
                          CellTableWidget(
                            width: 150,
                            content: usersList[index].updateUser ?? '',
                            isAlignLeft: true,
                          ),
                          CellTableWidget(
                              width: 150,
                              content: FileUtils
                                  .converFromDateTimeToStringddMMyyyyHHmm(
                                usersList[index].updateDate ?? '',
                              )),
                          CellTableWidget(
                              width: 150,
                              content: FileUtils
                                  .converFromDateTimeToStringddMMyyyyHHmm(
                                usersList[index].lastLogin ?? '',
                              )),
                          CellTableWidget(
                            width: 100,
                            content: usersList[index].empCode ?? '',
                          ),
                          CellTableWidget(
                            width: 170,
                            content: usersList[index].userRole ?? '',
                            isAlignLeft: true,
                          ),
                          CellTableWidget(
                            width: 100,
                            content: usersList[index].defaultCenter ?? '',
                          ),
                          _isDeletedNotifier.value
                              ? _buildIconButton(
                                  width: 80,
                                  icon: const Icon(Icons.manage_accounts,
                                      color: colors.btnGreyDisable),
                                  onPressed: () {
                                    _showDialogConfirm(context,
                                        userId: usersList[index].userId ?? '',
                                        isReset: false);
                                  })
                              : const SizedBox(),
                          _buildIconButton(
                              width: 80,
                              icon: const Icon(Icons.group,
                                  color: colors.textAmber),
                              onPressed: () {
                                _showDialogCopyUser(context,
                                    userIDOld: usersList[index].userId ?? '');
                              }),
                          _buildIconButton(
                              width: 80,
                              icon: const Icon(Icons.lock_reset,
                                  color: colors.btnGreen),
                              onPressed: () {
                                _showDialogConfirm(context,
                                    userId: usersList[index].userId ?? '',
                                    isReset: true);
                              })
                        ],
                      ),
                    ),
                  );
                },
              ));
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      String? Function(String?)? validator,
      required String label}) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
            label: validator == null
                ? Text(
                    label.tr(),
                  )
                : TextRichRequired(label: label.tr()),
            hintText: label.tr()),
      ),
    );
  }

  Widget _buildIconButton(
      {required Icon icon,
      required double width,
      required void Function()? onPressed}) {
    return Container(
      width: width,
      height: 50,
      decoration: const BoxDecoration(
          border: Border(
              right: BorderSide(
        color: Colors.black38,
      ))),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }

  _showDialogCopyUser(BuildContext buildContext, {required String userIDOld}) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController userIDOldController = TextEditingController();
    final TextEditingController userIDNewController = TextEditingController();
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    userIDOldController.text = userIDOld;
    AwesomeDialog(
      padding: EdgeInsets.all(8.w),
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      dismissOnTouchOutside: false,
      btnOkText: "5116".tr(),
      btnCancelText: "26".tr(),
      autoDismiss: false,
      onDismissCallback: (type) {},
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Text(
              "5116".tr(),
              style: styleTextTitle,
            ),
            const HeightSpacer(height: 0.02),
            _buildTextField(controller: userIDOldController, label: '2459'),
            _buildTextField(
                validator: (value) {
                  if (value == '') {
                    return "5067".tr();
                  }
                  return null;
                },
                controller: userIDNewController,
                label: '4063'),
            _buildTextField(controller: userNameController, label: '13'),
            _buildTextField(controller: emailController, label: '2415'),
            const HeightSpacer(height: 0.02),
          ],
        ),
      ),
      btnCancelOnPress: () {
        Navigator.of(context).pop();
      },
      btnOkOnPress: () {
        if (formKey.currentState!.validate()) {
          BlocProvider.of<UsersBloc>(context).add(UserCopy(
              generalBloc: generalBloc,
              userNameOld: userIDOldController.text,
              userIdNew: userIDNewController.text,
              userName: userNameController.text,
              email: emailController.text));
          Navigator.of(context).pop();
        }
      },
    ).show();
  }

  _showDialogConfirm(BuildContext buildContext,
      {required String userId, required bool isReset}) {
    AwesomeDialog(
            padding: EdgeInsets.all(8.w),
            context: context,
            dialogType: DialogType.noHeader,
            animType: AnimType.rightSlide,
            dismissOnTouchOutside: false,
            btnOkText: isReset ? "4586".tr() : '5115'.tr(),
            btnCancelText: "26".tr(),
            autoDismiss: false,
            onDismissCallback: (type) {},
            body: Column(
              children: [
                Text(
                  isReset ? "4586".tr() : "5115".tr(),
                  style: styleTextTitle,
                ),
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Text(isReset
                      ? '${'5117'.tr()} $userId?'
                      : '${'5118'.tr()} $userId?'),
                ),
              ],
            ),
            btnCancelOnPress: () {
              Navigator.of(context).pop();
            },
            btnOkOnPress: isReset
                ? () {
                    BlocProvider.of<UsersBloc>(context).add(
                        UserResetPWD(userId: userId, generalBloc: generalBloc));
                    Navigator.of(context).pop();
                  }
                : () {
                    BlocProvider.of<UsersBloc>(context).add(
                        UserActive(userId: userId, generalBloc: generalBloc));
                    Navigator.of(context).pop();
                  })
        .show();
  }
}
