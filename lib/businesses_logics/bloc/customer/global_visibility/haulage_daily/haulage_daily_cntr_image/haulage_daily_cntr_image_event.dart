part of 'haulage_daily_cntr_image_bloc.dart';

abstract class HaulageDailyCNTRImageEvent extends Equatable {
  const HaulageDailyCNTRImageEvent();

  @override
  List<Object> get props => [];
}

class HaulageDailyCNTRImageViewLoaded extends HaulageDailyCNTRImageEvent {
  final String customerWoTaskID;

  const HaulageDailyCNTRImageViewLoaded({required this.customerWoTaskID});
  @override
  List<Object> get props => [customerWoTaskID];
}
