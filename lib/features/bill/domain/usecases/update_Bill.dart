import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/common/entity/bill.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/features/bill/domain/repository/bill_repository.dart';

class UpdateBill implements UseCase<bool,UpdateBillParams>{
  final BillRepository billRepository;
  UpdateBill(this.billRepository);

  @override
  Future<Either<Failure, bool>> call(UpdateBillParams params) async {
    return await billRepository.updateBill(params.bill);
  }

}

class UpdateBillParams{
  final Bill bill;
  UpdateBillParams(this.bill);
}