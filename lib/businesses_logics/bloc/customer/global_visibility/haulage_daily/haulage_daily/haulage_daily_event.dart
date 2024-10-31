part of 'haulage_daily_bloc.dart';

sealed class HaulageDailyEvent extends Equatable {
  const HaulageDailyEvent();

  @override
  List<Object> get props => [];
}

class HaulageDailySearch extends HaulageDailyEvent {
  final CustomerHaulageDailyReq content;
  final String subsidiaryId;
  const HaulageDailySearch({
    required this.content,
    required this.subsidiaryId,
  });
  @override
  List<Object> get props => [content, subsidiaryId];
}

class HaulageDailyFilterDetail extends HaulageDailyEvent {
  final int status;

  const HaulageDailyFilterDetail({required this.status});

  @override
  List<Object> get props => [status];
}
