import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/error/exceptions.dart';
import 'package:invoicing_sandb_way/features/useraccount/data/datasources/user_account_remote_data_source.dart';
import 'package:invoicing_sandb_way/features/useraccount/data/models/user_account_model.dart';
import 'package:invoicing_sandb_way/core/common/entity/user_account.dart';
import 'package:invoicing_sandb_way/features/useraccount/domain/repository/user_account_repository.dart';

class UserAccountRepositoryImpl implements UserAccountRepository{
  final UserAccountRemoteDataSource remoteDataSource;
  UserAccountRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserAccount>> getUserAccountDetails({required String id}) async {
    try{
      final userAccount = await remoteDataSource.getUserAccount(id);
      return right(userAccount.toUserAccount());
    }on ServerException catch(e){
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> getUserStatus(String id) async {
   try{
     final bool = await remoteDataSource.isNewUser(id);
     return right(bool);
   }on ServerException catch(e){
     return left(Failure(e.message));
   }
  }

  @override
  Future<Either<Failure, bool>> updateUserAccountDetails(UserAccount userAccount) async{
    try{
      final bool = await remoteDataSource.updateUserAccount(UserAccountModel.fromUserAccount(userAccount));
      return right(bool);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> uploadUserPhoto(String filePath, String uid) async {
    try{
      final imgPath = await remoteDataSource.uploadImage(filePath, uid);
      return right(imgPath);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }
  }
}