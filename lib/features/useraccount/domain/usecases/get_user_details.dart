import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/core/common/entity/user_account.dart';
import 'package:invoicing_sandb_way/features/useraccount/domain/repository/user_account_repository.dart';

class GetUserDetails implements UseCase<UserAccount,GetUserDetailsParam>{
  final UserAccountRepository userAccountRepository;
  GetUserDetails(this.userAccountRepository);

  @override
  Future<Either<Failure, UserAccount>> call(GetUserDetailsParam params) async{
    return await userAccountRepository.getUserAccountDetails(id: params.id);
  }
}

class GetUserDetailsParam{
  final String id;
  GetUserDetailsParam({required this.id});
}