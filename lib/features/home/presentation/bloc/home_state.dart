part of 'home_bloc.dart';

@immutable
sealed class HomeState{}

final class HomeInitialState extends HomeState{}

final class HomeLoadingState extends HomeState{}

final class HomeFailureState extends HomeState{
  final String error;
  HomeFailureState(this.error);
}

final class HomeFetchUserFlagSuccessState extends HomeState{
  final bool flag;
  HomeFetchUserFlagSuccessState(this.flag);
}

final class HomeFetchUserNewFlagSuccessState extends HomeState{
  final bool flag;
  HomeFetchUserNewFlagSuccessState(this.flag);
}
