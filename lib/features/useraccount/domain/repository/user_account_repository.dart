import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/common/entity/user_account.dart';

abstract interface class UserAccountRepository{
  Future<Either<Failure,UserAccount>> getUserAccountDetails({
    required String id,
  });
  Future<Either<Failure,bool>> updateUserAccountDetails(UserAccount userAccount);
  Future<Either<Failure,bool>> getUserStatus(String id);
  Future<Either<Failure,String>> uploadUserPhoto(String filePath, String uid);
}