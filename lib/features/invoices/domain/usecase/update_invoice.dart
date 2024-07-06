import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/common/entity/invoice.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/features/invoices/domain/repository/invoice_repository.dart';

class UpdateInvoice implements UseCase<bool,UpdateInvoiceParams>{
  final InvoiceRepository invoiceRepository;
  UpdateInvoice(this.invoiceRepository);

  @override
  Future<Either<Failure, bool>> call(UpdateInvoiceParams params) async {
    return await invoiceRepository.invoiceUpdate(
        id: params.id,
        authorId: params.authorId,
        title: params.title,
        description: params.description,
        startData: params.startData,
        endDate: params.endDate,
        entries: params.entries,
        status: params.status,
    );
  }
}

class UpdateInvoiceParams{
  final String id;
  final String authorId;
  final String title;
  final String description;
  final DateTime startData;
  final DateTime endDate;
  final List<InvoiceEntry> entries;
  final String status;

  UpdateInvoiceParams({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.startData,
    required this.endDate,
    required this.entries,
    required this.status,
  });
}