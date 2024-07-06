import 'package:fpdart/fpdart.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';

abstract interface class HomeRepository{
  Future<Either<Failure,bool>> userStatus({required String id});
  Future<Either<Failure,bool>> isUserNew({required String id});
}