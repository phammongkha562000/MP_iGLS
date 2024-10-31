part of 'display_picture_bloc.dart';

abstract class DisplayPictureState extends Equatable {
  const DisplayPictureState();

  @override
  List<Object?> get props => [];
}

class DisplayPictureInitial extends DisplayPictureState {}

class DisplayPictureLoading extends DisplayPictureState {}

class DisplayPictureSuccess extends DisplayPictureState {
  final List<File> files;
  final String docRefType;
  final String refNoType;
  final String refNoValue;

  const DisplayPictureSuccess({
    required this.files,
    required this.docRefType,
    required this.refNoType,
    required this.refNoValue,
  });
  @override
  List<Object?> get props => [files, docRefType, refNoType, refNoValue];
}

class DisplayPictureFailure extends DisplayPictureState {
  final String message;
  final int? errorCode;
  const DisplayPictureFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class DisplayPictureSaveSuccess extends DisplayPictureState {}
