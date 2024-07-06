import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/core/common/entity/invoice.dart';
import 'package:invoicing_sandb_way/features/invoices/domain/repository/invoice_repository.dart';

class GetAllInvoices implements UseCase<List<Invoice>,GetAllInvoicesParams>{
  final InvoiceRepository invoiceRepository;
  GetAllInvoices(this.invoiceRepository);

  @override
  Future<Either<Failure, List<Invoice>>> call(GetAllInvoicesParams params) async {
    return await invoiceRepository.getAllInvoices(id:params.id);
  }

}

class GetAllInvoicesParams{
  final String id;
  GetAllInvoicesParams(this.id);
}