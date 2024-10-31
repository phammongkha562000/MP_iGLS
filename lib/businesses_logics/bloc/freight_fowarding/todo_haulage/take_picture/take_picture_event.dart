part of 'take_picture_bloc.dart';

abstract class TakePictureEvent extends Equatable {
  const TakePictureEvent();

  @override
  List<Object> get props => [];
}

class TakePictureViewLoaded extends TakePictureEvent {
  final String docRefType;
  final String refNoType;
  final String refNoValue;
  final GeneralBloc generalBloc;

  const TakePictureViewLoaded({
    required this.docRefType,
    required this.refNoType,
    required this.refNoValue,
    required this.generalBloc,
  });
  @override
  List<Object> get props => [docRefType, refNoType, refNoValue, generalBloc];
}

class TakePictureTakeCamera extends TakePictureEvent {
  final String docRefType;
  final String refNoType;
  final String refNoValue;
  const TakePictureTakeCamera({
    required this.docRefType,
    required this.refNoType,
    required this.refNoValue,
  });
  @override
  List<Object> get props => [docRefType, refNoType, refNoValue];
}

class TakePicturePickGallery extends TakePictureEvent {
  final String docRefType;
  final String refNoType;
  final String refNoValue;
  const TakePicturePickGallery({
    required this.docRefType,
    required this.refNoType,
    required this.refNoValue,
  });
  @override
  List<Object> get props => [docRefType, refNoType, refNoValue];
}
