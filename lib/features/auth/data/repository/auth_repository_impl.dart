import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/error/exceptions.dart';
import 'package:invoicing_sandb_way/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:invoicing_sandb_way/core/common/entity/user.dart';
import 'package:invoicing_sandb_way/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository{
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure,User>> currentUser() async{
    try{
      final user = await remoteDataSource.getCurrentUser();
      if(user == null){
        return left(Failure("User is Null!"));
      }
      return right(user);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailPassword({required String email, required String password}) async {
    try{
      final user = await remoteDataSource.signInWithEmailPassword(
          email: email,
          password: password
      );
      return right(user);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({required String email, required String password, required String name}) async{
   try{
     final user = await remoteDataSource.signUpWithEmailPassword(
         email: email,
         password: password,
         name: name
     );
     return right(user);
   }on ServerException catch(e){
     return left(Failure(e.message));
   }
  }


}