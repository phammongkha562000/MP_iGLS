part of 'todo_haulage_image_bloc.dart';

abstract class TodoHaulageImageState extends Equatable {
  const TodoHaulageImageState();

  @override
  List<Object> get props => [];
}

class TodoHaulageImageInitial extends TodoHaulageImageState {}

class TodoHaulageImageLoading extends TodoHaulageImageState {}

class TodoHaulageImageSuccess extends TodoHaulageImageState {
  final List<ImageTodoHaulageResponse> imageList;

  const TodoHaulageImageSuccess({required this.imageList});
  @override
  List<Object> get props => [imageList];
}

class TodoHaulageImageFailure extends TodoHaulageImageState {}
