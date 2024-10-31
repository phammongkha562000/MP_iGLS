import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/other/driver_salary/driver_salary_detail/driver_salary_detail_bloc.dart';

import 'package:igls_new/data/models/driver_salary/driver_salary_response.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:open_file_plus/open_file_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/services/injection/injection_igls.dart';
import '../../../../data/services/navigator/navigation_service.dart';
import '../../../presentations.dart';
import '../../../widgets/app_bar_custom.dart';

class DriverSalaryDetailView extends StatefulWidget {
  const DriverSalaryDetailView({super.key});

  @override
  State<DriverSalaryDetailView> createState() => _DriverSalaryDetailViewState();
}

class _DriverSalaryDetailViewState extends State<DriverSalaryDetailView> {
  final _navigationService = getIt<NavigationService>();
  late GeneralBloc generalBloc;
  late DriverSalaryDetailBloc _bloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<DriverSalaryDetailBloc>(context);
    _bloc.add(DriverSalaryDetailLoaded(generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarCustom(
        title: Text("4891".tr()),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(assets.kImageBg2),
          fit: BoxFit.fill,
        )),
        child: BlocListener<DriverSalaryDetailBloc, DriverSalaryDetailState>(
          listener: (context, state) async {
            if (state is DriverSalaryDetailFailure) {
              if (state.errorCode == constants.errorNoConnect) {
                CustomDialog().error(
                  btnMessage: '5038'.tr(),
                  context,
                  err: state.message,
                  btnOkOnPress: () =>
                      BlocProvider.of<DriverSalaryDetailBloc>(context).add(
                          DriverSalaryDetailLoaded(generalBloc: generalBloc)),
                );
              } else if (state.errorCode == constants.errDownloadAndGet) {
                CustomDialog().error(context, err: state.message);
              } else {
                CustomDialog().error(context, err: state.message);
              }
            }
            if (state is DriverSalaryDownFileSuccessfully) {
              if (state.fileType == "PDF") {
                _navigationService.pushNamed(routes.pdfViewRoute, args: {
                  key_params.fileLocation: state.fileLocation,
                });
              } else {
                final result = await OpenFile.open(
                  state.fileLocation,
                );

                if (result.type != ResultType.done) {
                  CustomDialog().warning(
                    // ignore: use_build_context_synchronously
                    context,
                    message: "${result.message}, Download App?",
                    isOk: true,
                    ok: () {
                      if (Platform.isAndroid) {
                        launchUrl(
                          Uri.parse(
                              "https://play.google.com/store/apps/details?id=com.microsoft.office.excel"),
                          mode: LaunchMode.externalApplication,
                        );
                      } else if (Platform.isIOS) {}
                    },
                  );
                }
              }
            }
          },
          child: BlocBuilder<DriverSalaryDetailBloc, DriverSalaryDetailState>(
            builder: (context, state) {
              if (state is DriverSalaryDetailSuccess) {
                return LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return Center(
                    child: state.listDriverSalary.isEmpty
                        ? const EmptyWidget()
                        : Column(
                            children: [
                              Card(
                                color: colors.bgDrawerColor,
                                shadowColor: colors.textGrey,
                                elevation: 12,
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Table(
                                      border: TableBorder.all(
                                        borderRadius: BorderRadius.circular(8),
                                        color: colors.defaultColor,
                                        width: 2,
                                      ),
                                      columnWidths: const {
                                        0: FlexColumnWidth(3),
                                        1: FlexColumnWidth(7),
                                      },
                                      children: [
                                        TableRow(
                                          children: [
                                            tableCellTitle(
                                                title: "month_salary"),
                                            tableCellTitle(
                                                title: "report_salary"),
                                          ],
                                        ),
                                        ...state.listDriverSalary.map((item) {
                                          return TableRow(children: [
                                            cellDate(item),
                                            cellView(state, item, context)
                                          ]);
                                        })
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  );
                });
              }
              return const Loading();
            },
          ),
        ),
      ),
    );
  }

  void _openFile(DriverSalaryDetailSuccess state, DriverSalaryPayload item,
      {required String url, required String pathFile}) async {
    try {
      log(pathFile);
      if (pathFile.isEmpty || pathFile == "") {
        CustomDialog().warning(context, message: "fileNotExits".tr());
      } else {
        var path = "$url$pathFile";
        log(path);
        BlocProvider.of<DriverSalaryDetailBloc>(context)
            .add(DriverSalaryDownAndGetFile(filePath: path, item: item));
      }
    } catch (e) {
      CustomDialog().warning(context, message: "canNotOpenFile".tr());
    }
  }

  TableCell cellView(DriverSalaryDetailSuccess state, DriverSalaryPayload item,
      BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              style: buttonStyle(),
              onPressed: () async {
                _openFile(state, item,
                    url: state.url, pathFile: item.pdfPayslip ?? "");
              },
              child: Row(
                children: [
                  Text("payslips".tr()),
                  const WidthSpacer(width: 0.01),
                  const Icon(
                    Icons.remove_red_eye,
                    size: 18,
                  ),
                ],
              )),
          const WidthSpacer(width: 0.01),
          TextButton(
              style: buttonStyle(),
              onPressed: () {
                _openFile(state, item,
                    url: state.url, pathFile: item.pdfTaskDetail ?? "");
              },
              child: Row(
                children: [
                  Text("attach".tr()),
                  const WidthSpacer(width: 0.01),
                  const Icon(
                    Icons.remove_red_eye,
                    size: 18,
                  ),
                ],
              ))
        ],
      ),
    );
  }

  TableCell cellDate(DriverSalaryPayload item) {
    var date = DateTime.parse("${item.yyyymm}01");
    var dateView = DateFormat("MM/yyyy").format(date);
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Text(
        dateView,
        textAlign: TextAlign.center,
      ),
    );
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(colors.defaultColor),
      foregroundColor: MaterialStateProperty.all<Color>(colors.textWhite),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(),
      ),
      shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    );
  }

  Widget tableCellTitle({
    required String title,
  }) =>
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: colors.defaultColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}
