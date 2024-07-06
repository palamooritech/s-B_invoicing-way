import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/features/home/domain/repository/home_repository.dart';

class GetUserRole implements UseCase<bool,GetUserRoleParams>{
  final HomeRepository homeRepository;
  GetUserRole(this.homeRepository);

  @override
  Future<Either<Failure, bool>> call(GetUserRoleParams params) async{
    return await homeRepository.userStatus(id: params.id);
  }
}

class GetUserRoleParams{
  final String id;
  GetUserRoleParams(this.id);
}