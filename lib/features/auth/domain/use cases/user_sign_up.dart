import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/core/common/entity/user.dart';
import 'package:invoicing_sandb_way/features/auth/domain/repository/auth_repository.dart';

class UserSignUp implements UseCase<User,UserSignUpParams>{
  final AuthRepository authRepository;
  UserSignUp(this.authRepository);

  @override
  Future<Either<Failure,User>> call(UserSignUpParams params) async{
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams{
  final String name;
  final String password;
  final String email;

  UserSignUpParams({
    required this.name,
    required this.password,
    required this.email
  });
}