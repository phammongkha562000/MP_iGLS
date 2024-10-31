part of 'haulage_activity_bloc.dart';

abstract class HaulageActivityState extends Equatable {
  const HaulageActivityState();

  @override
  List<Object?> get props => [];
}

class HaulageActivityInitial extends HaulageActivityState {}

class HaulageActivityLoading extends HaulageActivityState {}

class HaulageActivitySuccess extends HaulageActivityState {
  final List<ContactLocal> contactList;
  final String? contactLocalName;
  final String? url;
  final bool? isSuccess;
  const HaulageActivitySuccess(
      {required this.contactList,
      this.contactLocalName,
      this.url,
      this.isSuccess});
  @override
  List<Object?> get props => [contactList, contactLocalName, url, isSuccess];

  HaulageActivitySuccess copyWith(
      {List<ContactLocal>? contactList,
      String? contactLocalName,
      String? serverWcf,
      bool? isSuccess,
      String? url}) {
    return HaulageActivitySuccess(
      url: url ?? this.url,
      isSuccess: isSuccess ?? this.isSuccess,
      contactList: contactList ?? this.contactList,
      contactLocalName: contactLocalName ?? this.contactLocalName,
    );
  }
}

class HaulageActivityFailure extends HaulageActivityState {
  final String message;
  final int? errorCode;
  const HaulageActivityFailure({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class HaulageActivityLoadUrl extends HaulageActivityState {
  final String url;
  const HaulageActivityLoadUrl({
    required this.url,
  });
  @override
  List<Object?> get props => [url];
}
