part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final bool? isConnect;
  final List<List<PageMenuPermissions>> listMenuGroup;
  final List<PageMenuPermissions> listMenuQuick;
  final String driverName;
  final String server;
  final String version;
  final List<AnnouncementResponse>? listAnnouncement;
  const HomeSuccess(
      {this.isConnect,
      required this.listMenuGroup,
      required this.listMenuQuick,
      required this.driverName,
      required this.server,
      required this.version,
      this.listAnnouncement});

  @override
  List<Object?> get props => [
        listMenuGroup,
        listMenuQuick,
        driverName,
        server,
        listAnnouncement,
        isConnect,
      ];

  HomeSuccess copyWith(
      {bool? isConnect,
      List<List<PageMenuPermissions>>? listMenuGroup,
      List<PageMenuPermissions>? listMenuQuick,
      String? driverName,
      String? server,
      String? version,
      List<AnnouncementResponse>? listAnnouncement,
      List<FrequentlyVisitPageResponse>? listMenuFreq}) {
    return HomeSuccess(
      isConnect: isConnect,
      listMenuGroup: listMenuGroup ?? this.listMenuGroup,
      listMenuQuick: listMenuQuick ?? this.listMenuQuick,
      driverName: driverName ?? this.driverName,
      server: server ?? this.server,
      version: version ?? this.version,
      listAnnouncement: listAnnouncement ?? this.listAnnouncement,
    );
  }
}

class HomeFailure extends HomeState {
  final String message;
  final int? errorCode;
  const HomeFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class LogOutSuccess extends HomeState {}

class CountNotification extends HomeState {
  final int countNoti;

  const CountNotification({required this.countNoti});
  @override
  List<Object?> get props => [countNoti];
}

class GetAnnouncement extends HomeState {
  final List<AnnouncementResponse>? listAnnouncement;

  const GetAnnouncement({required this.listAnnouncement});
  @override
  List<Object?> get props => [listAnnouncement];
}
