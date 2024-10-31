import 'package:dio/dio.dart';
import 'package:igls_new/data/base/abstract_repository.dart';
import 'package:igls_new/data/models/customer/global_visibility/booking/customer_booking_request.dart';
import 'package:igls_new/data/models/customer/global_visibility/booking/customer_booking_response.dart';
import 'package:igls_new/data/services/result/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/businesses_logics/api/endpoints.dart' as endpoints;
import 'package:sprintf/sprintf.dart';

import '../../../../services/services.dart';

abstract class AbstractBookingRepository implements AbstractRepository {
  Future<ApiResult> getBooking(
      {required String subsidiaryId, required CustomerBookingReq content});
}

@injectable
class BookingRepository implements AbstractBookingRepository {
  AbstractDioHttpClient client;
  BookingRepository({required this.client});

  @override
  Future<ApiResult> getBooking(
      {required String subsidiaryId,
      required CustomerBookingReq content}) async {
    try {
      final request = ModelRequest(
          sprintf(endpoints.customerGetBooking, [subsidiaryId]),
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: List<CustomerBookingRes>.from(
                api.map((e) => CustomerBookingRes.fromJson(e))));
      } else {
        return ApiResult.fail(
            error: api,
            errorCode: api.response == null
                ? constants.errorNoConnect
                : api.response!.statusCode!);
      }
    } catch (e) {
      return ApiResult.fail(error: e, errorCode: 0);
    }
  }
}
