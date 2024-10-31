part of 'put_away_search_bloc.dart';

sealed class PutAwaySearchEvent extends Equatable {
  const PutAwaySearchEvent();

  @override
  List<Object> get props => [];
}

class PutAwaySearchViewLoaded extends PutAwaySearchEvent {
  final GeneralBloc generalBloc;

  const PutAwaySearchViewLoaded({required this.generalBloc});
  @override
  List<Object> get props => [generalBloc];
}
