part of 'customer_home_bloc.dart';

abstract class CustomerHomeState extends Equatable {
  const CustomerHomeState();

  @override
  List<Object?> get props => [];
}

class CustomerHomeInitial extends CustomerHomeState {}

class CustomerHomeLoading extends CustomerHomeState {}

class CustomerHomeSuccess extends CustomerHomeState {
  final bool? isConnect;
  final String userName;
  final String server;
  final CustomerPermissionRes premissionRes;
  final OsTodayRes osTodayRes;
  final List<GetMenuResult> listGroupName;
  final List<List<GetMenuResult>> lstMenuGroupBy;
  const CustomerHomeSuccess(
      {this.isConnect,
      required this.userName,
      required this.server,
      required this.premissionRes,
      required this.osTodayRes,
      required this.listGroupName,
      required this.lstMenuGroupBy});

  @override
  List<Object?> get props => [
        userName,
        server,
        isConnect,
        premissionRes,
        osTodayRes,
        listGroupName,
        lstMenuGroupBy
      ];
}

class CustomerHomeFailure extends CustomerHomeState {
  final String message;
  final int? errorCode;
  const CustomerHomeFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class CustomerLogOutSuccess extends CustomerHomeState {}
