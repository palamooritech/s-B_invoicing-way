import 'package:fpdart/fpdart.dart';
import 'package:invoicing_sandb_way/core/common/entity/bill.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';

abstract interface class BillRepository{
  Future<Either<Failure,List<Bill>>> getAllBills();
  Future<Either<Failure,bool>> updateBill(Bill bill);
  Future<Either<Failure,bool>> deleteBill(String id);
  Future<Either<Failure,bool>> approveBill(Bill bill, String comments, double paidAmount);
  Future<Either<Failure,bool>> rejectBill(Bill bill, String comments, double paidAmount);
}