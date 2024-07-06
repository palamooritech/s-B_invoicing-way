import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/common/entity/user_account.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/features/useraccount/domain/repository/user_account_repository.dart';

class UpdateUserDetails implements UseCase<bool,UpdateUserDetailsParams>{
  final UserAccountRepository userAccountRepository;
  UpdateUserDetails(this.userAccountRepository);

  @override
  Future<Either<Failure, bool>> call(UpdateUserDetailsParams params) async {
    return await userAccountRepository.updateUserAccountDetails(params.userAccount);
  }

}

class UpdateUserDetailsParams{
  final UserAccount userAccount;
  UpdateUserDetailsParams(this.userAccount);
}