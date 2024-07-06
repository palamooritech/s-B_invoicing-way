import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/common/entity/bill.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/features/bill/domain/repository/bill_repository.dart';

class ApproveBill implements UseCase<bool, ApproveBillParams> {
  final BillRepository billRepository;
  ApproveBill(this.billRepository);

  @override
  Future<Either<Failure, bool>> call(ApproveBillParams params) async {
    return await billRepository.approveBill(
      params.bill,
      params.comments,
      params.paidAmount,
    );
  }
}

class ApproveBillParams {
  final Bill bill;
  final String comments;
  final double paidAmount;

  ApproveBillParams(
      {required this.bill, required this.comments, required this.paidAmount});
}
