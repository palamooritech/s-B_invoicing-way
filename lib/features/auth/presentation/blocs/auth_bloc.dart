import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicing_sandb_way/core/common/cubit/appuser/app_user_cubit.dart';
import 'package:invoicing_sandb_way/core/common/entity/user.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/features/auth/domain/use%20cases/current_user.dart';
import 'package:invoicing_sandb_way/features/auth/domain/use%20cases/user_sign_in.dart';
import 'package:invoicing_sandb_way/features/auth/domain/use%20cases/user_sign_up.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  }):
        _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()){
    on<AuthEvent>((_,emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async{
    final res = await _userSignIn(
        UserSignInParams(
            email: event.email,
            password: event.password,
        )
    );
    
    res.fold(
        (l)=> emit(AuthFailure(message: l.message)), 
        (user) => _emitAuthSuccess(emit, user)
    );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async{
    final res = await _userSignUp(
        UserSignUpParams(
            name: event.name, 
            password: event.password, 
            email: event.email)
    );
    res.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (user) => _emitAuthSuccess(emit, user)
    );
  }
  
  void _isUserLoggedIn(AuthIsUserLoggedIn event, Emitter<AuthState> emit) async{
    final res = await _currentUser(NoParams());
    res.fold(
        (l) => emit(AuthFailure(message: l.message)),
        (r) {
          if(kDebugMode){
            print(r.email);
          }
          _emitAuthSuccess(emit, r);
        }
    );
  }

  void _emitAuthSuccess(Emitter<AuthState> emit, User user){
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }

}