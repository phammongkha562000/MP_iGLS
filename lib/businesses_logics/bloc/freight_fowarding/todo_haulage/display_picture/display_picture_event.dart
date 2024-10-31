part of 'display_picture_bloc.dart';

abstract class DisplayPictureEvent extends Equatable {
  const DisplayPictureEvent();

  @override
  List<Object?> get props => [];
}

class DisplayPictureViewLoaded extends DisplayPictureEvent {
  final List<File> files;
  final String docRefType;
  final String refNoType;
  final String refNoValue;

  const DisplayPictureViewLoaded({
    required this.files,
    required this.docRefType,
    required this.refNoType,
    required this.refNoValue,
  });
  @override
  List<Object> get props => [files, docRefType, refNoType, refNoValue];
}

class DisplayPictureSaved extends DisplayPictureEvent {
  final List<File> files;
  final String? docRefType;
  final String? refNoType;
  final String? refNoValue;
  final GeneralBloc generalBloc;

  const DisplayPictureSaved(
      {required this.files,
      required this.docRefType,
      required this.refNoType,
      required this.refNoValue,
      required this.generalBloc});
  @override
  List<Object?> get props =>
      [files, docRefType, refNoType, refNoValue, generalBloc];
}
