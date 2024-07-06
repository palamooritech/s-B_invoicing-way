import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/features/useraccount/domain/repository/user_account_repository.dart';

class StatusUserDetails implements UseCase<bool,StatusUserDetailsParams>{
  final UserAccountRepository userAccountRepository;
  StatusUserDetails(this.userAccountRepository);

  @override
  Future<Either<Failure, bool>> call(StatusUserDetailsParams params) async {
    return await userAccountRepository.getUserStatus(params.id);
  }

}
class StatusUserDetailsParams{
  final String id;
  StatusUserDetailsParams({required this.id});
}