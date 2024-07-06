part of 'home_bloc.dart';

@immutable
sealed class HomeEvent{}

final class HomeFetchUserFlagEvent extends HomeEvent{
  final String id;
  HomeFetchUserFlagEvent({required this.id});
}

final class HomeFetchUserNewFlagEvent extends HomeEvent{
  final String id;
  HomeFetchUserNewFlagEvent({required this.id});
}