import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart' as pdf;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:igls_new/businesses_logics/bloc/other/salary_file/salary_file_bloc.dart';

import '../../../presentations.dart';
import '../../../widgets/app_bar_custom.dart';

class PDFView extends StatefulWidget {
  const PDFView({super.key});

  @override
  State<PDFView> createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: const Text('PDF Viewer'),
      ),
      body: BlocListener<SalaryFileBloc, SalaryFileState>(
        listener: (context, state) {
          if (state is SalaryFileLoading) {
            CustomDialog().showCustomDialog(context);
          } else {
            CustomDialog().hideCustomDialog(context);
          }
        },
        child: BlocBuilder<SalaryFileBloc, SalaryFileState>(
          builder: (context, state) {
            if (state is SalaryFileSuccess) {
              return pdf.PDFView(
                filePath: state.fileLocation,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: true,
                pageFling: true,
                onRender: (pages) {
                  setState(() {});
                },
                onError: (error) {
                  log(error.toString());
                },
                onPageError: (page, error) {
                  log('$page: ${error.toString()}');
                },
                onViewCreated: (PDFViewController pdfViewController) {},
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }
}
