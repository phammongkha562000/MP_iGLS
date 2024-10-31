import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../../data/models/customer/contract_logistics/inbound_order_status/get_ios_detail_res.dart';
import '../../../../../../data/repository/customer/contract_logistics/inbound_order_status/inbound_order_status_repository.dart';
import '../../../../../../data/services/services.dart';

part 'inbound_order_detail_event.dart';
part 'inbound_order_detail_state.dart';

class InboundOrderDetailBloc
    extends Bloc<InboundOrderDetailEvent, InboundOrderDetailState> {
  InboundOrderDetailBloc() : super(InboundOrderDetailInitial()) {
    on<InboundOrderDetailLoaded>(_inboundOrderDetailLoaded);
    on<DownloadFileEvent>(_downloadFile);
  }
  final _iosRepo = getIt<CustomerIOSRepository>();

  Future<void> _inboundOrderDetailLoaded(
      InboundOrderDetailLoaded event, emit) async {
    try {
      emit(ShowLoadingState());
      var result = await _iosRepo.getIOSDetail(
          orderid: event.orderId, strCompany: event.strCompany);
      emit(HideLoadingState());

      if (result.isFailure) {
        emit(IOSDetailLoadFail(message: result.getErrorMessage()));
        return;
      }
      emit(
          IOSDetailLoadSuccess(iosDetailRes: result.data ?? GetIOSDetailRes()));
    } catch (e) {
      emit(HideLoadingState());
      emit(IOSDetailLoadFail(message: e.toString()));
    }
  }

  Future<void> _downloadFile(DownloadFileEvent event, emit) async {
    try {
      String? downloadDirectory;
      bool isFolderExist = false;
      if (Platform.isAndroid) {
        downloadDirectory = "/storage/emulated/0/Download/";
        isFolderExist = await Directory(downloadDirectory).exists();
        if (!isFolderExist) {
          downloadDirectory = "/storage/emulated/0/Downloads/";
        }
      } else {
        final downloadFolder = await getDownloadsDirectory();
        if (downloadFolder != null) {
          downloadDirectory = downloadFolder.path;
        }
      }
      emit(ShowLoadingState());

      var result = await _iosRepo.downLoadFile(
          savePath: downloadDirectory ?? '',
          docNo: event.docNo,
          strCompany: event.strCompany,
          fileName: event.fileName);
      emit(HideLoadingState());

      if (result.isFailure) {
        emit(DownloadFileFailState());
        return;
      }
      emit(DownloadFileSuccessState());
    } catch (e) {
      emit(HideLoadingState());
      emit(DownloadFileFailState());
    }
  }
}
