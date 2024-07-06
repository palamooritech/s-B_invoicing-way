import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/features/invoices/domain/repository/invoice_repository.dart';

class DeleteInvoice implements UseCase<bool,DeleteInvoiceParams>{
  final InvoiceRepository invoiceRepository;
  DeleteInvoice(this.invoiceRepository);

  @override
  Future<Either<Failure, bool>> call(DeleteInvoiceParams params) async{
    return await invoiceRepository.invoiceDelete(id: params.id,uid: params.uid);
  }
}

class DeleteInvoiceParams{
  final String id;
  final String uid;

  DeleteInvoiceParams({
    required this.id,
    required this.uid
  });
}