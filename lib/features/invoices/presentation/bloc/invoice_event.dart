part of 'invoice_bloc.dart';

@immutable
sealed class InvoiceEvent{}

final class InvoiceUpload extends InvoiceEvent{
  final String authorId;
  final String title;
  final String description;
  final DateTime startData;
  final DateTime endDate;
  final List<InvoiceEntry> entries;

  InvoiceUpload({
    required this.authorId,
    required this.title,
    required this.description,
    required this.startData,
    required this.endDate,
    required this.entries
  });
}

final class InvoiceUpdateInvoice extends InvoiceEvent{
  final String id;
  final String authorId;
  final String title;
  final String description;
  final DateTime startData;
  final DateTime endDate;
  final List<InvoiceEntry> entries;
  final String status;

  InvoiceUpdateInvoice({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.startData,
    required this.endDate,
    required this.entries,
    required this.status
  });
}

final class InvoiceDeleteInvoice extends InvoiceEvent{
  final String id;
  final String uid;
  InvoiceDeleteInvoice(this.id, this.uid);
}

final class InvoiceFetchAllInvoices extends InvoiceEvent{
  final String id;
  InvoiceFetchAllInvoices(this.id);
}