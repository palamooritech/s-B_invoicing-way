import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/common/entity/bill.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/features/bill/domain/repository/bill_repository.dart';

class GetAllBills implements UseCase<List<Bill>,NoParams>{
  final BillRepository billRepository;
  GetAllBills(this.billRepository);

  @override
  Future<Either<Failure, List<Bill>>> call(NoParams params) async{
    return await billRepository.getAllBills();
  }

}
