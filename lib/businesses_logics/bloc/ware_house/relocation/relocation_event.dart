part of 'relocation_bloc.dart';

abstract class RelocationEvent extends Equatable {
  const RelocationEvent();

  @override
  List<Object?> get props => [];
}

class RelocationViewLoaded extends RelocationEvent {
  final DateTime date;
  // final String? pageId;
  // final String? pageName;
  final GeneralBloc generalBloc;
  const RelocationViewLoaded({required this.date, required this.generalBloc
      // this.pageId,
      // this.pageName,
      });
  @override
  List<Object?> get props => [date, generalBloc /* pageId, pageName */];
}

class RelocationPreviousDateLoaded extends RelocationEvent {
  final GeneralBloc generalBloc;
  const RelocationPreviousDateLoaded({
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [generalBloc];
}

class RelocationNextDateLoaded extends RelocationEvent {
  final GeneralBloc generalBloc;
  const RelocationNextDateLoaded({
    required this.generalBloc,
  });
  @override
  List<Object?> get props => [generalBloc];
}

class RelocationPickDate extends RelocationEvent {
  final DateTime date;
  final GeneralBloc generalBloc;
  const RelocationPickDate({required this.date, required this.generalBloc});
  @override
  List<Object> get props => [date, generalBloc];
}

class RelocationSave extends RelocationEvent {
  final GeneralBloc generalBloc;
  final RelocationResult item;
  final String remark;
  const RelocationSave(
      {required this.item, required this.remark, required this.generalBloc});
  @override
  List<Object> get props => [item, remark, generalBloc];
}

class RelocationPaging extends RelocationEvent {
  final GeneralBloc generalBloc;
  const RelocationPaging({required this.generalBloc});
  @override
  List<Object> get props => [generalBloc];
}
