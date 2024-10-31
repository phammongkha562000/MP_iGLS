import 'package:igls_new/businesses_logics/server/constants.dart';
import 'package:igls_new/data/models/config/server_infor.dart';

class ServerConfig {
  static getAddressServerInfo(code) {
    final ServerInfo server = ServerInfo();
    switch (code) {
      case ServerMode.dev:
        server.serverAddress = "https://dev.igls.vn:8096/";
        server.serverCode = "DEV";
        server.notificationServerName = "https://pro.igls.vn:8185/";
        server.serverWcf = "https://dev.igls.vn:8085/";
        server.serverHub = "https://dev.igls.vn:8079/";
        server.serverMPi = "https://dev.igls.vn:9110/";
        break;
      case ServerMode.qa:
        server.serverAddress = "https://qa.igls.vn:8186/";
        server.serverCode = "QA";
        server.notificationServerName = "https://pro.igls.vn:8185/";
        server.serverWcf = "https://qa.igls.vn:8086/";
        server.serverHub = "https://qa.igls.vn:8178/";
        server.serverMPi = "https://qa.igls.vn:9112/";

        break;
      case ServerMode.prod:
        server.serverAddress = "https://pro.igls.vn:8186/";
        server.serverCode = "PROD";
        server.notificationServerName = "https://pro.igls.vn:8185/";
        server.serverWcf = "https://pro.igls.vn:8085/";
        server.serverHub = "https://pro.igls.vn:8182/";
        server.serverMPi = "https://mpi.mplogistics.vn:8187/";

        break;
    }
    return server;
  }
}
