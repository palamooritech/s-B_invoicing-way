import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicing_sandb_way/features/home/domain/usecases/get_user_role.dart';
import 'package:invoicing_sandb_way/features/home/domain/usecases/user_status_check.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetUserRole _getUserRole;
  final UserStatusCheck _userStatusCheck;
  HomeBloc({
    required GetUserRole getUserRole,
    required UserStatusCheck userStatusCheck,
  })  : _getUserRole = getUserRole,
      _userStatusCheck = userStatusCheck,
        super(HomeInitialState()){
    on<HomeEvent>((_,emit)=> emit(HomeLoadingState()));
    on<HomeFetchUserFlagEvent>(_onHomeFetchUserFlag);
    on<HomeFetchUserNewFlagEvent>(_onHomeFetchUserNewFlag);
  }

  void _onHomeFetchUserFlag(HomeFetchUserFlagEvent event, Emitter<HomeState> emit) async{
    final res = await _getUserRole(GetUserRoleParams(event.id));

    res.fold(
        (err)=> emit(HomeFailureState(err.message)),
        (flag)=> emit(HomeFetchUserFlagSuccessState(flag)),
    );
  }

  void _onHomeFetchUserNewFlag(HomeFetchUserNewFlagEvent event, Emitter<HomeState> emit) async{
    final res = await _userStatusCheck(UserStatusCheckParams(id: event.id));

    res.fold(
        (err)=> emit(HomeFailureState(err.message)),
        (flag) => emit(HomeFetchUserNewFlagSuccessState(flag))
    );
  }
}
