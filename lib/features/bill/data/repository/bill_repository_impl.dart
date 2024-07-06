import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/common/entity/bill.dart';
import 'package:invoicing_sandb_way/core/common/entity/invoice.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/error/exceptions.dart';
import 'package:invoicing_sandb_way/features/bill/data/datasources/bill_remote_data_source.dart';
import 'package:invoicing_sandb_way/features/bill/data/models/bill_model.dart';
import 'package:invoicing_sandb_way/features/bill/domain/repository/bill_repository.dart';

class BillRepositoryImpl implements BillRepository{
  final BillRemoteDataSource billRemoteDataSource;
  BillRepositoryImpl(this.billRemoteDataSource);

  @override
  Future<Either<Failure, bool>> deleteBill(String id) async {
   try{
     final bool = await billRemoteDataSource.deleteBill(id);
     return right(bool);
   }on ServerException catch(e){
     return left(Failure(e.message));
   }
  }

  @override
  Future<Either<Failure, List<Bill>>> getAllBills() async {
    try{
      final bills =  await billRemoteDataSource.getAllBills();
      print("Get All Bills called");
      return right(bills);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> updateBill(Bill bill) async{
    try{
      final bool = await billRemoteDataSource.updateBill(BillModel.fromBill(bill));
      return right(bool);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> approveBill(Bill bill, String comments, double paidAmount) async{
    try{
      final invoice = Invoice(
          id: bill.invoice.id,
          authorId: bill.invoice.authorId,
          title: bill.invoice.title,
          description: bill.invoice.description,
          startData: bill.invoice.startData,
          endDate: bill.invoice.endDate,
          entries: bill.invoice.entries,
          status: "Approved",
          updatedAt: DateTime.now(),
          comments: comments
      );

      await billRemoteDataSource.approveBill(BillModel(
          invoice: invoice,
          billId: bill.billId,
          status: BillStatus.Approved,
          paidAmount: paidAmount,
          pendingAmount: bill.pendingAmount-paidAmount,
          authorName: bill.authorName,
          authorPic: bill.authorPic
        )
      );

      return right(true);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> rejectBill(Bill bill, String comments, double paidAmount) async{
    try{
      final invoice = Invoice(
          id: bill.invoice.id,
          authorId: bill.invoice.authorId,
          title: bill.invoice.title,
          description: bill.invoice.description,
          startData: bill.invoice.startData,
          endDate: bill.invoice.endDate,
          entries: bill.invoice.entries,
          status: 'Rejected',
          updatedAt: DateTime.now(),
          comments: comments
      );

      await billRemoteDataSource.rejectBill(BillModel(
          invoice: invoice,
          billId: bill.billId,
          status: BillStatus.Rejected,
          paidAmount: 0,
          pendingAmount: bill.pendingAmount,
          authorName: bill.authorName,
          authorPic: bill.authorPic
      )
      );
      return right(true);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }
  }

}