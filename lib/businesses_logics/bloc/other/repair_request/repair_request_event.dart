part of 'repair_request_bloc.dart';

abstract class RepairRequestEvent extends Equatable {
  const RepairRequestEvent();

  @override
  List<Object?> get props => [];
}

class RepairRequestViewLoaded extends RepairRequestEvent {
  // final String? pageId;
  // final String? pageName;
  final GeneralBloc generalBloc;

  const RepairRequestViewLoaded({
    required this.generalBloc,

    // this.pageId,
    // this.pageName,
  });

  @override
  List<Object?> get props => [generalBloc /* pageId, pageName */];
}

class RepairRequestSave extends RepairRequestEvent {
  final String currentMileage;
  final String issueDesc;
  final GeneralBloc generalBloc;
  const RepairRequestSave(
      {required this.currentMileage,
      required this.issueDesc,
      required this.generalBloc});
  @override
  List<Object> get props => [currentMileage, issueDesc, generalBloc];
}
