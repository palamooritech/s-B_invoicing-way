import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/core/common/entity/user.dart';
import 'package:invoicing_sandb_way/features/auth/domain/repository/auth_repository.dart';

class UserSignIn implements UseCase<User,UserSignInParams>{
  final AuthRepository authRepository;
  UserSignIn(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignInParams params) async {
    return await authRepository.signInWithEmailPassword(
        email: params.email,
        password: params.password
    );
  }
}

class UserSignInParams{
  final String email;
  final String password;

  UserSignInParams({
    required this.email,
    required this.password
  });
}