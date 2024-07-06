import 'package:fpdart/fpdart.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';

abstract interface class UseCase<SuccessType,Params>{
  Future<Either<Failure,SuccessType>> call(Params params);
}

class NoParams{}