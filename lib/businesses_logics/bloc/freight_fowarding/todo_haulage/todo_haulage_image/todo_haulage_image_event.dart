part of 'todo_haulage_image_bloc.dart';

abstract class TodoHaulageImageEvent extends Equatable {
  const TodoHaulageImageEvent();

  @override
  List<Object> get props => [];
}

class TodoHaulageImageViewLoaded extends TodoHaulageImageEvent {
  final String trailerNo;
  final UserInfo userInfo;
  const TodoHaulageImageViewLoaded(
      {required this.trailerNo, required this.userInfo});
  @override
  List<Object> get props => [trailerNo, userInfo];
}
