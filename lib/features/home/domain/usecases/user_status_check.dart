import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/features/home/domain/repository/home_repository.dart';

class UserStatusCheck implements UseCase<bool, UserStatusCheckParams>{
  final HomeRepository homeRepository;
  UserStatusCheck(this.homeRepository);

  @override
  Future<Either<Failure, bool>> call(UserStatusCheckParams params) async{
     return await homeRepository.isUserNew(id: params.id);
  }

}

class UserStatusCheckParams{
  final String id;
  UserStatusCheckParams({required this.id});
}