part of 'invoice_bloc.dart';

@immutable
sealed class InvoiceState{}

final class InvoiceInitial extends InvoiceState{}

final class InvoiceLoading extends InvoiceState{}

final class InvoiceFailure extends InvoiceState{
  final String error;
  InvoiceFailure(this.error);
}

final class InvoiceUploadSuccess extends InvoiceState{}

final class InvoiceDisplaySuccess extends InvoiceState{
  final List<Invoice> invoices;
  InvoiceDisplaySuccess(this.invoices);
}

final class InvoiceUpdateSuccess extends InvoiceState{}

final class InvoiceDeleteSuccess extends InvoiceState{}