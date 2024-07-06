import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicing_sandb_way/core/common/entity/invoice.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/features/invoices/domain/usecase/delete_invoice.dart';
import 'package:invoicing_sandb_way/features/invoices/domain/usecase/get_all_invoices.dart';
import 'package:invoicing_sandb_way/features/invoices/domain/usecase/update_invoice.dart';
import 'package:invoicing_sandb_way/features/invoices/domain/usecase/upload_invoice.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent,InvoiceState>{
  final GetAllInvoices _getAllInvoices;
  final UploadInvoice _uploadInvoice;
  final UpdateInvoice _updateInvoice;
  final DeleteInvoice _deleteInvoice;

  InvoiceBloc({
    required GetAllInvoices getAllInvoices,
    required UploadInvoice uploadInvoice,
    required UpdateInvoice updateInvoice,
    required DeleteInvoice deleteInvoice,
    }):
      _getAllInvoices = getAllInvoices,
      _uploadInvoice = uploadInvoice,
      _updateInvoice = updateInvoice,
      _deleteInvoice = deleteInvoice,
        super(InvoiceInitial()){
      on<InvoiceEvent>((_,emit)=> emit(InvoiceLoading()));
      on<InvoiceUpload>(_onInvoiceUpload);
      on<InvoiceFetchAllInvoices>(_onInvoiceFetch);
      on<InvoiceUpdateInvoice>(_onInvoiceUpdate);
      on<InvoiceDeleteInvoice>(_onInvoiceDelete);
    }

    void _onInvoiceUpload(InvoiceUpload event, Emitter<InvoiceState> emit) async{
      final res = await _uploadInvoice(
        UploadInvoiceParams(
            authorId: event.authorId,
            title: event.title,
            description: event.description,
            startDate: event.startData,
            endDate: event.endDate,
            entries: event.entries
        )
      );
      res.fold(
          (err) => emit(InvoiceFailure(err.message)),
          (_) => emit(InvoiceUploadSuccess())
      );
    }

    void _onInvoiceFetch(InvoiceFetchAllInvoices event, Emitter<InvoiceState> emit) async{
      final res = await _getAllInvoices(GetAllInvoicesParams(event.id));

      res.fold(
          (err) => emit(InvoiceFailure(err.message)),
          (invoices) => emit(InvoiceDisplaySuccess(invoices))
      );
    }

    void _onInvoiceUpdate(InvoiceUpdateInvoice event, Emitter<InvoiceState> emit) async{
      final res = await _updateInvoice(
        UpdateInvoiceParams(
            id: event.id,
            authorId: event.authorId,
            title: event.title,
            description: event.description,
            startData: event.startData,
            endDate: event.endDate,
            entries: event.entries,
          status: event.status,
        )
      );

      res.fold(
              (err) => emit(InvoiceFailure(err.message)),
              (_) => emit(InvoiceUpdateSuccess())
      );
    }

    void _onInvoiceDelete(InvoiceDeleteInvoice event, Emitter<InvoiceState> emit) async{
      final res = await _deleteInvoice(
          DeleteInvoiceParams(
              id: event.id,
              uid: event.uid,
          )
      );

      res.fold(
          (err)=> emit(InvoiceFailure(err.message)) ,
          (_)=> emit(InvoiceDeleteSuccess()),
      );
    }
}