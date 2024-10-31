part of 'loading_status_bloc.dart';

abstract class LoadingStatusEvent extends Equatable {
  const LoadingStatusEvent();

  @override
  List<Object> get props => [];
}

class LoadingStatusViewLoaded extends LoadingStatusEvent {
  final DateTime? etp;
  final GeneralBloc generalBloc;
  // final String? pageId;
  // final String? pageName;
  const LoadingStatusViewLoaded({this.etp, required this.generalBloc
      // this.pageId,
      // this.pageName,
      });
  @override
  List<Object> get props => [
        [
          etp,
          /*  pageId, pageName */
          generalBloc
        ]
      ];
}

class LoadingStatusChangeDate extends LoadingStatusEvent {
  final DateTime dateTime;
  final GeneralBloc generalBloc;
  const LoadingStatusChangeDate(
      {required this.dateTime, required this.generalBloc});
  @override
  List<Object> get props => [dateTime];
}
