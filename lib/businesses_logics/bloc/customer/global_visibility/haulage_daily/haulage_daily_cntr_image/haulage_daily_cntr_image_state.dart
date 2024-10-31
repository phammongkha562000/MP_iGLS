part of 'haulage_daily_cntr_image_bloc.dart';

abstract class HaulageDailyCNTRImageState extends Equatable {
  const HaulageDailyCNTRImageState();

  @override
  List<Object> get props => [];
}

class HaulageDailyCNTRImageInitial extends HaulageDailyCNTRImageState {}

class HaulageDailyCNTRImageLoading extends HaulageDailyCNTRImageState {}

class HaulageDailyCNTRImageSuccess extends HaulageDailyCNTRImageState {
  final List<ImageTodoHaulageResponse> imageList;

  const HaulageDailyCNTRImageSuccess({required this.imageList});
  @override
  List<Object> get props => [imageList];
}

class HaulageDailyCNTRImageFailure extends HaulageDailyCNTRImageState {}
