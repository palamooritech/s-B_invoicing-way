import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/error/exceptions.dart';
import 'package:invoicing_sandb_way/features/invoices/data/datasources/invoice_remote_data_source.dart';
import 'package:invoicing_sandb_way/features/invoices/data/models/invoice_model.dart';
import 'package:invoicing_sandb_way/core/common/entity/invoice.dart';
import 'package:invoicing_sandb_way/features/invoices/domain/repository/invoice_repository.dart';
import 'package:uuid/uuid.dart';

class InvoiceRepositoryImpl implements InvoiceRepository{
  final InvoiceRemoteDataSource remoteDataSource;
  InvoiceRepositoryImpl(this.remoteDataSource);


  @override
  Future<Either<Failure, bool>> uploadInvoice({required String authorId, required String title, required String description, required DateTime startData, required DateTime endDate, required List<InvoiceEntry> entries}) async{
    try{
      final bool = await remoteDataSource.uploadInvoice(
          InvoiceModel(
          id: const Uuid().v1(),
          authorId: authorId,
          title: title,
          description: description,
          startData: startData,
          endDate: endDate,
          status: 'Reviewing',
          comments: '',
          entries: entries.map(
                  (entry)=>InvoiceEntryModel(
                      description: entry.description,
                      rate: entry.rate,
                      kms: entry.kms
                  )).toList(),
          updatedAt: DateTime.now(),
        )
      );
      return right(bool);
    }on ServerException catch(e){
      throw left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> invoiceUpdate({
    required String id, required String authorId,
    required String title, required String description,
    required DateTime startData, required DateTime endDate,
    required List<InvoiceEntry> entries, required String status}) async {
    try{
      final bool = await remoteDataSource.updateInvoice(
          InvoiceModel(
              id: id,
              authorId: authorId,
              title: title,
              description: description,
              startData: startData,
              endDate: endDate,
              comments: '',
              entries:  entries.map(
                      (entry)=>InvoiceEntryModel(
                      description: entry.description,
                      rate: entry.rate,
                      kms: entry.kms
                  )).toList(),
              status: 'Reviewing',
              updatedAt: DateTime.now()
          )
      );
      return right(bool);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> invoiceDelete({required String id, required String uid}) async{
    try{
      final bool = await remoteDataSource.deleteInvoice(id, uid);
      return right(bool);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Invoice>>> getAllInvoices({required String id}) async{
    try{
      final res = await remoteDataSource.getAllInvoices(id);
      return right(res);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

}