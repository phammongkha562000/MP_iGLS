part of 'take_picture_bloc.dart';

abstract class TakePictureState extends Equatable {
  const TakePictureState();

  @override
  List<Object?> get props => [];
}

class TakePictureInitial extends TakePictureState {}

class TakePictureLoading extends TakePictureState {}

//làm phần get ảnh về
class TakePictureSuccess extends TakePictureState {
  final List<XFile?>? imageFiles;
  final List<DocumentDTO>? imageListGet;

  const TakePictureSuccess({this.imageFiles, this.imageListGet});

  @override
  List<Object?> get props => [imageFiles, imageListGet];

  TakePictureSuccess copyWith(
      {List<XFile?>? imageFiles, List<DocumentDTO>? imageListGet}) {
    return TakePictureSuccess(
      imageFiles: imageFiles ?? this.imageFiles,
      imageListGet: imageListGet ?? this.imageListGet,
    );
  }
}

class TakePictureFailure extends TakePictureState {
  final String message;
  final int? errorCode;
  const TakePictureFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
