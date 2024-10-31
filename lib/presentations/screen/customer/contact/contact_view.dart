import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contact/contact/contact_bloc.dart';
import 'package:igls_new/data/global/global_app.dart';
import 'package:igls_new/data/models/customer/customer_profile/subsidiary_res.dart';
import 'package:igls_new/data/services/launchs/launch_helper.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../presentations.dart';

class ContactView extends StatefulWidget {
  const ContactView({super.key, required this.subsidiaryRes});

  final SubsidiaryRes subsidiaryRes;
  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text('5400'.tr())),
      body: BlocConsumer<ContactBloc, ContactState>(
        listener: (context, state) {
          if (state is ContactFailure) {
            CustomDialog().error(context,
                err: state.message, btnOkOnPress: () => Navigator.pop(context));
          }
        },
        builder: (context, state) {
          if (state is ContactSuccess) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: const Text(
                      constants.companyName,
                      style: TextStyle(
                          color: colors.defaultColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  _buildInfoCompany(
                      icon: const Icon(Icons.map),
                      title: '2387',
                      subTitle:
                          '${widget.subsidiaryRes.address1 ?? ''}${widget.subsidiaryRes.address2 ?? ''}${widget.subsidiaryRes.address3 ?? ''} '),
                  _buildInfoTel(
                      icon: const Icon(Icons.phone),
                      title: '66',
                      subTitle: widget.subsidiaryRes.tel ?? ''),
                  _buildInfoCompany(
                      icon: const Icon(Icons.fax),
                      title: '67',
                      subTitle: widget.subsidiaryRes.fax ?? ''),
                  _buildInfoWeb(
                      icon: const Icon(Icons.web),
                      title: '5380',
                      subTitle: widget.subsidiaryRes.www ?? ''),
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Text('5401'.tr()),
                  ),
                  CardCustom(
                    radius: 32,
                    child: Column(
                      children: [
                        _buildInfo(
                            title: '20',
                            trailing:
                                '${globalApp.version} (${globalApp.versionBuild})'),
                        _divider(),
                        _buildInfo(title: '64', trailing: '20/10/2024'),
                        _divider(),
                        // _buildInfo(
                        //     title: 'App Size',
                        //     trailing:
                        //         '${state.appSize.toString().substring(0, 2)} MB'),
                        // _divider(),
                        _buildInfo(title: '2414', trailing: '5382'.tr()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const ItemLoading();
        },
      ),
    );
  }

  Widget _divider() {
    return Divider(
      indent: 16,
      endIndent: 16,
      color: Colors.grey.withOpacity(0.2),
      height: 0,
    );
  }

  Widget _buildInfo({required String title, required String trailing}) {
    return ListTile(
      title: Text(
        title.tr(),
      ),
      trailing: Text(
        trailing,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildInfoCompany(
      {required String title, required String subTitle, required Icon icon}) {
    return ListTile(
      leading: icon,
      title: Text(
        title.tr(),
      ),
      subtitle: Text(subTitle),
    );
  }

  Widget _buildInfoWeb(
      {required String title, required String subTitle, required Icon icon}) {
    return ListTile(
      onTap: () {
        LaunchHelpers.launchWebsite(website: subTitle);
      },
      leading: icon,
      title: Text(
        title.tr(),
      ),
      subtitle: Text(subTitle,
          style: const TextStyle(
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
              color: Colors.blue)),
    );
  }

  Widget _buildInfoTel(
      {required String title, required String subTitle, required Icon icon}) {
    return ListTile(
      onTap: () {
        LaunchHelpers.launchTel(tel: subTitle);
      },
      leading: icon,
      title: Text(
        title.tr(),
      ),
      subtitle: Text(subTitle,
          style: const TextStyle(
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
              color: Colors.blue)),
    );
  }
}
