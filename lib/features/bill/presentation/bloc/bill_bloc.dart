import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicing_sandb_way/core/common/entity/bill.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/features/bill/domain/usecases/approve_bill.dart';
import 'package:invoicing_sandb_way/features/bill/domain/usecases/delete_bill.dart';
import 'package:invoicing_sandb_way/features/bill/domain/usecases/get_all_bills.dart';
import 'package:invoicing_sandb_way/features/bill/domain/usecases/reject_bill.dart';
import 'package:invoicing_sandb_way/features/bill/domain/usecases/update_Bill.dart';

part 'bill_event.dart';
part 'bill_state.dart';

class BillBloc extends Bloc<BillEvent, BillState> {
  final GetAllBills _getAllBills;
  final DeleteBill _deleteBill;
  final UpdateBill _updateBill;
  final ApproveBill _approveBill;
  final RejectBill _rejectBill;

  BillBloc({
    required GetAllBills getAllBills,
    required DeleteBill deleteBill,
    required UpdateBill updateBill,
    required ApproveBill approveBill,
    required RejectBill rejectBill,
  })  : _getAllBills = getAllBills,
        _updateBill = updateBill,
        _deleteBill = deleteBill,
        _approveBill = approveBill,
        _rejectBill = rejectBill,
        super(BillInitialState()) {
    on<BillEvent>((_, emit) => emit(BillLoadingState()));
    on<BillFetchBillsEvent>(_onBillFetchBills);
    on<BillDeleteEvent>(_onBillDelete);
    on<BillUpdateEvent>(_onBillUpdate);
    on<BillApproveEvent>(_onBillApprove);
    on<BillRejectEvent>(_onBillReject);
  }

  void _onBillFetchBills(
      BillFetchBillsEvent event, Emitter<BillState> emit) async {
    final res = await _getAllBills(NoParams());

    res.fold((err) => emit(BillFailureState(err.message)),
        (bills) => emit(BillFetchBillSuccessState(bills)));
  }

  void _onBillDelete(BillDeleteEvent event, Emitter<BillState> emit) async {
    final res = await _deleteBill(BillDeleteParams(event.id));
    res.fold((err) => emit(BillFailureState(err.message)),
        (_) => emit(BillDeleteSuccessState()));
  }

  void _onBillUpdate(BillUpdateEvent event, Emitter<BillState> emit) async {
    final res = await _updateBill(UpdateBillParams(event.bill));

    res.fold((err) => emit(BillFailureState(err.message)),
        (_) => emit(BillUpdateSuccessState()));
  }

  void _onBillApprove(BillApproveEvent event, Emitter<BillState> emit) async {
    final res = await _approveBill(ApproveBillParams(
        bill: event.bill,
        comments: event.comments,
        paidAmount: event.paidAmount)
    );

    res.fold(
        (err) => emit(BillFailureState(err.message)),
        (_) => emit(BillApproveSuccessState()),
    );
  }

  void _onBillReject(BillRejectEvent event, Emitter<BillState> emit) async{
    final res = await _rejectBill(
        RejectBillParams(
            bill: event.bill,
            comments: event.comments,
            paidAmount: event.paidAmount
        )
    );

    res.fold(
        (err)=> emit(BillFailureState(err.message)),
        (_) => emit(BillRejectSuccessState()),
    );
  }
}
