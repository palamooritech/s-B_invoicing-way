import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/error/exceptions.dart';
import 'package:invoicing_sandb_way/features/home/data/datasources/home_remote_data_source.dart';
import 'package:invoicing_sandb_way/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository{
  final HomeRemoteDataSource remoteDataSource;
  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, bool>> userStatus({required String id}) async{
    try{
      final flag = await remoteDataSource.getUserStatus(id);
      return right(flag);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isUserNew({required String id}) async{
    try{
      final flag = await remoteDataSource.isUserNew(id);
      return right(flag);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }
  }
}