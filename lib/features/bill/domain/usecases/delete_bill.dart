import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/features/bill/domain/repository/bill_repository.dart';

class DeleteBill implements UseCase<bool,BillDeleteParams>{
  final BillRepository billRepository;
  DeleteBill(this.billRepository);

  @override
  Future<Either<Failure, bool>> call(BillDeleteParams params) async{
    return await billRepository.deleteBill(params.id);
  }

}

class BillDeleteParams{
  final String id;
  BillDeleteParams(this.id);

}