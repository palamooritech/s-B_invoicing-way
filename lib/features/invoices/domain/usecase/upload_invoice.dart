import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/core/common/entity/invoice.dart';
import 'package:invoicing_sandb_way/features/invoices/domain/repository/invoice_repository.dart';

class UploadInvoice implements UseCase<bool,UploadInvoiceParams>{
  final InvoiceRepository invoiceRepository;
  UploadInvoice(this.invoiceRepository);

  @override
  Future<Either<Failure, bool>> call(UploadInvoiceParams params) async{
    return await invoiceRepository.uploadInvoice(
        authorId: params.authorId,
        title: params.title,
        description: params.description,
        startData: params.startDate,
        endDate: params.endDate,
        entries: params.entries,
    );
  }
}

class UploadInvoiceParams{
  final String authorId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<InvoiceEntry> entries;

  UploadInvoiceParams({
    required this.authorId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.entries
  });
}