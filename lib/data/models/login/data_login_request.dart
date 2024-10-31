import 'package:igls_new/data/global/global_app.dart';
import 'package:igls_new/data/services/network/client.dart';

class DataLoginRequestModel {
  final String username;
  final String password;
  final String ip;
  final String systemId;
  final String version;
  final String serverType;
  DataLoginRequestModel(
      {required this.username,
      required this.password,
      required this.ip,
      required this.systemId,
      required this.version,
      required this.serverType});

  Map<String, dynamic> toJson() {
    return {
      'UserName': username,
      'PassWord': password,
      'IP': ip,
      'SystemId': systemId,
      'Version': version,
      'ServerType': serverType,
    };
  }
}

class ModelRequest extends AbstractHttpRequest {
  ModelRequest(
    super.path, {
    super.parameters,
    Map<String, dynamic>? super.body,
    Map<String, dynamic>? header,
  }) : super(
    
          headers: header ??
              {
                "Content-Type": 'application/json',
                "Authorization": 'Bearer ${globalApp.getToken}'
              },
        );
}
