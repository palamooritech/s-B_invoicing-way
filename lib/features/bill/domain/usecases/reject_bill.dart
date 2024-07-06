import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/common/entity/bill.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/features/bill/domain/repository/bill_repository.dart';

class RejectBill implements UseCase<bool,RejectBillParams>{
  final BillRepository billRepository;
  RejectBill(this.billRepository);

  @override
  Future<Either<Failure, bool>> call(RejectBillParams params) async{
    return await billRepository.rejectBill(
        params.bill,
        params.comments,
        params.paidAmount
    );
  }
}

class RejectBillParams {
  final Bill bill;
  final String comments;
  final double paidAmount;

  RejectBillParams({
    required this.bill,
    required this.comments,
    required this.paidAmount
  });
}
