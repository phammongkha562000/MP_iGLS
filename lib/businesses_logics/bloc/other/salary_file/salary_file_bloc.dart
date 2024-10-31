import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'salary_file_event.dart';
part 'salary_file_state.dart';

class SalaryFileBloc extends Bloc<SalaryFileEvent, SalaryFileState> {
  SalaryFileBloc() : super(SalaryFileInitial()) {
    on<SalaryFileLoaded>(_mapViewToState);
  }

  Future<void> _mapViewToState(SalaryFileLoaded event, emit) async {
    emit(SalaryFileLoading());
    try {
      log("SalaryFile: ${event.fileLocation.toString()}");

      // // Chuyển đổi sang PDF
      // final pdf = PDFDocument();
      // for (var table in excel.tables.keys) {
      //   for (var row in excel.tables[table]!.rows) {
      //     final pdfRow = PDFTableRow();
      //     for (var cell in row) {
      //       final pdfCell = PDFTableCell(text: cell.value.toString());
      //       pdfRow.cells.add(pdfCell);
      //     }
      //     pdf.addTableRow(pdfRow);
      //   }
      // }
      emit(SalaryFileSuccess(
        fileLocation: event.fileLocation,
      ));
    } catch (e) {
      emit(SalaryFileFailure(message: e.toString()));
    }
  }
}
