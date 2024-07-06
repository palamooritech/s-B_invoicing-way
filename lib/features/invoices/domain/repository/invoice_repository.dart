import 'package:fpdart/fpdart.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/common/entity/invoice.dart';

abstract interface class InvoiceRepository {
  Future<Either<Failure, bool>> uploadInvoice({
    required String authorId,
    required String title,
    required String description,
    required DateTime startData,
    required DateTime endDate,
    required List<InvoiceEntry> entries,
  });

  Future<Either<Failure, List<Invoice>>> getAllInvoices({
    required String id,
});

  Future<Either<Failure, bool>> invoiceUpdate({
    required String id,
    required String authorId,
    required String title,
    required String description,
    required DateTime startData,
    required DateTime endDate,
    required List<InvoiceEntry> entries,
    required String status,
  });

  Future<Either<Failure, bool>> invoiceDelete({
    required String id,
    required String uid,
  });
}
