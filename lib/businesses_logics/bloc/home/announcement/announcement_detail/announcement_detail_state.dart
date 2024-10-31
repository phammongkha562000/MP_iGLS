part of 'announcement_detail_bloc.dart';

abstract class AnnouncementDetailState extends Equatable {
  const AnnouncementDetailState();

  @override
  List<Object?> get props => [];
}

class AnnouncementDetailInitial extends AnnouncementDetailState {}

class AnnouncementDetailLoading extends AnnouncementDetailState {}

class AnnouncementDetailSuccess extends AnnouncementDetailState {
  final AnnouncementResponse detail;
  final bool? isSuccess;
  const AnnouncementDetailSuccess({required this.detail, this.isSuccess});
  @override
  List<Object?> get props => [detail, isSuccess];

  AnnouncementDetailSuccess copyWith({
    AnnouncementResponse? detail,
    bool? isSuccess,
  }) {
    return AnnouncementDetailSuccess(
      detail: detail ?? this.detail,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class AnnouncementDetailFailure extends AnnouncementDetailState {
  final String message;
  final int? errorCode;
  const AnnouncementDetailFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
