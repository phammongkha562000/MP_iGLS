import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/freight_fowarding/shipment_status/shipment_status_detail_response.dart';
import 'package:igls_new/data/models/freight_fowarding/shipment_status/shipment_status_request.dart';
import 'package:igls_new/data/models/freight_fowarding/shipment_status/shipment_status_response.dart';
import 'package:igls_new/data/models/login/data_login_request.dart';
import 'package:igls_new/data/services/network/client.dart';
import 'package:injectable/injectable.dart';
import 'package:sprintf/sprintf.dart';
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;

abstract class AbstractShipmentStatusRepository implements AbstractRepository {
  Future<List<ShipmentStatusResponse>> getListShipmentStatus({
    required ShipmentStatusRequest content,
    required String subsidiaryId,
  });

  Future<ShipmentStatusDetailResponse> getDetailShipmentStatus({
    required String woNo,
    required String cntrNo,
    required String itemNo,
    required String subsidiaryId,
  });
}

@injectable
class ShipmentStatusRepository implements AbstractShipmentStatusRepository {
  AbstractDioHttpClient client;
  ShipmentStatusRepository({required this.client});

  @override
  Future<List<ShipmentStatusResponse>> getListShipmentStatus({
    required ShipmentStatusRequest content,
    required String subsidiaryId,
  }) async {
    final request = ModelRequest(
      sprintf(endpoints.getShipmentStatus, [subsidiaryId]),
      body: content.toMap(),
    );
    return await client.post<List<ShipmentStatusResponse>>(
        request,
        (data) => List<ShipmentStatusResponse>.from(
            data.map((x) => ShipmentStatusResponse.fromMap(x))));
  }

  @override
  Future<ShipmentStatusDetailResponse> getDetailShipmentStatus({
    required String woNo,
    required String cntrNo,
    required String itemNo,
    required String subsidiaryId,
  }) async {
    final request = ModelRequest(
      sprintf(endpoints.getShipmentStatusDetail,
          [woNo, cntrNo, itemNo, subsidiaryId]),
    );
    return await client.get(
        request, (data) => ShipmentStatusDetailResponse.fromMap(data));
  }
}
